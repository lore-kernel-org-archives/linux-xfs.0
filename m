Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840D8418A30
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786380200; cv=none; b=YkerBnMIgInFYIm35NZplxB96sBF1+TItqtcozSsxun83ZDe10WyLGOlSRYKozEhYgpx60sfWTQj7GCA3VLgUA60IwJDdZb/Og80zjKEFl8nG5NBJfjb+jjoXQDKhwopK2CPFQA98IS6Xq5CFgNELiNhTvFE/i7f4MkGP2I8QdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786380200; c=relaxed/simple;
	bh=O7lAK9Itxu3BtFZebuGm+soxk8EufQFIVRqNLSr9Y0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvv5JWDkOPNkOJP9l3jmMHec8If9ew5381MNHatEpKTkC1CIadfbpJZOUKElonOeGsGDZcbJAfMYfg0ccjesN7bn3LaZhKogt4stjyP9l4LN+wRPS/42ranBm94u70uGcMY/B/Nf+U4ov0kTMg8FVilgEJ4QTuvJATxWjutqyz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=fb+BNbyU; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="fb+BNbyU"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-73e516d6ddcso53140137.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 09:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786380197; x=1786984997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sND6wzkbiGyKvdiG9Z9kRm+epdaTPvk4GyaXe9tvODk=;
        b=fb+BNbyUh2xzUMRrkM5L8mmq9DQt52hI1WG0gzjNooFrJOW6FOjZiJZdVeNrw9wEZR
         1TgUCjmW1BT1XJWFAHanNwxOmDiNR2KmA7D8nP5h5ADNgZbMZNmlqvHy+dyLHJXi0pEn
         +mUE9Dn9TkDNBjE4CTZQ8r7N1FJt3n37KMcDvXEjLlrEAuC4+7TLpemHZdEgqQPQUYXN
         oNq0joWB21J+kU1R1FB/OOcuLad+5bY2vEPJ1cWTF0ys0A2vZsJxxM/sQAQCSBOQ93g2
         8Ots0z6igtFuBRpWDHrpMK4RgnmBUVqGOrC09MAPHltHZh/BdSSqz86uA3/V3NH3TrVA
         xy6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786380197; x=1786984997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sND6wzkbiGyKvdiG9Z9kRm+epdaTPvk4GyaXe9tvODk=;
        b=pcF8p+yldg8Z+TFPMSTzhETETL2HF/JHwJ0D54FdZLx7s67u9DwdzeNCOw+HisOImZ
         vyiskb4VvLAEe4b/2J9MaQVYnZqm2eol9tMcL2NtQ339LGhwalsraqtzuJOTD6qT6OOk
         zQxgTHkXR8M5DjzNO58fKt6RIsqYXEnhF383YNfbbPPgoqgiMYTGj0YklXbx6NQZbGQO
         9d0MKUI8ys/ZFi+Upbjap+mWwPpgjTGTR00Pun/5sG1aGYg10hDGEPX/+wHaEtT6uHyw
         WQabn4GvLQdjAK9A2okmgrQfBk/9sYnIj6H6V874JVfBLZ8nhl/Z7s7mUmGr72Har3Q6
         Kf1A==
X-Forwarded-Encrypted: i=1; AHgh+Rpy+sUk9/w1cYzpqMZR+i0N3fa9OBunAzLkZaywN8T7B1EAGrPIOoGM//BvMwGM1JiDb8Ew2mSEDUo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGKYBsub8ZUwMEdflOwgjvmwioVW98fUrATGQ8BJmiKZIS7eoT
	SMlj60wE4ejfL0UVrIWiEfAxScQJUaI0sFqpz3qneaFpBcF5R0aAwIotNz+rQwxe3bI=
