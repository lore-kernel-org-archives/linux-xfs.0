Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6E11E1A3D
	for <linux-xfs@vger.kernel.org>; Sat,  8 Aug 2026 23:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786232431; cv=none; b=LHgWwgiD1+ZcArZcVEOzw8rLt93Mu5DBO3njGQQvxjI6PPF9VLE+9dO1j3CssrC62Bf39Pj9L5eYMBldRgecBu3xm9mwuX6u7+/CloxY7+OTzbENTJ8tkFgO+oUVniKbSqcmPcHbdEK6Ra9f0mHqb1l5gtJYpRmbePGIsA8a7vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786232431; c=relaxed/simple;
	bh=sZmYt2raO8VdDm+hOpYDP0ljGepdC6gsEluhTLQWHd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7fD7Sb2/We4XnZxb44lh26HPh5LeXX6etDjAjEbHIY98loJAnjhWA6Nyn9pAAqu4Tk6NHBCvelAVDtEr9/+Zd/tBQT8hyFx90VR/ZXGv/m9Dxi+dwuLhrl5FtYlXhUbQXf9LgznGVQcQ3DJboB7TF8S/iKtpJ90s4I24a+/N5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=RNitRt2B; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="RNitRt2B"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5c2e66ecbc1so13376e0c.1
        for <linux-xfs@vger.kernel.org>; Sat, 08 Aug 2026 16:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786232429; x=1786837229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nyeyac7LrDv4OnnnUjx1xvNsyZmRbR/sEbRM05AokQ0=;
        b=RNitRt2BFB3jecBaQIKeTMPxf3ziAOkjS9aSgUUWB0LESgmdzH7N6Ili52e9qhjsqC
         Yrn4mEoX4Qmd68c0kCy/fFsShZwlBJaHMYLCvp0o8PWQeOnHXlz/aPxVYjsHR3XuVs9Y
         mRpGL5a4EkAVBpW/snIitgxDFA9lLvJP6hiFLYx9bjmYAhI3faST0buq+8NnXklMfB18
         ZaXX1oMC5f/WWzWirFZ5wISPqn3Kp3u++S0QjWe42s+FjiaDIKXqOh2XWUedH9xbuGyx
         98j8HtPm2SYPW1CSaSZxvGmFoj88cCbdsfAGRkrNhcPntd1tNQdO3TUgndOVQ8IYn+op
         QEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786232429; x=1786837229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nyeyac7LrDv4OnnnUjx1xvNsyZmRbR/sEbRM05AokQ0=;
        b=YK7HIpQh6ak/5OCAO6tiTPaVJCqymkzhNWga2O+xzlX321ojoxNGjnSuZoU93GsegJ
         yZrayJr/tj5RHPUlvpqsiDFYvIoQBnfIJR65PhEEfgnzgMXg/O6zIIC6LOWceqUCMCaZ
         WXmzqu2P4Uk9kswJQNHyrsydXikCUb77UJNyAsVRLFC3z+Rc0MOU0klYxUWcd91vd1Wi
         cgT8KRlJjCA1sGQqJD382SYoLD+6gkCZI2Z4bHLLxvsxcugqFnv3KPqa12vbxnLJbBdR
         5QucqkQoDvtXzikGR/oEmfe/giCIXpEaOq1UROrqJGyfEzwNvknS/VQjAwpN+5wUVNuu
         9Wmw==
X-Forwarded-Encrypted: i=1; AHgh+RpEfC8PguKeKmRbwbtdf6scX+jLqqHMSrq4/E+PPG9fo3SrN6HfvgqXIAm3X4C2XEaFkJsTh/nISL8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNV6GiKt9eQ6VR6yfXvQisvBULdK5v+tLGXCXhXV1NkQvUoYPe
	tc2Tjz35UGIcOOs3n1xCr8uP3VZVeaDvvtfIawgs2rzKKvHkVMCz67qkt2QZXLRgg/k=
