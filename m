Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0545C1DDF0
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 03:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949866; cv=none; b=Lf586Ww8X+3jfad6f3CTsP6rao4Las+eNQ9poctJgUEWLL19qhCkFL57cZIVUIkO5V4YTy/VMt+UlEaf6vdsLcWiqRqjys2Ls7Ba4lx7SMABgLDtHc4+EaODs/qT3MeCQY4U2vGsN/nrVzJ00C133VbzyYpi650VzhG1876/lyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949866; c=relaxed/simple;
	bh=boTImX66EgdueBCnnp1rLd8TSrk1o0uBpHLP7kAeQNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+17VtB4KEpYhk4qtj3GHAKITRsFMqEYs5+cvlBj+E8wUw5kNblhey7FAr1L0diqPC3W69haFp0/gOzwxmUyJcN1LNAz80OR9D2nfzL6LEYGX3lHocPhPqueHvkbM+IF3E2ggK10DenqeKomxi8RikRR2D+9COdLdOaQlTDT/sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YxCqUejX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hdg/FZ4I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YxCqUejX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hdg/FZ4I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791949863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mAkzzEWB8++crBY4u9wBab9oeVy6Kz82kexdXO95cY8=;
	b=YxCqUejXYmT31tdnwFHw31JJCRj8afPl5zip/WQxdGDd+6R+4dPPwXHBUrGVp6FEkqP3h4
	76HlakpTPJK+HyvL3Q0un/7bnwMZ5JVhuVeLgLvbIt6MMaQ23+VJCI1R5HKl7CCtSENRhw
	UET6Meo0BSLK6N3enCWn8Zv9w4gmijs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-er0N58SSO5-_26_r-xU8KQ-1; Wed, 14 Oct 2026 03:51:02 +0000
X-MC-Unique: er0N58SSO5-_26_r-xU8KQ-1
X-Mimecast-MFC-AGG-ID: er0N58SSO5-_26_r-xU8KQ_1791949862
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-934963b2bc0so718755085a.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 20:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791949862; x=1792554662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mAkzzEWB8++crBY4u9wBab9oeVy6Kz82kexdXO95cY8=;
        b=Hdg/FZ4In6LN/alhb0v/54zQoUF5YEKj+BqjEMoM3/DfHAEZ8a28fa+T0j4f+T9mBa
         AdBnNNZC4DUHk/nkAAwHMI++mALc7n9GgAAR5IOteQyIOwHRiW5dY1rq0ClyeQrs6fcr
         54FVL2Z7wWSyaOFuKjVkLkgL3rZF6wWTgA4ahQ5JoWsu4iT3AQ6IAXaIaB7o2DPxRCcJ
         udHLR+3swJhArzjiGzRh4xK4+KUZ7umgXu25rOnu62mfGUDrTGSP8sQJ4aFtORJbMcDW
         HTf6xEHtzlsNkYiO7sDur0zL6tG6iiClK3ii9Efp3JC11Nt5+QNnnynXA/02oPc3c0VL
         EfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791949862; x=1792554662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mAkzzEWB8++crBY4u9wBab9oeVy6Kz82kexdXO95cY8=;
        b=1A4iVQR3w5HW5k1fRuq6M0HowFOdWzriWD9dR5pP0Tu1BDxing1irHtDUhsyjvDhZX
         A3xIhzMpRymbJP/oAIR+fCRv/dgjLKlRLNW6GL2T1SgCgOIQ/1bhFLqCar2jYD6dPq6f
         LNsIEGq3ROYkkiczR66XzBqehXi9mkPSQu/vBVrH5SZcZ92lpixvSY44EqiJwAahUMwR
         6RjcSUopJUkKjSNHpv2qh9kpNDiAsm7Q3DlPcQGYvh/j2fjxk36AcgwrBN70TwhTN8AR
         XY6utYdZIbkhEaWgd1J/gmnQjXw8aMJnH+8qmDMBjih329gU9vNxTf/bN3rTWSILH3HK
         NpFQ==
