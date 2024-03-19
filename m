Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E863207
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 00:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710807436; cv=none; b=m4pAQ6JDwiB0WlKqG7t546Ovsv1ZO+Pq7ZeTaguM9oE6faVVUaEfXTIIJbveJsWY5j6Fg55iud7WWChDt2LuhYAhGoe/EyKDpiWUa7IlXh6V4YM2Evfzxc0mSmdhAhxlhTQjCqhKka7zrVGxmRD1foOMbFmGRKu+LHOoCGHlEZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710807436; c=relaxed/simple;
	bh=ON1He595Ej5nW6EphlJ5BP42XvgOXHeH3Jk6M9G1pPg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pumkxv4v+SNp+lltD28w9sbVuxuKpXfHXqBUMe2CdKzLxXM5gw+dmiaghm/loJuTa79RR4Qh47tTm8yn1bmVkNRRk6rPUfe5O6I2Xt7DEEZhz957x1CJ8zwms6TeMXfE9svQo0wuHzBfVQqXlvhhWZnHJBayTRW5KZVHLYh8Kck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=lX4xMtdk; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="lX4xMtdk"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e6b6f86975so3308218b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710807434; x=1711412234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9kh5vaOkQnPKq77D26tNwn12Y+fr4+qZqwSxQdPYHrE=;
        b=lX4xMtdksxid+81jv6dN62Vhr69Yt4n+9BG0nZybpWTgBTAouFC/Yp4D4Pz7m5gTEz
         ts9vh/xC/uSz71sQpfLwWW7BePQTgpuR7OfdXxG4WvcLOs1vGED03jU9Wl4B0KIDNjcX
         yDlQ0Ef3b31nbimWN73zgHZu+8y30lQ1H1jSRufYzoRxdHuWTI/1C52nsWHHnDlAi/di
         mM7GHR/Tb/gxxggGgd2ueAqe3SHewfbZdHcbniboGrRVVH/ZOJVqr0CY31bzDp8tGP5y
         M64vS9xAaHW5haA933Msj2sZXQXXzvovWIvxDqAJUaSxGDXZCgK5Oa3ge/swPLuqbMSC
         42YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710807434; x=1711412234;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kh5vaOkQnPKq77D26tNwn12Y+fr4+qZqwSxQdPYHrE=;
        b=PS0gR43n7SNbesFyzYPzzcktksI642dtdEUrpZpg7j/sgJ8x39LzISzmvyqENpINKe
         1uDD8GE0JWYm06Ake/yqcrtUGl5Yh3N+9kL9Yc1Ko71lClnqQUL41wSEpqGnoN02M19P
         stNLaibNCtEdfm2iGYNgIFUoSBpXSZ5X+AokobLunaZveNMw54hB19ketF5UagE9UmBi
         HB6dXel+8C9zdT8JMMt/B/ne+iwigQdMl9XkqDb0v6B70xRy0HRgvgbpbEkjbe9kZo4q
         LkZQwOMWS0BUDGercJNhsQ/pJV6B1V76WYqPaK22wD/QpM6qHW+I2vS3mTGNBSpTKDId
         MafA==
X-Gm-Message-State: AOJu0Yw9H41bbJ3O+n/piK0lWW6WtYri9DHlkdYPcZgalcEBfaxuOn9H
	/By2hReLOhQ4fL1lOL2W5VO8cRMoXDG74/1Mlj+rELMQdXPjTAu5T6m7E8rfmcmhDODvesmcdKW
	i
X-Google-Smtp-Source: AGHT+IEXAJRn9wf6KL6guiLUxXhM+vX5BoFm0pyLOE/tuEI9gNoAAkwHa39a85pUiJpX2QSVdESfDg==
X-Received: by 2002:a05:6a00:139d:b0:6e6:c38e:e8dc with SMTP id t29-20020a056a00139d00b006e6c38ee8dcmr17630825pfg.21.1710807434025;
        Mon, 18 Mar 2024 17:17:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id c2-20020a056a00008200b006e6c843dbe9sm8563795pfj.204.2024.03.18.17.17.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 17:17:13 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmNAD-003pkh-2e
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:17:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmNAD-0000000EONK-1Akx
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:17:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/4] xfs: recycle inactive inodes immediately
Date: Tue, 19 Mar 2024 11:15:56 +1100
Message-ID: <20240319001707.3430251-1-david@fromorbit.com>
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

Version 2:
- updated XFS_INACTIVATING comment to describe the new behaviours
  of XFS_NEED_INACTIVE and XFS_INACTIVATING bit.
- don't randomly move code about in patches.
- add trace_xfs_iget_recycle_fail() trace point to record
  reactivation failures.
- fix bug when unlinked inode check on NEED_INACTIVE inodes was not done before
  reactivating. This caused failures on xfs/183.

Version 1:
https://lore.kernel.org/linux-xfs/20240201005217.1011010-1-david@fromorbit.com/

