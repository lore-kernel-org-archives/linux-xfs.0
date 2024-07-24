Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD7A13A3E0
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 22:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721860730; cv=none; b=RtbpwZckba5nyDd3b+r71kMHYUlT9B1O9G2lCS8DcD5vQfgVIdf/FpwzZ/ikVcXlNYUe8TvoC5uffr1CNLrpGhQ+vtBKZXSBncFwhK7O6txdOFcJJGlrVRAr6/5IuLGBThOpx6aaZoC+2+a/e3Sp5nxCKznqnZHkIfoxqf2Yy3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721860730; c=relaxed/simple;
	bh=3KlVcwpXFBQEHBO3vkjHI/k5eNg6fyg6gzPoyeQUFZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s8cvOV3pN9J2V0rZOWhQpz/mKHgL8Q5WURQk86bJK/hIdZnzP8NqZr49MbteMQ5hR7WVFhEe9eQT9nyiEWVblYR+yMpqRJPnAUIY3NbZXIFksS1rZway5+Z0Yrgb5y+mO7UPQkHdEev63+LpncCGFIcO/3zp5ygk9IAj312Qigg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=frMcwp/k; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="frMcwp/k"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id CBD615CCE30;
	Wed, 24 Jul 2024 17:38:47 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net CBD615CCE30
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1721860727;
	bh=peb54OYwigvFgr7WVaiKWQj/ZazkcW3538zV4ts45mw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=frMcwp/kx2je9jDwfMgd9ifvJIMIWIRTP69A1/0GnDDduhhTClx2QKt1NAgyZ6C6B
	 c2FzhSILvZydjedQ78fCxoH0VLgy4skVYep90oY/l0WCGJAuuTDPMCR/nXGSx5j31T
	 m4SnBXtHNtOxB+gfBPGLuVjptktW9D2ll8ToOIgTYeYjfXFpSzCOvpeAl18ogxbGX7
	 zyiFNbNEUX7eHoofnYIEc/ca+YJWpp9ECGiPDjW2shwpQEKVLoQZg9+wioyujBcv0j
	 sl+O2bVn8XagubAvdQbS8TjV77QVuk3v/jy7Y/8oLnqrBWwSWgGstY0FLny5v8u5Sh
	 74aGPFhzJeeuA==
Message-ID: <5ccb5a51-75c0-41eb-92ff-a2ce5674ac0f@sandeen.net>
Date: Wed, 24 Jul 2024 17:38:46 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20240721230100.4159699-1-david@fromorbit.com>
 <345207bd-343a-417c-80b9-71e3c8d4ff28@sandeen.net>
 <20240724221233.GB612460@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20240724221233.GB612460@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/24/24 5:12 PM, Darrick J. Wong wrote:
> On Wed, Jul 24, 2024 at 05:06:58PM -0500, Eric Sandeen wrote:
>> On 7/21/24 6:01 PM, Dave Chinner wrote:
>>> +The solution should already be obvious: we can exploit the sparseness of FSBNO
>>> +addressing to allow AGs to grow to 1TB (maximum size) simply by configuring
>>> +sb_agblklog appropriately at mkfs.xfs time. Hence if we have 16MB AGs (minimum
>>> +size) and sb_agblklog = 30 (1TB max AG size), we can expand the AG size up
>>> +to their maximum size before we start appending new AGs.
>>
>> there's a check in xfs_validate_sb_common() that tests whether sg_agblklog is
>> really the next power of two from sb_agblklog:
>>
>> sbp->sb_agblklog != xfs_highbit32(sbp->sb_agblocks - 1) + 1
>>
>> so I think the proposed idea would require a feature flag, right?
>>
>> That might make it a little trickier as a drop-in replacement for cloud
>> providers because these new expandable filesystem images would only work on
>> kernels that understand the (trivial) new feature, unless I'm missing
>> something.
> 
> agblklog and agblocks would both be set correctly if you did mkfs.xfs -d
> agsize=1T on a small image; afaict it's only mkfs that cares that
> dblocks >= agblocks.

Yes, in a single AG image like you've suggested.

In Dave's proposal, with multiple AGs, I think it would need to be handled.

-Eric

> --D
> 
>> -Eric
>>
> 

