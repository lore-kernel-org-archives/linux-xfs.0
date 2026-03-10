Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C7339DBCA
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 17:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165340; cv=none; b=erE2lBQYdpyOr22/hVnAkry8UPq+wfDg4lzSESM0z/SpRskFXJNCpjQtzBVbkXrFPBFNM3ws3vOMn7ZD4QZuvUWfG+FUIxc+BsWaNgCTOe23dOq20Ly2pTyXr10VqDs46dRA4SMOehFaWNggeA9NtyFIbygMBDapkmJgaMWIseg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165340; c=relaxed/simple;
	bh=VCU+EpIetXArFMbXxWRS8WogDLF0jb+tsu314Avaalg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=c+y9sCNvsamr6rn9aEWVs71iSdP9suZUrSw9CTtyfl7W/L4wuvcvpYEsTMOXiYPuYDaBRGb/uPyHa9U7+666gfHHwy/8dtT8g2ThrWwgMQKu1Tu6mWIJ7o/WRZQBeGElClTR4F135DtZmPHdWuLH+OaLprJjJJfAkltN1pvj2Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ryuZ1UUw; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ryuZ1UUw"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260310175530epoutp04e43638ccb4c7bda1f29c1fcf59e249ee~bjHkpAGDc1162611626epoutp04V
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 17:55:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260310175530epoutp04e43638ccb4c7bda1f29c1fcf59e249ee~bjHkpAGDc1162611626epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773165330;
	bh=HziSH2/Cf5Alx7OkIwA/epyvhcQF8gIRyPzH4/4FbaI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ryuZ1UUwEEobVWVk0HzhPWygJpRPxXX9OVysCn7JI+FxfltU6zGEHJ9PqQKELr5Li
	 g1evJRuqDQ8xHyIZneLN+Qp7TgEkek/5nvxpvYFkCELWaF3TPqS6jVEm9fvmUiWSZN
	 sAGUY6NYqRmBWoNiEHvHzsqCtDTl9H0SNa5SmlB8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260310175529epcas5p4c8b08a7af0c347f8db0b0e4d242ece17~bjHj4oFW30201002010epcas5p4k;
	Tue, 10 Mar 2026 17:55:29 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.92]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4fVhPD3xKFz3hhT3; Tue, 10 Mar
	2026 17:55:28 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260310175527epcas5p4b20cd0d70a4401b7b213d97540aa43c6~bjHifQe6C0660906609epcas5p4P;
	Tue, 10 Mar 2026 17:55:27 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260310175526epsmtip196e441f42f3ac81bbdbafeb74fc677c7~bjHg9Tcpl2031820318epsmtip1M;
	Tue, 10 Mar 2026 17:55:26 +0000 (GMT)
Message-ID: <2cde8902-6d50-4035-b9c4-89bd5e2c9468@samsung.com>
Date: Tue, 10 Mar 2026 23:25:25 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] fs: add generic write-stream management ioctl
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, jack@suse.cz, cem@kernel.org,
	kbusch@kernel.org, axboe@kernel.dk, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, gost.dev@samsung.com,
	linux-api@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260309163325.GE6033@frogsfrogsfrogs>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260310175527epcas5p4b20cd0d70a4401b7b213d97540aa43c6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260309053427epcas5p23419afbe49e4e35526388601e162ee94
References: <20260309052944.156054-1-joshi.k@samsung.com>
	<CGME20260309053427epcas5p23419afbe49e4e35526388601e162ee94@epcas5p2.samsung.com>
	<20260309052944.156054-2-joshi.k@samsung.com>
	<20260309163325.GE6033@frogsfrogsfrogs>

On 3/9/2026 10:03 PM, Darrick J. Wong wrote:
>> +struct fs_write_stream {
>> +	__u32		op_flags;	/* IN: operation flags */
>> +	__u32		stream_id;	/* IN/OUT:  stream value to assign/guery */
>> +	__u32		max_streams;	/* OUT: max streams values supported */
>> +	__u32		rsvd;
>> +};
> This isn't an very cohesive interface -- GET_MAX probably only needs
> op_flags and max_streams, right?  And GET/SET only use op_flags and
> stream_id, right?

Yeah, right. That's the trade-off with swiss army knife type ioctl which 
uses op_flags to decide what it should do. Apart from keeping a single 
ioctl I was thinking a bit about extensibility (for anything new we may 
be able to do a new op_flags with some rsvd or union) too. But if you 
feel strong about this, I can take 3 ioctl route?

>> +#define FS_WRITE_STREAM_OP_GET_MAX		(1 << 0)
>> +#define FS_WRITE_STREAM_OP_GET			(1 << 1)
>> +#define FS_WRITE_STREAM_OP_SET			(1 << 2)
>> +
>> +#define FS_IOC_WRITE_STREAM		_IOWR('f', 43, struct fs_write_stream)
> EXT4_IOC_CHECKPOINT already took 'f' / 43.  I/think/ there's no problem
> because its argument is a u32 and ioctl definitions incorporate the
> lower bits of of the argument size but you might want to be careful
> anyway.

Indeed, thanks!
