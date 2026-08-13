Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5CD37F320
	for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 20:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654182; cv=none; b=byr6kHmvD2LoNQMFaVleJoMVOLy1moqm8pDw72W/ClG1mmiE9chmKci1e9jjxTE9pB7HLwiJRMTPPshgy0peFOEsQcNT//eijDcBMn6thHZ0oG8Uei4MuHRqlx+s01QjPrvsNzWITpqHwFrbCi2OxHbPtQLTbewbGNUY9+x3zIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654182; c=relaxed/simple;
	bh=8ee/7/7LFhDMIG88sH2aB7kMuWCpyP7z/i5rm3JMrEk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U2bEPP/p2kRndRQM6tg/Qf7DIdUg12QhcqpGeoo2A9SiQfx06QXfmaVLpn3FCyn190outOy2nJkLlac739aAg1XJzRjxLZoutwpmve+WDqDOYCp/2h9sxWhs+J0Ciwu2rzMgJftYo3vL9MqLi4zWXqcBydf5DH3K9utYFdfgKeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DaWB8s6G; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BVGIyTFg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DaWB8s6G";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BVGIyTFg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786654180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8ee/7/7LFhDMIG88sH2aB7kMuWCpyP7z/i5rm3JMrEk=;
	b=DaWB8s6Gudh2W6um7umChrAyDLhOEZNSNCWfMzpe0omieUR6CtrFx5FRSyJjl0qom2nFEC
	Del20srQvz/v/3vj5xY6JoCNzkKJZcN61byZCkjglw3fm1uRbDmHBbfHVdxCEi4FSRRcGO
	N04X/lJHHce+Z7ZIyfxX7vFBZOjhLR8=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-4tCks6FUPe2ZEHHAh9VfvQ-1; Thu, 13 Aug 2026 16:49:33 -0400
X-MC-Unique: 4tCks6FUPe2ZEHHAh9VfvQ-1
X-Mimecast-MFC-AGG-ID: 4tCks6FUPe2ZEHHAh9VfvQ_1786654173
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab4dd46ddeso140332b6e.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 13:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786654173; x=1787258973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8ee/7/7LFhDMIG88sH2aB7kMuWCpyP7z/i5rm3JMrEk=;
        b=BVGIyTFgaOMHDORl9v5Bkiy9MbAVnNdMV4QwRjq/7PImnHYaFUdMaFF6HrCFeCE0XH
         kgUxvcrDD9ZcrN96VBP7cVjr6h/o52733A2YFAIQtsI3S0RPXqodWJRAdQ5fOcxN8fB3
         14PglbqTsTiFN9G6O0WUulqK3EiqDjfi4Y3hcJ/EIoWRh3DeiqP6j9/3WZvutQNNiNAc
         +2otbGxHzizIyiC/1tQnhUul6y5AE8hSljAF+6KOBhQt9hzMQYyTDllgggVuJQRZfLef
         7T2gqLiytbRoI5DnF/v/SvfdjJYAUi3nF/E8zVYOK8mqt/lF+po6KEGuLXpd+ig7xhZ5
         OWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786654173; x=1787258973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8ee/7/7LFhDMIG88sH2aB7kMuWCpyP7z/i5rm3JMrEk=;
        b=D5yXu998kOVPpMZM4hAijwKoNdi7bntBd6KqWyOXmzi3aN2ZksooKsTO7xKFXqicm1
         D93JELOwmMJPOa39i2ubgmtQDtEqJCgEO9rxo3cIomkWmifPX1Z2qOiu2ENfP5Bp5zCt
         mAkZ3Wx6CyUooZvXmkfpEsu9bqhLEJ/b3bXCC8/+frePt+pOI2wFImxF/RDdVt2whU4U
         BKSdPGtUgFBrsS/3N23sKp3hWC3SZjpCuOadb8gDgF/FXKG3HcM9wAXC16wJawKSLxSg
         gaXJpXpNQIANuNeMZqZCSQD/AzNWKh84e00kxYHLc00lj2xLly3U1TzOPVDLN4F1eefl
         5RIQ==
X-Gm-Message-State: AOJu0YyfoI/QalZwim15sgFM+nsnmbqkj80fzfE1Ow5bTozi8kdWDoga
	4UioExhAx0b8+i9y0FJg8PS91TQWrHRaOJcQwVYwNR0Bo9/CpK82u/Ahxq2rcyPu0tJj9+pOiim
	P70pyEitg/oI2PNDd3u06ZkZ4OCr+40+hkmcZt3Ph/DHU9SZNDKjUMIiQFEBDTU4JIaE2t11rZB
	pJsRiVkYo1vc7zzY2QunZwgDK+vwCjP32hsF349U2YdLH8muM=
X-Gm-Gg: AR+sD12Me/gXGPcw+1c7/KiBJ9ViT/HOjw0Q/srL8R1PxCMD7JJnerjeDhX4dBeW87G
	2438eoM1qhRolWQl2VDMX4TP5nDHDt+BsRLopPMkGl3K+GaLYRXXW8q6GSku+yl2bapit5AqmRI
	IhO5vVwfx3nz+GSdgD1TxDDRodBgyrSFMczTHGnfR1Qpj7ciWp1ycv80sg9f99AiN3RBmLhoCmu
	2vPJMSew3d9yIwLdzQulfIfgVBvKgstX3arArw4ZTrQWkeIPCdWcLfhAPD+C/F/uyhBpqqDWbDR
	pBfqTeWluHFbZTtNM/9msETUXDhV0NmEeIUTRS9WiKNWB2lxL16DzNfpaDosODT7sPiz2tpGHo/
	9kdPbgByVo9GwA8I6rbTfkX1udhewB1POF96E7xxFg5E=
X-Received: by 2002:a05:6808:538d:b0:49b:33c8:4b75 with SMTP id 5614622812f47-4b2412c1b14mr769298b6e.5.1786654172997;
        Thu, 13 Aug 2026 13:49:32 -0700 (PDT)
X-Received: by 2002:a05:6808:538d:b0:49b:33c8:4b75 with SMTP id 5614622812f47-4b2412c1b14mr769258b6e.5.1786654172451;
        Thu, 13 Aug 2026 13:49:32 -0700 (PDT)
Received: from big24.xxmyappdomainxx.com (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b22d004c3csm2555958b6e.18.2026.08.13.13.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 13:49:32 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: xfs: properly account xfs_buf items as reclaimable
Date: Thu, 13 Aug 2026 15:40:51 -0500
Message-ID: <20260813204929.2253988-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It was reported that xfs_buf items are not accounted for as
reclaimable, and therefore various statistics in /proc/meminfo
and /proc/vmstat do not reflect their reclaimable nature as
other slab-allocated items with shrinkers would do, which in
turn affects the accuracy of stats such as MemAvailable.

2 patches here to add accounting for xfs_bufs allocated via
xfs_buf_alloc_kmem() and via xfs_buf_alloc_folio().

I was not sure how to handle xfs_buf_alloc_vmalloc but I think
that's a relatively rare path, and the above two will capture
the majority of xfs_buf allocations.

I've cc:d linux-mm just because i think this is the first
user of NR_KERNEL_MISC_RECLAIMABLE in the tree?

Thanks,
-Eric

