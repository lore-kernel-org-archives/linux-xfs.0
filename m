Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A831FDA
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 00:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706748744; cv=none; b=m3K43J5ju3t1izMFdjdZfx0/EydWOnNpUSSrV94nYnTvGVWv5dgNNgG3DjaMP7j2vrlLwCv+9Bms0VaZEWZIjdzNS6gWIIUYZEJ+NpveV8dhoGTg635QWjdUM8eCMZpdXlLnTLTMHklK/kZhV4ZP72k0nwY6dVxL6xTDi6SBMFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706748744; c=relaxed/simple;
	bh=m9d2vsgIZxEu/BhgDP+6k+2fkyqHOwJzryUt5P2IaIk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r75p/+kNgjI/RFr6JhjNbJPH2QwAuAFYRjYo8PU8fVQXjHsEjmlmVAX63EK6346aYHusWUIKt1EjYK/X7vQ6ugGtNr5MuAIehg7pNCGmBc5S24L7Msk1L8vj4nXlGe5fTS4wMoxLNOTnA6EjvppLFQtKNXb3iNHikBC3I+8HIwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=c5i1vIVr; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="c5i1vIVr"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5d8b70b39efso409205a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 16:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706748742; x=1707353542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VzwarccbZKIU3Xncbo7umu6MN3V9VqH9ljbc3L2ChSE=;
        b=c5i1vIVrfxA4m49ochE7oI1aOMY0vGZJqqO466uZNr4Hrl1g4Z/RwekT7ghDjLCEzY
         vTFQPBh5Q0kin40tUMssDjN7OhCstLOqcvvPyMS+KhntWw8mc+5AyVoqOnlZ30dblKlv
         YrMXnqIW80YKCw9s0XAHha39/FTWecyvyV8mmTfPvmThIrFywFKlL0flvOGVEc2Sd/co
         rCuhNHtq+gEnzxFy8jCt/bY6u4z5RjWmaUxRYGkl2tuvG3KqIoLq5yfWwcwV+6Rujalv
         RbGrtR3kAaJ8Qpsjls49g8r0F0WOpi79DhzEjLGpCylNZaA//lqVT5Xy93fR4DnLFsZ0
         zmBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706748742; x=1707353542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VzwarccbZKIU3Xncbo7umu6MN3V9VqH9ljbc3L2ChSE=;
        b=wk0TIXOJdcQULIgDaKWEiSBebQTSQLuQiBtpqKVYK7GjNeViBXmKKDdeRWqsvsUKO/
         gbcI6b2FXBMY0sewKMKyKk7q7kDwsACbJXkUBLOBl2wQNSNcMdgymkJw24tdPX4sXSyM
         Axv9wyE32IbWO+gh0rLG5wOLkp9z9CIG/HGbSu/uJrUcPGBMFnLTmbPn+2sdTooCIzVX
         dDtQRce7v5VKSFvpexbykqovm5M+O8pzeGu+ActyTj4dx3x53z61witjoh0jBFKrqkUa
         qfQK21vIwPijpnMM1Wn2kTxeeEiMPb6mVk0ctf/kPjylAuuFVn/wBweEdfJDxugTWtSi
         BVaQ==
X-Gm-Message-State: AOJu0Yx0jEQDs7l3t+qcakPPLff2qFoVNY7aiheAnC4ejeTX8PhZEJyu
	ikL3ktiXFUqqCxkFxwCvm8cmxzvlRz0V6uRYyFkUNM+AB2RtejlMAAJ1BfI9U6eoovEx1Zp2aY7
	d
X-Google-Smtp-Source: AGHT+IGsaPYv0lzWXepU8kQUfcKAE5WBoNkOWTBB83aakZ20Y9tvOdH62TuMUjyQ+0Aus2uJy1crAQ==
X-Received: by 2002:a05:6a20:1483:b0:19c:8a23:7eba with SMTP id o3-20020a056a20148300b0019c8a237ebamr2692670pzi.51.1706748742285;
        Wed, 31 Jan 2024 16:52:22 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id p26-20020a62ab1a000000b006ddb85a61cfsm10447105pff.162.2024.01.31.16.52.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 16:52:21 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rVLJT-000O7Y-2i
	for linux-xfs@vger.kernel.org;
	Thu, 01 Feb 2024 11:52:19 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rVLJT-00000004WQx-1QO8
	for linux-xfs@vger.kernel.org;
	Thu, 01 Feb 2024 11:52:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: make inode inactivation state changes atomic
Date: Thu,  1 Feb 2024 11:30:13 +1100
Message-ID: <20240201005217.1011010-2-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240201005217.1011010-1-david@fromorbit.com>
References: <20240201005217.1011010-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

We need the XFS_NEED_INACTIVE flag to correspond to whether the
inode is on the inodegc queues so that we can then use this state
for lazy removal.

To do this, move the addition of the inode to the inodegc queue
under the ip->i_flags_lock so that it is atomic w.r.t. setting
the XFS_NEED_INACTIVE flag.

Then, when we remove the inode from the inodegc list to actually run
inactivation, clear the XFS_NEED_INACTIVE at the same time we are
setting XFS_INACTIVATING to indicate that inactivation is in
progress.

These changes result in all the state changes and inodegc queuing
being atomic w.r.t. each other and inode lookups via the use of the
ip->i_flags lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 06046827b5fe..425b55526386 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1875,7 +1875,12 @@ xfs_inodegc_worker(
 	llist_for_each_entry_safe(ip, n, node, i_gclist) {
 		int	error;
 
-		xfs_iflags_set(ip, XFS_INACTIVATING);
+		/* Switch state to inactivating. */
+		spin_lock(&ip->i_flags_lock);
+		ip->i_flags |= XFS_INACTIVATING;
+		ip->i_flags &= ~XFS_NEED_INACTIVE;
+		spin_unlock(&ip->i_flags_lock);
+
 		error = xfs_inodegc_inactivate(ip);
 		if (error && !gc->error)
 			gc->error = error;
@@ -2068,9 +2073,13 @@ xfs_inodegc_queue(
 	unsigned long		queue_delay = 1;
 
 	trace_xfs_inode_set_need_inactive(ip);
+
+	/*
+	 * Put the addition of the inode to the gc list under the
+	 * ip->i_flags_lock so that the state change and list addition are
+	 * atomic w.r.t. lookup operations under the ip->i_flags_lock.
+	 */
 	spin_lock(&ip->i_flags_lock);
-	ip->i_flags |= XFS_NEED_INACTIVE;
-	spin_unlock(&ip->i_flags_lock);
 
 	cpu_nr = get_cpu();
 	gc = this_cpu_ptr(mp->m_inodegc);
@@ -2079,6 +2088,9 @@ xfs_inodegc_queue(
 	WRITE_ONCE(gc->items, items + 1);
 	shrinker_hits = READ_ONCE(gc->shrinker_hits);
 
+	ip->i_flags |= XFS_NEED_INACTIVE;
+	spin_unlock(&ip->i_flags_lock);
+
 	/*
 	 * Ensure the list add is always seen by anyone who finds the cpumask
 	 * bit set. This effectively gives the cpumask bit set operation
-- 
2.43.0

