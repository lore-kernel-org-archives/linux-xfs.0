Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3585DDDC
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 20:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734035148; cv=none; b=pAWH9s7gYGYRnLrWm2LDhm2PdF7uuFqEDVFlRdEo0lC/Cc06dDQon82u5uU0iB8U8S1WsCfjcNRG7E+8MAjcWgYzcOII+wO6YxSwywBSIAcObbHpBImvkB46mwckzQX64aY44RQjxcfRKKcrZedVDhzQegm9c0ljNUyuwSQAuF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734035148; c=relaxed/simple;
	bh=9GvQYJgV0TxHEx9pAJzloUiWJqOyWNa8x6M+F6dp9aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6GWrEj4De4ybmJ4CrP2lDvZuKokEb/ZhzvmBH0Fe/fTyv5wv7p2k2RjYTRbjcsWSC0zCzO9hC/Z3G2twULBnisFlosPHBv0+MNZB2N3x9ymyc7qPX6BWGTy4qA4SMCTZpWl7MQA31jfmBQwUV+zeKIwxvV2HPnoAVo7nag0Ls4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFxWVdXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFxWVdXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F90C4CECE;
	Thu, 12 Dec 2024 20:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734035148;
	bh=9GvQYJgV0TxHEx9pAJzloUiWJqOyWNa8x6M+F6dp9aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KFxWVdXNGUUiyk7+BOPO4BnveOkEEbOfEeZbb3FtSfOqyv/86ZCGfM1LCd8NzvoPN
	 cj+LNvMcZzVUL30rxOW6UMc6Y5emX6F/mbzIl/uG/oGC9gMIEaj1l/1lN4Yog6mYR3
	 0V+mY6Wq9Fmx6W3ni93XdPyO1uxyuS8YWmUZyuCGtICcI5kbC9rVQQfUX10Ht3UiPO
	 w/iBS4/THTursf/A5k+snCu48aMXVpQUVDjG1cjyu2mDpMAVq3AcgFMHwVvlJ/UUnr
	 +YLc1DJUqlMlnRCQvNyywugFT6Y790zQ3BNWFokWYqsvrZ2ce1pISoysxZmmXugJ8+
	 7wcuSfdAS4CdQ==
Date: Thu, 12 Dec 2024 12:25:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <20241212202547.GK6678@frogsfrogsfrogs>
References: <20241128171458.37dc80ed@harpe.intellique.com>
 <Z0jbffI2A6Fn7LfO@dread.disaster.area>
 <20241129103332.4a6b452e@harpe.intellique.com>
 <Z0o8vE4MlIg-jQeR@dread.disaster.area>
 <20241212163351.58dd1305@harpe.intellique.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241212163351.58dd1305@harpe.intellique.com>

On Thu, Dec 12, 2024 at 04:33:51PM +0100, Emmanuel Florac wrote:
> Le Sat, 30 Nov 2024 09:14:20 +1100
> Dave Chinner <david@fromorbit.com> écrivait:
> 
> > > xfs_quota -x -c "limit -p bhard=30000g 10" /mnt/raid  
> > 
> > That should set it up appropriately, hence the need to check if it
> > has actually been set up correctly on disk.
> > 
> 
> Unfortunately in the meantime the users did some cleanup, therefore the
> displayed information is coherent again (as there is more free space on
> the filesystem as a whole as any remaining allocated quota).
> 
> xfs_quota -x -c "report -p"
> Project quota on /mnt/raid (/dev/mapper/vg0-raid)
>                          Blocks  
> Project ID       Used       Soft       Hard    Warn/Grace
> 
> ----------- ------------------------------------------------------
> 
> <snip>
> #40        10795758244          0 16106127360     00 [--------]
> 
> 
> > > > Output of df and a project quota report showing usage and limits
> > > > would be useful here.
> 
> looking at the corresponding folder :
> 
> /dev/mapper/vg0-raid    15T     11T  5,0T  68% /mnt/raid/pad
> 
> 
>  du -s /mnt/raid/pad
> 10795758244	/mnt/raid/pad
> 
> # find /mnt/raid/pad -print | wc -l
> 39086
> 
> > > > Then, for each of the top level project directories you are
> > > > querying with df, also run `xfs_io -rxc "stat" <dir>` and post
> > > > the output. This will tell us if the project quota is set up
> > > > correctly for df to report quota limits for them.
> > > > 
> 
> Starting with "pad" :
> 
> # xfs_io -rxc "stat" pad
> fd.path = "."
> fd.flags = non-sync,non-direct,read-only
> stat.ino = 6442662464
> stat.type = directory
> stat.size = 4096
> stat.blocks = 16
> fsxattr.xflags = 0x200 \[--------P--------\]
> fsxattr.projid = 40
> fsxattr.extsize = 0
> fsxattr.cowextsize = 0
> fsxattr.nextents = 2
> fsxattr.naextents = 0
> dioattr.mem = 0x200
> dioattr.miniosz = 512
> dioattr.maxiosz = 2147483136
> 
> # xfs_io -rxc "stat" rush
> fd.path = "."
> fd.flags = non-sync,non-direct,read-only
> stat.ino = 142
> stat.type = directory
> stat.size = 283
> stat.blocks = 0
> fsxattr.xflags = 0x200 \[--------P--------\]
> fsxattr.projid = 10
> fsxattr.extsize = 0
> fsxattr.cowextsize = 0
> fsxattr.nextents = 0
> fsxattr.naextents = 0
> dioattr.mem = 0x200
> dioattr.miniosz = 512
> dioattr.maxiosz = 2147483136
> 
> # xfs_io -rxc "stat" labo
> fd.path = "."
> fd.flags = non-sync,non-direct,read-only
> stat.ino = 2147695168
> stat.type = directory
> stat.size = 310
> stat.blocks = 0
> fsxattr.xflags = 0x200 \[--------P--------\]
> fsxattr.projid = 20
> fsxattr.extsize = 0
> fsxattr.cowextsize = 0
> fsxattr.nextents = 0
> fsxattr.naextents = 0
> dioattr.mem = 0x200
> dioattr.miniosz = 512
> dioattr.maxiosz = 2147483136
> 
> # xfs_io -rxc "stat" prods
> fd.path = "."
> fd.flags = non-sync,non-direct,read-only
> stat.ino = 4295178816
> stat.type = directory
> stat.size = 319
> stat.blocks = 0
> fsxattr.xflags = 0x200 \[--------P--------\]
> fsxattr.projid = 30
> fsxattr.extsize = 0
> fsxattr.cowextsize = 0
> fsxattr.nextents = 0
> fsxattr.naextents = 0
> dioattr.mem = 0x200
> dioattr.miniosz = 512
> dioattr.maxiosz = 2147483136
> 
> > > > It would also be useful to know if the actual quota usage is
> > > > correct
> > > > - having the output of `du -s /mnt/raid/project1` to count the
> > > > blocks and `find /mnt/raid/project1 -print |wc -l` to count the
> > > > files in quota controlled directories. That'll give us some idea
> > > > if there's a quota accounting issue.  
> > 
> > iAnother thought occurred to me - can you also check that
> > /etc/projid and /etc/projects is similar on all machines, and post
> > the contents of them from the bad machine?
> > 
> 
> Hum, actually they didn't set up neither projid nor projects. Of course
> I did create these during my tests, but could this be the culprit ?

