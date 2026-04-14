Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800BA2E8B81
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 07:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776151285; cv=none; b=ddysAdI73OKlW19r8TWpMEZZ2jme2+lQ7pDrsbAwv8eiPyrEuB+7Iok2J/xqhmBS+tre4CaM0JQdOjdEDGvBYiLRa5xYOqOxpmSKjUw9sOHTSF8KJXNQmT6fCjxBooPPt4tcwo48Lb50XDO8l0bR2YBzNEEXwmD1IrzPatHaHSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776151285; c=relaxed/simple;
	bh=rOin3Pv8FmH9s21gwev/4brK8hZJavzBhufSKvf75w8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UnhqeNjaW2/DHRVlrhGJ4j14l+rseapzcJhyc9HHwlvhlBRtpYQ9Bhl2ipGXVERFk2adq21qDVoVM/Ge/EjfsslOZeajnwbm4Ht/81G2VlaoGzFpllnQK8bdSI4tx5PzazHYO0ldKufjm5mN9DATYMdCI/ZcfV01Od3FlAQ1UqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GWV3gk3s; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ad4YRfop; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GWV3gk3s";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ad4YRfop"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776151282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DzDvdcj5STpLxm9O+mIbjJO8816UhdLGXaxjYeBxCnI=;
	b=GWV3gk3sJzC9yYUow5E/7zwkr7d9Plf2P6lV9hWnIcSHVPvV3S1B+bE8p6PqG3sgoW9T/3
	IOayavVOIexibBwKk0+WczTUpTIYMr+5I5Wwh+5rwBOr540IJR3Dodz9dq2fkBgbfEBfOZ
	DNQPeDfIeexCs1+Q2lSuvW5hwL7UMH0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-2P7cRvRdM2yKuGH3Ku1Bfg-1; Tue, 14 Apr 2026 03:21:21 -0400
X-MC-Unique: 2P7cRvRdM2yKuGH3Ku1Bfg-1
X-Mimecast-MFC-AGG-ID: 2P7cRvRdM2yKuGH3Ku1Bfg_1776151280
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8d5b5d607d1so1030601485a.3
        for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 00:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776151279; x=1776756079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DzDvdcj5STpLxm9O+mIbjJO8816UhdLGXaxjYeBxCnI=;
        b=Ad4YRfopwF1DW53kBxfuOVcPbPydER8ytD4GOeaEjMCU4eoPfgLczFRRr6gMfEilSz
         shvpDrRz0XW1kbibiW1OEgATy2uElilcy0WQGKQM0gdWNTwj9JoiE6c33E/k1oMYB6lL
         suRi9/KlA/Qwspb5yop+vsN4UFc8wM8lrNufd55xi5fBrHqNioWRcSMJPuwFB0N/0kmg
         eB6qtBkKMttCJoUhOKRFQfblU1WfoA+pxfGALnHThRBit/UHyom2z1O18I0PRwPHaML5
         ZzWLFhOFImTWQv9vUDb0GQeBdiCU2kALOhC3nXiKRRWjr59VZ5sueZL9uok9jxECHYac
         YtJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776151279; x=1776756079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DzDvdcj5STpLxm9O+mIbjJO8816UhdLGXaxjYeBxCnI=;
        b=YsHKjPSBxm77PZNFMnU8Jp4JeD5oX3s1l64dAUz954hNC/rtHeZnXCTwVY0LtnScGS
         QB1+UHvxuE5FH3J6hSSnJ6q2KKyggDASjenODzhAsC+xupp+Ly8WK+bQefChH/ar9ZRk
         ndozzpWgi70gVX40u9f6J8zGQ2zD9/uwfFWz8rgcb+MkUOa9xLTeTPjqmJn1U4WHq42t
         XLMj3mxpcB2Jy+UjljG/F0kWQMsrcj73LI1CToWa8fvi+kup6vKo22bX57BEsahbW62I
         9xK9mlpO6UyKXkxw0hrfmHgqJezllNI1UdfsrnDliASbSRUwDXhB4A3haMPWaX2hQyga
         wotw==
