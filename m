Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7360364D6
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734110138; cv=none; b=b0Ovp9DWXe7GduuJjDzWQ+VKumA7KrnF4cCP45PfCqrz+TQQuJLIc0xFwZTEYTmIjX814pf8cpWSyZrm8MJDT0wgP7JriVw3NJi1oc0N43eMdesAb99k4ikB43nqFsNy95D9xzKB8LMbeUArsAtvLIfG5KbNnvxSgUA9KxqHv7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734110138; c=relaxed/simple;
	bh=+J0TYNtkbkc1mAV0UwHrysbJGxr83NWDHKkpAznnxko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6Q6oqC6aSj3YMd25xVcaPeN2w4xsqCcLCJdXdAExUh/SlFXZo4m57hMpd65mJqRcdtgBzrHYKUgsf+UAbpmowdX+isOxao9L1hI5BfL1MFBtEgt/NWYzdiMufAuOjWRoDGfHt0WfcEx8CYwHITVIdaBiBl0oH1/K16avZrPfI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNWc6xNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNWc6xNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3720AC4CED0;
	Fri, 13 Dec 2024 17:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734110138;
	bh=+J0TYNtkbkc1mAV0UwHrysbJGxr83NWDHKkpAznnxko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kNWc6xNIOcbY+j7Ni1dSGo0JgdYITPydOn5YvikYY9AOxnu4hjBjqLJPml3OqtRG4
	 /GMKLa1mC3UFmKu7yW5xIzUlUJjQfu/kTBkezDYKrUyi1EiMehW6xssxPAaJ9DnGkT
	 4i2utTiSKaE+WWvK8We/EHg9YzlJh50DK9QadzvQSCSzJueLgkvc1cD7DrHvtcVtuf
	 LR0O/Mkklsz00BXQsHGUGjgfrvP7za2MMXKV7R9TNdZLGcGawA9x6DKMrfiWs6oq1q
	 kty+ngtClAFJyfM3p18DpDwRpC6ZVu53s9tOUwCCG09+ACEcEOnTG+TAfzryEch4+g
	 u6jP1fc4K3dmw==
Date: Fri, 13 Dec 2024 09:15:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <20241213171537.GL6698@frogsfrogsfrogs>
References: <20241128171458.37dc80ed@harpe.intellique.com>
 <Z0jbffI2A6Fn7LfO@dread.disaster.area>
 <20241129103332.4a6b452e@harpe.intellique.com>
 <Z0o8vE4MlIg-jQeR@dread.disaster.area>
 <20241212163351.58dd1305@harpe.intellique.com>
 <20241212202547.GK6678@frogsfrogsfrogs>
 <20241213164251.361f8877@harpe.intellique.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241213164251.361f8877@harpe.intellique.com>

On Fri, Dec 13, 2024 at 04:42:51PM +0100, Emmanuel Florac wrote:
> Le Thu, 12 Dec 2024 12:25:47 -0800
> "Darrick J. Wong" <djwong@kernel.org> écrivait:
> 
> 
> > Does this recreate the symptoms?
> > 
> <snip>
> > # df /mnt /mnt/dir
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/sda         20G  420M   20G   3% /mnt
> > /dev/sda        2.0G     0  2.0G   0% /mnt
> > # fallocate -l 19g /mnt/a
> > # df /mnt /mnt/dir
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/sda         20G   20G  345M  99% /mnt
> > /dev/sda        2.0G     0  2.0G   0% /mnt
> > 
> > Clearly, df should be reporting 345M available for both cases, since
> > we haven't actually used any of project 55's blocks.
> > 
> > # xfs_io -f -c 'pwrite -S 0x59 0 1m' -c fsync -c 'stat -vvvv'
> > /mnt/dir/fork wrote 1048576/1048576 bytes at offset 0
> > 1 MiB, 256 ops; 0.0008 sec (1.121 GiB/sec and 293915.0402 ops/sec)
> > fd.path = "/mnt/dir/fork"
> > fd.flags = non-sync,non-direct,read-write
> > stat.ino = 134
> > stat.type = regular file
> > stat.size = 1048576
> > stat.blocks = 2048
> > stat.atime = Thu Dec 12 12:11:06 2024
> > stat.mtime = Thu Dec 12 12:11:06 2024
> > stat.ctime = Thu Dec 12 12:11:06 2024
> > fsxattr.xflags = 0x0 []
> > fsxattr.projid = 55
> > fsxattr.extsize = 0
> > fsxattr.cowextsize = 0
> > fsxattr.nextents = 1
> > fsxattr.naextents = 0
> > dioattr.mem = 0x200
> > dioattr.miniosz = 512
> > dioattr.maxiosz = 2147483136
> > # df /mnt /mnt/dir
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/sda         20G   20G  344M  99% /mnt
> > /dev/sda        2.0G  1.0M  2.0G   1% /mnt
> > 
> > I think this behavior comes from xfs_fill_statvfs_from_dquot, which
> > does this:
> > 
> > 	limit = blkres->softlimit ?
> > 		blkres->softlimit :
> > 		blkres->hardlimit;
> > 	if (limit && statp->f_blocks > limit) {
> > 		statp->f_blocks = limit;
> > 		statp->f_bfree = statp->f_bavail =
> > 			(statp->f_blocks > blkres->reserved) ?
> > 			 (statp->f_blocks - blkres->reserved) : 0;
> > 	}
> > 
> > I think the f_bfree/f_bavail assignment is wrong because it doesn't
> > handle the case where f_bfree was less than (limit - reserved).
> > 
> > 	if (limit) {
> > 		uint64_t	remaining = 0;
> > 
> > 		if (statp->f_blocks > limit)
> > 			statp->f_blocks = limit;
> > 		if (limit > blkres->reserved)
> > 			remaining = limit - blkres->reserved;
> > 		statp->f_bfree = min(statp->f_bfree, remaining);
> > 		statp->f_bavail = min(statp->f_bavail, remaining);
> > 	}
> > 
> > This fixes the df output a bit:
> > # df /mnt /mnt/dir
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/sda         20G   20G  344M  99% /mnt
> > /dev/sda        2.0G  1.7G  344M  84% /mnt
> > 
> > Though the "used" column is nonsense now.  But I guess that's why
> > statfs only defines total blocks and free/available blocks.
> 
> Yep, that looks exactly like the problem we've met. Does the fact that
> not all folders have project quota change something in that case ?

