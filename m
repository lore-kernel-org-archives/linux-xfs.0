Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3852C026D
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 21:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755812181; cv=none; b=AdhImTMm29GUN682T9YCTpZowvDHETUQJH+QYhnTnaeFkH3XHLrdpy+CDV2uLj9ZJiSNr+qLiHsdHeW4v/T6Y8iLXF4/8bG2/UlgCk3/pQThATJ4bG+X4OVU2apDsf5JT23cKLfYzwcWGTAsAy3J6m9QkYPo3BATYadjHTTVK3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755812181; c=relaxed/simple;
	bh=aiNY+ZTD3J8SFNTG73ygzdE3xlpHDbcZ32iFUva19kI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Fu0tvcqtU+jDMht6lBEnNBslEmr8ev0a5lRI7tifydpIlRncx01SEryrbkrBK1ELMui8g4UysncA2iM23xhnbqU4OoCzbFXESmhHIE/h2I/XJV+LESIdKAMHg2vRNtmdhkbloNhkhuCx8oPSac/wdGzW9JU7mTcOt3qkd7OzPbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b2z+Qhi9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b2z+Qhi9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755812178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1+V6iqvdf26GZ2QBtVStSSy1lweCRThJvVkBRh8q3qs=;
	b=b2z+Qhi9ubdhP967AlxIZoA829GrERAS7cPkWoULEIeatGK9D5bw4cswtjHXDhZYRBO6IZ
	oY7bXBuz9S62Mt1zsuOTyu3+VIgjjn3ia9yItZy2ADnWulHeokLb+MF84pRnWYoYfwDcba
	qb6fzM0JJQ7YnLdzOkPQ2r7f/30lvWM=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-VlNLvGTsNR2ACIb8UpLfig-1; Thu, 21 Aug 2025 17:36:13 -0400
X-MC-Unique: VlNLvGTsNR2ACIb8UpLfig-1
X-Mimecast-MFC-AGG-ID: VlNLvGTsNR2ACIb8UpLfig_1755812173
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-886b468c98cso263167639f.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 14:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755812172; x=1756416972;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1+V6iqvdf26GZ2QBtVStSSy1lweCRThJvVkBRh8q3qs=;
        b=hdOevDFHAgkY+LGaK3wNsKUyIoeYHIDSDBh6yVY3R/GMVFKkgLA5hPFNgkxchGBfD0
         pT7MEYmF/IBfJ4qBDMfXw+ZalFvyVHFTt2sNh+OnSxl74G8IZcWeF9M4wuUzx1FSXivl
         pIGPnqXaQGcj7QW2c+ycKE3qMPFL+0j4KLRop9a06CQDYJnGYFB8Lq73ceVrdVquKcAM
         EJcTEq5KztEqGTmDeyuu/SHbl/MXpgvKAhb8c1Lq7vVRkYR3mvLB7psHCwWn9inuXCZx
         5hd6mX/A56HQc+g2NElowfBk7t0LpxqszylXPol+dFytqlNpr1XYkW7YjEpiKCvmCtKY
         tDEw==
X-Gm-Message-State: AOJu0YyoXNdqnHNLjz4ly4gk7HvYpYuYpZUCAWweDvFhY7LK5eTbCOw3
	41X7eNaNlcUelwDrKLKxiRBp3aRJ42VmQ8Aa189ry/PJy4ZvM3PLQZcZfjFKhyUC3xi8UPpHjga
	Frac3M9UNGrCORpSMQpY3p2YaaWbXYiYeFyqFwdeTX2u1bpfzlNtntf/yMCuTDQRgNv+VZyVk4d
	mwd4O92zOW1YO9igAPDv1VRxDzNe3uofzKjJOdNqukrmhCqOI=
X-Gm-Gg: ASbGnctr1oIPd2t0JMD387awXiLsyujUTIbeYfp93SU0AIINdH5nmwFz6+lvr3Zubw/
	ssISE//5Wu5UtseWOITPHFQa+TlzxAKPM5kXORBIk66amDyYVoKS5TBM8eWEyM5vwrA0sY8UZvA
	FqZxpzgiEfgrmW8zR7UhQAP15D9/tV1m6JWrDsjgSVNFuppiMILa2lbSW+f0grU0Y+msbn/I8js
	xF0EZP9sBcYx7HTjvclznPePWg0K0bOOLZ5Qt0craGZAf0H627qbzM3NIaBxPP4OZHxoqRuAEgI
	ZCzVhZZYWiF/bAGuDn6eCpS+CiF1lVgZyYEARi2tlya+nMoSGjXKBmunoa8jh9Ej+eIUy3iDO0f
	y
