Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0B81CF96
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479245; cv=none; b=OnZcQl9S2mErq63ZLbmBuOU2rV29c8zodDfiIVOhvkdQRhTTRds4/9IkTdihAK2tv4fz465Xae22MaDLN4HBTfSUXigiANFwml1KjT0bDi1CqrDtWgUcdKl9gw5pg1g4Mvn18YjuHreNIpIQoNRw43ONrmaIhwTSnNPk2QNfyis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479245; c=relaxed/simple;
	bh=HcN4R1z46584pw7lQoyqCdW2kElMRPDCVeQWwM9oex8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BOoqe57QkrHKF83owTLhX8iSaQFlozq7/7rh5BPcrNr08uj6+Hv/EroAkCMg3mslkzozSVmfKdh5TxWLNCvyh5ofz0eftgvhq2P948h/X+2ssoX/ikTIlAfDnaYM80QUAv/8k50yiItBOVcXTRis9bL4hesUdVpqKAahNsaOrdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=beN7+zk0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="beN7+zk0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=q9tGd0SKlLt0O9AuIy2QZpxCgBcM/zMzZwKyIQXRCoY=;
	b=beN7+zk0EFY++ZlOrnQULHhyvMOqlvJU3Z91NtLa4qdddH1TIYD4Sn/JHxbzgishs8z6bM
	xc3mewrkth19BxCnb7idserp8IaOh24xOHFiE4JOnNMw+CpdnFN1Rg9zZWnPKhh3lRokUm
	UrllNGa+PtpyApZ3sOaLV2ORSvJWhEk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-DU5hJlPmMGGGrky5O0_ZYA-1; Sun, 29 Dec 2024 08:34:01 -0500
X-MC-Unique: DU5hJlPmMGGGrky5O0_ZYA-1
X-Mimecast-MFC-AGG-ID: DU5hJlPmMGGGrky5O0_ZYA
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa67f03ca86so614822666b.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:34:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479239; x=1736084039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q9tGd0SKlLt0O9AuIy2QZpxCgBcM/zMzZwKyIQXRCoY=;
        b=j19Lb5SSfjbggI+8E82YZUNTIWmX9Vu1+1h9pZ1kxjbnajxPb7xI1iGIptAfDJR3dC
         YhlT3ebGyjvTIshTjAkm6XYuEjQzPBaqw75d9Q9mifppnX/0/kq241qhLYe0SpYBskge
         GEEk7jOZOLRiK8VUoZ0oc52KEyjF3lbx2sSDdhZyZrAwrmA/oONiJ/RGD6PAtDVHVRWD
         KXPzhZErKKR3W13XUcp45mUKTDn1sGJmBAKsbo7fV0meTi3/sPaYM4F/i1/baDTNAxGc
         ph9fzcyRvfpd687omMITM7j/9K/l2vN3zgzRgO0QAjw/4O836rNV2qHigPpMZj8fQvbw
         MnMg==
X-Gm-Message-State: AOJu0Ywlw8UIq1d0Psm9uBDuMsWUVdQSkPQzPE/nvAkpnwTK0+b52v0Y
	4YHsi9LbPsAYyBl85gj14x/iOCGpnsXeDfvapl04JlVGsN8ELmIZR7A9cPKtHr38UwyH8XH2uEG
	eYCVvHICDlIzeVEEvAL57uZdFmeU2OD1W6N/YiYH0KT/s2aHG7twfnePfyrL8NzSM9Ywx8tpo/3
	NhaZV8x/otwVW7HVrxcsJ0wAHD6vQbW0kyShw4Io6E
X-Gm-Gg: ASbGncsSg8s9eiYhtQachKBrx0LVVX4jF5KLxqPao07pO28YFgrw0iHr+IIx0QT3yrS
	TtUKk6JGEE59HB0kqInAqa1Vnj/fOZV+iuj7QTHldkrm+KxlDWYQXsUehJZuRzFM2+6h2YGeYxX
	bFNlD8YVGuZ2GaDRZaaU+tB+J8GFXRiPmkeeCduRcWfA+mn1yVXM8/A7WPg/OJiJW/2UhZe3Esy
	f6kmQ0E/tV4lGglRRhB34eMSN0ewY14JQx1/UKCNk0+FDQhRiB3Vx+6EWLIPt4EtrgJ4HycwDDz
	3KuEsBMSaGALeHA=
X-Received: by 2002:a05:6402:270d:b0:5d0:fb56:3f with SMTP id 4fb4d7f45d1cf-5d81dd9cdf0mr72012948a12.12.1735479239608;
        Sun, 29 Dec 2024 05:33:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1TUlV/6TQLhOi7E/NbMhSnqc9O9sKn4GiKfkPHz1NboY8yKdnGqEOmoVRqrrQZy1aYD2+9g==
X-Received: by 2002:a05:6402:270d:b0:5d0:fb56:3f with SMTP id 4fb4d7f45d1cf-5d81dd9cdf0mr72012896a12.12.1735479239253;
        Sun, 29 Dec 2024 05:33:59 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d806fedb05sm13814046a12.68.2024.12.29.05.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:33:58 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [RFC] Directly mapped xattr data & fs-verity
Date: Sun, 29 Dec 2024 14:33:50 +0100
Message-ID: <20241229133350.1192387-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is a bit different version of fsverity for XFS from one Darrick sent last
time.

This is mostly a half-baked prototype, sending this out to get
feedback/suggesting/discuss on a design. If you think this approach would be
fine and I can go further with polishing it.

I haven't done anything to repair/scrub yet, haven't tested how old xattr leaf
would work with this changes, and fsverity doesn't work with block size != page
size yet...

The reasoning for iomap interface is that it could possibly be used for other
page cache related processing like fscrypt, compression. Cutting a few more
regions for those.

The attributes design is well described in design doc.

This patchset consists of four parts:
1. Design document which describes directly mappped xattr data (dxattr) and how
   fsverity uses it
2. Patchset with iomap_read_region()/iomap_write_region() interface to write
   beyond EOF
3. Patchset implementing dxattr interface
4. Patchset implementing fsverity using dxattr. Using a xattr per merkle tree
   block, not using da tree address space.

Thanks
Andrey

-- 
2.47.0

