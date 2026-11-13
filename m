Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575996;
	b=Ai9u5p0/mAcFlUyqLDnwOt9QKU21DdmhxOBWtQsllY91BIF60koadNcsnMvW9Fm7RT2u
	 +bVu31WXFgweClvvlZ4RDydt+sFiHeSTqIgwj6W8jCKAxlL02G6H/hHeV7Xqe8e7S2cnz
	 EArPIGERHqj5CR8KvtET0H1PEEbxKHXR/Yf8n8B3oQDhR9AJfuVfLS9FgDWT8fWuGo0kx
	 +lmNlDccBbvdP8VVsBEOZ2JpdR3VppT57EXI9Qk3Xtpt3O4++3w+Gaxini2XUNehFrscm
	 crAYlXF0FHTm8QIWpSWFM2/Tqb8J7lOF8qPCu7NTWChWsNKd5Zc7rX80GXe0lvGhPPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575996;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 Cc:Content-Language:From:In-Reply-To:Content-Transfer-Encoding:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=DDR4P7HOyvC7IYDwpp7LvapCJ7chv0vTEAbX+6tMHUQ=;
	b=W3ac4K+QmdxsAm9te1Y4S9t3C7LUEHGUzmyh6C4nZhw9YYI9FYzV2vCMhJzx4wtVBLyY
	 rHdnh9ASU5w5j4VeFJF9x/sMUmdKZA/WLf5LAk2q8jqmwFfucs8PzXveyFDx86DdPe2SH
	 kaiZMyXTJv5d+c2fvUwazCCYDL2TiCVBAiBhDyjFeUfUl/DYEiviKNpFMaRFDSChFIrOw
	 LCGbegsb5l44wPykyCcGSMvz4BG5gA1G3D87gzYTocVmuQ6MPzS0Xz4quSeZaSYl3eS61
	 LUIRjpxCKQrdY4XPWuoSZtoKQVyvWkr+2HePotpXa7z4BCrOtmuvy0zffgzwfRKmhOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=uvPUZisx;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B0606A8AA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 13:19:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD5B0606A8AA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=uvPUZisx
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261113131953epoutp01215c7f566ae01f0cfab23a840c6cc128~nnVuzVoGj2254522545epoutp015
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 13:19:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261113131953epoutp01215c7f566ae01f0cfab23a840c6cc128~nnVuzVoGj2254522545epoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794575993;
	bh=DDR4P7HOyvC7IYDwpp7LvapCJ7chv0vTEAbX+6tMHUQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=uvPUZisxTkvb/qMiGTktcpio5EKmJY6gg3/33lGJKeH+y7Q/yMq06ol70J14Niidk
	 P1KIELLoxhxJJussbdkyiQXcO4NcjvX7i8vF2TkPZ/xlKenynIcjiUUATcpBhvJn7P
	 IBmJ3ib8XJJ+/WiI+8aCpDOtNw7C9GW9Ott+cOu0=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261113131953epcas5p36952e24063c2ba1de5549205e7d8facd~nnVuVnxqc1582415824epcas5p32;
	Fri, 13 Nov 2026 13:19:53 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jQyXm3PLYz2SSKZ; Fri, 13 Nov
	2026 13:19:52 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261113131951epcas5p333ff9d5d0526adf49980bd7bd6c4f63c~nnVtMplE21579815798epcas5p3O;
	Fri, 13 Nov 2026 13:19:51 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261113131950epsmtip2242dde28ee4e9b43b1cf87ee71c98bab~nnVrgads80994909949epsmtip2B;
	Fri, 13 Nov 2026 13:19:49 +0000 (GMT)
Message-ID: <1f4d1ad2-e327-41fd-96cc-7ca50f2b3786@samsung.com>
Date: Fri, 13 Nov 2026 18:49:48 +0530
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/8] xfs: implement software write-stream management
To: Hans Holmberg <hans.holmberg@wdc.com>, Anuj Gupta
	<anuj20.g@samsung.com>, brauner@kernel.org, hch@lst.de, djwong@kernel.org,
	dgc@kernel.org, cem@kernel.org, jack@suse.cz, axboe@kernel.dk,
	kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <ea775e38-bce9-4dd1-98c4-5d675b5bd3b5@wdc.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261113131951epcas5p333ff9d5d0526adf49980bd7bd6c4f63c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103111031epcas5p19a4cdbbf45612ff2c541b2aa0bb6cc30
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
	<CGME20261103111031epcas5p19a4cdbbf45612ff2c541b2aa0bb6cc30@epcas5p1.samsung.com>
	<20261103110640.1000095-5-anuj20.g@samsung.com>
	<ea775e38-bce9-4dd1-98c4-5d675b5bd3b5@wdc.com>

On 11/12/2026 6:27 PM, Hans Holmberg wrote:
> None of this is xfs specific, and it defines the uapi semantics, so
> every filesystem implementing these ioctls would have to duplicate it
> and get it exactly right. The CAP_SYS_ADMIN check in particular should
> not depend on the filesystem, and any later relaxation of it (e.g. the
> per-user limit Christoph suggested) will have to live in common code
> anyway.
>   
> Would it not be better to move the generic checks to common code, and
> leave only the xfs specific parts in xfs, i.e. picking the pool for an
> inode and refusing streams for filestream and zoned realtime inodes?

Yes, it would be better. V8 will have that refactoring.
