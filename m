Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B93C3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 22:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF5E8206E6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 22:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCCWS1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 17:18:27 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33814 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727665AbgCCWS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 17:18:27 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5C86C7E9A9A;
        Wed,  4 Mar 2020 09:18:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Frp-0004K2-L4; Wed, 04 Mar 2020 09:18:21 +1100
Date:   Wed, 4 Mar 2020 09:18:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     David Brown <davidb@davidb.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Unable to xfsdump/xfsrestore filesystem
Message-ID: <20200303221821.GU10776@dread.disaster.area>
References: <20200303165000.GA33105@davidb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303165000.GA33105@davidb.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=C6iAp25jAAAA:20 a=7-415B0cAAAA:8 a=qx_UaYKZ7xdfEaKQvzoA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 09:50:00AM -0700, David Brown wrote:
> I am using xfsdump with multiple levels to backup my main system
> (Fedora f31, xfs root and home on LVM).  Kernel is
> 5.5.6-201.fc31.x86_64.
> 
> When doing a test restore of my backup, when I reach my level 2
> backup, I get the following warnings:
> 
>     xfsrestore: directory post-processing
>     xfsrestore: WARNING: unable to rename dir orphanage/422178422.2232121414 to dir <<path>>/b-cloud: No such file or directory

The orphanage is a special xfsrestore thing. files and directories
without any tree links at the time they are restored from the media
file are placed into the orphanage. When a link to that object in
the orphanage is found, it moves it into place.

However, directory post processing also removes stale tree entries.
Hence you can get files in the orphanage that have no directories
that point to them at all, and they then get discarded because there
is nowhere to restore them to.

This process can be recursive, as directory post processing can move
entries to the orphanage and vice versa, meaning that files that
were skipped in the restore because they had not tree linkage now
have their parent directory in place and so can now be restored.
There's a chicken-and-egg problem in this algorithm, too, which can
lead to an unresolvable recursion loop, so restore may not be able
to resolve everything correctly form such a media file....

> In addition, I get hundreds of these.  They seem to all be related to
> that same directory.
> 
>     xfsrestore: restoring non-directory files
>     xfsrestore: WARNING: open of orphanage/422178422.2232121414/modules/atmel/cmake_install.cmake failed: No such file or directory: discarding ino 2833282
>     xfsrestore: WARNING: open of orphanage/422178422.2232121414/modules/atmel/asf/common/cmake_install.cmake failed: No such file or directory: discarding ino 2833283

Yep, this is typical of a dump taken on a live, changing filesystem.
i.e. This is not an xfsrestore problem but a result of changing
filesystem structure while xfsdump is running.

That is, xfsdump has scanned the filesystem, found all the
files/dirs that need to be backed up, then gone and read all the
data into the media file. It does a separate directory traversal to
write the directory heirarchy into the dump inventory. As a result
of the time time difference between the file data backup vs the
directory struct backup, the dump media file contains files that
don't exist in the directory tree and the directory tree can contain
files that don't exist in the dump.

Hence the backup data in the media file can be inconsistent as it is
not a point in time snapshot of the live filesystem, and the only
time you are going to see that inconsistency is whey you go to
restore the media file.

> When I verify the restore (using https://github.com/d3zd3z/rsure), I
> indeed find that <<path>>/b-cloud is missing, but another directory
> next to it is still present that should be removed.

Yup, that can happen on a live filesystem backup. If you want
a guaranteed consistent backup, then you need to run xfsdump on a
static snapshot of the filesystem and not the live filesystem
itself.

> Restores of subsequent print similar messages (and don't restore the
> directory), until one of them dies with this:
> 
>     xfsrestore: WARNING: unable to rename dir orphanage/422178422.2232121414 to dir <<path>>/b-cloud: No such file or directory
>     xfsrestore: node.c:539: node_map: Assertion `nh != NH_NULL' failed.
> 
> Any ideas on how to debug this?

The node freeing code has been passed a null pointer, which
indicates there's an inconsistency in the internal directory tree
that restore is building. Smells like a double-free is occuring.

The usual is in order: turn the debugging logging all the way up,
run it under gdb to find the path that leads to the crash, make your
eyeballs bleed by reading the xfsdump code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
