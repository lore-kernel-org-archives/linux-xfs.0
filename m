Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3023C4165
	for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2026 19:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792264922; cv=none; b=fuADvTiaF0qZseAUCMZAXHNA4ZR8TbmbY6nV/bBrVdJONXh1h5c6FKsloK3WtPAHG55YQpeW9qal+6FbV1+bhpi5GdFBbcXp7LksPBjSUkS/U4VPSJye7nQ8xKoxt/RiK3GeluM10M+9ri+whmLoBIAo85kWN7GpKSGENuwUpIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792264922; c=relaxed/simple;
	bh=pUJ4t6fYR66T5Chk1hsszLOax4EyulaPaTgUdunIi44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=oXJQopX+O4BmFgL+EL+dZ6p6EMD2eYiASzrDf9xp5lTGory28Zo3+H26wyUsR33BvioeZ+DFkaXkDLgDwx0bPupO9ubdalNLQ/TnrJGEiGT8tbjDPgU4bQaAJbZKY9GhRPvAqaMrbwQ/Jvh2huRSCMDcGNUW2G/vDREfxf0ZScg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Zt4EsW5z; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Zt4EsW5z"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261017192157epoutp033995d0e151b77f66a248eb375970cc92~fZ3JVfJ2W1811518115epoutp034
	for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2026 19:21:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261017192157epoutp033995d0e151b77f66a248eb375970cc92~fZ3JVfJ2W1811518115epoutp034
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792264917;
	bh=xD9a7NYCcup25z9n2LZtGalPFX/FDsci29c5QBnpFK8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Zt4EsW5zUnVLcQK4HfKmcrRTQSw4l/MQLTDlVlaxv91K6KNeK51vTLPMPUUf94JrW
	 SVJUxZ5HN1fuILCxQ2nauLvZezldx6Wdti8bKb2yjwT/AoWl0dj7CKDi8gvqQKIga/
	 Qu1y7EwWjcYUpjwtm2OkEAGXPGp6F03Apni2Kweg=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20261017192156epcas5p13d48c930f366ce79c27e31d461d2116c~fZ3Ii0ae40315903159epcas5p1r;
	Sat, 17 Oct 2026 19:21:56 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4j6Wrz6fbkz2SSKY; Sat, 17 Oct
	2026 19:21:55 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20261017192155epcas5p4ff4047dbc7a3d0f719fd0e5e3df983b7~fZ3HE24RB1137011370epcas5p4L;
	Sat, 17 Oct 2026 19:21:55 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261017192153epsmtip2c88ae0eebde1a6ed6a5223b78b45fd98~fZ3FOFagN2000820008epsmtip2I;
	Sat, 17 Oct 2026 19:21:52 +0000 (GMT)
Message-ID: <a6be7644-f04c-4af9-a49b-97d8997f90aa@samsung.com>
Date: Sun, 18 Oct 2026 00:51:52 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/8] xfs write streams
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, cem@kernel.org,
	jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20261016204321.GN107986@frogsfrogsfrogs>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261017192155epcas5p4ff4047dbc7a3d0f719fd0e5e3df983b7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261015063425epcas5p23fd76d70af639f4bb138332ca3a575b0
References: <CGME20261015063425epcas5p23fd76d70af639f4bb138332ca3a575b0@epcas5p2.samsung.com>
	<20261015063246.103433-1-joshi.k@samsung.com>
	<bf0505d2-115d-43e9-95e8-2ed6a3404799@samsung.com>
	<20261016204321.GN107986@frogsfrogsfrogs>

On 10/17/2026 2:13 AM, Darrick J. Wong wrote:
> On Fri, Oct 16, 2026 at 11:20:41AM +0530, Kanchan Joshi wrote:
>> Christoph, Darrick
>>
>> The shape of the series is aligned with your feedback on v4 [1].
>> Possible to take a look and tell if anything should be changed?
> I sent a few comments

Thanks.

>, but the big thing missing here is a design
> document -- what problem are you trying to solve by adding the ability
> to group files in flocks?  How mandatory vs. opportunistic is the stream
> id? etc.  

I guess you are not asking for answers here (given the cover letter, 
commit description, past discussions etc). But under a new file in 
'Documentation/filesystems".

> What about Dave's comments about hard constraining files to
> particular AGs?

I had replied here:
https://lore.kernel.org/linux-xfs/ef9844a0-3a9f-48e4-8092-2de2e03db1c8@samsung.com/#t

In short, hard placement into a specific AG/RG (returning ENOSPC when 
full) is a distinct XFS-specific contract and is better served by an XFS 
ioctl rather than a generic interface. And, nothing in this series 
prevents adding such an ioctl later, and perhaps some of the code can be 
reused.

Write-stream remains a layout-agnostic information, about file 
relationship/lifecycle, provided by the application. This equips the 
allocator (of device or FS) to do better spatial isolation than it could 
otherwise.