X-Gm-Gg: AR+sD11HB+qL7CfOUQWR4YI3Kd/IETuEJvlJgc3lXT5SSOLuhSYDRzRvOWIXsxIJYQF
	Z8VDLlR3EFrpvCbM3Br9QN+4lV4znmnjcEuilRJw3oyLbMkED6nHz9YsUIPEyc38aRCIEIqlPV9
	guy7rtAIYreIDRDbYaaPbCGhJSRe2egZsaAJBgz7/0FoB8WbmElT2GL1nACUJCol81Hae/Ki06+
	mxxQp350OpH+Dn0jzLdej0UmVlWu3WTEoAa8s1DvNRRKyd6lX64jTTKmSrb03mZAzbLztFCDwGR
	aodTtIK2qnAdnkFH9XmV8Bf3xauHdWeyugyixtgpY4Cg3tUxW7gpV9eHSkB7Gts95xA9nkn4Icq
	oP47vXxyuGj5odKVD+KKcmbpKN2+idwraQN3W6QMG87fB2lGrkh0a8e9SaQGpd1m7DOuQJ1OVg+
	89C7rWygIxCgbS7t1aZTcCKhSWbTj0SeQGJLykCkDQsociRIxqkPLRqXMrWwmjlmwKjA==
X-Received: by 2002:a05:6102:5689:b0:738:8d0f:72a3 with SMTP id ada2fe7eead31-760edc7e42fmr5605791137.4.1786380197362;
        Mon, 10 Aug 2026 09:43:17 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-76400dfe036sm4853650137.8.2026.08.10.09.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 09:43:16 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/6] xfs: initialise error in xfs_defer_finish_one()
Date: Mon, 10 Aug 2026 10:43:14 -0600
Message-ID: <20260810164312.960721-9-floss@jetm.me>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1468; i=floss@jetm.me; h=from:subject; bh=O7lAK9Itxu3BtFZebuGm+soxk8EufQFIVRqNLSr9Y0g=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqef+hdkIzN6Vm6qJyjzD8yEylWzJ49lYuL+7hF mhBN6Hvjd+JAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCann/oQAKCRC17sMLqGd3 H+1yDACf56wZHP4m1Y5Uv+vxhSX72AcZO0A9l+l/pCUvABZ7e8DJfMfAjVVgcP6MKXNRxUvq/eG wnOcudsw7GhWD3fa88++G0srE3xuALcSYhbEVtSa/ZrONxsuKAV0+UVZFPwBVidfEWxWMaVfI8N zsAYzC41KkH7Kl0ssLLbhdKUNAyUHfAvyUU2iTiB3PFhpsntX6uQ2KQuj7+JngtMXBMhhEneLsv eQ2uy6J8cvXs2rmQm7AxqY8xbe+EOzKSXHpMBTC861NSxQugYgGHWKa07vAkaMdw3nhqsLHyvJJ OXPsbfdK6G12aSHqvJL9em7/LJA7z/eDYiEIyheG+j/0z/0MjbemMRRpf/A4/8sy0JJffFx24Ma opQXba+zcp+e9mXciUzc6iDhNGu3UynCtuO0wzIcaKhdT7xJ8/SpGQNbo9uH7X8IqM7cRxfDJxd m/OOYLfBJ7/ix/fTPTqKx2g6ztofRFrXs2OdvQQ32VGoPz8J6oDACVD5KxmPIC0CiGzP4=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

xfs_defer_finish_one() declares error without an initialiser and only
assigns it inside the loop over dfp->dfp_work.  When that list is empty
the loop body never runs, control falls through to the "Done with the
dfp, free it" path, and the function returns an indeterminate value.

An item-less pending item reaches this through xfs_defer_add_barrier(),
which xfs_reap_ag_blocks() uses on any CONFIG_XFS_ONLINE_REPAIR kernel.
xfs_defer_finish_noroll() treats any non-EAGAIN return as fatal, so a
non-zero stack value turns a successful barrier into a
SHUTDOWN_CORRUPT_INCORE in the middle of a repair.  Zero is the correct
result: reaching the free path means the item loop drained without a
non-zero error.

Fixes: 3f3cec031099 ("xfs: force small EFIs for reaping btree extents")
Cc: <stable@vger.kernel.org>
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 89501e8bd2f8..843c33304441 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -583,7 +583,7 @@ xfs_defer_finish_one(
 	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	struct xfs_btree_cur		*state = NULL;
 	struct list_head		*li, *n;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
 
-- 
Javier Tia

