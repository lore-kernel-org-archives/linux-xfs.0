Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3CD19AA5D
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727444642; cv=none; b=oFqu1iDLf0R2Ds9ubpzIUTrk0K+8tFUdpGsYqq5tOdcU8eDZe08Pp9axN+AqSxtb4KM01UEd/ssErGzHxYRX2d3VXW5x9arq4Q6psKsXOWouY3+qmRQ7CGhZSHbOwwqWmec+hhRd6k91ruhTHRLVyJ0KrUXvd1R+XncQnr6UaU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727444642; c=relaxed/simple;
	bh=QxRR9fAsY3W2vJOY/KaoeJXVqb+ZuekOUjVzdnP9Qv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rv2n/533ULsiSUTXeBMHz68KkDXYuS2vKMkfGyGAPl0az0QTL1VECK2ywc2s31wRWxujFoJeanczaNtMstqIRM1j/RjPq4O8DgQ4GAXl7lKh9lcYUJAzNK3AaPdvbIbhtd8c0xb1ZUOJGnxIOKHxUNMEo4joeZauvZPVd7OltDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ni5C+m7L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ni5C+m7L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727444639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oTagCMb5yLa0eGeaGV2N4BJRJWXhxVrMVHHIrF/7I2U=;
	b=Ni5C+m7LDfp1hvwMa/KDrCGce3aoJmqf9Yvbk/cYJDYOtOsZFrZV7uB3wBVPaIY0NDWdup
	JaPSsOwMUg0gRFNFQDeDlDbf4h+KbHCJDqIyqez0ZmOi2lchgJnoNwuGZ12dW2wHdZS17t
	3KlwLByxraBSjr5SIqJwQrlaPm4/TqM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-vKEQJCwNOOCMoa85EIz0DA-1; Fri, 27 Sep 2024 09:43:58 -0400
X-MC-Unique: vKEQJCwNOOCMoa85EIz0DA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37cc4f28e88so1338627f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 06:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727444637; x=1728049437;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oTagCMb5yLa0eGeaGV2N4BJRJWXhxVrMVHHIrF/7I2U=;
        b=xSlEwOTTm/znXQ5WJ4d88ujx0opeEXFICSFemadkspn0D8gyQyUaSJy4NXMWE4SwC5
         c4oyloeHrfOHJOxmQHO4ALfQ8MWqvESKzrj8ee+K9EECC6ROjh0LRD1K0RDxx+NDwnEo
         gF7idVSM2UL3D3a3576xkymzIAvkkMVBLNGk39hkIgbY/GkGWhPO0+Baw0ivEYaSKYuY
         2jTnlJZUtbxN9dkwFx6dRu30BaIuQGckDWWnU7+KCe1ndO3h0sWWtdxz1EaZvWma9r9j
         DhoP08ys/r81+4NlPoaiUrsBND6drRJVxDRqkqgvls0ibLU8rBz1zXITO3/AiUcAwlg6
         F0bQ==
X-Gm-Message-State: AOJu0YxVuvBig3X2UW3Qohpir3zE2FvmTZPTEfAzeexbk1e5BpUoUpUU
	6wcmU5v9mmCGF0Di0+pfULONrAMTRHVsBeBJI4XfUj8lRwI0fHiHYk93csZggmhrVCf4lVPV0Ja
	CJdmootvv6dZYo+4SiMGl8IK9Kl0E1oZMioSwtW1SD3TLuil5F+/CUdxdbAdXM0wVJB4RHzjgCP
	U1K6zpT7rQR49W2kffT32oQKSiu4/qCogEwqdhcfFe
X-Received: by 2002:adf:8b1b:0:b0:374:ba2b:4d1c with SMTP id ffacd0b85a97d-37cd5aa684emr2777928f8f.31.1727444636965;
        Fri, 27 Sep 2024 06:43:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIUC4wDZS1Rtc/fv1vmU0IRb2TBjLsA9bWQbDS1E7dJavSVCo0vTjNQc44caz5hZZDbivjvA==
X-Received: by 2002:adf:8b1b:0:b0:374:ba2b:4d1c with SMTP id ffacd0b85a97d-37cd5aa684emr2777906f8f.31.1727444636627;
        Fri, 27 Sep 2024 06:43:56 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd565dd86sm2572660f8f.27.2024.09.27.06.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 06:43:56 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 0/2] Minor fixes for xfsprogs
Date: Fri, 27 Sep 2024 15:41:41 +0200
Message-ID: <20240927134142.200642-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.44.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

These two patches are fix for building xfsprogs in immutable distros
and update to .gitignore.

Andrey Albershteyn (2):
  xfsprogs: fix permissions on files installed by libtoolize
  xfsprogs: update gitignore

 .gitignore | 12 ++++++++++++
 Makefile   |  2 ++
 2 files changed, 14 insertions(+)

-- 
2.44.1

