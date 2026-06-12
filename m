Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797D62288CB
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 02:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781231521; cv=none; b=ZUPLCg5zjknq4cQWgfZBU4ktfYWZF4/3Lm5cdk5bHYILkt6RpBS7xldzuBAPTUOmSFi/zBUcrU2iBxn/xF0bglHqWxyrGj47JsDV+4qAMxXdqiUxJiZ5ghh2RLWv5IK7/LywaIzZeYReTpTejalUFa1F+6w8clK+6WdVpoEW9qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781231521; c=relaxed/simple;
	bh=Ri4rEg2zAX9ViqRedUKetrvrP0VtaF2+4RO4Wm9/WzU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o7hF0Ppc3PfMvwG4qbwXe+uLEc9uDVTCh7nRHhJpfXUIZPCk0sHaLQiPS87tO85z4gB92nNhAUk4KJgDL15Y+CjdkHNvT7B4470yWEyK7xU9Vlf39JI5mHua4fudIIcnMbFQ4/Bss6ZpdZj52i1Arz0sW6dPniju1fByZtjnIvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: de2049bc660611f1aa26b74ffac11d73-20260612
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_QP, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e9360bfc-a80e-4697-b748-369e8534fa6c,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:e9360bfc-a80e-4697-b748-369e8534fa6c,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:de84e6a048b2ad5c2feaed65f90b64ca,BulkI
	D:260611101313SYQAGXSG,BulkQuantity:4,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|136|841|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,Fil
	e:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DK
	R:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: de2049bc660611f1aa26b74ffac11d73-20260612
X-User: sangyao@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sangyao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 451209558; Fri, 12 Jun 2026 10:31:50 +0800
From: Yao Sang <sangyao@kylinos.cn>
To: hch@infradead.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	dlemoal@kernel.org,
	linux-xfs@vger.kernel.org,
	sangyao@kylinos.cn
Subject: Re: [PATCH] xfs: shut down zoned file systems on writeback errors
Date: Fri, 12 Jun 2026 10:31:45 +0800
Message-Id: <20260612023145.238069-1-sangyao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aiq74YOg20v4RtfU@infradead.org>
References: <aiq74YOg20v4RtfU@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Jun 2026 06:45:05 -0700, Christoph Hellwig wrote:=0D
> Step 1 is merging your patch.  I have a few minor nitpicks I'll=0D
> reply directly.=0D
> =0D
> Can you also submit your reproducer for xfstests?=0D
=0D
Yes, I'll submit an xfstests reproducer as a separate follow-up patch after=
=0D
sending the kernel patch v2 with the commit log and comment fixes.=0D
=0D
The fault injection I used for debugging was based on a temporary test kern=
el=0D
patch, which is not suitable for upstream submission. I'll implement the=0D
reproducer properly using the standard xfstests infrastructure.=0D
=0D
> Step 2 is defining a new shutdown reason for irrecoverable data write=0D
> error.  Do you want to look into this or should I?  I'll also prepare a=0D
> document on the current model the zone allocator is written for, in=0D
> which trying to recover from write errors that bubble up to the file=0D
> system do not make sense, and we'll see if we get any disagreements=0D
> with that, or examples for cases that we should and could handle.=0D
=0D
I'm also happy to take step 2. I'll send an RFC for a dedicated shutdown=0D
reason for irrecoverable data writeback errors, so that this path does not=
=0D
have to keep using SHUTDOWN_META_IO_ERROR.=0D
=0D
Thanks,=0D
Yao=0D
=0D