Does this recreate the symptoms?

# mkfs.xfs -f /dev/sda
meta-data=/dev/sda               isize=512    agcount=4, agsize=1298176 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0   metadir=0
data     =                       bsize=4096   blocks=5192704, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
Discarding blocks...Done.
# mount /dev/sda /mnt -o prjquota
# xfs_quota  -x -c 'limit -p bhard=2G 55' /mnt
# mkdir /mnt/dir
# xfs_io -c 'chproj 55' -c 'chattr +P' -c 'stat -vvvv' /mnt/dir
fd.path = "/mnt/dir"
fd.flags = non-sync,non-direct,read-write
stat.ino = 132
stat.type = directory
stat.size = 6
stat.blocks = 0
stat.atime = Thu Dec 12 12:07:53 2024
stat.mtime = Thu Dec 12 12:07:53 2024
stat.ctime = Thu Dec 12 12:08:12 2024
fsxattr.xflags = 0x200 [proj-inherit]
fsxattr.projid = 55
fsxattr.extsize = 0
fsxattr.cowextsize = 0
fsxattr.nextents = 0
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
# df /mnt /mnt/dir
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda         20G  420M   20G   3% /mnt
/dev/sda        2.0G     0  2.0G   0% /mnt
# fallocate -l 19g /mnt/a
# df /mnt /mnt/dir
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda         20G   20G  345M  99% /mnt
/dev/sda        2.0G     0  2.0G   0% /mnt

Clearly, df should be reporting 345M available for both cases, since we
haven't actually used any of project 55's blocks.

# xfs_io -f -c 'pwrite -S 0x59 0 1m' -c fsync -c 'stat -vvvv' /mnt/dir/fork
wrote 1048576/1048576 bytes at offset 0
1 MiB, 256 ops; 0.0008 sec (1.121 GiB/sec and 293915.0402 ops/sec)
fd.path = "/mnt/dir/fork"
fd.flags = non-sync,non-direct,read-write
stat.ino = 134
stat.type = regular file
stat.size = 1048576
stat.blocks = 2048
stat.atime = Thu Dec 12 12:11:06 2024
stat.mtime = Thu Dec 12 12:11:06 2024
stat.ctime = Thu Dec 12 12:11:06 2024
fsxattr.xflags = 0x0 []
fsxattr.projid = 55
fsxattr.extsize = 0
fsxattr.cowextsize = 0
fsxattr.nextents = 1
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
# df /mnt /mnt/dir
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda         20G   20G  344M  99% /mnt
/dev/sda        2.0G  1.0M  2.0G   1% /mnt

I think this behavior comes from xfs_fill_statvfs_from_dquot, which does
this:

	limit = blkres->softlimit ?
		blkres->softlimit :
		blkres->hardlimit;
	if (limit && statp->f_blocks > limit) {
		statp->f_blocks = limit;
		statp->f_bfree = statp->f_bavail =
			(statp->f_blocks > blkres->reserved) ?
			 (statp->f_blocks - blkres->reserved) : 0;
	}

I think the f_bfree/f_bavail assignment is wrong because it doesn't
handle the case where f_bfree was less than (limit - reserved).

	if (limit) {
		uint64_t	remaining = 0;

		if (statp->f_blocks > limit)
			statp->f_blocks = limit;
		if (limit > blkres->reserved)
			remaining = limit - blkres->reserved;
		statp->f_bfree = min(statp->f_bfree, remaining);
		statp->f_bavail = min(statp->f_bavail, remaining);
	}

This fixes the df output a bit:
# df /mnt /mnt/dir
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda         20G   20G  344M  99% /mnt
/dev/sda        2.0G  1.7G  344M  84% /mnt

Though the "used" column is nonsense now.  But I guess that's why statfs
only defines total blocks and free/available blocks.

--D


> -- 
> ------------------------------------------------------------------------
>    Emmanuel Florac     |   Direction technique
> ------------------------------------------------------------------------
>    https://intellique.com
>    +33 6 16 30 15 95
> ------------------------------------------------------------------------
>  