X-Gm-Message-State: AFq9FYLu0MRsSZZt+QcN5SvZ8bi3KAx1O1A4o9qZN398AoZkrafN8Qw9
	GjSZ1hx9QsLWiSiLHEK/bSQIL4xb6xukJTMRL58zS9ESw6LpqHrvQVlrzJfazrcWMazRxJ1DWzg
	3ZnrdQwS+Ox980f8iWHby6qCia1KQmC7g5tiGtamE+vu+QpMiJ9p5Y3/s4Tnk/twQMjrJPPZyY9
	OKu0ygkvK/ujst/af77k2j5OBeB/wzrHkUl+jvmf7pFZ3k
X-Gm-Gg: AYBFou1nIYJZ4/2yV+7syLxiI7JHf5v4EE0e2o8YttDOorFsKdTdEn6N5M8yverEa0b
	7hfdgDw9k8nzb1+aXkkwvdXg92FHLFpuoZDnBjS79R1FH41uZXj9751IKQAPnDqqYd1HShCsDP1
	U/MqRGKccJ9OZw9Y/jDGcKecDDkzFqTOGTSpyr2GKpJOoKlRPcE8Ty7ev/8j2byF8cQhShGr/Cq
	QN34n6OeD/UnK6dN10hr/m2Qs5n884PNhMbmpPpV688g+dm6tsHe22zziZdFDrbhOAUjXZT3iA/
	jRBZvIOqA2t8F7puMOsAp2LhcfOSAAx13SeL9yJBw4fH8XysifVm7ObMylv/VhwTQ0ABJlgwRWu
	RVV5CTmiSITa+Vgrg8TJePnoeTfw1bFRx9Mkq6g==
X-Received: by 2002:a05:620a:8086:b0:93e:74e5:2b3a with SMTP id af79cd13be357-93ebd1dfda8mr2133025785a.28.1791949861917;
        Tue, 13 Oct 2026 20:51:01 -0700 (PDT)
X-Received: by 2002:a05:620a:8086:b0:93e:74e5:2b3a with SMTP id af79cd13be357-93ebd1dfda8mr2133023385a.28.1791949861223;
        Tue, 13 Oct 2026 20:51:01 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50b6c4fsm393907285a.47.2026.10.13.20.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:51:00 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/5] xfs: remove redundant stat checks after xfs_inobt_insert_rec()
Date: Tue, 13 Oct 2026 20:30:01 -0500
Message-ID: <20261014013505.759089-4-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014013505.759089-1-sandeen@redhat.com>
References: <20261014013505.759089-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_inobt_insert_rec() simply returns the error and status from
xfs_btree_insert, which has already validated the insert or returned
an error.

This makes every instance of the 2nd test in this idiom:

        if ((error = xfs_inobt_insert_rec(cnt_cur, &i)))
                return error;
        if (XFS_IS_CORRUPT(mp, i != 1)) {
                xfs_btree_mark_sick(cnt_cur);
                return -EFSCORRUPTED;
        }

duplicate/unreachable code. Remove them.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index bb6e684f5467..fd916a2a005b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -236,7 +236,6 @@ xfs_inobt_insert(
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 			return error;
 		}
-		ASSERT(i == 1);
 	}
 
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
@@ -572,12 +571,6 @@ xfs_inobt_insert_sprec(
 					     nrec->ir_free, &i);
 		if (error)
 			goto error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto error;
-		}
-
 		goto out;
 	}
 
@@ -647,7 +640,6 @@ xfs_finobt_insert_sprec(
 	struct xfs_buf			*agbp,
 	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new rec. */
 {
-	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_btree_cur		*cur;
 	int				error;
 	int				i;
@@ -665,11 +657,6 @@ xfs_finobt_insert_sprec(
 					     nrec->ir_free, &i);
 		if (error)
 			goto error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto error;
-		}
 	} else {
 		error = xfs_inobt_update(cur, nrec);
 		if (error)
@@ -2254,8 +2241,6 @@ xfs_difree_finobt(
 					     ibtrec->ir_free, &i);
 		if (error)
 			goto error;
-		ASSERT(i == 1);
-
 		goto out;
 	}
 
-- 
2.55.0

