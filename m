Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E4CC61DA4
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Mar 2023 00:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCJA3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Mar 2023 19:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjCJA3T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2023 19:29:19 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CE9F28A2
        for <linux-xfs@vger.kernel.org>; Thu,  9 Mar 2023 16:29:11 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so8135435pjh.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Mar 2023 16:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1678408151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3WBsV3bhcv4hgyil4FIjA3SklpAihLLim76x3D+mICA=;
        b=DBRXfnGTMeYUosPqInsKWx0A5BUNc3/B5THb00F62kUII6HusV4Ch8tHMSZA96158K
         4SqP+t8vEQ+pt8le8b38ur3nCdbfKh5SKKbs1tAqjiz38rBgX514O7iu0xSxzqDkNliA
         a8JFZv52S0rp8IgCv/j2samFtZFbaN+M8Yxaguz3JgMT2AymI7kc1Rzr3mS5m2Di9rYh
         86RWngbE45eNlxfcC9nMgk+vjPN8y+lYKKEXnEXmMoAz9TDi2EC8bIOE9Gad8KOab1xz
         6wE9albtNtPuPRIXqLzygeUoqxMa8G6uD3cJP8Oq6wdrM71nn3p7mTvO1wSfcpgKyDFo
         Lj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678408151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WBsV3bhcv4hgyil4FIjA3SklpAihLLim76x3D+mICA=;
        b=oJJkqdSRbjPWDYOLfXtMUQxUCGh6ouJrrxvZnDM6AbfptJzXW8YWB/9bhlbv6waB7f
         YOUYqQPrpj9t8f98Vwk70/0QSrsPUYa5hfpRDTV8zH2z6WwVG402k28mNgz54FONwF1p
         ql3xl3/A3Cy1OMUPPg3Vmn7Ix17Jpntg051mVzCdwFVO53Ak6nGgcAJS9eA80VyrIjuo
         q0pE+4zqMkuugMPeKLEOYA54n50kSZorY7xja9RLzAUrkZsSLH5HweruGQr+IdZuvz20
         dCZK5Afh5sUUi3uqse4BcvtO+bfBGlpBUwX0xXPO84t4BQxftXpq7NGYr2ie1+9WArJA
         RBCA==
X-Gm-Message-State: AO0yUKW2r+P/xHzZ7tmwyvbLeV8rtNcTp5USzQ+bIyX2X+cz0Uk0EWRW
        c1WNvWE9RsCCikGkNLnGyZrfEw==
X-Google-Smtp-Source: AK7set8R4mshaynwz/QrqypGjX4UL0sVrpujVweUk2jep12ynM7Ifc/iRGucfOBxbtQy3hpIIiMcHA==
X-Received: by 2002:a17:90b:180b:b0:233:e660:aaae with SMTP id lw11-20020a17090b180b00b00233e660aaaemr25188378pjb.16.1678408151173;
        Thu, 09 Mar 2023 16:29:11 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a2b8e00b00227223c58ecsm146418pjd.42.2023.03.09.16.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 16:29:10 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1paQd9-006sqQ-5q; Fri, 10 Mar 2023 11:29:07 +1100
Date:   Fri, 10 Mar 2023 11:29:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        dchinner@redhat.com, linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error
 xfs_trans_cancel
Message-ID: <20230310002907.GO360264@dread.disaster.area>
References: <Y/ZFtEbLTX38pReY@magnolia>
 <87356eknlt.fsf@doe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87356eknlt.fsf@doe.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 09, 2023 at 07:56:06PM +0530, Ritesh Harjani wrote:
> Hi Darrick,
> 
> Please find the information collected from the system. We added some
> debug logs and looks like it is exactly what is happening which you
> pointed out.
> 
> We added a debug kernel patch to get more info from the system which
> you had requested [1]
> 
> 1. We first breaked into emergency shell where root fs is first getting
> mounted on /sysroot as "ro" filesystem. Here are the logs.
> 
> [  OK  ] Started File System Check on /dev/mapper/rhel_ltcden3--lp1-root.
>          Mounting /sysroot...
> [    7.203990] SGI XFS with ACLs, security attributes, quota, no debug enabled
> [    7.205835] XFS (dm-0): Mounting V5 Filesystem 7b801289-75a7-4d39-8cd3-24526e9e9da7
> [   ***] A start job is running for /sysroot (15s / 1min 35s)[   17.439377] XFS (dm-0): Starting recovery (logdev: internal)
> [  *** ] A start job is running for /sysroot (16s / 1min 35s)[   17.771158] xfs_log_mount_finish: Recovery needed is set
> [   17.771172] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:0
> [   17.771179] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:1
> [   17.771184] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:2
> [   17.771190] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:3
> [   17.771196] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:4
> [   17.771201] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:5
> [   17.801033] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:6
> [   17.801041] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:7
> [   17.801046] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:8
> [   17.801052] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:9
> [   17.801057] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:10
> [   17.801063] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:11
> [   17.801068] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:12
> [   17.801272] xlog_recover_iunlink_bucket: bucket: 13, agino: 3064909, ino: 3064909, iget ret: 0, previno:18446744073709551615, prev_agino:4294967295
> 
> <previno, prev_agino> is just <-1 %ull and -1 %u> in above. That's why
> the huge value.

That's NULLFSINO and NULLAGINO respectively. That's the indication
that this is the last inode on the chain and that the recovery loop
should terminate at this inode.

Nothing looks wrong to me there.


> 2. Then these are the logs from xfs_repair -n /dev/dm-0
> Here you will notice the same agi 3064909 in bucket 13 (from phase-2) which got also
> printed in above xlog_recover_iunlink_ag() function.
> 
> switch_root:/# xfs_repair -n /dev/dm-0
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> agi unlinked bucket 13 is 3064909 in ag 0 (inode=3064909)
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 2
>         - agno = 1
>         - agno = 3
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> would have reset inode 3064909 nlinks from 4294967291 to 2

And there's the problem. The link count, as an signed int, is -5.
It got reset to 2 probably because it was moved to lost+found due to
having a non-zero link count. Not sure how it got to -5 and I
suspect we'll never really know. However, I think that's irrelevant
because if we fix the problem with unlink recovery failing to
register an unlink recovery error from inodegc we'll intentionally
leak the inode and it won't ever be a problem again.


> No modify flag set, skipping filesystem flush and exiting.
> 
> 
> 3. Then we exit from the shell for the system to continue booting.
> Here it will continue.. Just pasting the logs where the warning gets
> generated and some extra logs are getting printed for the same inode
> with our patch.
> 
> 
> it continues
> ================
> [  587.999113] ------------[ cut here ]------------
> [  587.999121] WARNING: CPU: 48 PID: 2026 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]

Yeah, that happens because we failed to recover the unlinked inode,
we don't feed errors that occur in inodegc back to the unlink
recovery code, so it didn't clear the AGI bucket when we failed to
remove the inode from the unlinked list in inodegc. Hence it goes to
add the new inode to the start of unlinked list, and doesn't find the
broken, unrecovered inode that the bucket points to in cache.

IOWs, we fix the problem with feeding back errors from inodegc to
iunlink recovery, and this specific issue will go away.

> I can spend some more time to debug and understand on how to fix this.
> But thought of sharing this info meanwhile and see if there are any
> pointers on how to fix this in kernel.

I suspect that we need to do something like gather an error in
xfs_inodegc_flush() like we do for gathering the error in
xfs_btree_split() from the offloaded xfs_btree_split_worker()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
