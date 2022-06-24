Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3919CC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 01:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiFXBhs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 21:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiFXBhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 21:37:48 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E8EA5DF25
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 18:37:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EDA1E5ECBFB;
        Fri, 24 Jun 2022 11:37:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o4YGV-00AJdL-Rv; Fri, 24 Jun 2022 11:37:43 +1000
Date:   Fri, 24 Jun 2022 11:37:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Clay Gerrard <clay.gerrard@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: ENODATA on list/stat directory
Message-ID: <20220624013743.GY227878@dread.disaster.area>
References: <CA+_JKzo7V5PZkWGFPB5hP0pAtWrOsi0TomxHaO5W+ViEF8ctwQ@mail.gmail.com>
 <20220623221309.GU227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623221309.GU227878@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b51569
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=0WRdYS3FQElAfalNivUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 24, 2022 at 08:13:09AM +1000, Dave Chinner wrote:
> On Thu, Jun 23, 2022 at 02:52:22PM -0500, Clay Gerrard wrote:
> > I work on an object storage system, OpenStack Swift, that has always
> > used xfs on the storage nodes.  Our system has encountered many
> > various disk failures and occasionally apparent file system corruption
> > over the years, but we've been noticing something lately that might be
> > "new" and I'm considering how to approach the problem.  I'm interested
> > to solicit critique on my current thinking/process - particularly from
> > xfs experts.
> > 
> > [root@s8k-sjc3-d01-obj-9 ~]# xfs_bmap
> > /srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53
> > /srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53:
> > No data available
> > [root@s8k-sjc3-d01-obj-9 ~]# xfs_db
> > /srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53
> > /srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53:
> > No data available
> 
> ENODATA implies that it's trying to access an xattr that doesn't
> exist.
> 
> > fatal error -- couldn't initialize XFS library
> > [root@s8k-sjc3-d01-obj-9 ~]# ls -alhF /srv/node/d21865/quarantined/objects-1/e53
> > ls: cannot access
> > /srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53:
> > No data available
> > total 4.0K
> > drwxr-xr-x  9 swift swift  318 Jun  7 00:57 ./
> > drwxr-xr-x 33 swift swift 4.0K Jun 23 16:10 ../
> > d?????????  ? ?     ?        ?            ? f0418758de4baaa402eb301c5bae3e53/
> 
> That's the typical ls output when it couldn't stat() an inode. This
> typically occurs when the inode has been corrupted. On XFS, at
> least, this should result in a corruption warning in the kernel log.
> 
> Did you check dmesg for errors?

Just to close the circle on the list thread - this is being caused
by failing storage hardware, not filesystem issue.

> [3600194.452706] sd 0:0:3:0: [sdd] tag#5 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=7s
> [3600194.452715] sd 0:0:3:0: [sdd] tag#5 Sense Key : Medium Error [current] [descriptor]
> [3600194.452719] sd 0:0:3:0: [sdd] tag#5 Add. Sense: Unrecovered read error
> [3600194.452723] sd 0:0:3:0: [sdd] tag#5 CDB: Read(16) 88 00 00 00 00 03 00 1c 76 30 00 00 00 20 00 00
> [3600194.452727] blk_update_request: critical medium error, dev sdd, sector 12886767168
> [3600194.453801] XFS (sdd): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x3001c7630 len 32 error 61
> [3600194.454846] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() returned error -61.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
