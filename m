Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ECD472079
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 09:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142027; cv=none; b=MvQ1ocO2NXtulwjPVDtIvZpb2QvJaw270vHVu0K5hFkgaAwqg+5KCaBFqG7hgQXP8zF8c6W/DG7r+xv41Zcl4Q/iDt7Q7G2aBij/vDPf8ZbpyXOyIIVuWGoEFYKVuolK/2Ynsg4s+bH99TIA3J8MNABpuJZy5c1Pi5DCaiu7x44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142027; c=relaxed/simple;
	bh=CtH/Vf7ari7AB6RWWGf45YDue4zz6p+iLIVLPULLBz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B2Xx524gvtGb19n6E4x1ZdsWvXTChQR7gZ1n3TPU7T+jMUYYBJoQ3BMPV1j6wfk+TdeMxhxlPmWrPxMgM6nJnNiEyhO9aCKH1gHD2ZoyLIuSP2NwJ7jZLiQIqx+255+YFooAZ1h0GdDDXGkKlTWVmofhqryHnbV55WO/vFnJ+6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yrt3d/Wr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=M+u/N09z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yrt3d/Wr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="M+u/N09z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792142025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Nvyep45+Ocd9G5AEE7LTrvRKFFek8ljG1vClwySaUIg=;
	b=Yrt3d/WrahzZHE197C9VluFHSPz/L3Gb07xs3WwJgfmvlw5ORSn8jTR8bwb6ucA8wxllTR
	tIYP/FreOq3gC3Yvj0nufc3pM1ary5aiYrv0UtxOzXObsO6BmoNhNMnxpj7wX9xbCYKcP9
	ytTsAcZu+zx66CfjOwTJ6Sj3QuoAXkU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-hG-5LrhnMlygdmSkjjeKIw-1; Fri, 16 Oct 2026 09:13:38 +0000
X-MC-Unique: hG-5LrhnMlygdmSkjjeKIw-1
X-Mimecast-MFC-AGG-ID: hG-5LrhnMlygdmSkjjeKIw_1792142018
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48b00febba3so4812726f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 02:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792142018; x=1792746818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nvyep45+Ocd9G5AEE7LTrvRKFFek8ljG1vClwySaUIg=;
        b=M+u/N09zukkRiuT3z//Tvu8kASF7zuDgvhBXAZer3bpTRtUKO/4iWo6a+0HRJPXa0R
         a0BYJnWPJGD0RgB+ukPKPSPH4wciJmuPOuFxbPg1KNIkrep9Tm+uxD4ejVA+9l3f9uvk
         1Y48gsdRPv3j8JvXb/QWhoTu2+xfNBNEe1/v/PmtmqwM1iX2Uta6D7KRglplGN8WO4uY
         0V2MNNzSCETx4uiXqQ4yp0RPgVxIPLAoMFph9U7Csn9+ZD6ESN+FIqUSyNYYqUBQnVI+
         KdyfMQACCfODeQBkLVgNG4wFx5pQDbSzcT0Rhq2XxQfkqkPXE3livgs9M/7vB4vAKpx5
         VCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792142018; x=1792746818;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nvyep45+Ocd9G5AEE7LTrvRKFFek8ljG1vClwySaUIg=;
        b=yN38HR8UkD16x0/1G+hQJFVlTDLe8P1L5bFaIQqh7F86PoSsGO5ZHQaLG1Bak7Qn1q
         x9XJ46VYubbvq2bFxNhVEAQzhbhI7t1xW8EIRMQaIMK3dCF8AimBjP1iTfItygk9zADi
         kZurgOrbeja+UMpcRfr9YbBA4Jz40O8qe6tEznUPAhvJem9zjErPC5Zc4vgOlkIP8Ho7
         AXCr6m4YODhB8055JOkwrPAUmnwcSt9iK8dfWtG5qqahGfi2YweJLxVFvJj3qhBs6cOZ
         dVAWq8CNNMYraSfH4NAq9sH0suA1tqVfUPNzWrjfgkjcjRqisbYgjxwVgxmv7K/adWfQ
         pESw==
X-Forwarded-Encrypted: i=1; AKwUvByD1cGG/y6BD86Y0sssBChJcyrWEChCRx8XD+CAjW//9xkVlzyKwih37hD2ax1g69IrYdEdt1JzmCA=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ3dUyr84ocdarJbh2ODggYs8jRp+FkOb3lcfV6H/FcSrpTzw5J
	v+6oWYR04uFKesaPqIlZyWpmv0T/3V9F5KRErzhLrDhW4Yud+2xRzd0Bi4yyOC1/dnKkb9QnhVB
	y8G4RIGY4bbT99uRencwzOv7qyFr+BtAJMS9TLq6uZVXQ+XUlEYOd+tXyz+qnAw==
X-Gm-Gg: AYBFou0QbDdE+l1zb2BtOig8Clu/fQQNZgYBv0xdWPHoNBSSZZ2Hq+/oA02/OEtoAHr
	9t/JHLw97+MfkE8UonVQr8kd/IIePwtBOb2naI0JbkcQdET1Wf6pFjeKnO0sJBQSRYujak1jcwq
	I356tp0XfMQuKyZ3csRD0ogOY2RDssOx2XJEWCiq++VrjMa+3f4cmKyBJBWPAe8FR5Sm8Y0iVSa
	h6Qk5ebgKOFBiNkIMt435TCjuWdtBWIvcEMRjnSDRtD9/L6/7kA5sxUOd1GQe/Xvz73HAKKC+RI
	OEuuuvSzC/2021QZ6H2tjRtt2G5ZEMl+s6MDTazY31oAWIZZTA5Jxp6TADZ/N3S3EGLMaAbsFkw
	+bO7c
X-Received: by 2002:a05:600d:8488:10b0:4a1:9078:911 with SMTP id 5b1f17b1804b1-4a190780997mr303070965e9.31.1792142017785;
        Fri, 16 Oct 2026 02:13:37 -0700 (PDT)
X-Received: by 2002:a05:600d:8488:10b0:4a1:9078:911 with SMTP id 5b1f17b1804b1-4a190780997mr303070785e9.31.1792142017488;
        Fri, 16 Oct 2026 02:13:37 -0700 (PDT)
Received: from localhost (mx0.herbolt.com. [5.59.97.199])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4a1bd9b303csm130227205e9.8.2026.10.16.02.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 02:13:36 -0700 (PDT)
From: Lukas Herbolt <lherbolt@redhat.com>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: [PATCH 0/1] New test for ENOSPC and ENOSR on pre v6.10 kernels
Date: Fri, 16 Oct 2026 11:13:10 +0200
Message-ID: <20261016091312.294645-2-lherbolt@redhat.com>
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

