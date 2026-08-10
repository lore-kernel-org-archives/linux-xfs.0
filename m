Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2177E429028
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786380203; cv=none; b=gVp7sqhwDOlfDK3Xps5pNGZIsuYx7wKa3Up6Af8e90RVMi8k2Vo5O6UEavSgiFzHReHFtJGYMQQ7oe9M6VqUoZApPKL0elORxg9oSummzg8ayUW73e/aYL0mzAGtZ3CXFYPggKLfDlQMymIb8JWAWv0OQWIjCYS3CHNqbuHQ2JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786380203; c=relaxed/simple;
	bh=sZmYt2raO8VdDm+hOpYDP0ljGepdC6gsEluhTLQWHd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1RYnnz1tQchYscjjND/mCIotg97U5/CJL4XnZpEoO+NejhHCNopXq8i7DPQkN4V0q6ecpkboS7THEHzMHIMZwEMC808qvXY+NTlwmu0U8sOqJPl5M/DEYf13pA9OW/lce0888H+hP457uxJZ6ZzZXb724M/hnOpZmgrD/5R9a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=qowcV/X1; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="qowcV/X1"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5c0f74349e0so64224e0c.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 09:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786380201; x=1786985001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nyeyac7LrDv4OnnnUjx1xvNsyZmRbR/sEbRM05AokQ0=;
        b=qowcV/X1uj0dh9ECDAw91GFIvBGPaNAff2rlFNoo7Dh93adG7G59GHLk0GRnZBUTbF
         CMoUFnMnbBJOupcCNC+uGs0H0zN9vVNUUHa+IHzScZrQrpbBore2LpDE+2lmZbUqMkFy
         5AxYHBKOsiaHHZOrxqVEqfqcQwkDaCgOFlBVwCLnDGe2tS9fIMDUACLllUfd8Oy+2dgD
         AMrMbYLiiG2hPdhwSDIomN61f7enYdgsQ96HMhMHvxyNR/BBEzJ6JZ2Hq1+H3PER9ub/
         NVnmMjRIninOnJ+yd+9Oi0CkuCxcOcCmlKhA/n5GNPWDp+R9CwczqSyrDlNnl0O1dp8j
         d9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786380201; x=1786985001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nyeyac7LrDv4OnnnUjx1xvNsyZmRbR/sEbRM05AokQ0=;
        b=f6x1hRyO60bhJSl+fLTRQWexCbpvjo5uiXbKy4svHgvrBxUjZj94G01aRMqjmUxW0H
         FzfHZK/N/HyEIvj5EVad2msepfa060m1RIMRbUIRJ1ZB7M0qHmtnclvxt8kevTIgLmp2
         FT0hHo5HY3pXTvb5QaZONDWuwMyl71SQoACfXYahOcZTED40Gdzi6y2+AwHQi/BbWO+v
         g9Yx/fjOp8dst3Fy4KnDxTfB864YjyP/4ukMxeQYcF2bQl20Oqzb09Cox1cLt9cKjBoc
         BBVYdwb0wggIntak8WJdtQIamWDNUNOJjv4thi+8xB9momYQ9XsL5SlDrRKkuqRTe0Gz
         wgIQ==
X-Forwarded-Encrypted: i=1; AHgh+RoJ0XnZnwuEXY7jqc+u3UKdvhRQFb256BCv69neo6MaHJqectQPc07l7MP2/cDcVGJdRR0DWf4FkSg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAzu7xac1F5hLIaMAbsVicKEfy5/nhTzUapp9yiaq5+udI16V2
	rO4swxSMLbxMHs70i0uLzFrkLoSTUiMoSQ01vVsDckGUBp82xi1mTL3+PJhhs9tEklI=
X-Gm-Gg: AR+sD124b8Te3f5LUUOWcZUSD+Y3EhsNBSSVNwnhIigLdbfiDH1lB/5avzS8O3Smhfr
	6IGmjvkCVdOznH5vsHSd5esgV1Zc4V1tu5bwfabHkrdvZXdLJfctHQhzO1wDwyoTSLwHYb+K08z
	qQlrA0hpN4k1TWUCfAqUOpqahfm+EiNURX8BVybaFKH8PbLYWUi8vOUilUq7MA1oW7WI1yaOiEf
	CCfngIOmDY0JdQRO7NffMB9Vh6O9iTxk2MG/KPV65QF0yJ6W8iy5S8wx+NAwZUbp2ecdwovz1Hd
	NY4nmM+6BH7HLTSD3alWLtCMihz0lSZvJl1DBbYnrSgKl6O54poZ9yH36iRA5PyeJUjKU78WS//
	kDIOT5rpgJiJxCi1mA/oZsL0LAl8/HKxMG7tYMGBbtVVeh3DspOSNqvr4grbPUf+iTxoJRO2NZH
	y163IO0HxaH8/rjQXaK84hvrC57m6ETvq07frq4JCRN8G91ngnGs0O/qo=
X-Received: by 2002:a05:6122:c288:b0:5bf:73a5:3e05 with SMTP id 71dfb90a1353d-5c3d927a735mr3088839e0c.3.1786380200754;
        Mon, 10 Aug 2026 09:43:20 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c40b1aaafasm4503614e0c.9.2026.08.10.09.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 09:43:20 -0700 (PDT)
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
Subject: [PATCH v2 3/6] xfs: report the error that made deferred work shut down the fs
Date: Mon, 10 Aug 2026 10:43:16 -0600
Message-ID: <20260810164312.960721-11-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810164312.960721-8-floss@jetm.me>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260810164312.960721-8-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5410; i=floss@jetm.me; h=from:subject; bh=sZmYt2raO8VdDm+hOpYDP0ljGepdC6gsEluhTLQWHd4=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqef+hWc2ucnGB2iLvPGY7GFwsoX7z/tvck4NsP BrXDiEHud+JAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCann/oQAKCRC17sMLqGd3 H7lWC/93Hf88PQ9bhf2CtTxEr0K7yd0xz8tsq33Rs32dpi8+yHBi0q06Eq2nHm3UkYu8BEeBtSW ZMrSUuCLCOiwTggHu7Pa3xcSXSQJUUpjCoQAivN8nkJULpKzsgROklkaW+G7SbcCaBDWBVKmK9k FhqnjY+ZXDYtFfk1NmcdE0hzlQqXLLlQabvb2TGXPEuikC6sixNquj5gYDdH2+/rodTclTmTcD3 6iwGC083Je7JZQwxAcwoS1m3mE5fFZwVIGLboSZPwsQKNozWnQPHh8u0RXdNhP3g1+9ob+vsJXq fau79caz4v3VHiaLyXipTg7fHVfMxlDx5DfRQQC36YkfkwaRKXH5t2jrhd9WsYq7Id72cmSEmtO eC3xPX4SmoM3tiZx67I7hMjEPq04pu4mSRyNrIY51C2y/PH/wX9v3lybx0eJdjAaIv5T+wyTvoS 013JLtcNnWi4Gc/mAUNwItQfQKlbk31KOeVXf3GmuLM0W9DSJmL5AspdpCzALD03K+HOU=
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

