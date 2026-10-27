Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793117889;
	b=PZ80p1TwioWx2+1dskv45bhIgzOb6qSC7ueyvlxZYmZFZCAqg13ykuGqDbBxA33I7faz
	 DefJOQ4nPitsHtuFd2VtYeotOCR0+FryUP3+XzGVRDOCnZNEmL/EcOT6dEooJXBaGLjai
	 5BGMVlDF4H1WG6BM6cU9WhI8T+dfIERUVnWGp4Z3ey0hL5jVEBcYSiHlPqjaLoCN+wTZq
	 97EHBLtqw18pgOwSM2bUh4I35+oCLso7kdP3ydMAaLpxcWol/ha8SIiqyucw4NXt19LoG
	 /32kMpEXk6jBmZb6oYhUiPCWRqjDdsXTa9czn7iWSFTmZAaNaunNZ42Wg831pspUb1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793117889;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=DPXZ2yO3cU+s5EkiY6YjtMfPdHRJToYSpXviTD5gzv8=;
	b=hab3D7brIj5TzMtiCzV9T/j0dxysLkplpUnD6hkpqXF2Du+fHB/kYei3gMn4kwJ6jOk7
	 EIFhSrsJhYxe087VH90pvNL0FnS3ZKDiB2p3OSn7IAKBpkarUxw+0pjKPJvUDBYMMk39E
	 19NHiesyL7XNUS2+OzAv0R1qN7z2JgfeICDkVY0uJqT97Hl+HF+QtAWY11aEbA3KSG7nV
	 fxJhbbdHeCA0ev04wepYLc86RUuY6A99wwDpwtqhhzIP3hFV2OzkEsGPD9F2Cco6SmISZ
	 IeUSQvxkTI8eh1zmU5Fxys255raJZDeeDsMFhGuMC3y5jLyoz7RFZSFiUa/4OnigvOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O+JlxNbb;
	arc=none smtp.remote-ip=209.85.128.169
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2302606A321
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 16:18:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2302606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O+JlxNbb
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8ae4be9594eso5003707b3.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 09:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117888; x=1793722688; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DPXZ2yO3cU+s5EkiY6YjtMfPdHRJToYSpXviTD5gzv8=;
        b=O+JlxNbbBci8nKYL2Pt4pT1VkmDlJsEd1AdhRhqw9wYVP/lt7TDymN6QDIQOPZVQq3
         HUA/xOfvzFYdfdao/+3O66XnwpitnwgsFXdhICCmraATdxZa4LwGXUdvwwNukG1cLe2L
         5qN5g2BveaYqj6x+IUjtD/oWIa3LZHMZPB3OSKx6SzVBcL5HDu5em3O+ORdHWQ3qqStn
         bIr81WEClQ+YbTAO/hc5rh0iDu4rFJUC6zZclKwpjN2YSRsr8Hcj7dm1GheulqnVJiVd
         7sRV5FMdTBhs48Wh/8Cmp0zYffAFLRWmoEY1HwUDDLAVf7U7NYOpWKNLQjx8xM2ecX1J
         lOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117888; x=1793722688;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DPXZ2yO3cU+s5EkiY6YjtMfPdHRJToYSpXviTD5gzv8=;
        b=Ta2lmCrnXMjrKfQyks4GIdpa51/okzV0bRIrVY9glA49F/jXHKom8uhiqW32GigZc1
         Rq/bscEMeXpxwGwVD1Dpza+qALo70ek00Ov+TzoU1YF9ta4Mzim05i82ziZt7rRlxnMc
         t1mWGm72MSHwx/juFwQ08JbwwPVNRs7tzz8wvBI7XD5Xo0BjbHCWtkJNQJLunM9ImP2D
         +hfx6OO443EWWqwo44giXplGDmxn8XEvKIQgRm50jqd0rMKnE7TVnAoNBS1hdE0MFgMr
         hhsgykncegaiFwzREDtgx3wCYYeIZmm5kEQiS2fX0rIotwIQxS48QAg5AqSMh0+Nr9Vy
         Meww==
X-Gm-Message-State: AFq9FYKYxr02Ump7o4NBYnarkLUW0qYabxsWDKavZAq4J8qKlAYMBK5M
	uud6DCHJkqrJcogQvzeLr+EY8D7bx21miMG+hDt87HjHtO/hwU6VuEB5
X-Gm-Gg: AYBFou35Cyws+DfqRGRlPE+CcwOrKVGY9V7o62Ic8QCJyOmsM4WnJlmKt3d1oOY/IL4
	NwrGj92PemzQBrJj/leHqqFW/JdgTldyNOap3NmVp4ro8mvtk8XX+CFnhFAzEY+TTVWIHXUpTb4
	TBTo2TiecLj/2jx9f06jCEXzWcY+1wj/0pb3u+9oYFMjm6Zq098U0YVMRo1tdngZAGdL4q0axmX
	i8GtwBJoXfsCX6/tVu3aVVdjp0294LSpxiUPAjRWqtwAo8X+2TMG8nvxcYLcSrsVh2BENfs1nmj
	NyBNriCtPY7s23caIXLo5HYdNAMpkcmv9e+FgXLAhu6j3wwVuQSyhgHNH/iYVf4XPx8aQsmVkk7
	Dcl5C/d6HWhMIC0NEBUdRZWIwHKzZh3QozvmTgm3XtmXq+1+tYDVVU2RQelaN4PvzhXgpRVzTkI
	MCXvHz43dpCbSBu7lgUicAI6yyaMOokNcAIXa+3Sf/94C3qXL6KhvycPzjMW9KYY3CWVeBO/Owu
	MXTyOMU7wyOAw1VnzVh9DlbkBuZJnEsl5qsYPaGPZ/kvusZONgoGCHvccoO6HA+bTDQRzJ+J3g5
	u1Axkg9TyELkL6KgSms6wynaMFlmXnE=
X-Received: by 2002:a05:690c:a847:20b0:8b1:a3dd:a6b4 with SMTP id 00721157ae682-8b1a3dda6e1mr20302397b3.4.1793117887797;
        Tue, 27 Oct 2026 09:18:07 -0700 (PDT)
Received: from tacolabs ([2601:6c1:600:2d04:4132:6a2c:2819:9df8])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e656162sm15033077b3.44.2026.10.27.09.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 09:18:07 -0700 (PDT)
From: Reid Downing <skibletz@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Reid Downing <skibletz@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
Date: Tue, 27 Oct 2026 12:17:48 -0400
Message-ID: <20261027161748.2760321-1-skibletz@gmail.com>
X-Mailer: git-send-email 2.53.0
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

bs_blocks and bs_xflags were both read from bstat32->bs_size.
Read each one from its own field instead.

Fixes: e94fc4a43e5c39 ("[XFS] Add compat handlers for swapext ioctl")
Cc: <stable@vger.kernel.org> # v2.6.29
Signed-off-by: Reid Downing <skibletz@gmail.com>
---
v2:
 - Also fix bs_blocks (spotted by Eric Sandeen)

 fs/xfs/xfs_ioctl32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index f6875a2cc70..77bc936bf0d 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -143,8 +143,8 @@ xfs_ioctl32_bstat_copyin(
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
-	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
-	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
+	    get_user(bstat->bs_blocks,	&bstat32->bs_blocks)	||
+	    get_user(bstat->bs_xflags,	&bstat32->bs_xflags)	||
 	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
 	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
 	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
-- 
2.53.0

