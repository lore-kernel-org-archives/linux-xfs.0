Received: from a27-52.smtp-out.us-west-2.amazonses.com (a27-52.smtp-out.us-west-2.amazonses.com [54.240.27.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24FCA47
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 01:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.27.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713315831; cv=none; b=qstuNUhf/Nhil3Ld7HGe2G1hFt/d3ZaJ2Jyp13YHrh35wkLoYqlo7LOlnBTDpqg356GE7PXFMPTU/5cEIctiM1fdTRgQSXEjkB6C5ZtlP2cH3OLoIC3pEf/jVbshCdENLGvO7sv5TCpiTyQkgAE1ZAEdykGZGalqw/XXs2PbFFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713315831; c=relaxed/simple;
	bh=ACt/YU7mRu6rYSa4MEYKGPxGiIl1Q19ovy+YJkphELs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WvVNc2ddtTVCJLSvT51t/HrNlgfEba7UmvI/DWO/hRt8UQh9iAv1sSQTaD3AgMnqzWGlg0WPbB2tqLK5OXtSTpTdiP0PQzGcXWSpzENS1F/pxWWulju2sENdfzR5duzxT71h6OhwAFc65La8lDRLZqOarpdMenc4l3Z7SiX5Dp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rutile.org; spf=pass smtp.mailfrom=us-west-2.amazonses.com; dkim=pass (1024-bit key) header.d=rutile.org header.i=@rutile.org header.b=YIur1B0K; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=l6lAYBTT; arc=none smtp.client-ip=54.240.27.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rutile.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=us-west-2.amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rutile.org header.i=@rutile.org header.b="YIur1B0K";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="l6lAYBTT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=cd6jqasjwj7rkm4pcqvzv2v4wr47yxhv; d=rutile.org; t=1713315829;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ACt/YU7mRu6rYSa4MEYKGPxGiIl1Q19ovy+YJkphELs=;
	b=YIur1B0KCB1dTuIEXtUShJZDi5pygakd/9eGnb5L4ES8BQ4ARuCYzTgh5UWcnZ1n
	d1KG6WJkmY+Ru+MXvy6PmAKxzboo//KVkrYEodTWT34cwu/CepSYCmvQiu0Y9kjdkiU
	cCa5FzwDYqsSz36HrimGnZjmpjj4dnhFwyRSS8Ys=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=7v7vs6w47njt4pimodk5mmttbegzsi6n; d=amazonses.com; t=1713315829;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
	bh=ACt/YU7mRu6rYSa4MEYKGPxGiIl1Q19ovy+YJkphELs=;
	b=l6lAYBTTsEX5byL+RtZ+RkasqU8I1dc5kSuN9L8NgxW+sUL4shAVhro97p6vt+UF
	CJK2IC8WhYYLM6LOmSDbtNVfruphV9SNC8JYF1Wngg4JRWt+j1YKGmcWJyHMr6OqX+7
	QKwP43crUit3Mu4/fVVpnrGzUzMJEWdYYTY2wYRo=
Message-ID: <0101018ee994d5c1-fafa8e6b-6d23-4182-9164-7bd5b33eab19-000000@us-west-2.amazonses.com>
Date: Wed, 17 Apr 2024 01:03:49 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: linux-xfs.ykg@rutile.org
Subject: Re: Question about using reflink and realtime features on the same
 filesystem
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <0101018ee939dd0d-f4f89d16-04ff-44ae-97f6-541a30117a4d-000000@us-west-2.amazonses.com>
 <20240417002639.GJ11948@frogsfrogsfrogs>
Content-Language: en-US
In-Reply-To: <20240417002639.GJ11948@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Feedback-ID: 1.us-west-2.IG/R7L46ohk7VXbk73xp5DybEdSON9tjwQLyIAtkjJo=:AmazonSES
X-SES-Outgoing: 2024.04.17-54.240.27.52

On 4/16/2024 17:26, Darrick J. Wong wrote:
> On Tue, Apr 16, 2024 at 11:24:27PM +0000, linux-xfs.ykg@rutile.org wrote:
>> Greetings,
>>
>> I was attempting to use mkfs.xfs on Linux Mint 21 (kernel 6.5.0, xfsprogs
>> 5.13.0) and ran into an error trying to use realtime and reflink features on
>> the same filesystem. Is there anything I'm doing wrong, or is this
>> combination simply not supported on the same filesystem?
>>
>> The exact command I ran was:
>> mkfs.xfs -N -r rtdev=/dev/sda1,extsize=1048576 -m reflink=1 /dev/sda2
>>
>> Which returned with:
>> reflink not supported with realtime devices
>>
>> Just to be clear - I didn't expect to be able to use reflinking on realtime
>> files (*), but I did expect to be able to have realtime files and reflinked
>> non-realtime files supported on the same filesystem. With my limited
>> knowledge of the inner workings of XFS, those two features _seem_ like they
>> could both work together as long as they are used on different inodes. Is
>> this not the case?
> 
> It's not supported, currently.  Patches have been out for review since
> 2020 but have not moved forward due to prioritization and backlog issues.
> Sorry about that. :(
> 
> https://lore.kernel.org/linux-xfs/160945477567.2833676.4112646582104319587.stgit@magnolia/
> 
> --D
> 
>> Thanks,
>> Reed Wilson
>>
>>
>>
>> (*) I noticed that there were recent commits for reflinking realtime files,
>> but that's not really what I was looking for
>>
>>
> 


Thanks for the quick response. It's not really a big problem in my case; I can
work around it fairly easily. I mostly wanted to verify that it's not a supported
configuration since I couldn't find any documentation to that effect.

Thanks again!
Reed Wilson
