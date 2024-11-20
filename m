Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9932633C5
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 10:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732099983; cv=none; b=a7sUBKwtHA7PNqVZ8cuIMNjZYsBnhC7o2qkqSJ8S1Ztvjez1Y6YgIyC0Mp/J2mYiJh6TVKEM+eBmFp+wWqb2EUYp1/dr8fc7iuzSXsCIpC56S8Uqse2PdYgbAYqc19scGj/ukiXtH1vPaJRN4MXlNXUlB8BAmvIvU2Ra0QM2A04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732099983; c=relaxed/simple;
	bh=8ksXJaU+ne3GEuIftEdnIyV7RoTDJdvrqqR0huqRUac=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nP7BAfB+sHZU8O/JR+nR3ZkY6nLbwT2sNDWD4CHRQ9HrzEup0lwhHRFEiROxKFcdALa46nOUaO8fpaT5lYen+sDcbWG/oNAWw5b+qB7srMGYg1/UR9yjaTIMK54iAqhSw4KEVBZfKG+yJXJ+mI3JdKpDaA+7d/OR8udbg72/zZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=gdYsxreZ; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="gdYsxreZ"
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D513F3F32F
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 10:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1732099976;
	bh=PgdrR9n5YgYBLiJUlB4jPUUK+GYx55Z5/ajI9HiscVw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type;
	b=gdYsxreZa9J+fdxWJq3no6OBpVssNn6/8XNGhvgaLqEZFejD4ZNxSdPr+hs9mugUs
	 aqvfxQKPc+lpUc0XB7phCzpMxPukR9vGgeXhiIGia8arSaA+/iSKaYwlKBLDbEY3iv
	 OU6AfLRqX2Uh1kA32ZxKX24jQ3C/YSbuNNTK5Gk8xheeG3bwjicF0CL1c6g0mImFty
	 0CjYDiKE2ACKHoe3b1masXTocBQIJUztB9Sofra/CLJ+agl6W3yZ301aiTqMJKCcT4
	 GWQ5rTgeQprTAD6R+hvuyZXZOKTnPYjkIQfEIYw3CiN3Nb9RYhEePfcSjY1BcMig1d
	 b4p1xinb8jt2A==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a9a2ccb77ceso129698266b.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 02:52:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732099976; x=1732704776;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PgdrR9n5YgYBLiJUlB4jPUUK+GYx55Z5/ajI9HiscVw=;
        b=ODVhfZHXV0fknNRhkGWTJy90ZJZpOfAwVJ6B2o1fft25bZ3jXfG9Itp8YzY/zKHUGA
         aOhLdjxoRKnEJSN2d7cSuu6jof9nYmkepSF2dvOBCgT5ujDjYcpCEy3rIK7/KH64nb/C
         qpr3C8TxVYfMFmu8upYnX9bfPm1ONNzNk97DNRPP0VqeC/SvxFTXuqyIk9Wd0Y80+1iI
         rcYPUSR2OdIw6t61mazg8mbWXoaSKgzwp5snlYCfm0nJd/OiW+NcX0YomXhqlkZoBPlE
         UMoB6+zhDYwv9Q8zn6ujdcCvGKjEKOzyp+EWdjvwLVhS+4CqL33JkMW8exMLsHm2x/he
         TN1w==
X-Gm-Message-State: AOJu0YwThUNSsbCvnm0NBVx/HOBKVBlc0EBe7+Ix0MpIfTxeY9qF2aq2
	fFFWl3atBOaLnkGiOYSQO8vg30VXzgJvd1Tyw/asjzFb+CQuUF5gVXr9znUiMJNQDDTein57dfk
	dPiBS8J2ChZJNuDzBv8UOgvQr5c9IPHdQs+WaXGRXfauxPxEemQioXdEsDYplZZ7a/jL31NCYHZ
	A10IbzxqNFsnEm3+OEBPPx+fs94DqXQwEkvxqMkCJ752gBKKhnEy66voaiRGz3vw==
X-Received: by 2002:a17:907:e8b:b0:aa1:e050:89 with SMTP id a640c23a62f3a-aa4dd57be49mr208768466b.25.1732099975546;
        Wed, 20 Nov 2024 02:52:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSsaPq7nJKGrw8XNO3LhmlZ9rloGV/js207snxmObH+QsbBn+vUyzGvsHaShpv5DeIwfQ4zcdJKAtFu2/+c/A=
X-Received: by 2002:a17:907:e8b:b0:aa1:e050:89 with SMTP id
 a640c23a62f3a-aa4dd57be49mr208766966b.25.1732099975197; Wed, 20 Nov 2024
 02:52:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Robert Malz <robert.malz@canonical.com>
Date: Wed, 20 Nov 2024 11:52:44 +0100
Message-ID: <CADcc-by3uHkgsZBBCH-_xGW2eyRs4A6S6c-4GpvVX2hq42_UbA@mail.gmail.com>
Subject: Potential Null Pointer Dereference in xlog_recover_get_buf_lsn During
 XFS Recovery
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Folks,
I=E2=80=99ve come across a potential null pointer dereference issue in the =
XFS
recovery process. This seems to occur in the xlog_recover_get_buf_lsn
function during the line:
magic32 =3D be32_to_cpu(*(__be32 *)blk);
Here, blk is a pointer to bp->b_addr, which is allocated earlier in
xlog_recover_buf_commit_pass2 during a call to xfs_buf_read. However,
I=E2=80=99ve observed that there is a code path where xfs_buf_read may retu=
rn
success without allocating/assigning bp->b_addr. This could lead to a
null pointer dereference in xlog_recover_get_buf_lsn.

Context
From my analysis, this issue can occur only when buf_f->blf_flags has
the XFS_BLF_INODE_BUF flag set.

Reproduction Details
- I encountered a kernel panic stack trace pointing to this issue
during XFS recovery while booting from an initramfs.
- The root partition was mounted, and recovery was being performed.
- Unfortunately, I haven=E2=80=99t been able to reproduce the issue locally=
,
corrupting the xfs partition while performing inode modifications.

Analysis
Here=E2=80=99s a breakdown of how the issue seems to occur:
    In xlog_recover_buf_commit_pass2, the following condition must be met:
if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
    buf_flags |=3D XBF_UNMAPPED;

During xfs_buf_read, there is a code path which can lead to bp->b_addr
not being allocated:
    xlog_recover_buf_commit_pass2 -> xfs_buf_read -> xfs_buf_read_map
-> xfs_buf_get_map -> xfs_buf_find_insert
    If xfs_buf_find_insert is not called or does not call
xfs_buf_alloc_kmem, allocation of bp->b_addr may not occur.

In _xfs_buf_map_pages, which is called after xfs_buf_find_insert,
following check:
if (bp->b_page_count =3D=3D 1)
can evaluate to false, leading to:
    } else if (flags & XBF_UNMAPPED) {
        bp->b_addr =3D NULL;
    }
    which leaves bp->b_addr as NULL but still returns success (error =3D 0)=
.
    The recovery process proceeds, resulting in the null pointer
dereference in xlog_recover_get_buf_lsn.

Suggested Fix
From my limited understanding of the recovery process, adding a null
check for bp->b_addr in xlog_recover_get_buf_lsn and performing
recover_immediately in such cases might resolve the issue.
if (!bp->b_addr)
    goto recover_immediately;

Request for Feedback
Could you share any feedback, guidance, or comments on this issue? I=E2=80=
=99m
open to suggestions on the best way to address this and would be happy
to provide further details or assist with a patch if needed.

Thanks,
Robert