X-Gm-Gg: AR+sD10iRNE9kPDdhpK7HgofYeb6Yk7MsBvYyd4dqVx5DUrTi3dW6Vb/yAkZ5IfPPnE
	6OzwJU9DGTu1EMryBbCX3pdVEoDOl91c02Mt5W1Q/Iun4x3t0uG8Guxg5Vi+G2vlBc0Tqik2Z6Y
	Rw+PKJh9fTUyHzm9fc2WAovqLX1ruvEkCT8Wkb/g4uiCEIO4FCdicyOQyrs23GRq2QDyzkX5Rs7
	LaMOZ6oLm0drOfQbHczO+sObS8qhQwtNfTmLm+nFByLFJ99kGMXYJl0e+XGzEYhJGXb/4jyWePQ
	8WS9iPYwOzqo9gvrFcRfSiy6nOpQ/9ZOEzRt6TeLq/Cl5CVlWyZiVbQ0WyeL8K5+fPFrrIo/KPX
	KscO4J3tn8hrZ1ZtJ/7DFuGd0WzTEvO1DH9QynW95yvo0voV4zRNP8eHLE0VzlEZCXaqxjeAlk6
	QTToEaCkJexeysSKnXElVarnE4mr5s8ftnV+vj/Msw2kQgTnqD8zekeMk5kbmAPfsD2sje2J2nm
	dU=
X-Received: by 2002:a05:6102:d8a:b0:6c1:6ef9:db9d with SMTP id ada2fe7eead31-760eab487cemr4716210137.3.1786232428639;
        Sat, 08 Aug 2026 16:40:28 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-763fe4da46dsm2793059137.3.2026.08.08.16.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 16:40:27 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] xfs: report the error that made deferred work shut down the fs
Date: Sat,  8 Aug 2026 17:40:20 -0600
Message-ID: <20260808234016.246054-10-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260808234016.246054-7-floss@jetm.me>
References: <20260808234016.246054-7-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5410; i=floss@jetm.me; h=from:subject; bh=sZmYt2raO8VdDm+hOpYDP0ljGepdC6gsEluhTLQWHd4=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqd75hWc2ucnGB2iLvPGY7GFwsoX7z/tvck4NsP BrXDiEHud+JAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCane+YQAKCRC17sMLqGd3 H1LNC/4wKA7riBK0Lx0jjbe0pLAuX6QzsUcBNOdymajX9QLvjjH6tAAjtCv7Mv3KMdbCSWGyL9E nJvNON+EFJbab9DgT8cM9FCkvxLG0ovXjHXm3nFSOYMAPbFnIEavy2lOAXmqI6KG15UyVGCOMMr k3deGaw381LAgy2PnKKV68UV51F5qposNKjQED/qAsHsgmZcoLRMGdGZKKc7UemUwktlenfCEYE owXgdz3atyiAM7OwHRAEb5SvtoVg7DQh10kgTEHWMZzAOmzkSN8rsjjstvgoj4b/rArqYIfqzwn M0UvGii4ZavqIhx1QYNyQGfRPQb5uXT5OLamHmmU52lG2N50NiKIqB8JRYnSMVwqRbQOFApb8Wv Ic0xMv5TYi6zvWqV8NvOgHd/iQqJVXa2xs5/rFAH8Z0d1d8EaIS4InyMOBn3JBUzF6QnW7lG2b3 BT8dJaAW9qnOBvYHx5RKSVuCAIKjCq0lOakmcSq2AL8izLH9cXa8D4ADziW/oe+EkzIPk=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

When xfs_defer_finish_one() fails with anything other than -EAGAIN,
xfs_defer_finish_noroll() shuts the filesystem down from a generic
out_shutdown: label.  SHUTDOWN_CORRUPT_INCORE makes that surface as
"Corruption of in-memory data (0x8) detected at
xfs_defer_finish_noroll+0x29a/0x4b0 (fs/xfs/libxfs/xfs_defer.c:721)",
naming neither the errno nor the deferred op that produced it.  Any
error from any deferred work item lands on that one line, so the report
is equally consistent with a transient -ENOSPC, an -EIO on a metadata
buffer, or genuine in-core corruption, and there is no way to tell
which from the log.

