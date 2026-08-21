Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0A52DE6E6
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 22:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787349823; cv=none; b=cPsLNFhXr0eyolZYpqlrFsrV1a1hzdeRvMmkptZK3POkAogSmPeRfE7sC8p9J6oZTn/j2QqLnYcUhI/LEtZ5doWoHCpIEOigTiFUQl3FBHKihFLePxqA2uDVsr5L4yVGz4oYrFUshLvgLcqMEfCZZIa0EaTdppDoHBBsMmMbruo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787349823; c=relaxed/simple;
	bh=CidgavDoxyV2WnCGn7ZkA7/Lk0FLgpHx+WotF2vqhDY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=D0qRYH9moqCJcaumb45XzxDcg0Xs8zlUp5zHsqfaQ1byXkHf7TwKosbzBDu/ApmuCKzeYJ41Dw5mhlQ/bI/+TbxPf16u//ipYk2lswF5vmdfZvSuVPhwyRLB9V56jqwylsjwjgB4RrGt9MM/8zWd46IvNrdEj0msx9cpBiU0TPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dERtsKTa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QRzMqO9d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dERtsKTa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QRzMqO9d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787349821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oVNVHEeJhSSQzpgmhVniVXo1wjrMyJ2Aak0pTWRmhAE=;
	b=dERtsKTaE/9KnZIhfMZUn69KdxuZJA5Nm6d7wE5yWXS2eZm6ZzrovBwrp5SBA5aseKB+NM
	K4BBYB7bqTd6bwWsxEbmo47ztfEHyB+rp/TbFcLfpz4sUWDtzoidv3CGkFhaviCyPKAuSf
	hMIoXYH3OQ4WLa2o2HyMYzD/KNCpfCw=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-dqSF8GG7P8q14XgHcSdRfw-1; Fri, 21 Aug 2026 18:03:39 -0400
X-MC-Unique: dqSF8GG7P8q14XgHcSdRfw-1
X-Mimecast-MFC-AGG-ID: dqSF8GG7P8q14XgHcSdRfw_1787349819
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-456b5122c7cso4090729fac.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 15:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787349819; x=1787954619; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oVNVHEeJhSSQzpgmhVniVXo1wjrMyJ2Aak0pTWRmhAE=;
        b=QRzMqO9dFDXeUhxJkmmjYkKr6VbPQJWT2UCL0XFn1W6CXgOUVw8lSCsX/OLNZtNFgQ
         4X3tDJPXDtqG+Lxiwcx6mEqouL+/pmctrunxLsBoMHzujmdo/6CVE8q4DVSobeCLXfiJ
         /l4892cz0s35Mry6mv79BfSXeTODiV8rw4vbKbxf1CVFIf83YKLPaKQatPejqlpB71SV
         Bd9kuPWfpVA/XPOui64r7eFKlDaEzC7nlP6sWWgPi+CTRFByzBYNHPD3lN46IqEj7Jmq
         yMWzWvIzXKWBpBISyN2zpfGm2n+mU1eh2kZDMeBDb4HdcwinO6kg6ZhQE9SBt59zHDDU
         GmdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787349819; x=1787954619;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oVNVHEeJhSSQzpgmhVniVXo1wjrMyJ2Aak0pTWRmhAE=;
        b=pdFsI+fSjPC5VU29WUP68Fr/RgVUT7vuaqKdd+JO4p5j5d7kocn0OefsKrUxRpRQyR
         zy0onR98KvlhwwDoq19vBzFogqD2ZOsqDY2vJ+d7ADW1mI/fDgE2Wf9lCShA9sWdfrnI
         jgQGNJ1NmlOk2JOy+p4nHJA10zUvjDpepyi07M83gIYZRArx9CQqye7ZAVyKdgUSXEFK
         DKmQ5rsqXcZC81pbcB15cW5Lo9wpuerit9+KHLYTcqiEfWncrGJjofUd2b5PatqFlf8C
         kQa/evUMqRpVzpWuQ+e/BOO4GW5/ZCHnz39zUiZFktA6u/A1DtddMvmXizsa+KfR5alA
         sJjQ==
X-Gm-Message-State: AFuF++nxk8J/Py1clLoPd/edPhof8kqiLTDYhbw7t3JJPS4U3ABrHoEx
	Cyt4y54PpgUmp66Lo6dQwbDRHRwJUeRH8cL9yWA2hGGsjzA9/ARln3YGqaYMBJU5lr+CxfigeFF
	pxRj/92ZEz/BU2TNiVE+NXmrvdVokcjuifHKAR5Yr2/vW/ybATxszwaaF8XXru/x/a98nVsw14L
	W5EA8h0UTi+KfQ172hEir9sTb3zSu45JrjY5qopIBVRPFos/M=
X-Gm-Gg: AR+sD13GmULbg/mj6/+Y7tkl0U1D/a0jy87M4N1hd/x6OBv77uPXRG1Xvpjwzl6QQY0
	ocXKImO1OPE4HIeYejUf47JEsxu9AchgYOtEjCe1KW/QyFiEBw8y5FpNtLEx83fgYOPVaxfcJkH
	1GPmczqnveho5ld8SVXMV/H8nGVcR1Ds/OI0WQjtbE2rQpznRSP1KwO211KwBhvIl5ho0TndZi4
	j/MOFxjpUJhgzDc0NcitnAZ2oDZLQBJjxSNn6V/G60j0xbtD5XF6sLEg0E+S5NXcguZ78k3kGu8
	qNd/7UjYyRJuvEink63fn6Zv+8HepwqG+YvznK4xXfWlq2sLI72+GDUKdIBjmsxLee4g6F+W4Ji
	sUGdLI1zJsHh26wMqKL/gkgDoarTKubMiRLJkHYoZ
X-Received: by 2002:a05:6820:2009:b0:6aa:da90:8bd2 with SMTP id 006d021491bc7-6b15ae18075mr8414742eaf.16.1787349819039;
        Fri, 21 Aug 2026 15:03:39 -0700 (PDT)
X-Received: by 2002:a05:6820:2009:b0:6aa:da90:8bd2 with SMTP id 006d021491bc7-6b15ae18075mr8414622eaf.16.1787349818409;
        Fri, 21 Aug 2026 15:03:38 -0700 (PDT)
Received: from [10.0.0.119] (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b13cebebc2sm9200648eaf.9.2026.08.21.15.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 15:03:37 -0700 (PDT)
Message-ID: <bf0a3369-f788-4519-9883-8d01d42631e5@redhat.com>
Date: Fri, 21 Aug 2026 17:03:37 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: fix reclaimed page accounting in xfs_buf_free
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

To obtain nr. of pages in "size" bytes, we need howmany(size, PAGE_SIZE)
not howmany(size, PAGE_SHIFT). This over-reports reclaim by orders of
magnitude, up to 4096x on a 64k page system.

Fixes: e2874632a621 ("xfs: use vmalloc instead of vm_map_area for buffer backing memory")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1a5340baeabf..8256c1d13ce2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -139,7 +139,7 @@ xfs_buf_free(
 	ASSERT(list_empty(&bp->b_lru));
 
 	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
-		mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
+		mm_account_reclaimed_pages(howmany(size, PAGE_SIZE));
 
 	if (is_vmalloc_addr(bp->b_addr))
 		vfree(bp->b_addr);

