Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AB8429816
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786380202; cv=none; b=Dm2xxj7BCkVyiEY6+DMuYFtr/7cgl+CCIewAI8VFPcN1+FV21C/FAd7RqnarbCjwu13h+CDmlhKNn+MJoUKy8ivhbpzrD7PF9UAQcwMNjWec0vzVtanw3bLy0ACdQt4vyAwepXyswcbN4r1WV9r5y6WUto+hw4wSzGrLybyD4fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786380202; c=relaxed/simple;
	bh=cN3dntYSRKkBZpxQVRebrXb/QZ7i856/vDVWzWsugXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fijPj7EYhOPoY9WvY+1QruLcTPWFyRpVLFV9u5sma3FHZIsfJvBlBEE1orzKN/YDWnoIVrSgSPLYYWGyxpjz1Eury+s0dmayUZDZvcv94A3/emJ8m8R86qVmq0SM1YT2h336Q0VaPQNg49Y0rs6pfpyETiiAYmhiCLifcQKPoKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=f/aKMsB8; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="f/aKMsB8"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-73a334d1128so53498137.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 09:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786380199; x=1786984999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qEP94udPMsH7DZzh3NprgOqukKgliAk1nMK36vluOns=;
        b=f/aKMsB8ofDNN4AmZhaYk8CV+2NQkpY7e/9T8+BqcvPjph9Nlcxih0i52yDQiYvvWW
         pgBlIpi1jHWILY9RoIUt4iaCDLVJpodkmGiveCKJ1v7ZsskLGtQXSIUvverqILpvUKAE
         t61oqR892DoAunM0El+i5VxknDK8S87hYR1SR0/ZMVwmzXsLED/7GX4oRdvrN4ocUZkD
         LynP8MGCTPPC6QRgB6QT0SgR74ZAGTmqCIy+g+O0rqCmLoNzkJGFjIRzcFQRD590YZUh
         VeNoO+iF917FobbMfwDbLyz6l+nTtdEor/i+SjE+yOKGo1qu9YKXjAqK4vZNCwW7NPEm
         DRIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786380199; x=1786984999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qEP94udPMsH7DZzh3NprgOqukKgliAk1nMK36vluOns=;
        b=QlyZgZoADLYJmeq7rL3FDuSJQmVLcimdyivt/ItUGJXigHumgQzZ5ndwGJBLD/pD2A
         +pzqR77rBMTOOGvoCuNpQrbq0RPJB3Nnl3Jj3mv2I85A6LYHoTFI0vhEjFiUd1AR9To/
         kQ/xDejmLdx4+ah8ZtCQ8jMzyAsdg8aKHZawAIHMvOkXMp+1SbK9hQs7qlrF9r5CYOPJ
         zPdKX8n+fYmgu3IfxNXEnh4rnHFV4KS3MrjLTVh8BdR03APkbWUA/elT3cGfrMvBT6v/
         6iQr2wto5KYWEJNyN3k0BrAg6DwHHfjbkQzblSpv8GQ3FNIyZsUP6cGYSIKhDJ48KK3Z
         EL2A==
X-Forwarded-Encrypted: i=1; AHgh+RoU3ZIfZfJ0pO4ol6VGgBU6Bzga2SM+SA4Fh6rlS7fFwJNBuk8uJb5QNfsj64bH1k+mavrBNO2yTxc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqy2orAonY4rDU+Ojkn68BKf1nz2naHayv3eZnY95yYpSRB+pi
	rSniRrEIfVc244x1xSidXRDi8EJ3HF9cXDswhB3Pbke8MmZpj774YC8iUXKWBaLHL0w=
