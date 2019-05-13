Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbfEMOJz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 May 2019 10:09:55 -0400
Date: Mon, 13 May 2019 10:09:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
Message-ID: <20190513140943.GC61135@bfoster>
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tim Smith <tim.smith@vaultcloud.com.au>
Cc: linux-xfs@vger.kernel.org

On Mon, May 13, 2019 at 11:45:26AM +1000, Tim Smith wrote:
> Hey guys,
> 
> We've got a bunch of hosts with multiple spinning disks providing file
> server duties with xfs.
> 
> Some of the filesystems will go into a state where they report
> negative used space -  e.g. available is greater than total.
> 
> This appears to be purely cosmetic, as we can still write data to (and
> read from) the filesystem, but it throws out our reporting data.
> 
> We can (temporarily) fix the issue by unmounting and running
> `xfs_repair` on the filesystem, but it soon reoccurs.
> 
> Does anybody have any ideas as to why this might be happening and how
> to prevent it? Can userspace processes affect change to the xfs
> superblock?
> 

Hmm, I feel like there have been at least a few fixes for similar
symptoms over the past few releases. It might be hard to pinpoint one
unless somebody more familiar with this problem comes across this.

FWIW, something like commit aafe12cee0 ("xfs: don't trip over negative
free space in xfs_reserve_blocks") looks like it could cause this kind
of wonky accounting, but that's just a guess from skimming the patch
log. I have no idea if you'd be affected by this.

> Example of a 'good' filesystem on the host:
> 
> $ sudo df -k /dev/sdac
> Filesystem      1K-blocks       Used  Available Use% Mounted on
> /dev/sdac      9764349952 7926794452 1837555500  82% /srv/node/sdac
> 
> $ sudo strace df -k /dev/sdac |& grep statfs
> 
> statfs("/srv/node/sdac", {f_type=0x58465342, f_bsize=4096,
> f_blocks=2441087488, f_bfree=459388875, f_bavail=459388875,
> f_files=976643648, f_ffree=922112135, f_fsid={16832, 0},
> f_namelen=255, f_frsize=4096, f_flags=3104}) = 0
> 
> $ sudo xfs_db -r /dev/sdac
> [ snip ]
> icount = 54621696
> free = 90183
> fdblocks = 459388955
> 
> Example of a 'bad' filesystem on the host:
> 
> $ sudo df -k /dev/sdad
> Filesystem      1K-blocks        Used   Available Use% Mounted on
> /dev/sdad      9764349952 -9168705440 18933055392    - /srv/node/sdad
> 
> $ sudo strace df -k /dev/sdad |& grep statfs
> statfs("/srv/node/sdad", {f_type=0x58465342, f_bsize=4096,
> f_blocks=2441087488, f_bfree=4733263848, f_bavail=4733263848,
> f_files=976643648, f_ffree=922172221, f_fsid={16848, 0},
> f_namelen=255, f_frsize=4096, f_flags=3104}) = 0
> 

It looks like you end up somehow having a huge free block count, larger
even than the total block count. The 'used' value reported by userspace
ends up being f_blocks - f_bfree, hence the negative value.

> $ sudo xfs_db -r /dev/sdad
> [ snip ]
> icount = 54657600
> ifree = 186173
> fdblocks = 4733263928
> 
> Host environment:
> $ uname -a
> Linux hostname 4.15.0-47-generic #50~16.04.1-Ubuntu SMP Fri Mar 15
> 16:06:21 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
> 

Could you also include xfs_info and mount params of the filesystem(s) in
question?

Also, is this negative blocks used state persistent for any of these
filesystems? IOW, if you unmount/mount, are you right back into this
state, or does accounting start off sane and fall into this bogus state
after a period of runtime or due to some unknown operation?

If the former, the next best step might be to try a filesystem on a more
recent kernel and determine whether this problem is already fixed one
way or another. Note that this could be easily done on a
development/test system with an xfs_metadump image of the fs if you
didn't want to muck around with production systems.

Brian

> $ lsb_release -a
> No LSB modules are available.
> Distributor ID: Ubuntu
> Description: Ubuntu 16.04.5 LTS
> Release: 16.04
> Codename: xenial
> 
> Thank you!
> Tim
