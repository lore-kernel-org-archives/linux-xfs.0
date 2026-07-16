Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A554313550;
	Thu, 16 Jul 2026 06:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784183359; cv=none; b=djy54BsnXqaccPbk3UPMB0MZTqvNIRGfEjDh0xVSkh9VfZBqEP+eJqPRdt0cIQ4duy3XrAPHA4IhliM3zCAuyEl+VDQYdLgBDCy4bgdpzfVD0G6+UYS0Pr5HgrIdAa9xftXZ9tQpvcuCEHCE5qp17MccJcXSmqJsK1nCABNcQJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784183359; c=relaxed/simple;
	bh=NyvYIScMGaKZYb27RvMW5m/kQAsBIbpoPTyb4yzW99c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fTBu6hGQENJPFVAYyB+h4NG+PGqIBYb/iRBmj+a2mksROYDa3u4g/CX5Irr4dPl8XEFpxkPjWllk7d9Qu6HTsjfMDn7cSrqJO+EQXfcaKEHNgkig4tIGumKbMvhN9WvsyMyFx+wRwoToA+jmQt1amqYqHjBTvSCh/GuymUNyUZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a5133c9e80df11f1aa26b74ffac11d73-20260716
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:75492334-b140-4bed-b174-67b71ca262f4,IP:10,
	URL:0,TC:0,Content:18,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:28
X-CID-INFO: VERSION:1.3.12,REQID:75492334-b140-4bed-b174-67b71ca262f4,IP:10,UR
	L:0,TC:0,Content:18,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:28
X-CID-META: VersionHash:e7bac3a,CLOUDID:994016d673ddcf58d7422cf99569db36,BulkI
	D:260716142759SUU37U7G,BulkQuantity:1,Recheck:0,SF:10|66|78|81|82|83|102|1
	27|850|865|898,TC:nil,Content:3|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a5133c9e80df11f1aa26b74ffac11d73-20260716
X-User: sangyao@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sangyao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 176749619; Thu, 16 Jul 2026 14:29:06 +0800
From: Yao Sang <sangyao@kylinos.cn>
To: shinichiro.kawasaki@wdc.com
Cc: fstests@vger.kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	sangyao@kylinos.cn,
	zlang@kernel.org
Subject: Re: [PATCH] xfs/333: require external scratch device
Date: Thu, 16 Jul 2026 14:28:48 +0800
Message-Id: <20260716062848.1768294-1-sangyao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260716013747.1288925-1-shinichiro.kawasaki@wdc.com>
References: <20260716013747.1288925-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Looks good to me.

Reviewed-by: Yao Sang <sangyao@kylinos.cn>
