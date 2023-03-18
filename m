Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19492C61DA4
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 16:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCRQu6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Mar 2023 12:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCRQu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Mar 2023 12:50:57 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343DD28E8F
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 09:50:56 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id l14so4748437pfc.11
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 09:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679158255;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EV3mSw3YF08qCwlL4eJExcKoHZEyz5gn5MywHLFLaeE=;
        b=I4HR3r+oqOk6RAwHxTIVx3RmTq0Nm4M1vqaO7mcYIfbXVsaeR3U0LQqoDVn6x96SKm
         fIP/w26yz6ng8usFb8v6tJGEMj2c8ieZmDQk8xhwKLEf/0o/8s0LrojF60Zwuxq6HtXL
         d8H0PAIca/flwdS9hQEzoDEnppBZZZBVuU8rN6xYkleojv8QS4z9k3AuuEEnqSzxIjy/
         F26p2f3diJ3O6+DL97zfacqf1C9gBjY9163T/uY+Tz6fe7WvD+S2qzXPaM0PzSzb1Tt+
         MtpUT6MuroGrnuBhxLJ0l+OdeAgnYbo6gr9hirKIOiZojK4nvbx133ZOdnnS3LW0R1mk
         k1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679158255;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EV3mSw3YF08qCwlL4eJExcKoHZEyz5gn5MywHLFLaeE=;
        b=vhPpu6navy2ZWCyyFHE2xxm6xkxoKAnpNcFRkgjK9uGyTpqMhN/qOycpWNjjqy02YB
         HPNqavDs9E3CnOeqZmOoigxQ8PirAzfKQc4STiiLPvmJ6g3+pTYGfk4hp+GaI2zTD8uR
         p39f5gPhx3pgRr4IWFl6WVNwLArjLwb1BDwlfv4Ojt6D/RqUZqkXdWuyf7VV1aoIoPzZ
         6oZrZ9qpoMM7LK0zENiNGSDFvr+r+3R/kxn0W090KDK1XqA0wMT4PvIyACRRpCq2cjmb
         R/8kr6Ug6kbd9bSsivk+tD4jvjpnvTpkvDPsqjZ/oOSWSOwm5F3r8D7CXUscLD4JIkry
         V3Ig==
X-Gm-Message-State: AO0yUKV5Z/WjrwYx3zpj4Qt1zL3zsrS54g/DrX+UzC9X0nd/sie43Rwq
        mvGJOg86gU/8hYyuJ92+SlnzbdiGuCae1A==
X-Google-Smtp-Source: AK7set+8WaxIm17yEPHVb3f83cl14WkUBJyHk4Ckrxg20fUBzpmAtueLiB7JyYcCiGsPGyPFSIodlQ==
X-Received: by 2002:a62:5802:0:b0:626:14fb:3c87 with SMTP id m2-20020a625802000000b0062614fb3c87mr6565000pfb.4.1679158255431;
        Sat, 18 Mar 2023 09:50:55 -0700 (PDT)
Received: from rh-tp ([2406:7400:63:469f:eb50:3ffb:dc1b:2d55])
        by smtp.gmail.com with ESMTPSA id l21-20020a656815000000b004eecc3080f8sm3412187pgt.29.2023.03.18.09.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 09:50:54 -0700 (PDT)
