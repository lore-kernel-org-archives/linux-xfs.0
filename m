Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E07A3BFE3A
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179279; cv=none; b=KGFwY2d5sMU7LWaVF4cVnVjzhKdM8NgydRmM6zuO33YUz4UYoXeIsDodW+gp3/dncTe1kyy07tdetGE9Z9+XNQThpHYwwVnHufTxU3/LctU8Y2gCPmqqkL8NaWdtXirayJ8bMI92QfERrNOR1QuF/qA5nt834Ug7G94iSkGe5ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179279; c=relaxed/simple;
	bh=DH8iPZS4huxVm6YowzoubJA0ck0LL4nGUs6YqjI5Yv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4tcePoQOD0qNc2IQnxEaFPCVRkvo2tx7+wbmx87OkYrqFk4nt4WpBDKiRUEE0LcC0/7WKnm/TwVFReLNG0R8n5wPXBtk92MUCk8eV2P7NG/3eTPtfn+H+nEjvkBQc+QfRLQK94gLkAJhO7fAl+yNUI+pLPitm5BfBfxIv6W6s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gqi+OslU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uKhjxDMQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gqi+OslU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uKhjxDMQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792179276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g1hpnIZS+rqWZA2eiXkLsEbcMPuVOm6f4Edvm7O5FKQ=;
	b=gqi+OslUkkVS20maVONkJytDxfG6L095bLaLGVSlunhhNJ3VNiqLlUh8zQgN2a1cG000pL
	KExNDl2pVrtSxm177XiSVuVBAMcIqFjT3MaSou8KSt8riBpPDbGYpx15ICAu1OheIAfNbs
	SVP5v6b6LBsUE+9YHa7ohe65b9wnkMM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-1RghWM7SNtavh05dhyWCBw-1; Fri, 16 Oct 2026 19:34:34 +0000
X-MC-Unique: 1RghWM7SNtavh05dhyWCBw-1
X-Mimecast-MFC-AGG-ID: 1RghWM7SNtavh05dhyWCBw_1792179274
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-934956beec8so61362985a.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 12:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792179274; x=1792784074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g1hpnIZS+rqWZA2eiXkLsEbcMPuVOm6f4Edvm7O5FKQ=;
        b=uKhjxDMQUsjU5UUewzgiuAlkglXKh3dFICbfTSmlv6R7OskNTyO4NUYehQibuLtP7G
         tzrrSK+87ScjJbXnyYnX0Mv3jZ/X2lGzjIaxxiNdRtXmKMwicM3alYFXqrWV2vTvThJY
         Fcd4ddVhPTshGcEwMIvoM1RBMQwH710SBKb1hObSdGwiofCP7evCvMt5nqeBEVvFfPDi
         bIyH9HMejEfRTrQ5BEVZiNMniEBBlSAwa0QOUC7VSbeR8rGZ/L3WAMYjDI+5m7FqAh6S
         JRnQjNPhfT+PUsbbg7cq6PPFfaP6NiQx6+Bi1f0TJX2HBCCl2pu7v/Z68jEUseLeJrQU
         HJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792179274; x=1792784074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g1hpnIZS+rqWZA2eiXkLsEbcMPuVOm6f4Edvm7O5FKQ=;
        b=LGsTd886nKXy41WsAIqUzeXDL8AZT3JVL99TaxIOUK7QfOVrVC1/6cU6plOiFm7UEd
         0W/y4JdKv6nJ7gswn8JvRAHSjofTGGEeHMnKfoU7NtB+G+RN74A5koVdzv1V36JSqA40
         pFTjaKa8weLbcl6YSQtjSzWBqSf/okcKdlmC6KdhT1BLRERsllNHZoFb+N2zpmD+6+fu
         Yk5Q/gDrMW5VJKfNVpCjNmtPTwmUBM0w3MfAZWQmkVCHEamEjoVCAHDtVqHKCQ1cFDi+
         6FCKGf0+rMajPPwoGvLIbuq31mYdJY71oMguqUK7vl4VF3aTjsZsSdBDeu3EASeg2kBN
         WV4A==
X-Gm-Message-State: AFq9FYJitZ0+g/uaDwtxln7CiTyNDQK6NLCwqft1SdgkUiuQ2s4ukodD
	teD/AlM+fKolRaoM3xAAAzHphZh3dQVnOngaqPWQM7X+ddf7xjKd+SUcnHTVmWyAhk9LwNFoqvX
	ojKZ7Ownn+iUQHDvRjObUgIEQpBGOk+ZdKn2nW1As2qC+fRp5Dx7gO2OQJqujfNr9y8gGnU+Z1C
	Ke8dTBywCXLuqNZ7jSWRyeR298y4cevRmvlbkFZsYLS0mi
X-Gm-Gg: AYBFou2e6arNhJe6BmNZpEqz3VuM8SSNoCdgIEeHcoSHAjg09jXuQJEs+AdqxSl9oMc
	+lY3OJeUTzAyfRxzpkt4Q5VRNgu/mU7Tm0vdAZ9UhwfNVZGArAQ2b7ah6cMGK0Z8X0RVnbKk912
	FSV6D5MR9P7/J36nX/rXhNy6S55rzYF+blIlgnFEmmDPFnm6HsBqIqmrb9g5WgeqjSWSk3/aP2U
	fCppnWa3ZvzmNSVkf8jl9j9zuGcumPX3lZ6bXLM+LQcQLGq0p6ny0kqY+/6tK5DynxER8Bnf51y
	+/UEaENnybL1igPicOYRZZl/bxXu3O12em6umb5HS9J58Zo2K/KNwRCEWusx1SU7SuXb7sSLbaC
	qxaSQ9quoL4izR9t/ijHlyrEcAJ2TpMOJe+RHTw==
X-Received: by 2002:a05:620a:701c:b0:93b:d7a3:45d4 with SMTP id af79cd13be357-93f29d823b4mr144673585a.61.1792179273812;
        Fri, 16 Oct 2026 12:34:33 -0700 (PDT)
X-Received: by 2002:a05:620a:701c:b0:93b:d7a3:45d4 with SMTP id af79cd13be357-93f29d823b4mr144669685a.61.1792179273330;
        Fri, 16 Oct 2026 12:34:33 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a990fsm284359185a.35.2026.10.16.12.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 12:34:32 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	dgc@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/8] xfs: remove redundant stat check after rcbagbt_insert()
Date: Fri, 16 Oct 2026 14:29:04 -0500
Message-ID: <20261016193422.1630907-5-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261016193422.1630907-1-sandeen@redhat.com>
References: <20261016193422.1630907-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rcbagbt_insert() simply returns the error and status from
xfs_btree_insert, which has already validated the insert
or returned an error.

This makes this instance of this idiom:

	error = rcbagbt_insert(cur, &bagrec, &has);
	if (error)
		goto out_cur;
	if (!has) {
		error = -EFSCORRUPTED;
		goto out_cur;
	}

unnecessary/unreachable code. Remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/scrub/rcbag.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
index 8f3a10f7c908..fd9ccb205725 100644
--- a/fs/xfs/scrub/rcbag.c
+++ b/fs/xfs/scrub/rcbag.c
@@ -105,10 +105,6 @@ rcbag_add(
 		error = rcbagbt_insert(cur, &bagrec, &has);
 		if (error)
 			goto out_cur;
-		if (!has) {
-			error = -EFSCORRUPTED;
-			goto out_cur;
-		}
 	}
 
 	xfs_btree_del_cursor(cur, 0);
-- 
2.55.0