X-Received: by 2002:a5d:8d09:0:b0:873:f23:ff5 with SMTP id ca18e2360f4ac-886bd20cc50mr130395239f.12.1755812172658;
        Thu, 21 Aug 2025 14:36:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTXROUU0BOWkIwqW7aq87mNa1x6wTYMofjvoPwPlrk/Jtplx9tFC5q+tecaIxCLJG3XXs57g==
X-Received: by 2002:a5d:8d09:0:b0:873:f23:ff5 with SMTP id ca18e2360f4ac-886bd20cc50mr130391239f.12.1755812172215;
        Thu, 21 Aug 2025 14:36:12 -0700 (PDT)
Received: from [10.0.0.82] (75-168-243-62.mpls.qwest.net. [75.168.243.62])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8843f83eb6dsm796958139f.9.2025.08.21.14.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 14:36:11 -0700 (PDT)
Message-ID: <a896ce2b-1c3b-4298-a90c-c2c0e18de4cb@redhat.com>
Date: Thu, 21 Aug 2025 16:36:10 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: Donald Douwsma <ddouwsma@redhat.com>, Dave Chinner <dchinner@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig
 <hch@infradead.org>, stable@vger.kernel.org
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: do not propagate ENODATA disk errors into xattr code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

ENODATA (aka ENOATTR) has a very specific meaning in the xfs xattr code;
namely, that the requested attribute name could not be found.

However, a medium error from disk may also return ENODATA. At best,
this medium error may escape to userspace as "attribute not found"
when in fact it's an IO (disk) error.

At worst, we may oops in xfs_attr_leaf_get() when we do:

	error = xfs_attr_leaf_hasname(args, &bp);
	if (error == -ENOATTR)  {
		xfs_trans_brelse(args->trans, bp);
		return error;
	}

because an ENODATA/ENOATTR error from disk leaves us with a null bp,
and the xfs_trans_brelse will then null-deref it.

As discussed on the list, we really need to modify the lower level
IO functions to trap all disk errors and ensure that we don't let
unique errors like this leak up into higher xfs functions - many
like this should be remapped to EIO.

However, this patch directly addresses a reported bug in the xattr
code, and should be safe to backport to stable kernels. A larger-scope
patch to handle more unique errors at lower levels can follow later.

(Note, prior to 07120f1abdff we did not oops, but we did return the
wrong error code to userspace.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Cc: <stable@vger.kernel.org> # v5.9+
---

(I get it that sprinkling this around to 3 places might have an ick
factor but I think it's necessary to make a surgical strike on this bug
before we address the general problem.)

Thanks,
-Eric

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index fddb55605e0c..9b54cfb0e13d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -478,6 +478,12 @@ xfs_attr3_leaf_read(
 
 	err = xfs_da_read_buf(tp, dp, bno, 0, bpp, XFS_ATTR_FORK,
 			&xfs_attr3_leaf_buf_ops);
+	/*
+	 * ENODATA from disk implies a disk medium failure; ENODATA for
+	 * xattrs means attribute not found, so disambiguate that here.
+	 */
+	if (err == -ENODATA)
+		err = -EIO;
 	if (err || !(*bpp))
 		return err;
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 4c44ce1c8a64..bff3dc226f81 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -435,6 +435,13 @@ xfs_attr_rmtval_get(
 					0, &bp, &xfs_attr3_rmt_buf_ops);
 			if (xfs_metadata_is_sick(error))
 				xfs_dirattr_mark_sick(args->dp, XFS_ATTR_FORK);
+			/*
+			 * ENODATA from disk implies a disk medium failure;
+			 * ENODATA for xattrs means attribute not found, so
+			 * disambiguate that here.
+			 */
+			if (error == -ENODATA)
+				error = -EIO;
 			if (error)
 				return error;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 17d9e6154f19..723a0643b838 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2833,6 +2833,12 @@ xfs_da_read_buf(
 			&bp, ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_dirattr_mark_sick(dp, whichfork);
+	/*
+	 * ENODATA from disk implies a disk medium failure; ENODATA for
+	 * xattrs means attribute not found, so disambiguate that here.
+	 */
+	if (error == -ENODATA && whichfork == XFS_ATTR_FORK)
+		error = -EIO;
 	if (error)
 		goto out_free;
 

