Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2809A37A848
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 09:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142130; cv=none; b=nxVsSldACDsPEjXditDMyNkx5IfK2h9AjP4q5UnN3QGZI/PZ4Xe4Ks9n9qLR3IetgNspPaAxXEMBgLzd3y7INNavFt9GhShRBB64udDEZO0SgqjDgTH9kE1r96cc/V8CszHBx6upa1RATdhb8XNegxWY8GeIqZVmkjVCFU/Wtiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142130; c=relaxed/simple;
	bh=ffkoKDIdGGE56y/QSI0VYZgfQlzr+u0AHAsPiTaWUvM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QGgcT3Eqg9SWzqlGWRp96RAlz0tjk5H40eANVZyjLoWz4lUIloqlNMXsB5Mx5K/rpJqS5T3g1S8B2OWiXuSTH5OAc7z8GVYIw2lNKOi2XfUHnGNiyyQOI1j95KsuakadEcesNizKu/v8vgXiDaOjh6+In8FNgdD/tHc0VKzeCLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K+wvjPaX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dqbmSh+M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+wvjPaX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dqbmSh+M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792142128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cGD28N5eS0nZxh81/Vm4e61Bi2VqoNQPqUMCznEkaro=;
	b=K+wvjPaXO1txTtWyJRx4gw1N5WxGg+nMaQiEThMSFQ0HyuU3VIt8LGuYv8POdX+bkIWq5x
	ypgp9mBZ9ZoTa/vqdFgg/BFSpikzbg47VyrQ1qPJo+bVlB2LgrI+9Bk6UMSkaeK9fxCWPB
	lLSXyI/FMFru5Fh0kgBldm2FagOzpvs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-6SM7043nPD2u4vpr4GU7PA-1; Fri, 16 Oct 2026 09:15:26 +0000
X-MC-Unique: 6SM7043nPD2u4vpr4GU7PA-1
X-Mimecast-MFC-AGG-ID: 6SM7043nPD2u4vpr4GU7PA_1792142126
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a022fee32fso47612495e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 02:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792142125; x=1792746925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cGD28N5eS0nZxh81/Vm4e61Bi2VqoNQPqUMCznEkaro=;
        b=dqbmSh+M/thKkGxyV3wHhYBHoAvXx8S2ZbGHGETxnMyEDnRrYoPLBbH/thOauGcD5/
         h4Z745q1pEw51p+c3FljEH1jsWtjSCm/pUyeTSi0ONFG7ui94e6qMsZrj2xCzaG6jsUF
         m8Oh2YeLAlj54Mwu2q1ZahUInAZ/eChuzBOQOG3RVV2aKb+QsMhYUEKiLOAbVFJO+fbA
         ybfl4BoHckOVg7uF1SdbO/dLEvoVHFiFx0TTx4ndnMjX6XmerkUVrWTxwaPqtDH927sO
         hsR93atzttsAf9mxvhG4xmTHPN2eW0LZ936EVT19JLXoOljuzOzcN/I2SpmEtzNNSAZv
         7WEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792142125; x=1792746925;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cGD28N5eS0nZxh81/Vm4e61Bi2VqoNQPqUMCznEkaro=;
        b=fGAPmnwlN7hKmBc+wGY3lSfY0Qsk1hGyp86rA8jac3CcR4Kh9aHuGBL8TMss8tf5ZL
         8RgPVxtwJsLw1yJ5nkQj/oS9Od7TOaPnqITne69AsPYOLd1sS8VJiKuz2PzfQ2TKXgUB
         iSmAkCx8ahvA1K4GmbYtm14DbwOZRHZYqaK/IrMvrBTDUSLlukXKyLSCcdqEIat0H0vN
         q8SY9xAgleZiJ+qablkRX73M36kUP9my0m3ix84omfo9YutB2a9Fq1YNlRD/WyISpT6T
         CtMVj+EdWINgKN0dR1J7XzUCLdh1qjUdPCzXCgdq3jpnxZHdjz5Iz0eYwB5wUY76ABbB
         4tXA==