X-Gm-Gg: AR+sD13Xzr9YF7xzuQ/hHJ4YrjoThLyjRg08bapqcQSLrGAzpls9sAZJ+cTRKBiHP13
	ZGL/QyKDc12Fkv8SSS8kZtV0dX+fssLbKCcxL1LVYFWkFYAl9Ex5D5isrL4iWtuoYW8LFkdmv4h
	+f+gLJgH4lwK3qOuvFrUpTTqhQmtWbGqb+jlG0pltBOH3MY6zaWy+WT5sef5vAUlM2wdJJGEqsg
	gLs8TU29qFl6gsoy7/r3qzUtoCNUsXJn4oQF6uXqg1HFOt+lUfoTx4cLOprA+vxXK4msS7+UMFw
	35JXlxJjIuc/7ysblBEyTWyMnfUabAooIge6AoQMYMjuVmRWbqVnPssljYRQSy3O7DBqJYB+CsR
	7ruu3kDddI7lpqj0G8Yfp+M5JiRdCa+fReb4Rv8PYUz93DIdU0EBLIc1XOHcg9Lwv4T9ZvafwDz
	FnbUulWpZOejKzIOd8TQ5gwUkgESjzHfVrmipK7P98dM/GJl6vMrNjcxGrhSNHZ2DsUutqZmpxd
	Pc=
X-Received: by 2002:a05:6102:3e84:b0:74c:551:54d2 with SMTP id ada2fe7eead31-760eb45605dmr6646040137.4.1786380198949;
        Mon, 10 Aug 2026 09:43:18 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-979f303c685sm3721486241.9.2026.08.10.09.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 09:43:18 -0700 (PDT)
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
Subject: [PATCH v2 2/6] xfs: give the deferred barrier op type a name
Date: Mon, 10 Aug 2026 10:43:15 -0600
Message-ID: <20260810164312.960721-10-floss@jetm.me>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1371; i=floss@jetm.me; h=from:subject; bh=cN3dntYSRKkBZpxQVRebrXb/QZ7i856/vDVWzWsugXQ=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqef+hZqnJOJa7RnkDd+smQ6u6sTV39cbOgg3pl R42h1J2EW+JAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCann/oQAKCRC17sMLqGd3 H/q8C/4gf++xZgmHnv21fz2YCwoOa2YFWkg3+h2arEpIMhkJxLl03yDfVekOy7jqym2OH58Qhcq oDkifo144aRxquJSPwxs02wzCKj8iqc94vOJEho+aV+jDcikrDQu8Yyc9JF28LXx5jpZph+nryQ uTrSb7sp/SH7p5YYBk6o/H92+MI2nqqq7dmiOfpBON18iaFXOVf+gGfA8cBiIYoRPOb96anipfZ E7whd6HhO8t8mKrcFIzlKEKFf2Wht8UqB1qKxSFdB4AJ8X8yqEKzZwpDzAbh8DgaDSJBaa954HP aJ6Vbc/VGp+PA7wofqCAUHeDGGgL1ccH9zsoy4zHkeaaXQd8IPk7Ay3cJ6MhBKm1DLuBFv03s6m hd2yxeXfGODmdVNV2W+PnFQRZyiDB9j7Bbs3wQ9neb5b0lqn7FkovSD+fbNOMLBOqYqLvIjQcr7 OTORWrqIfGzvigmxCnFDfqb5x31W6PjIqwHAKsSNi880QWWscab6klPOYVaotf12Unmt4=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

xfs_barrier_defer_type is the only xfs_defer_op_type with no .name.
Every other one carries a short string used for tracing and reporting:
attr, bmap, extent_free, agfl_free, rtextent_free, refcount,
rtrefcount, rmap, rtrmap and exchmaps.

That has been harmless because nothing dereferences the field, but it
leaves a NULL in a table where every other entry is populated, so the
first caller to print it gets "(null)" in the kernel and undefined
behaviour in the userspace libxfs build of this file, where xfs_alert
lands in fprintf.  xfs_defer_add() already treats a missing member of
this table as worth shutting the filesystem down for, so an unpopulated
one is out of step with how the file handles its own ops tables.

Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 843c33304441..75f0d37914d5 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -229,6 +229,7 @@ xfs_defer_barrier_cancel_item(
 }
 
 static const struct xfs_defer_op_type xfs_barrier_defer_type = {
+	.name		= "barrier",
 	.max_items	= 1,
 	.create_intent	= xfs_defer_barrier_create_intent,
 	.abort_intent	= xfs_defer_barrier_abort_intent,
-- 
Javier Tia

