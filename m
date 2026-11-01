Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793550489;
	b=n7rMQFHbXSJ676u1CP/tluim/Hj30EAZ4HVgPevtW6Q70uhmf28nJg7ltoaBpW+0sPds
	 oCAYm/Mje1KKc5FkgGUwBYsFH2VgPS7qFWrwUalybWhsg81/pCY6d+02+5psCk7GU5SbV
	 UMJCse6KsSgdCx7OgemsQRWaXYjfy2pkZjorbvNSiny38xeTO5qV83gNfW4YW9efLxin9
	 kkQsM7GosG5IfpB14wZk3X14O20d9uNDY7bGkoFKfCsJxCJKdirF5QeZxhwlkbNNqvBQd
	 AQ/jfngPx0v2Ho1upSC91mQH2/XKraeUgrn7gO9sUyt4BbXm9hzz8HtVvn1wv1nCuJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793550489;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nefoxCveWO0xbEAordh7jDzaAtWnXNOWNSJ+ENu4gZw=;
	b=jopPEejcwuz2ifoATB75ngtbjDjgJSd9GDx5KKEcgq7DVa4LaPfI+3VcAnYFgLg1R2lK
	 3g9uUWsQwO9s8b34jFBoHohrI9LiLO+z/A1WynJShrbaEz1vf1HdZI+P3KMFTuDAiZxA1
	 ONH4eqn46vCjdut7JaYITzMY0lU/BapQgk5f8kZY8MyFj6BZpXz8rP056jlEV7Z7wP6Ki
	 QqNDO0Q33OXFOXl+JFpCEU2aXiPRvHvNdzHwuN8kG/pQQWuhFiVF8omPecv05KvtkNtiG
	 TIYLcEOLg5za45xwbO+yxuZBRsZXmCMLEVxNpFuVcn65WnX6hpiRimgp0G7hWHC356g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EgkSNL8X;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAE0606A327
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 16:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AAE0606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EgkSNL8X
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so28731225e9.1
        for <linux-xfs@vger.kernel.org>; Sun, 01 Nov 2026 08:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793550487; x=1794155287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nefoxCveWO0xbEAordh7jDzaAtWnXNOWNSJ+ENu4gZw=;
        b=EgkSNL8XByqFyT0Xrc+JT9yxtdAf9CDS05tYbQk6FY1fmWkgNa41dPSyeM30sEKjAX
         NZgD4LD6xcTVI1+zGdI8Kt5/ibcQufecAVE+Yk7z6tk57mUp2y8hlABB/Ptt6uPcYdzQ
         mG8UWLeyAjOcb2Gcqkw0Mh+U6RvMgH2JkJ1CAoTHG1VeY4ZPzCiLPDXp0zz6m5g9HRlr
         exaiJIdEeqiI6Hb30MJsOb38BDCNhFmjfhlLUW0PqpW9Mx5uejShh86MiIiWr8pB2lES
         QyawWD3UrG1fwUrqna4NnyHreNm2SEQOVMfqqlQP9nIzSulOkdhL9rq4NMp3erIirvD2
         CI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793550487; x=1794155287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nefoxCveWO0xbEAordh7jDzaAtWnXNOWNSJ+ENu4gZw=;
        b=mid03ctXZjTSgvH4Bt06u19IbSe/tGv/jwj7Whuw+bXM1AztwfzUncVF3W0kRVqWy1
         YLTIm3IxLx7XAFibQ6GKlZH/x0xjQbQ5LXdyH/U3LXC0C0E3PthXaHIEXk277D1eNfL/
         MYJk58oeIughnfObpnFMtDTZaymyUfZBX8/O2PS/EEVIC298eQmn1iyP/eS3yz6Kf5qR
         pSzR9CPvXv36yGL666+bq935bR3Ynzh3yWjvcCYJDsSgpl7k7aT24bgWWTChQVagLVlI
         Jr5RKz67kfv32FsZDnyif3zBs86Owf/3AGbvhX0Hxf5KyulOJeRL3gDsD37qC/XUJ8QS
         i/zg==
X-Gm-Message-State: AFq9FYJbZaxtdi2005EpJzRu1y6MmicDjgWVXA7YPb9KQBNetYx8cYjQ
	wZo4b3/n71VF1MAFsyH2gkUcZFOwu/1E/oAMWiVV40VjkzkHY+sdX27g8e1R
X-Gm-Gg: AYBFou1r4FSDZcIUSMPFUaV23WyTvWnVVlX0BM03+N3FIUNKYYXdDC0cju0NAJod9SL
	O67j/NJgtG8rbkwmBwaeTymGZYvk2jXuolZdSOiBc39aczvSDCkbS1NQW/o30oumBrYN5y/Ho4p
	/AKfMDQxLEkkehccRXaJE10IZcsm6YxcU5TRkWtDKri5ZWpo0BJufKojlg5eMmXMcOLyNPZwIRp
	93gYNrta3t5F/A1jp9ngMp77XcNAM9/SszFzfEWZ2EY79aPwA8mr5VxjcSReEh98iKHNncr5nY5
	GJfUKc17zwNU7CQJI7gjTDnj+HoM3LTNeJlW4GboFql+HDAHaziO+ZHT4hET7YRjTMXbXRDa1IT
	1YBnn2RyMzzUTTjaoub9WNOf+K8Ayd5bQPoJDcNTxHjrdZf9lV93CzAtc6RST6CUN8/L8w6V5vA
	1lwL6BgkOMo87RBVxixhZNb0/4MUggP4j8MiYVN9vTX4rAzGkJiyRVpDM8q4KXT221HUJL0npgH
	9TA2zbVtjHoZJIurWqYzJYfaZy215ByWmUK4lKjafr8eEwbRp1I/Ez2rMNvfZbtWh7AiPSdCEVL
	15iUfWShx8A=
X-Received: by 2002:a05:600c:37c8:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4ac16acd93cmr186307385e9.6.1793550486953;
        Sun, 01 Nov 2026 08:28:06 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf0b36853sm192023245e9.0.2026.11.01.08.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:28:06 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	djwong@kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH xfsprogs 2/5] copy: validate bb_numrecs before iterating alloc btree records
Date: Sun,  1 Nov 2026 16:28:00 +0000
Message-ID: <20261101162804.1444159-3-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101162804.1444159-1-tristan@talencesecurity.com>
References: <20261101162804.1444159-1-tristan@talencesecurity.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The alloc btree leaf record loop in xfs_copy uses the on-disk
bb_numrecs field directly as the iteration count without checking
that it does not exceed the maximum number of records that fit in
a single btree block.  A crafted filesystem image with an inflated
bb_numrecs causes reads past the btree block buffer.

Add a check against mp->m_alloc_mxr[0] (the precomputed maximum
leaf records per block) before the loop, consistent with the
validation already present in repair/scan.c for the same btree
type.

Found by code audit.

Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 copy/xfs_copy.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 4692a4ff..9658aea3 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -1083,6 +1083,14 @@ main(int argc, char **argv)
 			}

 			rec_ptr = XFS_ALLOC_REC_ADDR(mp, block, 1);
+			if (be16_to_cpu(block->bb_numrecs) >
+						mp->m_alloc_mxr[0]) {
+				do_log(
+			_("WARNING:  bb_numrecs %u exceeds max %u in AG %u.  Aborting.\n"),
+					be16_to_cpu(block->bb_numrecs),
+					mp->m_alloc_mxr[0], agno);
+				exit(1);
+			}
 			for (i = 0; i < be16_to_cpu(block->bb_numrecs);
 							i++, rec_ptr++)  {
 				/* calculate in daddr's */
--
2.53.0