No, I don't think that changes anything.  If you can build your own
kernel, can you try this out?

--D

xfs: don't over-report free space or inodes in statvfs

Emmanual Florac reports a strange occurrence when project quota limits
are enabled, free space is lower than the remaining quota, and someone
runs statvfs:

  # mkfs.xfs -f /dev/sda
  # mount /dev/sda /mnt -o prjquota
  # xfs_quota  -x -c 'limit -p bhard=2G 55' /mnt
  # mkdir /mnt/dir
  # xfs_io -c 'chproj 55' -c 'chattr +P' -c 'stat -vvvv' /mnt/dir
  # fallocate -l 19g /mnt/a
  # df /mnt /mnt/dir
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/sda         20G   20G  345M  99% /mnt
  /dev/sda        2.0G     0  2.0G   0% /mnt

I think the bug here is that xfs_fill_statvfs_from_dquot unconditionally
assigns to f_bfree without checking that the filesystem has enough free
space to fill the remaining project quota.  However, this is a
longstanding behavior of xfs so it's unclear what to do here.

Cc: <stable@vger.kernel.org> # v2.6.18
Fixes: 932f2c323196c2 ("[XFS] statvfs component of directory/project quota support, code originally by Glen.")
Reported-by: Emmanuel Florac <eflorac@intellique.com>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_qm_bhv.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 847ba29630e9d8..db5b8afd9d1b97 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -32,21 +32,28 @@ xfs_fill_statvfs_from_dquot(
 	limit = blkres->softlimit ?
 		blkres->softlimit :
 		blkres->hardlimit;
-	if (limit && statp->f_blocks > limit) {
-		statp->f_blocks = limit;
-		statp->f_bfree = statp->f_bavail =
-			(statp->f_blocks > blkres->reserved) ?
-			 (statp->f_blocks - blkres->reserved) : 0;
+	if (limit) {
+		uint64_t	remaining = 0;
+
+		if (limit > blkres->reserved)
+			remaining = limit - blkres->reserved;
+
+		statp->f_blocks = min(statp->f_blocks, limit);
+		statp->f_bfree = min(statp->f_bfree, remaining);
+		statp->f_bavail = min(statp->f_bavail, remaining);
 	}
 
 	limit = dqp->q_ino.softlimit ?
 		dqp->q_ino.softlimit :
 		dqp->q_ino.hardlimit;
-	if (limit && statp->f_files > limit) {
-		statp->f_files = limit;
-		statp->f_ffree =
-			(statp->f_files > dqp->q_ino.reserved) ?
-			 (statp->f_files - dqp->q_ino.reserved) : 0;
+	if (limit) {
+		uint64_t	remaining = 0;
+
+		if (limit > dqp->q_ino.reserved)
+			remaining = limit - dqp->q_ino.reserved;
+
+		statp->f_files = min(statp->f_files, limit);
+		statp->f_ffree = min(statp->f_ffree, remaining);
 	}
 }
 