trace_xfs_defer_finish_error() records the errno, but it is called
after xfs_force_shutdown().  With fs.xfs.panic_mask carrying
XFS_PTAG_SHUTDOWN_CORRUPT (16), the first shutdown reaches
_xfs_alert_tag(), which BUGs, so the tracepoint does not fire for it.
Later racers do reach it, because xfs_do_force_shutdown() returns early
once xfs_set_shutdown() has fired, but by then the errno belongs to a
secondary failure.  The informative one is lost, and that is the
configuration used to capture a crash dump: recovering the errno from a
vmcore means an ORC unwind of the xfs_defer_finish_noroll frame to read
the callee-saved %rbp that happens to still hold the value.

Move the tracepoint ahead of xfs_force_shutdown() so it is reachable
for the first failure, and report the same information through the log,
because the systems that hit this do not have tracing armed in advance.
Report t_blk_res as well as the errno: how much of the reservation is
left separates a transaction that ran out of blocks from one that never
came close, which is the difference between suspecting whichever
xfs_*_space_res() fed it and moving the search to the allocator or to
the buffer that returned the error.  It cannot say more than that,
since xfs_trans_dup() hands each rolled transaction the unused
remainder, so a small value is also what a correctly sized reservation
looks like several rolls in.  t_blk_res_used is not worth printing
beside it: the new transaction starts at zero because xfs_trans_dup()
allocates it with kmem_cache_zalloc(), so it reads zero on the roll
paths and counts only the current segment on the others.

Take the op name in a local read before the call rather than from dfp
afterwards.  dfp is freed once its work list drains, so the name has to
be captured while the item is known live, and it has to outlive the
item to be available at out_shutdown for the paths that do not come
from xfs_defer_finish_one() at all.  dfp_ops points into a static const
table, so the string itself outlives everything.

Clear the attribution once an item finishes.  Three of the four paths to
out_shutdown - the create_intents failure and both trans_roll failures -
are reached at the top of a later loop iteration, before any item has
been picked, so a name left over from an item that already succeeded
would blame it for a log commit that failed afterwards.  That is worse
than the generic message this replaces, because it invents a lead where
there was none.  An -EAGAIN item keeps its name, since the roll that
follows is part of completing it.

Skip the alert once the filesystem is already down.  Only the first
failure is informative; everything after it is a consequence, and
xfs_do_force_shutdown() suppresses its own message for exactly that
reason.  Testing xfs_is_shutdown() rather than rate-limiting keeps the
first report unconditionally and drops the ones that follow, instead of
a token bucket that could spend itself on another mount's failures and
discard the one that mattered.

Signed-off-by: Javier Tia <floss@jetm.me>
---
 fs/xfs/libxfs/xfs_defer.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 75f0d37914d5..bbf2f4ca3c2e 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -656,6 +656,7 @@ xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_pending	*dfp = NULL;
+	const char			*what = "deferred";
 	int				error = 0;
 	LIST_HEAD(dop_pending);
 	LIST_HEAD(dop_paused);
@@ -705,9 +706,17 @@ xfs_defer_finish_noroll(
 				struct xfs_defer_pending, dfp_list);
 		if (!dfp)
 			break;
+		what = dfp->dfp_ops->name;
 		error = xfs_defer_finish_one(*tp, dfp);
 		if (error && error != -EAGAIN)
 			goto out_shutdown;
+		/*
+		 * A finished item is no longer a candidate for a later
+		 * failure.  An -EAGAIN one is not finished, so it keeps the
+		 * attribution across the roll that completes it.
+		 */
+		if (!error)
+			what = "deferred";
 	}
 
 	/* Requeue the paused items in the outgoing transaction. */
@@ -719,8 +728,12 @@ xfs_defer_finish_noroll(
 out_shutdown:
 	list_splice_tail_init(&dop_paused, &dop_pending);
 	xfs_defer_trans_abort(*tp, &dop_pending);
-	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
+	if (!xfs_is_shutdown((*tp)->t_mountp))
+		xfs_alert((*tp)->t_mountp,
+			  "%s work failed, error %d, %u blocks reserved",
+			  what, error, (*tp)->t_blk_res);
+	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
 	xfs_defer_cancel(*tp);
 	return error;
-- 
Javier Tia

