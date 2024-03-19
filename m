Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0842FB6
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 00:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710807435; cv=none; b=sngoARFseEFzox7Lb3Ua/XO8MzL/vk+V0MkOngj5E5y8A22XL2/2mo5lCy7BmuWVdFpN9Zg5NPf+U3goE3UJZQ/r0iaBq9Aubcdwf7DxBfC+EZblMN3FGMb2xPKjkcN1H64wrwaqXJrTGN28cniZs5BRttwIdfE/GiSN5nHRvbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710807435; c=relaxed/simple;
	bh=3JQ1gvt+lcgaeKtFjjCkc8E54eKaNQv2fDaIaYCFPxU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzO/tFtUr0vQdZgqMtI70eJWITs4MPI6ajXXaUfxLNcB8SZyS08P8yIlCMJqzeSsR5UoTDdbacvJ5In0sNbVrubJdPAZ/ZLY2WkW0oaFJktlFXh5NiA8jU+d7+ktqcz3DM6RKXOurE9SRr5qQMfKl6+f4IyzOMruw0Y92GvB12E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=d2UOKT/d; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="d2UOKT/d"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e6adc557b6so4631319b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710807434; x=1711412234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38Mm0g44j6DzSxjcPXjDVW5ORPCUj/mMvG9NE8VE3sU=;
        b=d2UOKT/dlMZm0gV73SiuZl+vwym3ybpG8NLyvnTGdpcdzzm34fnNgTaN5h1n/xI3Nc
         gWv4q/Q0ZqHsMht1a3ZyzU52HCb6Ildu54q6+/6oSzousfOE4K34XDEK87Qu4lyW43tO
         rKZkji8oWw1xFIhiQ8pUsQMBeF0oK6XnYasiVzbxBNA/4XlMHy5hBVtPE9GOb+7YLVAV
         VsEhbdyrEM59o3QrGz4rBtG0vwppdOQJ/Pb46Wai4tzP7iUBk0ftmOIW4e8VL/yQLNsq
         6A+XQDDYhSbaTRyMFaDyy1l9nt1c5M9O4hiRGPktGuUVy82Sc7yblQ2riOkFA9rK+YcR
         LaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710807434; x=1711412234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=38Mm0g44j6DzSxjcPXjDVW5ORPCUj/mMvG9NE8VE3sU=;
        b=jh33ZUWOSY5pg5g7rpUZYwzdME7Z/w7w6xASouNIdsxnNHNmW1F+PTz1xs8hlDw7DH
         LXCnAoIj9ho8DhrkK/hxr8BU9IEd9ey7d1O8pRcw+CH9gSsxAsTLR5tnRcbchYVw9dg8
         /S411+4N8Otj3rD5fOKxjLsDhF5XGGcfDpkBSMaZuD8u4AO8AMyQF7O3YF9NuyfD0QdH
         We6jCygB7CPB6yU60z/m3lwd7LVo3WMlm8tZ4QhjrI9gVxc+MYKi4EV8dra8N8b5Wb0t
         KBd/Ge9WSC58arVFBFKLZwzCoOB/+Wa6Xv6hPWcqod7enWzoVqlEl1JbNU+hTihgzg2r
         3vdQ==
X-Gm-Message-State: AOJu0YwTBbsIbLbv1+WvCQGyD4pFBqQsyRcjxVdGhwW55iZqom9MSrxV
	ngi5/1Np6T/PWAWjdERdpnHxDQbPyrbbEQ/He1wBue/W9/wBYhc9S9mHFhpedFN4aKmaHNuSLKe
	q
X-Google-Smtp-Source: AGHT+IESfqRNAzXEfBNJCs+gOdaiFmuHsI182WyKMSVW/4pGE0q1MKAqMlbPeURaEl1qM+bxNs+hWQ==
X-Received: by 2002:a05:6a20:7f8e:b0:1a1:4b57:4e9b with SMTP id d14-20020a056a207f8e00b001a14b574e9bmr16875157pzj.60.1710807433564;
        Mon, 18 Mar 2024 17:17:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id r21-20020a635155000000b005dc98d9114bsm7730052pgl.43.2024.03.18.17.17.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 17:17:13 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmNAD-003pkl-2r
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:17:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmNAD-0000000EONR-1VPx
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:17:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: prepare inode for i_gclist detection
Date: Tue, 19 Mar 2024 11:15:58 +1100
Message-ID: <20240319001707.3430251-3-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319001707.3430251-1-david@fromorbit.com>
References: <20240319001707.3430251-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

We currently don't initialise the inode->i_gclist member because it
it not necessary for a pure llist_add/llist_del_all producer-
consumer usage pattern.  However, for lazy removal from the inodegc
list, we need to be able to determine if the inode is already on an
inodegc list before we queue it.

We can do this detection by using llist_on_list(), but this requires
that we initialise the llist_node before we use it, and we
re-initialise it when we remove it from the llist.

Because we already serialise the inodegc list add with inode state
changes under the ip->i_flags_lock, we can do the initialisation on
list removal atomically with the state change. We can also do the
check of whether the inode is already on a inodegc list inside the
state change region on insert.

This gives us the ability to use llist_on_list(ip->i_gclist) to
determine if the inode needs to be queued for inactivation without
having to depend on inode state flags.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9a362964f656..559b8f71dc91 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -113,6 +113,7 @@ xfs_inode_alloc(
 	spin_lock_init(&ip->i_ioend_lock);
 	ip->i_next_unlinked = NULLAGINO;
 	ip->i_prev_unlinked = 0;
+	init_llist_node(&ip->i_gclist);
 
 	return ip;
 }
@@ -1880,8 +1881,14 @@ xfs_inodegc_worker(
 	llist_for_each_entry_safe(ip, n, node, i_gclist) {
 		int	error;
 
-		/* Switch state to inactivating. */
+		/*
+		 * Switch state to inactivating and remove the inode from the
+		 * gclist. This allows the use of llist_on_list() in the queuing
+		 * code to determine if the inode is already on an inodegc
+		 * queue.
+		 */
 		spin_lock(&ip->i_flags_lock);
+		init_llist_node(&ip->i_gclist);
 		ip->i_flags |= XFS_INACTIVATING;
 		ip->i_flags &= ~XFS_NEED_INACTIVE;
 		spin_unlock(&ip->i_flags_lock);
@@ -2082,13 +2089,21 @@ xfs_inodegc_queue(
 	trace_xfs_inode_set_need_inactive(ip);
 
 	/*
-	 * Put the addition of the inode to the gc list under the
+	 * The addition of the inode to the gc list is done under the
 	 * ip->i_flags_lock so that the state change and list addition are
 	 * atomic w.r.t. lookup operations under the ip->i_flags_lock.
+	 * The removal is also done under the ip->i_flags_lock and so this
+	 * allows us to safely use llist_on_list() here to determine if the
+	 * inode is already queued on an inactivation queue.
 	 */
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags |= XFS_NEED_INACTIVE;
 
+	if (llist_on_list(&ip->i_gclist)) {
+		spin_unlock(&ip->i_flags_lock);
+		return;
+	}
+
 	cpu_nr = get_cpu();
 	gc = this_cpu_ptr(mp->m_inodegc);
 	llist_add(&ip->i_gclist, &gc->list);
-- 
2.43.0

