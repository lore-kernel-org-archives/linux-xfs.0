Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB941E376C
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 20:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755548529; cv=none; b=IOS68KhElx/3P/+KPhb9yEm+G/9cL3m+bKkDYNokNnvXsVloCGctopXf0xb909F4t90DGkjwDAByZhKMkZp1X+Ut8RrjEN0LnOXApPzpbqGnbMcfhHY6tz2rftgo30Jcfm/SgcHmdC2c0YCVl0N3efYSVQjaY+Nvqbio0kGc2I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755548529; c=relaxed/simple;
	bh=G/eJYmelY0vZEdum0MW+pn4uh8ljJYe83EEAoxtl0UQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=ciZZBfcf2za7VrDufYBizgn3tkS8/HuvV1TNNRm71Jy4O0S3sLth37fXTkQ4CBo0CMV1zE9iZj9OVs71bHmvlmyxitKHALoZN2M4jRN0ftCNgcIlgbTUlz7M7kEZwDApoK2ARzcbJn/F2Mj3ZHjnZx/rbwM+PPJyFOjiEGE/5lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NQFb6Y2c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NQFb6Y2c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755548526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TwfAlAx0rfuOoywD0FUXmybSnW42YvRfdKMs995DazE=;
	b=NQFb6Y2cQCgIy+Mca1GJCw/IJqtDgJ4/7ehvcI/W6PL0ILm5BEV5kdK+ZtolvnKjWEhHRc
	l81aLLS0IrlaBWNNEdJ7zP8YU4jsTtMjlJoybUDUfrtzZsg7uXiBCeKb5e9B/4bdMZHQIL
	Io2ma8lFIBAjolRbF/CnkwV84qhG3ig=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-fOSKke-tPuSLT9moWr41Yw-1; Mon, 18 Aug 2025 16:22:05 -0400
X-MC-Unique: fOSKke-tPuSLT9moWr41Yw-1
X-Mimecast-MFC-AGG-ID: fOSKke-tPuSLT9moWr41Yw_1755548524
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e671c9ebc5so9028895ab.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 13:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755548524; x=1756153324;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TwfAlAx0rfuOoywD0FUXmybSnW42YvRfdKMs995DazE=;
        b=t2m14+japg7L7WJxSp0zw6blXrBHkNGfVvmq2QuG04h7HTo3S/yXT66c+jDtJPJsbi
         ul+uu3ffcFn48Uwp4N0rjVSyjgRCf1lQhTrtPjY4t5zYAF079GeDTkjlaNjCcFzd+Grk
         uDfOfL0qxa5kTOA4yQBJ0NgTcHZ+Z2Lu/5xBaWWxsjOZ+I2Bb6m7y7eTYXI3QpzRV31S
         XmgSty2pHknwePjsD0Wke+TIJF111t0Iq04tnM5PlWp+O3l2zmI88eU6327WlZtgmUPu
         47oeDWiYoqVAKUSBCbYlBUK5v4WORQoeXhxlFUbC0IqlgNZXRaJf3cPjro8t6A4ALlpu
         UwvA==
X-Gm-Message-State: AOJu0YwDx5xbWyN9xZEtfr3grOiAIamX0iO46EQX5ITbXDYR47a30Iv+
	KEe1MdYleEo5S5m71T8dLkuKYdJevuTIaPTPD1MXn3ljDLOBlx+5EvHnXskSLJ8b9FLobru0U7t
	IgUuDB86vjaO1gGylR/RUSrfugi8QFGPmTExd3ieE3IYB7jTpM+ApbqTGIZyAV3/k9T9g+EE5Hf
	wRKgaJvWFaHVBHPm2rziyUch/i6W0rXWgDL5473T+oryV55sQ=
X-Gm-Gg: ASbGncsIvJBnd/NWKlFhQzV+MDARMX70XSWhH4jnmRDTXU92fWtgwohh1WJC1iZnwXE
	GcreU8oMXZ4VhCOAo2pKDBIqQh8Wh5eJLfsxY+VfzIIMO2TRDo9hq7XxJzqcd9Jk8IgOlbchnQd
	AS3gQjtTESwSld/k8AO2SuCKGEliMUmYzXt6Dv8kIUO2p4xmRjPedz/GlVgGBlrmlryQu0Y3oyq
	aKfiqWviSbN6Efoz90kc+Jh4IVjVW0PlaOPYKkptexqPRP2y/FQCkSIIrnr5vT3DWGEGJN0JyIV
	zDW9uBKFGAlmPJOF8Sm+cPYUiBKOTKcvGahHbeS3PdW8jDX+7Ka2IOP/Eagz1owzyDH0BMo37/A
	B
X-Received: by 2002:a05:6e02:3c89:b0:3e5:6a6d:dd38 with SMTP id e9e14a558f8ab-3e67661bee1mr1490025ab.11.1755548524047;
        Mon, 18 Aug 2025 13:22:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdQ8UlE/kQlj5HpXukmG6z4uqxSVU/12SzpQ66PX185CTo33Z5vRWujVvuO9MNz9j9juLCrA==
X-Received: by 2002:a05:6e02:3c89:b0:3e5:6a6d:dd38 with SMTP id e9e14a558f8ab-3e67661bee1mr1489485ab.11.1755548523487;
        Mon, 18 Aug 2025 13:22:03 -0700 (PDT)
Received: from [10.0.0.82] (75-168-243-62.mpls.qwest.net. [75.168.243.62])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e67a3cbsm37692435ab.29.2025.08.18.13.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 13:22:03 -0700 (PDT)
Message-ID: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
Date: Mon, 18 Aug 2025 15:22:02 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Cc: Donald Douwsma <ddouwsma@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

We had a report that a failing scsi disk was oopsing XFS when an xattr
read encountered a media error. This is because the media error returned
-ENODATA, which we map in xattr code to -ENOATTR and treat specially.

In this particular case, it looked like:

xfs_attr_leaf_get()
	error = xfs_attr_leaf_hasname(args, &bp);
	// here bp is NULL, error == -ENODATA from disk failure
	// but we define ENOATTR as ENODATA, so ...
	if (error == -ENOATTR)  {
		// whoops, surprise! bp is NULL, OOPS here
		xfs_trans_brelse(args->trans, bp);
		return error;
	} ...

To avoid whack-a-mole "test for null bp" or "which -ENODATA do we really
mean in this function?" throughout the xattr code, my first thought is
that we should simply map -ENODATA in lower level read functions back to
-EIO, which is unambiguous, even if we lose the nuance of the underlying
error code. (The block device probably already squawked.) Thoughts?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f9ef3b2a332a..6ba57ccaa25f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -747,6 +747,9 @@ xfs_buf_read_map(
 		/* bad CRC means corrupted metadata */
 		if (error == -EFSBADCRC)
 			error = -EFSCORRUPTED;
+		/* ENODATA == ENOATTR which confuses xattr layers */
+		if (error == -ENODATA)
+			error = -EIO;
 		return error;
 	}
 

