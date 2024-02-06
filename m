Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCC8127B6B
	for <linux-xfs@vger.kernel.org>; Tue,  6 Feb 2024 06:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707201938; cv=none; b=sooz/ATn6mVqP9mWuSOINHqoLPhLb6L1sVvgexCW3r4PS6S3ETu2e85hFORRhhAQdjjs5e/7svtPlek8jggleQ/RhLYSoU8s9Sb98G3mfZ9JDSQApjclIa3A5Jvb1A+X9sVEwyrYdiyL6nxLpVck3PljHkb6CVUsRQwFcL4xvis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707201938; c=relaxed/simple;
	bh=gpGcYWZ/RqijVBiIVZCzl8XRP6D9ch1xlS3XgGqLOGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DAczoO4DnUqJxw97uZbX1p+GVgZwpxMB8PaYCs9Xyo7HqFT8KX5aD0lwtTOCFUhg11LOGYz6mms8bDnbcLseqGeXy1OLnF0uFbKxdhvobFN9B7wM/PYOzcx1gZTBmTFJhWCw3zOqJfCz+xFjEOYLJrrtrcXwBQXmaUGNHcDfqL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.1.122] (ip5f5ae993.dynamic.kabel-deutschland.de [95.90.233.147])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id DD97E61E5FE01;
	Tue,  6 Feb 2024 07:45:22 +0100 (CET)
Message-ID: <c171c058-fc69-4e47-aca1-c1a35a774038@molgen.mpg.de>
Date: Tue, 6 Feb 2024 07:45:22 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [QUESTION] zig build systems fails on XFS V4 volumes
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
References: <1b0bde1a-4bde-493c-9772-ad821b5c20db@molgen.mpg.de>
 <ZcAICW2o5pg7eVlM@dread.disaster.area>
 <39caab25-bf87-4a62-814d-b67f9c81a6e0@molgen.mpg.de>
 <ZcFPf8R8geZwBgIV@dread.disaster.area>
Content-Language: en-US
From: Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <ZcFPf8R8geZwBgIV@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/24 22:13, Dave Chinner wrote:
> On Mon, Feb 05, 2024 at 02:12:43PM +0100, Donald Buczek wrote:
>> On 2/4/24 22:56, Dave Chinner wrote:
>>> On Sat, Feb 03, 2024 at 06:50:31PM +0100, Donald Buczek wrote:
>>>> Dear Experts,
>>>>
>>>> I'm encountering consistent build failures with the Zig
>>>> language from source on certain systems, and I'm seeking
>>>> insights into the issue.
>>>>

> The reason for this difference seems obvious: there's a distinct
> lack of stat() calls in the ftype=0 (bad) case. dirent->d_type in
> this situation will be reporting DT_UNKNOWN for all entries except
> '.' and '..'. It is the application's responsibility to handle this,
> as the only way to determine if a DT_UNKNOWN entry is a directory is
> to stat() the pathname and look at the st_mode returned.

You've nailed it. [1][2]

I'll take this over to the zig community.

Thanks!

   Donald

[1]: https://github.com/ziglang/zig/blob/39ec3d311673716e145957d6d81f9d4ec7848471/lib/std/fs/Dir.zig#L372
[2]: https://github.com/ziglang/zig/blob/39ec3d311673716e145957d6d81f9d4ec7848471/lib/std/fs/Dir.zig#L669

> 
> The code is clearly not doing this, and so I'm guessing that the zig
> people have rolled their own nftw() function and didn't pay
> attention to the getdents() man page:
> 
> 	Currently,  only some filesystems (among them: Btrfs, ext2,
> 	ext3, and ext4) have full support for returning the file
> 	type in d_type.  All applications must properly handle a
> 	return of DT_UNKNOWN.
> 
> So, yeah, looks like someone didn't read the getdents man page
> completely and it's not a filesystem issue.
> 
> -Dave.

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
