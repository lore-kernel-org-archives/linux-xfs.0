Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6C66AB80
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 19:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Foy5J4qh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702582093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rl5/QKFiTbeqk+UwqYW9Uj9qkXuMtMguimh5cqMBUWE=;
	b=Foy5J4qhEDFz/BZ8D62l1NNnKqN0QPjNHzXlGElPrTTi1DLwBL0sb23CQ9v0bC5ERi3T4k
	+lF8GXNfrenUIP6yZpTw1WFoFYRMm2EQJPBgXgX/uRFjFoMv75R5MWgE09tefxJ189OmHw
	d+O/LLw0//TbOS/OA4VbCqKCI2Gc7Z8=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-1NaQ0W6-NaSeT3DN1YLFkA-1; Thu, 14 Dec 2023 14:28:12 -0500
X-MC-Unique: 1NaQ0W6-NaSeT3DN1YLFkA-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7b705896cb2so784618739f.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 11:28:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702582091; x=1703186891;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rl5/QKFiTbeqk+UwqYW9Uj9qkXuMtMguimh5cqMBUWE=;
        b=n/YSS0Rv/Uqoi75bN8YURZFBmoHOx0825ZtgXnvxgWEwFRl3GmZBxzQoRaoZQnpuDj
         uNmn0pwwj4kkJXp0dpReh6dxY0Xhi8xdxM5nWumIcemqaBFCvXjGjmoSUtMlbFqBgz0Y
         nr8yArJ6AvSF5H0X4skdMrjQyon/siV6VEAp3kTQfV/GOb5DUnl7RH9ERtG52or1Qw7X
         GmuuIZBZNkkBtF7MM5lsximDTUkiDwqHj9txJEhxSwar6pNXTn6E0aMqEH06IqkSk3QF
         8DfBCIwA57vo92FmLOhWWxcstqa0hZfgsS6tUUA/J2T5fXPACivrKogNVayepUxvFOJ7
         NwsA==
X-Gm-Message-State: AOJu0YxwYW8J0+ehCICv0J3Jt9DA7QTW3hufegJ4aM/BxrB2DUkzU0BZ
	n96N84lV4rYZsHM3litRmF8OxCpl0y91jx+Ew7n7ivpKombb4T7nn3ZjTd42m06bndo8w0K0cs0
	G5v4ebNNzC2BEwIxvesrQrtewXi3Cj+2JcTu6epzaj7L5tztaIRa5Igf9ELEkdS6xhZCEjM2Uir
	iXXqA=
X-Received: by 2002:a05:6e02:180b:b0:35f:754d:fed3 with SMTP id a11-20020a056e02180b00b0035f754dfed3mr3504825ilv.18.1702582090766;
        Thu, 14 Dec 2023 11:28:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYRxTWlno53ekVYT4nWu6WYJuCUm8py1kSdMfVwAYQosg0Y+zMXIcVoNxbBlFFgRynZgkQRw==
X-Received: by 2002:a05:6e02:180b:b0:35f:754d:fed3 with SMTP id a11-20020a056e02180b00b0035f754dfed3mr3504817ilv.18.1702582090359;
        Thu, 14 Dec 2023 11:28:10 -0800 (PST)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id db10-20020a056e023d0a00b0035af0c79e23sm393180ilb.40.2023.12.14.11.28.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Dec 2023 11:28:09 -0800 (PST)
Message-ID: <a6a7bfa4-a7bb-4103-9887-63c69356d187@redhat.com>
Date: Thu, 14 Dec 2023 13:28:08 -0600
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
Subject: [PATCH] xfs: short circuit xfs_growfs_data_private() if delta is zero
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Although xfs_growfs_data() doesn't call xfs_growfs_data_private()
if in->newblocks == mp->m_sb.sb_dblocks, xfs_growfs_data_private()
further massages the new block count so that we don't i.e. try
to create a too-small new AG.

This may lead to a delta of "0" in xfs_growfs_data_private(), so
we end up in the shrink case and emit the EXPERIMENTAL warning
even if we're not changing anything at all.

Fix this by returning straightaway if the block delta is zero.

(nb: in older kernels, the result of entering the shrink case
with delta == 0 may actually let an -ENOSPC escape to userspace,
which is confusing for users.)

Fixes: fb2fc1720185 ("xfs: support shrinking unused space in the last AG")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7cb75cb6b8e9..80811d16dde0 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -134,6 +134,10 @@ xfs_growfs_data_private(
 	if (delta < 0 && nagcount < 2)
 		return -EINVAL;

+	/* No work to do */
+	if (delta == 0)
+		return 0;
+
 	oagcount = mp->m_sb.sb_agcount;
 	/* allocate the new per-ag structures */
 	if (nagcount > oagcount) {

