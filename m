Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FB346AEE1
	for <linux-xfs@vger.kernel.org>; Wed,  6 May 2026 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778073991; cv=none; b=LmBcY+TgtaUDAK2uWSBfjnQ0DhNR3rolavn6rMna8G3/cC1j93wEyNeqKdH2RqGRIin7VlLiaCqTOio5BB4bkW+d5B2wnnK69wE2EB6ls67jG/rAf27iJc/T8Ub6avbjITmtrKLVQWKveEMTsrohn4fUNu7sd/dh509LhZvP7cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778073991; c=relaxed/simple;
	bh=SGyP/xNWZfU2hQPJfNJ7a4mayqdEMhefyTR84u+8ICQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=trtIDtErMlLm/yY7z4/H+G8KOnltMRh4moseHzsZaE1q+AGo1zAA/eh83xD9SSyP7V3cKdZcistLJz4ntIzZlH8B6EA8g/pRj9OzQnpofqMNEC1BpzVLc3qt3aW03zOw7VfCbsyyx89zKuDsBiIItO2OOrV3EZn5gLRwoIEJJeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=anarazel.de; spf=pass smtp.mailfrom=anarazel.de; dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b=irFTT6Mz; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MUtTTfeI; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=anarazel.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=anarazel.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b="irFTT6Mz";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MUtTTfeI"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id C4AF6EC017B;
	Wed,  6 May 2026 09:26:28 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Wed, 06 May 2026 09:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm3;
	 t=1778073988; x=1778160388; bh=CO/4Mi57QAHFEFqhWPR5xXbntcM5acJg
	/V/KSwd8IRc=; b=irFTT6MzXDlEdkIvQgeCDdaM5iWv4FnaWXx+29LwSk8/+jk9
	k73duAC/GM2R02zdP9W4PmEn+IlvYNUqsv9udZ36Dym+2FKsAQw8golnNHAgbqeh
	Y0S696h+y1Zu0PF1N4eWZkQlHzHuNzYSyTC7HT4pUwhsHg2TjHlye6Z0/BnBcpOX
	g9+5MgrCSxntQNXGas8ItJ+vk60Pofknvi23lWKgGvCEXlE5gHv/+onblLwC6dMR
	6vqC4bDUJr60hf813KrPK8mUwfehV6sZe7WCoM+uGbEp2fBUCq3eMJvBnO+Txash
	U+sOCkd6Nd+YPJZrx3fW0yuvQl0ViEPDpoQEVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1778073988; x=
	1778160388; bh=CO/4Mi57QAHFEFqhWPR5xXbntcM5acJg/V/KSwd8IRc=; b=M
	UtTTfeIhKg0tlAKtxC+3sx5AbZosW9qHFuL5wcty41bc2fOgneU297AydWl8oyOJ
	cRUZ9zTvmSSUy0CfXrcc3BMoD40/QAWV2aFOJOEC8zA99pQPepJ1VryjlbmSp1F1
	yHRmpYVhYpGoGW8btVUFGk6PfPhRycBU17J8ko9cmO9IbeyY+j2Vq6pRlV9aqsfk
	Cki18AA3S+9Zj62NJmU5BAlul+JPI5hSk9EJgB+FmUOeKD3uR8CjBZdcQC1B26xO
	dpm33NkjNXkyPxsCh1ck5aTrExCweoeMKEUgCxRZH6J2ZG8CH4I5YXozi05ys+a2
	B5VV1BYbTqSFCzCOSPS4Q==
X-ME-Sender: <xms:hEH7aUOBlG0_kA2Djx0UMNdZ0XNJPPaddjD71ykj0PjWMPHJ9PNYtg>
    <xme:hEH7aR0iTnOczjHxR0Tb3rm5-bY0y44JNC0JOaKwsY6r7WC1dYQwUkPD5RMA7pDfh
    aGznDNho7Bzp3BaQQbT5ETSTyAt7jvHT8M8zc-BBmO1twsaH5PZaw>
X-ME-Received: <xmr:hEH7aTknuYb1gJ-0LxXyqckhAIMtjcThykjM6e0S9IARgYMcfuTkzVfFXjEMsKXrHNw17FI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutdegjedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkgggtugesthdtsfdttddtvdenucfhrhhomheptehnughrvghsucfh
    rhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrthhtvg
    hrnhepgefhvdegteeiieeggeduhfekteffgeeffefhueffueffheelhedugfevudetlefg
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvgdp
    nhgspghrtghpthhtohephedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghrrg
    hunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheptggvmheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepphgrnhhkrghjrdhrrghghhgrvheslhhinhhugidruggvvhdprh
    gtphhtthhopehhtghhsehlshhtrdguvgdprhgtphhtthhopehlihhnuhigqdigfhhssehv
    ghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:hEH7aYUTQNKm6gBSFDZNalWnnZAlyvpuD5Kg9tkWXwsh2Z4ejyywsg>
    <xmx:hEH7aZuKg6CWenynWWUvfoKiWRPkO_TLoMJN2TRni6ZiRO8PqcQL8A>
    <xmx:hEH7abafabsVOwGGwcxQcknebLyAbHfMVf0t3XrJp8EmhkvZNt_5bw>
    <xmx:hEH7aYXMdxf8tnZ9Y5bkp7co80AZMHu6V07jhmaFN_bXwv8JphDCkA>
    <xmx:hEH7afoOJxZDMpGE70xT_VuJeE4wDYGOkh3Vcc9lo6kIipWzrA8_eFZD>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 6 May 2026 09:26:27 -0400 (EDT)
