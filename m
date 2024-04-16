Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E0113A24A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713299057; cv=none; b=UJGj6bP8qkVzi1dgqCJohQ6blI1d4BYh1YkqaEn614DpRCYjy+cBtcR2+IFoAtD/LZRF5sMrlV84+cVXx2Hmc9mjRIihTnubuO04BQk0I+V+ZTTTKC+ff2PnJUE17XqQYlQnQ03tIqT4ryGAz86/MDHpNUr/CtCPPDNGLwHSOHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713299057; c=relaxed/simple;
	bh=KbPdMOvna67YGQw+67yp+CHNScmYhC66eSON3x9wW3o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SaFN3ac6cgDxYmajbEuDZdQ4v7lLul/zENIYpkukbLqeQbJ4s4eG0xoQnaXouC4n1w4BT/BBgIaKALxiNzkl81/WlY+IFZRtuxjpeBQcqrhXwVlsyKda9pXzn6onfVOr8eLZ3k/i/Ctl2GCXmsSLNCVDvqHO6hZplLZjd5Ow0LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IFDqwee4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFDqwee4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713299055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sFa1WsFcygs2IN5DPW6gGsrOC3+TgkgWfUGNJcnkIPk=;
	b=IFDqwee4hVC+xfmcdS3F+95/ljZxZ5Un/fgcMuTkEO2CHwk6r+//ZvlpnGRls8JrALOlWL
	+c1Js3YKcULYuQZuJTFHbwF5lCMtowCHKLWmFfga/Fvwj0FQFXPksjBZQMOnBrUnEC6qGv
	r6RlgkndfAZSrbi8gKUK00a2RRDGHEk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-Zgaew-2PPy-nbgxgJbL7XA-1; Tue, 16 Apr 2024 16:24:13 -0400
X-MC-Unique: Zgaew-2PPy-nbgxgJbL7XA-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-56bf2d59fceso4213979a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 13:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713299051; x=1713903851;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sFa1WsFcygs2IN5DPW6gGsrOC3+TgkgWfUGNJcnkIPk=;
        b=lxYwgfIXo8RJWSxdKrh4wrdYA0jAVKFt+un8KYhQuwUYEe8fpwGo8t1j+s6T0Ny+Gk
         Csm0A9UXk9RTjwGuisxKaToE/nNOIVN+TAWo4W4oRWv6OdYMUyGHyBjtC1u/QVNrX0Ks
         dKfZU4lrGgB2xZvnBqZL3azKggl+O3WDEd6MlLROWps3A4ANnfbyfsa477pmPSndSdeb
         1quBfopizAltz63exgV3jgfTHJjDfqOtsUopFx1rb9/j2Np3nmov156avbgXwEZ4GGP4
         9ffEuk7kpU3xnTKxZyEbxY+pDdVOaxZdLT6niVFNSmTVWj4aKlQNU6tU0H7Rhi4kzcs/
         MP4w==
X-Forwarded-Encrypted: i=1; AJvYcCUeR2RVpp5KmR4weBVV0LAvxYz6ehSuwBSH1PxCYr7D3+urgPDaIcXtv1kUKtS01UoV+QEMr1r0TpMjERpXAWbIl/OcVF+815sW
X-Gm-Message-State: AOJu0YzfSnhh2wpbsqwA98keH2MPmVFP2fX0TjaO7uU0Z5Q96u3jCrwz
	81CGZ128AVMQPrUu/LQQTU/QQJojG7/x9ExrI7dO2W09EkrM6mKARc0Vwtgy/o0AZX4oAohQLNo
	9tDMg7p60kIwmyLfBkoN+uqJ4mn5JsgkfKav04No7nD09RTzkC92gfZb5ZkVmWIFi
X-Received: by 2002:a50:d598:0:b0:56e:743:d4d9 with SMTP id v24-20020a50d598000000b0056e0743d4d9mr9753166edi.42.1713299051196;
        Tue, 16 Apr 2024 13:24:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDI9UqfDHDpBzYD7VPasC4zp/DWqKK5ZxxMClbQc0AiEebWT1/CAKpXMpHfXgT4jcVdKdHmg==
X-Received: by 2002:a50:d598:0:b0:56e:743:d4d9 with SMTP id v24-20020a50d598000000b0056e0743d4d9mr9753156edi.42.1713299050725;
        Tue, 16 Apr 2024 13:24:10 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id fe1-20020a056402390100b005701df2ea98sm3655687edb.32.2024.04.16.13.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 13:24:10 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 0/4] xfsprogs random fixes found by Coverity scan
Date: Tue, 16 Apr 2024 22:23:58 +0200
Message-ID: <20240416202402.724492-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is bunch of random fixes found by Coverity scan, there's memory
leak, truncation of time_t to int, access overflow, and freeing of
uninitialized struct.

--
Andrey

Andrey Albershteyn (4):
  xfs_db: fix leak in flist_find_ftyp()
  xfs_repair: make duration take time_t
  xfs_scrub: don't call phase_end if phase_rusage was not initialized
  xfs_fsr: convert fsrallfs to use time_t instead of int

 db/flist.c          | 4 +++-
 fsr/xfs_fsr.c       | 8 ++++++--
 repair/globals.c    | 2 +-
 repair/globals.h    | 2 +-
 repair/progress.c   | 7 ++++---
 repair/progress.h   | 2 +-
 repair/xfs_repair.c | 2 +-
 scrub/xfs_scrub.c   | 3 ++-
 8 files changed, 19 insertions(+), 11 deletions(-)

-- 
2.42.0

