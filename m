Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1446B139F
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 00:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706748745; cv=none; b=i+40d1H5qf0fW8EgbTY1PIVJ6FNOgGR6neL1REudLpMguc8D3bvFO2NsAiJRWSTFGXgVeugn27bfCmrhAhnXSeCp6z6A23ykbi7vxzGhj2YWLNQKWcsrOtp0CqZfxDwStDzo+KWICete2SgFlZzdiNv10besXJ61m9GrrYEzgvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706748745; c=relaxed/simple;
	bh=pDprpbLHdaXHf87/OJ5tvPjGlnUacrdJTc3knd/gdBI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RRO0ddtC5NiGjFTPnUAfKkLdG60jbevgzBnn6Y2E0X317upDIXCyGAm0ipgFYQqt9PCSYiiE2KX2QXA/TD6W6P3gQoi8VMOlMqlrD9J5wPk6Tg+VhkShpBHnGX2wJayhxyIJVyPNJhLZ6KGPCtApMtdW341yyLt7Ypp5o6s8Kgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=HOrWi/8u; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="HOrWi/8u"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d7393de183so2952095ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 16:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706748743; x=1707353543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=VvXXdhMJaI2cP/uUnZbvuaDRJM0YEAFe45ycn8xm1cA=;
        b=HOrWi/8uhMmRf6KLBqrXng0zl+ozhutyWYLLauyyLx4AstJKUhSeT6XO7183FBC3JO
         U1H8FXmOs3l+WIKtcloKRDw0g2TDhTXbS40ZAPtTn5rFSy1Tayo0BFk72hiZyLrfsoiz
         NxRPsilaXKG5OG2lVeszcaPGjONFXEBnEP4B7Vpov3yqDYhAfjgsOBs5yznVg+kvHa8B
         LW7CSL3xSrWh6Zzcf9PfCbKkIF1PDwY0mmYB3Ucy0oLuVYlThnl1SxRJtfUEEU2CkGf8
         Oa9Ufz9KC8wq+lBZV2p1/LJPM9gkd0VFcS/dv6bK3NTOeNYSrZOmw/3fbDWzk/MhMcoM
         6WWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706748743; x=1707353543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VvXXdhMJaI2cP/uUnZbvuaDRJM0YEAFe45ycn8xm1cA=;
        b=OD/C9aLCapDLvmOKh8utvvAshb24DdnhDjOBmde19POLh2K4EyxxuWDcm3ysXQqOPt
         BIUuG/s773S1BxfLwNKs+O8tAMBCTMKKmx0IslJrU9vwBlwMi4907RU6ajd1p9GpmPR6
         Ya+pdGZ6UBqN3Lc7qqO5Fdsn7jHwW+z+uS8hPCOswuUTf0JtvfYodjfL+wEMawG9QqvW
         NqcgZXeIbt5i8msxb2r8TSF3I+9H4L6A4QLcTTqmSg+r3geZ+Z86qLhn1Wl+r8daBLDc
         MsDXNlQcoU/OLgU317muqGf+QEHTyTaPYKsj2LYtfSWoY0Om5rV0YrFrjXfgtSQ+YxRW
         v7ig==
X-Gm-Message-State: AOJu0YwyrJWiLK6fW9xQSDa14UU2pe9SNYeVaatQu406qquUmvgEQGrc
	TzRGQIWTXh1wKdBEqokdjUv4dD43ouln0bujAFTy7souhPYpUeRwkWFRfn6HdWOBUSvUeSEJ2Wm
	v
