Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899171531C8
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479418; cv=none; b=RXNRJcnQbNBS5MmXaQvS6uJJecQRLjdcCwS53La4BLSNl4yUkjvE2ZrhjeLc/k7c/t7WMXX69Z2pY86NT3VeYGb5x9/+I1M3jg69BlkyXt9BY1FBRy9XBVlFWQOqOTFD8Qm10+qFFLvxFGnYZcunfcf2kHvfK+S17NNhskT+Mbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479418; c=relaxed/simple;
	bh=PbonLM2adnzTG/Rdf4IaShWh14yHvGGG78zhicipViw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQa5By6Eo6fn5wH+k76a208/YsDERu/H/u7FdKAK7BtiS0r+4Lot9+Gz7ePXtF7La3LOd3frlWLFaeNiVERgVqMo7A9UHHSdvmo5RlBhi7Fo7KKK0QNReTha4hLa+CB4FvB6lA9CGpIJhH/f7ao+4j85B1E3K6Sd6ap2XMG1Om8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iXdKk4Vf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iXdKk4Vf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UbgYcdFGkBaHiSXxE60QpSANgll6OdXCYAK1FS8RVVo=;
	b=iXdKk4VfVpSoOIYnxfJBbwqdnw1hWau+WnNJRunCBH35EgczkEAgMpRlmMftuOEL5x4Uic
	KFQQzX1z1+luACfxuewJgE2GYxtru4e/4jc9vxtw1HfE09Opc6G4uXLH8nEybwY9Fzaq0Y
	N/HP0kHZLpjjs0pvBHU9+fywOgnkiD0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-LL5K_osjNzKU8e_8vkpI9g-1; Sun, 29 Dec 2024 08:36:54 -0500
X-MC-Unique: LL5K_osjNzKU8e_8vkpI9g-1
X-Mimecast-MFC-AGG-ID: LL5K_osjNzKU8e_8vkpI9g
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5d401852efcso2092868a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:36:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479412; x=1736084212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UbgYcdFGkBaHiSXxE60QpSANgll6OdXCYAK1FS8RVVo=;
        b=qiTj7aBV8e/c/1zK1zlHzmyZkj+9r7xhrVleLIu31eY30NRLX/Qme+TzMJ2unIKD66
         RPHmQzo8dqXhPotH9Yhjx9VEVJJFjoOVuCSjumhHVyENP2duNqQJK0Ld8qPfiejy863a
         aImzlP37Vh1hM0e1UhMvaoD3MULPs5GDiwTyztC8ycBbmEbC/7pu6XK2XIUEENncOSTg
         6L8V1RnLu6+l16pU2hwqYDX7VUPCMNBRGIxgoebCcjD2o/oCH9msFO+V4bGcPCpNFK2O
         0jMyInhig7um2tuJxA5ovhOB8vMBzXN4urOf9emSCZdw3gLsDxPkzYbC4jRyxE+Bi2Co
         nlyA==
X-Gm-Message-State: AOJu0YxXWUxjt8eF1hnF037yESRy77zO8ptJ09GnhkG8OmvnvqQdq7Cs
	Z1D6HjKy6HYDCYQ5iaB8LE72ntYSozMX+qHFbBXL3fEwZe2zX9hTOziumRvj5EDSIHfbzAXIRvO
	kjixex28z9IhQgtxfMmdATJy1Pjn2NQsoM8cl1/w5BJFj7bxEsr+vxatc5j5DLM1pc+A/8Y3TW0
	3daTD4cc/khGVyZPggcRUx0fHmg50ENOWnaD4dLzxV
X-Gm-Gg: ASbGnctBNZZfj0cp9YAZli3GJu5i1BPZ6+WCxjoOMemH4TzOQKSjGHVVgI3GIk471Zn
	vx5l6BxSN3MZW8e0GtNC1IisoNe2H1UqU/cacvQC1/vymf1gM/JIUwKTSWTxcPvELh17RGDh0pF
	+/aPuWeE2A3q0aqJftvKiTsxDbfkaVmBBqMC1kDSPBIE8DBLRoVbcVgmjnc2SSe+GIqi/MLTDP2
	LoYltNsHtxcBvpYc89JLksap9c9oj/sz+PCAUweD5UAxR5izhUjRN9pn9ol7jH84TKdQDinraRm
	cBa88kpGrP3JtP0=
X-Received: by 2002:a05:6402:400e:b0:5d3:cdb3:a66 with SMTP id 4fb4d7f45d1cf-5d81ddb0fb5mr33419420a12.18.1735479412224;
        Sun, 29 Dec 2024 05:36:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHqr2PAXwt62WK9g6QRoEKAdK/Cu29iqOqWcjC4997TtNDuVjUu8gIgnsuOaAIUGBSMsi0BdA==
X-Received: by 2002:a05:6402:400e:b0:5d3:cdb3:a66 with SMTP id 4fb4d7f45d1cf-5d81ddb0fb5mr33419390a12.18.1735479411818;
        Sun, 29 Dec 2024 05:36:51 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d806fedbc5sm13839735a12.60.2024.12.29.05.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:36:51 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 0/2] Introduce iomap interface to work with regions beyond EOF
Date: Sun, 29 Dec 2024 14:36:38 +0100
Message-ID: <20241229133640.1193578-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133350.1192387-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iomap_read/write interface without EOF bound.

--
Andrey

Andrey Albershteyn (2):
  iomap: add iomap_writepages_unbound() to write beyond EOF
  iomap: introduce iomap_read/write_region interface

 fs/iomap/buffered-io.c | 158 +++++++++++++++++++++++++++++++++++++----
 include/linux/iomap.h  |  17 +++++
 2 files changed, 161 insertions(+), 14 deletions(-)

-- 
2.47.0

