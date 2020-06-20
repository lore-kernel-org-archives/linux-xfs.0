Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67500C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 23:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45BAF23C17
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 23:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgFTXVp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 19:21:45 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:35412 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728633AbgFTXVp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 19:21:45 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id DB3871A8EBC;
        Sun, 21 Jun 2020 09:21:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jmmnk-00013B-Cr; Sun, 21 Jun 2020 09:21:32 +1000
Date:   Sun, 21 Jun 2020 09:21:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     peter green <plugwash@p10link.net>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
        953537@bugs.debian.org
Subject: Re: Bug#953537: xfsdump fails to install in /usr merged system.
Message-ID: <20200620232132.GR2005@dread.disaster.area>
References: <998fa1cb-9e9f-93cf-15f0-e97e5ec54e9a@p10link.net>
 <20200619044734.GB11245@magnolia>
 <ea662f0b-7e73-0bbe-33aa-963389b9e215@sandeen.net>
 <20200619224325.GP2005@dread.disaster.area>
 <3ecca5f3-f448-195a-4fd7-d078139972f9@p10link.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ecca5f3-f448-195a-4fd7-d078139972f9@p10link.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=gu6fZOg2AAAA:8 a=7-415B0cAAAA:8
        a=nxzmxJyfhhf4jdFrYR0A:9 a=CjuIK1q_8ugA:10 a=-FEs8UIgK8oA:10
        a=NWVoK91CQyQA:10 a=2RSlZUUhi9gRBrsHwhhZ:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 03:10:05AM +0100, peter green wrote:
> Putting the debian bug back in cc, previous mails are visible at https://marc.info/?l=linux-xfs&m=159253950420613&w=2
> 
> On 19/06/2020 23:43, Dave Chinner wrote:
> 
> > Isn't the configure script supposed to handle install locations?
> > Both xfsprogs and xfsdump have this in their include/builddefs.in:
> > 
> > PKG_ROOT_SBIN_DIR = @root_sbindir@
> > PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@
> > 
> > So the actual install locations are coming from the autoconf setup
> > the build runs under. Looking in configure.ac in xfsprogs and
> > xfsdump, they both do the same thing:
> > 
> The issue is that xfsdump installs the programs in /sbin but it *also* creates symlinks in /usr/sbin,
> presumablly at some point the binaries were moved to /sbin but the developers wanted to keep
> packages that hardcoded the paths working.

Ah, thanks for explaining the issue, Peter.

> Those symlinks are suppressed if installing directly to a merged-usr system, which is fine for
> end-users installing the program directly but isn't useful if installing to a destination dir for
> packaing purposed.

OK, so what I'm really missing here is knowledge on how a modern
distro is expecting binaries to be packaged. If every distro is
having to work around the install locations the package uses by
default, then we need to fix up the default locations and behaviour
of the upstream packaging.

So, what is expected behaviour in these situations:

	- user installs directly in /usr/local/... or $HOME/...
	- user installs directly in /usr/....
	- package installed on split-usr system
	- package installed on merged-usr system

Th first two here are coded into the build via 'make install', and
the package build systems use the same install command to build the
package. It seems to me that we'd want 'make install' to behave the
same way for the last 3 cases, but I'm missing how the
build/packaging system is actually supposed to reliably detect the
differences between such split/merged systems and hence just DTRT....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