X-Google-Smtp-Source: AGHT+IFPQtWFpJdO8cFcqU+lSgIbXOHqAmB0sJYlDHDFZue/j2dLHsRjrzIAsX6/6NvTsn7G2wmNfA==
X-Received: by 2002:a17:902:e808:b0:1d8:ac08:3cb7 with SMTP id u8-20020a170902e80800b001d8ac083cb7mr881593plg.33.1706748743344;
        Wed, 31 Jan 2024 16:52:23 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id km12-20020a17090327cc00b001d8dd63670bsm6380101plb.290.2024.01.31.16.52.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 16:52:22 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rVLJT-000O7W-2Y
	for linux-xfs@vger.kernel.org;
	Thu, 01 Feb 2024 11:52:19 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rVLJT-00000004WQu-14q5
	for linux-xfs@vger.kernel.org;
	Thu, 01 Feb 2024 11:52:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [RFC] [PATCH 0/4] xfs: reactivate inodes immediately in xfs_iget
Date: Thu,  1 Feb 2024 11:30:12 +1100
Message-ID: <20240201005217.1011010-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently xfs_iget() will flush inodes queued for inactivation
rather than recycling them. Flushing the inodegc queues causes
inactivation to run and the inodes transistion to reclaimable where
they can then be recycled. the xfs_iget() code spins for a short
while before trying the lookup again, and will continue to do
so until the inode has moved to the reclaimable state, at which
point it will recycle the inode.

However, if the filesystem is frozen, we cannot flush the inode gc
queues because we can't make modifications during a freeze and so
inodegc is not running. Hence inodes that need inactivation that
they VFS then tries to reference again (e.g. shrinker reclaimed them
just before they were accessed), xfs_iget() will just spin on the
inode waiting for the freeze to go away so the inode can be flushed.

This can be triggered by creating a bunch of files with post-eof
blocks and stalling them on the inodegc queues like so:

# cp a-set-1MB-files* /mnt/xfs
# xfs_io -xr -c "freeze" /mnt/xfs
# echo 3 > /proc/sys/vm/drop_caches
# ls -l /mnt/test

If the timing is just right, then the 'ls -l' will hang spinning
on inodes as they are now sitting in XFS_NEED_INACTIVE state on
the inodegc queues and won't be processed until the filesystem is
thawed.

Instead of flushing the inode, we could just recycle the inode
immediately. That, however, is complicated by the use of lockless
single linked lists for the inodegc queues. We can't just remove
them, so we need to enable lazy removal from the inodegc queue.

To do this, we make the lockless list addition and removal atomic
w.r.t. the inode state changes via the ip->i_flags_lock. This lock
is also held during xfs_iget() lookups, so it serialises the inodegc
list processing against inode lookup as well.

This then enables us to use the XFS_NEED_INACTIVE state flag to
determine if the inode should be inactivated when removing it from
the inodegc list during inodegc work. i.e. the inodegc worker
decides if inactivation should take place, not the context that is
queuing the inode to the inodegc list.

Hence by clearing the XFS_NEED_INACTIVE flag, we can leave inodes on
the inodegc lists and know that they will not be inactivated when
the worker next runs and sees that inode. It will just remove it
from the list and skip over it.

This gives us lazy list removal, and now we can immediately
reactivate the inode during lookup. This is similar to the recycling
of reclaimable inodes, but just a little bit different. I haven't
tried to combine the implementations - it could be done, but I think
that gets in the way of seeing how reactivation is different from
recycling.

By doing this, it means that the above series of operations will no
longer hang waiting for a thaw to occur. Indeed, we can see the
inode recycle stat getting bumped when the above reproducer is run -
it reactivates the inodes instead of hanging:

# xfs_stats.pl | grep recycle
    xs_ig_frecycle.......            75    vn_reclaim............           304
# cp a-set-1MB-files* /mnt/xfs
# xfs_io -xr -c "freeze" /mnt/xfs
# echo 3 > /proc/sys/vm/drop_caches
# ls -l /mnt/test > /dev/null
# xfs_stats.pl | grep recycle
    xs_ig_frecycle.......           100    vn_reclaim............           330
# xfs_io -xr -c "thaw" /mnt/xfs
# rm -rf /mnt/test/a-set*
# umount /mnt/test
#

This is all pretty simple - I don't think I've missed anything and
it runs the full fstests auto group with a few different configs
without regressions.

Comments, thoughts?