X-Gm-Message-State: AOJu0YwKG9e2O7z/RDIBaWO+1rcoWC2fFWf69Q1IfyrrytoQMYCdyzAD
	FHonwJVYNIGAcGD/xEInn5J4lzqH8qWZiKCB50BPZ9szkP3xZLj43WVYcXn3jPUIi5byDDChySH
	GbIWscSeGCRXUwTPtLN/WFom/qWY2Bgyjw4+3VtldpaaV0j3pv6eogIl1b8wCRPxmZQfCaC64wN
	jl/SaYnR3hqNkJo1VSG5S4aJEinCyt6x/sH74M4A6Snk5RmVhU
X-Gm-Gg: AeBDievaGBG5lQL1GTMW24Atc5NTEFh5tQHCSWntZtcntBocgkCGxZJnVPw/UNxGFh0
	4jUkpAZ76y1Tsn7XqjSw8RCwr5kPZOrFZsdFbK12U9qqWheI5vgWl04/CL4PIxT8/ukydhcazOR
	+X5wG5t8S39tVomfE9mEccuhL4VjPg15hmB3FKqLxLk7+AcIWC6kCGCYVkV0bvQyqyzLE/4WUrE
	NYuySpy+aqV+d6UBruZKVqzW3YhWNhDd3FJflN8fory+y5tCG3jh4ORGzCPLOAxBFDN21nKgsNh
	xX79knIcSnSC7MuPLQuwMPugPbG9wHGc9fFvSc1rCLvjsX732tL+hTOQIbuJ4Y3TVJ0/Te//3iC
	+5+3gEPutL+BO9D0y
X-Received: by 2002:a05:620a:1a11:b0:8cd:b38c:4748 with SMTP id af79cd13be357-8ddcf2b0f8fmr2538054185a.34.1776151279323;
        Tue, 14 Apr 2026 00:21:19 -0700 (PDT)
X-Received: by 2002:a05:620a:1a11:b0:8cd:b38c:4748 with SMTP id af79cd13be357-8ddcf2b0f8fmr2538050885a.34.1776151278706;
        Tue, 14 Apr 2026 00:21:18 -0700 (PDT)
Received: from fedora.. ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac849dd312sm116830396d6.9.2026.04.14.00.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 00:21:18 -0700 (PDT)
From: Ravi Singh <ravising@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	aalbersh@redhat.com
Subject: [PATCH] xfs_quota: display default limits for users with zero usage
Date: Tue, 14 Apr 2026 15:19:21 +0800
Message-ID: <20260414071921.1226575-1-ravising@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the kernel returns default quota limits for IDs without a dquot
on disk, xfs_quota suppresses the output because it only checks
usage counters (d_bcount, d_icount, d_rtbcount). If all counters
are zero the line is skipped even though non-zero limits apply.

Also check the soft/hard limit fields so that quota output is
displayed whenever limits are configured, even if usage is zero.

This is the userspace companion to the kernel commit:
"xfs: return default quota limits for IDs without a dquot"

Signed-off-by: Ravi Singh <ravising@redhat.com>
---
 quota/quota.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/quota/quota.c b/quota/quota.c
index fea55f03..08a07b20 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -62,11 +62,14 @@ quota_mount(
 
 	if (!(flags & VERBOSE_FLAG)) {
 		count = 0;
-		if ((form & XFS_BLOCK_QUOTA) && d.d_bcount)
+		if ((form & XFS_BLOCK_QUOTA) &&
+		    (d.d_bcount || d.d_blk_softlimit || d.d_blk_hardlimit))
 			count++;
-		if ((form & XFS_INODE_QUOTA) && d.d_icount)
+		if ((form & XFS_INODE_QUOTA) &&
+		    (d.d_icount || d.d_ino_softlimit || d.d_ino_hardlimit))
 			count++;
-		if ((form & XFS_RTBLOCK_QUOTA) && d.d_rtbcount)
+		if ((form & XFS_RTBLOCK_QUOTA) &&
+		    (d.d_rtbcount || d.d_rtb_softlimit || d.d_rtb_hardlimit))
 			count++;
 		if (!count)
 			return 0;
-- 
2.49.0