Date:   Sat, 18 Mar 2023 22:20:28 +0530
Message-Id: <87pm969f6z.fsf@doe.com>
From:   Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     shrikanth hegde <sshegde@linux.vnet.ibm.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error xfs_trans_cancel
In-Reply-To: <20230317204418.GQ11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Wed, Mar 15, 2023 at 10:20:37PM -0700, Darrick J. Wong wrote:
>> On Thu, Mar 16, 2023 at 10:16:02AM +0530, Ritesh Harjani wrote:
>> > "Darrick J. Wong" <djwong@kernel.org> writes:
>> > 
>> > Hi Darrick,
>> > 
>> > Thanks for your analysis and quick help on this.
>> > 
>> > >>
>> > >> Hi Darrick,
>> > >>
>> > >> Please find the information collected from the system. We added some
>> > >> debug logs and looks like it is exactly what is happening which you
>> > >> pointed out.
>> > >>
>> > >> We added a debug kernel patch to get more info from the system which
>> > >> you had requested [1]
>> > >>
>> > >> 1. We first breaked into emergency shell where root fs is first getting
>> > >> mounted on /sysroot as "ro" filesystem. Here are the logs.
>> > >>
>> > >> [  OK  ] Started File System Check on /dev/mapper/rhel_ltcden3--lp1-root.
>> > >>          Mounting /sysroot...
>> > >> [    7.203990] SGI XFS with ACLs, security attributes, quota, no debug enabled
>> > >> [    7.205835] XFS (dm-0): Mounting V5 Filesystem 7b801289-75a7-4d39-8cd3-24526e9e9da7
>> > >> [   ***] A start job is running for /sysroot (15s / 1min 35s)[   17.439377] XFS (dm-0): Starting recovery (logdev: internal)
>> > >> [  *** ] A start job is running for /sysroot (16s / 1min 35s)[   17.771158] xfs_log_mount_finish: Recovery needed is set
>> > >> [   17.771172] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:0
>> > >> [   17.771179] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:1
>> > >> [   17.771184] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:2
>> > >> [   17.771190] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:3
>> > >> [   17.771196] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:4
>> > >> [   17.771201] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:5
>> > >> [   17.801033] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:6
>> > >> [   17.801041] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:7
>> > >> [   17.801046] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:8
>> > >> [   17.801052] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:9
>> > >> [   17.801057] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:10
>> > >> [   17.801063] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:11
>> > >> [   17.801068] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:12
>> > >> [   17.801272] xlog_recover_iunlink_bucket: bucket: 13, agino: 3064909, ino: 3064909, iget ret: 0, previno:18446744073709551615, prev_agino:4294967295
>> > >>
>> > >> <previno, prev_agino> is just <-1 %ull and -1 %u> in above. That's why
>> > >> the huge value.
>> > >
>> > > Ok, so log recovery finds 3064909 and clears it...
>> > >
>> > >> [   17.801281] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:13
>> > >> [   17.801287] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:14
>> > >
>> > > <snip the rest of these...>
>> > >
>> > >> [   17.844910] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:62
>> > >> [   17.844916] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:63
>> > >> [   17.886079] XFS (dm-0): Ending recovery (logdev: internal)
>> > >> [  OK  ] Mounted /sysroot.
>> > >> [  OK  ] Reached target Initrd Root File System.
>> > >>
>> > >>
>> > >> 2. Then these are the logs from xfs_repair -n /dev/dm-0
>> > >> Here you will notice the same agi 3064909 in bucket 13 (from phase-2) which got also
>> > >> printed in above xlog_recover_iunlink_ag() function.
>> > >>
>> > >> switch_root:/# xfs_repair -n /dev/dm-0
>> > >> Phase 1 - find and verify superblock...
>> > >> Phase 2 - using internal log
>> > >>         - zero log...
>> > >>         - scan filesystem freespace and inode maps...
>> > >> agi unlinked bucket 13 is 3064909 in ag 0 (inode=3064909)
>> > >
>> > > ...yet here we find that 3064909 is still on the unlinked list?
>> > >
>> > > Just to confirm -- you ran xfs_repair -n after the successful recovery
>> > > above, right?
>> > >
>> > Yes, that's right.
>> > 
>> > >>         - found root inode chunk
>> > >> Phase 3 - for each AG...
>> > >>         - scan (but don't clear) agi unlinked lists...
>> > >>         - process known inodes and perform inode discovery...
>> > >>         - agno = 0
>> > >>         - agno = 1
>> > >>         - agno = 2
>> > >>         - agno = 3
>> > >>         - process newly discovered inodes...
>> > >> Phase 4 - check for duplicate blocks...
>> > >>         - setting up duplicate extent list...
>> > >>         - check for inodes claiming duplicate blocks...
>> > >>         - agno = 0
>> > >>         - agno = 2
>> > >>         - agno = 1
>> > >>         - agno = 3
>> > >> No modify flag set, skipping phase 5
>> > >> Phase 6 - check inode connectivity...
>> > >>         - traversing filesystem ...
>> > >>         - traversal finished ...
>> > >>         - moving disconnected inodes to lost+found ...
>> > >> Phase 7 - verify link counts...
>> > >> would have reset inode 3064909 nlinks from 4294967291 to 2
>> > >
>> > > Oh now that's interesting.  Inode on unlinked list with grossly nonzero
>> > > (but probably underflowed) link count.  That might explain why iunlink
>> > > recovery ignores the inode.  Is inode 3064909 reachable via the
>> > > directory tree?
>> > >
>> > > Would you mind sending me a metadump to play with?  metadump -ago would
>> > > be best, if filenames/xattrnames aren't sensitive customer data.
>> > 
>> > Sorry about the delay.
>> > I am checking for any permissions part internally.
>> > Meanwhile - I can help out if you would like me to try anything.
>> 
>> Ok.  I'll try creating a filesystem with a weirdly high refcount
>> unlinked inode and I guess you can try it to see if you get the same
>> symptoms.  I've finished with my parent pointers work for the time
>> being, so I might have some time tomorrow (after I kick the tires on
>> SETFSUUID) to simulate this and see if I can adapt the AGI repair code
>> to deal with this.
>
> If you uncompress and mdrestore the attached file to a blockdev, mount
> it, and run some creat() exerciser, do you get the same symptoms?  I've
> figured out how to make online fsck deal with it. :)
>
> A possible solution for runtime would be to make it so that
> xfs_iunlink_lookup could iget the inode if it's not in cache at all.
>

Hello Darrick, 

I did xfs_mdrestore the metadump you provided on a loop mounted
blockdev. I ran fsstress on the root dir of the mounted filesystem,
but I was unable to hit the issue.

I tried the same with the original FS metadump as well and I am unable
to hit the issue while running fsstress on the filesystem. 

I am thinking of identifying which file unlink operation was in progress
when we see the issue during mounting. Maybe that will help in
recreating the issue.

Although the xfs_repair -n does show a similar log of unlinked inode
with the metadump you provided.

root@ubuntu:~# xfs_repair -n -o force_geometry /dev/loop7
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
agi unlinked bucket 3 is 6979 in ag 0 (inode=6979)
agi unlinked bucket 4 is 6980 in ag 0 (inode=6980)
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 6979, would move to lost+found
disconnected inode 6980, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 6979 nlinks from 5555 to 1
would have reset inode 6980 nlinks from 0 to 1
No modify flag set, skipping filesystem flush and exiting.

Thanks again for the help. Once I have more info I will update the
thread!

-ritesh
