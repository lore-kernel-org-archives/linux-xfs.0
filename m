Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfGKPch (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jul 2019 11:32:37 -0400
Date: Thu, 11 Jul 2019 23:38:12 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: project quota ineritance flag test
Message-ID: <20190711153812.GA19443@dhcp-12-102.nay.redhat.com>
References: <20190619101047.3149-1-zlang@redhat.com>
 <20190711143516.GG5167@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711143516.GG5167@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Jul 11, 2019 at 07:35:16AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 19, 2019 at 06:10:47PM +0800, Zorro Lang wrote:
> > This case is used to cover xfsprogs bug "b136f48b xfs_quota: fix
> > false error reporting of project inheritance flag is not set" at
> > first. Then test more behavior when project ineritance flag is
> > set or removed.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> 
> <skipping to the good part>
> 
> > diff --git a/tests/xfs/507.out b/tests/xfs/507.out
> > new file mode 100644
> > index 00000000..c8c09d3f
> > --- /dev/null
> > +++ b/tests/xfs/507.out
> > @@ -0,0 +1,23 @@
> > +QA output created by 507
> > +== The parent directory has Project inheritance bit by default ==
> > +Checking project test (path [SCR_MNT]/dir)...
> > +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> > +
> > +Write SCRATCH_MNT/dir/foo, expect ENOSPC:
> > +pwrite: No space left on device
> > +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> > +pwrite: No space left on device
> > +
> > +== After removing parent directory has Project inheritance bit ==
> > +Checking project test (path [SCR_MNT]/dir)...
> > +[SCR_MNT]/dir - project inheritance flag is not set
> > +[SCR_MNT]/dir/foo - project identifier is not set (inode=0, tree=10)
> > +[SCR_MNT]/dir/dir_uninherit - project identifier is not set (inode=0, tree=10)
> > +[SCR_MNT]/dir/dir_uninherit - project inheritance flag is not set
> > +[SCR_MNT]/dir/dir_uninherit/foo - project identifier is not set (inode=0, tree=10)
> > +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> > +
> > +Write SCRATCH_MNT/dir/foo, expect Success:
> > +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> > +pwrite: No space left on device
> 
> I keep seeing this test failure:
> 
> --- a/xfs/508.out      2019-06-30 08:32:32.216174715 -0700
> +++ b/xfs/508.out.bad    2019-07-11 07:32:30.488000000 -0700
> @@ -19,5 +19,5 @@
>  
>  Write SCRATCH_MNT/dir/foo, expect Success:
>  Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> -pwrite: No space left on device
> +/opt/dir/dir_inherit/foo: Disk quota exceeded

Hmm... I never saw this issue. I tested on RHEL-7, RHEL-8.0 and latest upstream
xfsprogs & xfs-linux, all passed.

>  Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:
> 
> IIRC EDQUOT is the correct error code for running out of /project/
> quota (and I tried with a modern V5 fs and a V4 fs too) both with
> setting no quota options at all and turning on every quota type
> supported by the fs.
> 
> Under what circumstances does xfs_io spit out ENOSPC?

I didn't test with any special test arguments, all as default. For example, as
below test on
xfsprogs: HEAD: 8bfb5eac (HEAD -> for-next, origin/for-next) xfs_quota: fix built-in help for project setup
xfs-linux: HEAD: 036f463fe15d (HEAD -> for-next, tag: xfs-5.3-merge-10, origin/xfs-5.3-merge, origin/for-next) xfs: online scrub needn't bother zeroing its temporary buffer

# ./check xfs/508
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 xxx-xxxxxx-xxx 5.2.0-rc4-xfs-for-next
MKFS_OPTIONS  -- -f -bsize=4096 /dev/mapper/xfscratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/xfscratch /mnt/scratch

xfs/508 5s ...  5s
Ran: xfs/508
Passed all 1 tests

# xfs_io -V
xfs_io version 5.1.0-rc0

# xfs_info /dev/mapper/xfscratch
meta-data=/dev/mapper/xfscratch isize=512    agcount=4, agsize=5570560 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=22282240, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=10880, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Do you need me to provide anything else?

Thanks,
Zorro

> 
> --D
> 
> > +Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index ffe4ae12..46200752 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -504,3 +504,4 @@
> >  504 auto quick mkfs label
> >  505 auto quick spaceman
> >  506 auto quick health
> > +507 auto quick quota
> > -- 
> > 2.17.2
> > 
