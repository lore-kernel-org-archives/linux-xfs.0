Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB71EB64D9
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jul 2023 22:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjGJWBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 18:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjGJWBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jul 2023 18:01:08 -0400
X-Greylist: delayed 429 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Jul 2023 15:01:07 PDT
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25294DB
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 15:01:06 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 3368461980
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 07:53:55 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id SiSIze3Z3uGj for <linux-xfs@vger.kernel.org>;
        Tue, 11 Jul 2023 07:53:55 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 039E56196C
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 07:53:55 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id DC4B968061C; Tue, 11 Jul 2023 07:53:54 +1000 (AEST)
Date:   Tue, 11 Jul 2023 07:53:54 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     linux-xfs@vger.kernel.org
Subject: rm hanging, v6.1.35
Message-ID: <20230710215354.GA679018@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

This box is newly booted into linux v6.1.35 (2 days ago), it was 
previously running v5.15.118 without any problems (other than that fixed 
by "5e672cd69f0a xfs: non-blocking inodegc pushes", the reason for the 
upgrade).

I have rm operations on two files that have been stuck for in excess of 22 
hours and 18 hours respectively:

$ ps -opid,lstart,state,wchan=WCHAN-xxxxxxxxxxxxxxx,cmd -C rm
     PID                  STARTED S WCHAN-xxxxxxxxxxxxxxx CMD
2379355 Mon Jul 10 09:07:57 2023 D vfs_unlink            /bin/rm -rf /aaa/5539_tmp
2392421 Mon Jul 10 09:18:27 2023 D down_write_nested     /bin/rm -rf /aaa/5539_tmp
2485728 Mon Jul 10 09:28:57 2023 D down_write_nested     /bin/rm -rf /aaa/5539_tmp
2488254 Mon Jul 10 09:39:27 2023 D down_write_nested     /bin/rm -rf /aaa/5539_tmp
2491180 Mon Jul 10 09:49:58 2023 D down_write_nested     /bin/rm -rf /aaa/5539_tmp
3014914 Mon Jul 10 13:00:33 2023 D vfs_unlink            /bin/rm -rf /bbb/5541_tmp
3095893 Mon Jul 10 13:11:03 2023 D down_write_nested     /bin/rm -rf /bbb/5541_tmp
3098809 Mon Jul 10 13:21:35 2023 D down_write_nested     /bin/rm -rf /bbb/5541_tmp
3101387 Mon Jul 10 13:32:06 2023 D down_write_nested     /bin/rm -rf /bbb/5541_tmp
3195017 Mon Jul 10 13:42:37 2023 D down_write_nested     /bin/rm -rf /bbb/5541_tmp

The "rm"s are run from a process that's obviously tried a few times to get 
rid of these files.

There's nothing extraordinary about the files in terms of size:

$ ls -ltrn --full-time /aaa/5539_tmp /bbb/5541_tmp
-rw-rw-rw- 1 1482 1482 7870643 2023-07-10 06:07:58.684036505 +1000 /aaa/5539_tmp
-rw-rw-rw- 1 1482 1482  701240 2023-07-10 10:00:34.181064549 +1000 /bbb/5541_tmp

As hinted by the WCHAN in the ps output above, each "primary" rm (i.e. the 
first one run on each file) stack trace looks like:

[<0>] vfs_unlink+0x48/0x270
[<0>] do_unlinkat+0x1f5/0x290
[<0>] __x64_sys_unlinkat+0x3b/0x60
[<0>] do_syscall_64+0x34/0x80
[<0>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

And each "secondary" rm (i.e. the subsequent ones on each file) stack 
trace looks like:

== blog-230710-xfs-rm-stuckd
[<0>] down_write_nested+0xdc/0x100
[<0>] do_unlinkat+0x10d/0x290
[<0>] __x64_sys_unlinkat+0x3b/0x60
[<0>] do_syscall_64+0x34/0x80
[<0>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Multiple kernel strack traces don't show vfs_unlink or anything related 
that I can see, or anything else consistent or otherwise interesting. Most 
cores are idle.

Each of /aaa and /bbb are separate XFS filesystems:

$ xfs_info /aaa
meta-data=/dev/mapper/aaa        isize=512    agcount=2, agsize=268434432 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=1
          =                       reflink=1    bigtime=1 inobtcount=1
data     =                       bsize=4096   blocks=536868864, imaxpct=5
          =                       sunit=256    swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=262143, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

$ xfs_info /bbb
meta-data=/dev/mapper/bbb        isize=512    agcount=8, agsize=268434432 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=1
          =                       reflink=1    bigtime=1 inobtcount=1
data     =                       bsize=4096   blocks=1879047168, imaxpct=5
          =                       sunit=256    swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

There's plenty of free space at the fs level:

$ df -h /aaa /bbb
Filesystem          Size  Used Avail Use% Mounted on
/dev/mapper/aaa     2.0T  551G  1.5T  27% /aaa
/dev/mapper/bbb     7.0T  3.6T  3.5T  52% /bbb

The fses are on sparse ceph/rbd volumes, the underlying storage tells me 
they're 50-60% utilised:

aaa: provisioned="2048G" used="1015.9G"
bbb: provisioned="7168G" used="4925.3G"

Where to from here?

I'm guessing only a reboot is going to unstick this. Anything I should be 
looking at before reverting to v5.15.118?

...subsequent to starting writing all this down I have another two sets of 
rms stuck, again on unremarkable files, and on two more separate 
filesystems.

...oh. And an 'ls' on those files is hanging. The reboot has become more 
urgent.

Cheers,

Chris
