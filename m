Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299AF27F732
	for <linux-xfs@vger.kernel.org>; Fri, 22 Aug 2025 17:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755885364; cv=none; b=Iq0J+2qkakxiQknqjB2lmSTUbKlivc6/RGQ+jbaz78IL7yRq8OSgiCzx0TrDtkwtSMxFQi7bNt7Ju5UU2bqZbQ8YDf/p3Uipe4mDKKOQ/bX1IlG9pDY08Lyex7KGhIjHUBPrPts3ElQ3HK+jyE8qqRZjar5lCkNGwNeX1kHWFMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755885364; c=relaxed/simple;
	bh=xQ+zVOciUe9esHEkfPFHQqVaOS4MGWLxMv83onPRSEg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=mzlkhWAJiDOmCoG2oFhu5BoT7siGLxvqw6ArT29bIvG3VJMPg3iG19tt2cbjrbYCDX83EyX7S8yJTxUZYByh1igHHLXcVMmPSIFEGvVD67xtFHiGn5lMOxP68l1hBLHfTnpdA7uNAJ+B3IeAUZqw/ZPkT++asl14obXAGd1lvhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RZbHBmGh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RZbHBmGh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755885361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2C9uMmDzJgvIqVnkRpI+9UCzK4E2EO+0JQESM7awR7Y=;
	b=RZbHBmGhImvAvH7FTckLqFvpOB91mloGaeinQIAqDBPEps+JGrDhka9b8amxJtqsYm9i7Y
	n/tmk/0R3x7ONv5j/yoLpNv+x9cfAd6sk/Og4THRtz6TSrgVaV6MrShoyFEMIV0TjtnZoo
	fS3+UqKArezZF2dcelNF5sTexmJFRjY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-mRmVnM_cMDGyo7fBRTmQTw-1; Fri, 22 Aug 2025 13:55:59 -0400
X-MC-Unique: mRmVnM_cMDGyo7fBRTmQTw-1
X-Mimecast-MFC-AGG-ID: mRmVnM_cMDGyo7fBRTmQTw_1755885359
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-88432e62b4aso576932039f.3
        for <linux-xfs@vger.kernel.org>; Fri, 22 Aug 2025 10:55:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755885358; x=1756490158;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2C9uMmDzJgvIqVnkRpI+9UCzK4E2EO+0JQESM7awR7Y=;
        b=GDXlNb9FYwq2tck+DrbQfXdM+ieK1N4unkFwudV3boDbEozBa0GIHfg0Ab1aN3j+q0
         jpm+xCXmw3auI/oq4BuLDlByX1MTyLKNvtOON7sk7zNrX3taTA/Oy8TuusSVKyOF46X3
         BIxWWzwXdx9ScUu+/kgqO4Pm+XT3aGP2gdGxAHonsMaY1xchYL8mdnV5RTvce5MaC3UO
         0nOhO3CFpZpEScJS5BTU6793Vx0V5/gTkgTfROIC/RiCJwwAiLcOL0jMYSdQZlW2nmPi
         AHYIw+QBR3X8OYpeYJ3N8/ygeaQejh0GXbechR9d14vL3F1CtniMrbfVawaVjlno5mPs
         5G4A==
X-Gm-Message-State: AOJu0Yz7UZS/bpz2FC7cJxyxbS/asZmSyPOqB4Fbg9WsUtSPFE1PzL+u
	46VNXixfrRwcCrG4WNsDfqUV5N6CFSMe3oDqrVimTZFgHfNFITuDLyEVQej4C5wYRN2jW+x3GZV
	Y20R/T6bnKNYL0IN6bQZKYWyRXPwYheXtEOES2vsFGEmTYnAYP4yiinUownZaH6FvWx29rvm0oz
	TL5REPoTwNMf9ImN+nSNfE98j1kUYctdQ770/TFMGXg6FZGcc=
X-Gm-Gg: ASbGncsiOEShGBIDe6aKIlKiGwFypquuxBhHSK+G/6L5dDTWm3W45sV2TPwCINyFbRn
	qxF9W1wzoLwR5/vrmiuNo1PZ/26ij8dO0eQdQBrjS/ZJ3Kxm4XOEZxhCMXB7fW8DDZBCs5VHNbV
	m3RuvumnGlkzvAzL0XMOejGUcjS4Hth8rgGBBpGz5JL/smqjOF830qddNpKB02a/i4kdPUqrgF0
	Ihi+Xc93/1th1WOf3u/Cl0q+88mh3IDlBCfrMRwMOxgp7L9Fu0nrShm2e7oEpxnWCw6Ts5O3/uH
	hpCgnXlEUn9XE4qEW0hK5dQ7pP7h3XL1xJSS0IZ9vQ9mqtbwqiMloDT2qAprAJFw0rEkEb3u4gU
	+
X-Received: by 2002:a05:6e02:1a02:b0:3e5:50a5:a7ef with SMTP id e9e14a558f8ab-3e921a5d65emr63056345ab.15.1755885358620;
        Fri, 22 Aug 2025 10:55:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG99RzF6KCqfmUFjX3cBBUX7QwUbXxiwJZ9DeMwhOkE+Oq4K7yuee4+FqmL1gWqJYt+egCtJg==
X-Received: by 2002:a05:6e02:1a02:b0:3e5:50a5:a7ef with SMTP id e9e14a558f8ab-3e921a5d65emr63055755ab.15.1755885357953;
        Fri, 22 Aug 2025 10:55:57 -0700 (PDT)
Received: from [10.0.0.82] (75-168-243-62.mpls.qwest.net. [75.168.243.62])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ea4ec1f7d2sm3425805ab.42.2025.08.22.10.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 10:55:57 -0700 (PDT)
Message-ID: <06c9617f-a753-40f3-a632-ab08fe0c4d4d@redhat.com>
Date: Fri, 22 Aug 2025 12:55:56 -0500
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
Subject: [PATCH V2] xfs: do not propagate ENODATA disk errors into xattr code
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

V2: Remove the extraneous trap point as pointed out by djwong, oops.

(I get it that sprinkling this around in 2 places might have an ick
factor but I think it's necessary to make a surgical strike on this bug
before we address the general problem.)

Thanks,
-Eric


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
 


