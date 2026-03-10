Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB293D812A
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 17:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165526; cv=none; b=mNjtdPmCXV4D4dJ6zdxWVyfYQn2ebHJ8N0sUIsxacSkBy35qAFbiC5k5YAvyzsevEUqgF5/qEoBr+xW8gg6428mUCO8N6wSya+HlXnUYpUXCi+dQeEg4O7cG86+nvmZmmWV0MsjHG74Uauf+tvELAgESlJn2zv10UkURBnN4bqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165526; c=relaxed/simple;
	bh=wEJOBh2NlInZXFFEuHXzo2nJZQ5UFeZc6PCjSkQQA9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=IXozMOvZznlIf0lWmQqBDz04jznqR0UngKdud+BzdbBbQuJpUyu24QRIdb9foG38KxACzgoFam6PQyc8iEJbzntrLOleR0xct6MeOCjikbwjBOINjEZYPv90Y65lMLr2TsJoO7woukeLdg23bp93QU9xQGJWpGf0CyC361Dy53w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ELuGW08m; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ELuGW08m"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260310175835epoutp01fb6be3ffd0fcaa6e63cf62db52993d5b~bjKRHcNzt0532305323epoutp01M
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 17:58:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260310175835epoutp01fb6be3ffd0fcaa6e63cf62db52993d5b~bjKRHcNzt0532305323epoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773165515;
	bh=Y064StOmPwr6lQ0PMnnAJLXtBD9ksvl/A1W65AZe5Eg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ELuGW08mdeaJWnsQoTZyQ5RbMmZUySEKGftBs2rjKB9hKyOw2FME+7zNXx34kETrs
	 SxxENQjEJ3KGfaCg63zYXAtrvEUnGJ/8xJ1Zlyb9Cw2C81cUZ30SuP9W/AJmcOgnNB
	 X7xEjS5wweA6Vh16GZB/GeZ5CyGL3vJ4UxshAbxI=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260310175835epcas5p3ba8a95052199ee25dfb8daa22d4c6e3d~bjKQxXHor2493224932epcas5p3h;
	Tue, 10 Mar 2026 17:58:35 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4fVhSp28Whz6B9m4; Tue, 10 Mar
	2026 17:58:34 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260310175833epcas5p378d51d27f5e55e915cbd4995c4602998~bjKPcd1Dy2493224932epcas5p3d;
	Tue, 10 Mar 2026 17:58:33 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260310175832epsmtip26a411643b284d122fa83a745dc6891cf~bjKOD2Y1q1376813768epsmtip2A;
	Tue, 10 Mar 2026 17:58:32 +0000 (GMT)
Message-ID: <7ee6ec73-6316-4746-8556-869073f2dbd2@samsung.com>
Date: Tue, 10 Mar 2026 23:28:31 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] iomap: introduce and propagate write_stream
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, jack@suse.cz, cem@kernel.org,
	kbusch@kernel.org, axboe@kernel.dk, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, gost.dev@samsung.com
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260309163449.GF6033@frogsfrogsfrogs>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260310175833epcas5p378d51d27f5e55e915cbd4995c4602998
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260309053430epcas5p3db87d346a4a816f385becac0212cd3ab
References: <20260309052944.156054-1-joshi.k@samsung.com>
	<CGME20260309053430epcas5p3db87d346a4a816f385becac0212cd3ab@epcas5p3.samsung.com>
	<20260309052944.156054-3-joshi.k@samsung.com>
	<20260309163449.GF6033@frogsfrogsfrogs>

On 3/9/2026 10:04 PM, Darrick J. Wong wrote:
>>   	u64			length;	/* length of mapping, bytes */
>>   	u16			type;	/* type of mapping */
>>   	u16			flags;	/* flags for mapping */
>> +	/* 4-byte padding hole here */
> It's 3 bytes now, right? 😉

:-) Yup. Fat finger/brain. I wrote the comment first, and added the 
field afterwards.
