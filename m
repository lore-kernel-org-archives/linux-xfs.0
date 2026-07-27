Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17CC28AB0B
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785161680; cv=none; b=R2Uxh/04+GYM0rISrFxqWbuKq/1YquXI21ug77rKeZ+QocI7MjLxvnF5vsyueRF/48oS9MCMAMKBvfZO8q6ibouZAdbR7BRIllHG1BJ7QMSjva37yx6HD60LbfGRBzdgHCQ4OZUaLbQUkwW88wTw/QFpzRVMYvWQm7rlDYhQQos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785161680; c=relaxed/simple;
	bh=eKHFSO+ds2gOJiJYXNqitUVpph0pIlyv/tlBdPX2qlI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=cjYjiolTHKkhiSQmaMolVLuzEK3vAQxHHeIvZ3a6R9jNvVZisgS1B/wetGzL0bU21qDd1IblF9Vf1GqhlFShENaKzIxxYHbHad9gfK0ppopkmRzQHxW2ydBoN3wdUsJ2GyWG53EQ01d1GudKa2k8RolWLzUP1tLQhRJwiCSEILw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CJq2OKHU; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CJq2OKHU"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260727141436epoutp015d4e771fc499f9d98fea9ae7322154a4~GKxYlPvOx2658626586epoutp01c
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:14:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260727141436epoutp015d4e771fc499f9d98fea9ae7322154a4~GKxYlPvOx2658626586epoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785161676;
	bh=D/JMmRRYNZbh+t3oK1GKPHh/JRzQcE933XPUTJwvp3g=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=CJq2OKHUnj1AMnp2oYPopTtz4rkD6kUoMggBDKZPI1dyyioFPpf3mifNChVFazzUJ
	 4TXk8PNRezTLeMhp7eRjURqdAWmMjhKDGcGjgN6ldEkWie8akXVw+QzjoB85y0Nk4K
	 vA0R52UtnXK+XI8gjwD4lVgYvPJ3IfBdfQO2Arx4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260727141435epcas5p46366ef6b355d50e3cf78b8504cacc0c0~GKxX4AFd-1610916109epcas5p4q;
	Mon, 27 Jul 2026 14:14:35 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.90]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4h80wB6Ccwz2SSKY; Mon, 27 Jul
	2026 14:14:34 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260727141434epcas5p4affbf1329c37edaeb20f1ac5ec2f247e~GKxWyvnQr3019630196epcas5p4B;
	Mon, 27 Jul 2026 14:14:34 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260727141433epsmtip10af5b3be92436c1bf32bf31d07f1c218~GKxVlR0cQ1873218732epsmtip1X;
	Mon, 27 Jul 2026 14:14:33 +0000 (GMT)
Message-ID: <65cd47a4-eef5-43c5-a336-0a5693e5e4f1@samsung.com>
Date: Mon, 27 Jul 2026 19:44:32 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/22] xfs: add support for lazy direct read bounce
 buffering
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian
	Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Carlos
	Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <20260723145000.116419-21-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260727141434epcas5p4affbf1329c37edaeb20f1ac5ec2f247e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260723145144epcas5p4c78e8b6d81ed76935bff66479dff874e
References: <20260723145000.116419-1-hch@lst.de>
	<CGME20260723145144epcas5p4c78e8b6d81ed76935bff66479dff874e@epcas5p4.samsung.com>
	<20260723145000.116419-21-hch@lst.de>

On 7/23/2026 8:19 PM, Christoph Hellwig wrote:
> +static ssize_t
> +read_bounce_store(
> +	struct kobject	*kobj,
> +	const char	*buf,
> +	size_t		count)
> +{
> +	struct xfs_mount	*mp = csum_to_mp(kobj);
> +
> +	if (!strcmp(buf, "never"))
> +		WRITE_ONCE(mp->m_read_bounce, XFS_READ_BOUNCE_NEVER);
> +	else if (!strcmp(buf, "always"))
> +		WRITE_ONCE(mp->m_read_bounce, XFS_READ_BOUNCE_ALWAYS);
> +	else if (!strcmp(buf, "lazy"))
> +		WRITE_ONCE(mp->m_read_bounce, XFS_READ_BOUNCE_LAZY);
it returns a -EINVAL always.

# echo always > /sys/fs/xfs/nvme0n1/csum/read_bounce
bash: echo: write error: Invalid argument

Maybe use sysfs_streq here?