X-Forwarded-Encrypted: i=1; AKwUvBykOT++BOr30yQrcJqe6Xb2/TEBABHLfuwszyNXRNmFPEh7/Kcd+Nu3+ZK+9eZQrvEwTylk2MZ4Xmw=@vger.kernel.org
X-Gm-Message-State: AFq9FYK9o8SPDJzi8rivUeSPB/Y9OngFrBWqvC41WgkFbth6dagEJjNb
	m0TV7OI4WZ4ufKGwaIPaprjWToaHxLp2ZRGRkEgx3wna+PGuqIaez0muuFUjPBl8176rGBJat8O
	DzI41yo+P7/AeavuSxl7FoaScD+Uz3stk+P05UtfyFdWPc/Dte31xN3+XHyaNi1xxud8s7Q==
X-Gm-Gg: AYBFou0n/2s3skCtviWcuNyCFX4beccHSoAcYfYF5N8CCqNnal/7glrZe/j8tjLq5NO
	ZhgAqAhRivZatPdOkaQCIw5IDF8QI8ItRiNYHz8he9oqFDCjFG18HsUiKhyQUJHL45hQ9mXmUWg
	VuPpoRebr06iDKGq32QCQPa6ebUrJ++q8nhW8SFOj3Alq9NKBPHlE2s0neFiV/9Sk0nAC/giW1K
	ZvKGt8W2C88EFzPVe9k+jWHRejxgaOWn2ONT+/ypfE5lmGO3dTz2A1J3WiWisboWIlBO+lt1q/3
	A+5UmtP+mGJNGCwG7lj/EJcf5krp5110YdmJWO9UL35Y6AUas4bskqUlEAph2w5APk178hrjWN0
	UDzr3
X-Received: by 2002:a05:600c:a0d:b0:4a1:b187:1314 with SMTP id 5b1f17b1804b1-4a1b1871350mr181535545e9.7.1792142125621;
        Fri, 16 Oct 2026 02:15:25 -0700 (PDT)
X-Received: by 2002:a05:600c:a0d:b0:4a1:b187:1314 with SMTP id 5b1f17b1804b1-4a1b1871350mr181535015e9.7.1792142125214;
        Fri, 16 Oct 2026 02:15:25 -0700 (PDT)
Received: from localhost (mx0.herbolt.com. [5.59.97.199])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4a1cca30aa4sm16423035e9.2.2026.10.16.02.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 02:15:24 -0700 (PDT)
From: Lukas Herbolt <lherbolt@redhat.com>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: [PATCH 0/1] New test for ENOSPC and ENOSR on pre v6.10 kernels
Date: Fri, 16 Oct 2026 11:14:37 +0200
Message-ID: <20261016091438.294872-2-lherbolt@redhat.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tests covers the XFS spurious ENOSPC (and ENOSR and if only 6773da870ab
is applied). 

Two new helper programs are added:
  1) src/fragment_fs.c - will fragment the filesystem, by writing user defined
			 file size and then deleteing every n-th
  2) src/mix_buffer_direct_io.c - mixes buffered and direct IO to the same file

Adding Christoph to cc as he is author of the fixes.

Ignore the first email, I mixed up my indentities.

Lukas Herbolt (1):
  xfs: add test for ENOSR/ENOSPC on DIO into delalloc extents

 .gitignore                 |   2 +
 src/Makefile               |   3 +-
 src/buffer_direct_io.c     | 154 ++++++++++++++++++++++++++++++++
 src/fragment_fs.c          | 101 +++++++++++++++++++++
 src/mix_buffer_direct_io.c | 175 +++++++++++++++++++++++++++++++++++++
 tests/xfs/842              |  63 +++++++++++++
 tests/xfs/842.out          |   2 +
 7 files changed, 499 insertions(+), 1 deletion(-)
 create mode 100644 src/buffer_direct_io.c
 create mode 100644 src/fragment_fs.c
 create mode 100644 src/mix_buffer_direct_io.c
 create mode 100755 tests/xfs/842
 create mode 100644 tests/xfs/842.out

-- 
2.56.0