Date: Wed, 6 May 2026 09:26:25 -0400
From: Andres Freund <andres@anarazel.de>
To: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Pankaj <pankaj.raghav@linux.dev>
Subject: Increase in XFS journal flushes with (direct_write;fdatasync)+
Message-ID: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

While looking at performance issues on Samsung client drives due to slow FUA,
I tried to reproduce older numbers on a recent kernel.  And couldn't, at first
- but not because the problem went away, but because the fdatasync numbers
(which shouldn't use FUA) got *much* worse.

These drives have FUA writes that are slower than full flushes, making
O_DIRECT|O_DSYNC writes perform poorly and fdatasync() comparatively better.


What I'm seeing is that with recent kernels the fdatasync() performance is
roughly as bad as the O_DSYNC, whereas previously it was > 2x as
fasts. blktrace showed that there are ongoing FUA writes during a workload
with just overwriting writes and an fdatasync after every write.


At first I thought it was a regression between 7.0..7.1-rc2, but that turned
out to be only because the 7.0 machine did not have lazytime enabled. After
fixing that discrepancy, the regression is also visible in 7.0.  I have
confirmed it's not visible in 6.18.

Repro Workload:

fio --directory ${mountpoint}/fio/ --overwrite 1 --size=$((4096*123)) --buffered 0 --bs=4096 --rw=write --name write-fdatasync --fdatasync=1 |grep IOPS

On v7.1-rc2-5-g6d35786de2811:

mounted with lazytime:
write: IOPS=158, BW=636KiB/s (651kB/s)(492KiB/774msec); 0 zone resets

mounted with nolazyatime:
write: IOPS=594, BW=2377KiB/s (2434kB/s)(492KiB/207msec); 0 zone resets



Running it with perf stat and a few events [1] shows:

using lazytime
  write: IOPS=174, BW=697KiB/s (714kB/s)(492KiB/706msec); 0 zone resets

 Performance counter stats for 'fio --directory /srv/fio/ --overwrite 1 --size=503808 --buffered 0 --bs=4096 --rw=write --name write-fdatasync --fdatasync=1':

               123      syscalls:sys_enter_pwrite64
               122      syscalls:sys_exit_fdatasync
               121      xfs:xlog_iclog_write
               121      xfs:xlog_iclog_sync
               123      xfs:xfs_file_direct_write
               122      xfs:xfs_update_time
               122      xfs:xfs_log_reserve
               123      xfs:xfs_trans_add_item
                 8      writeback:writeback_dirty_inode
               122      xfs:xfs_trans_commit

       1.170287744 seconds time elapsed

       0.192673000 seconds user
       0.054510000 seconds sys


using nolazytime
  write: IOPS=672, BW=2689KiB/s (2753kB/s)(492KiB/183msec); 0 zone resets

 Performance counter stats for 'fio --directory /srv/fio/ --overwrite 1 --size=503808 --buffered 0 --bs=4096 --rw=write --name write-fdatasync --fdatasync=1':

               123      syscalls:sys_enter_pwrite64
               122      syscalls:sys_exit_fdatasync
                 1      xfs:xlog_iclog_write
                 1      xfs:xlog_iclog_sync
               123      xfs:xfs_file_direct_write
                55      xfs:xfs_update_time
                55      xfs:xfs_log_reserve
                55      xfs:xfs_trans_add_item
                 7      writeback:writeback_dirty_inode
                55      xfs:xfs_trans_commit

       0.667253953 seconds time elapsed

       0.160385000 seconds user
       0.061264000 seconds sys


The relevant difference presumably is that nolazytime has a lot more log
flushes (xfs:xlog_iclog_sync).


ext4 does not show that behaviour.


Presumably this happened as part of

commit 74554251dfc9374ebf1a9dfc54d6745d56bb9265
Merge: 996812c453caf 77ef2c3ff5916
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   2026-02-09 11:25:01 -0800

    Merge tag 'vfs-7.0-rc1.nonblocking_timestamps' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs

    Pull vfs timestamp updates from Christian Brauner:
     "This contains the changes to support non-blocking timestamp updates.

Or in one of the followup fixes.  Hence CCing the folks involved in that.


Greetings,

Andres Freund


[1] mountpoint=/srv; for opt in lazytime nolazytime; do echo "using $opt"; mount $mountpoint -o remount,$opt && perf stat -e syscalls:sys_enter_pwrite64,syscalls:sys_exit_fdatasync,xfs:xlog_iclog_write,xfs:xlog_iclog_sync,xfs:xfs_file_direct_write,xfs:xfs_update_time,xfs:xfs_log_reserve,xfs:xfs_trans_add_item,writeback:writeback_dirty_inode,xfs:xfs_trans_commit fio --directory ${mountpoint}/fio/ --overwrite 1 --size=$((4096*123)) --buffered 0 --bs=4096 --rw=write --name write-fdatasync --fdatasync=1 |grep IOPS || break;done
