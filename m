Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D292EC10DCE
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 22:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4AAC208E4
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 22:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgCJWOM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 18:14:12 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43016 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726273AbgCJWOM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 18:14:12 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D21B17E991C;
        Wed, 11 Mar 2020 09:14:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jBn8Y-0004cq-Mh; Wed, 11 Mar 2020 09:14:06 +1100
Date:   Wed, 11 Mar 2020 09:14:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>
Subject: Re: 5.5 XFS getdents regression?
Message-ID: <20200310221406.GO10776@dread.disaster.area>
References: <72c5fd8e9a23dde619f70f21b8100752ec63e1d2.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72c5fd8e9a23dde619f70f21b8100752ec63e1d2.camel@nokia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=pM9yUfARAAAA:8 a=TXhh1AoAAAAA:20 a=7-415B0cAAAA:8
        a=kddjMyLgLR5ZLaLsPHMA:9 a=CjuIK1q_8ugA:10 a=YH-7kEGJnRg4CV3apUU-:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 08:45:58AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> Hello,
> 
> One of my GitLab CI jobs stopped working after upgrading server 5.4.18-
> 100.fc30.x86_64 -> 5.5.7-100.fc30.x86_64.
> (tested 5.5.8-100.fc30.x86_64 too, no change)
> The server is fedora30 with XFS rootfs.
> The problem reproduces always, and takes only couple minutes to run.
> 
> The CI job fails in the beginning when doing "git clean" in docker
> container, and failing to rmdir some directory:
> "warning: failed to remove 
> .vendor/pkg/mod/golang.org/x/net@v0.0.0-20200114155413-6afb5195e5aa/intern
> al/socket: Directory not empty"
> 
> Quick google search finds some other people reporting similar problems
> with 5.5.0:
> https://gitlab.com/gitlab-org/gitlab-runner/issues/3185

Which appears to be caused by multiple gitlab processes modifying
the directory at the same time. i.e. something is adding an entry to
the directory at the same time something is trying to rm -rf it.
That's a race condition, and would lead to the exact symptoms you
see here, depending on where in the directory the new entry is
added.

> Collected some data with strace, and it seems that getdents is not
> returning all entries:
> 
> 5.4 getdents64() returns 52+50+1+0 entries 
> => all files in directory are deleted and rmdir() is OK
> 
> 5.5 getdents64() returns 52+50+0+0 entries
> => rmdir() fails with ENOTEMPTY

Yup, that's a classic userspace TOCTOU race.

Remember, getdents() is effectively a sequential walk through the
directory data - subsequent calls start at the offset (cookie) where
the previous one left off. New entries can be added between
getdents() syscalls.

If that new entry is put at the tail of the directory, then the last
getdents() call will return that entry rather than none because it
was placed at an offset in the directory that the getdents() sweep
has not yet reached, and hence will be found by a future getdents()
call in the sweep.


However, if there is a hole in the directory structure before the
current getdents cookie offset, a new entry can be added in that
hole. i.e. at an offset in the directory that getdents has already
passed over. That dirent will never be reported by the current
getdents() sequence - a directory rewind and re-read is required to
find it. i.e. there's an inherent userspace TOUTOC race condition in
'rm -rf' operations.

IOWs, this is exactly what you'd expect to see when there are
concurrent userspace modifications to a directory that is currently
being read. Hence you need to rule out an application and userspace
level issues before looking for filesystem level problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
