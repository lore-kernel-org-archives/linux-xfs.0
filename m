Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7359B15CE
	for <linux-xfs@vger.kernel.org>; Sun, 11 Feb 2024 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707683954; cv=none; b=m3/6YHAIhdOgA0Qh8+EadkBiUSUUuz7TlY4BWmP70q5mipdSJ8kZyFYcNG8MaGudWJ9GFIzQo/UU0KeuL3KkrBsdYfwxdNgNdkf8gWdCmLC2KE3OgkPHHqxuOnYphtGrYH1EmfxHweU/SNIzkZJ60He8wYDAxlam/vhWjnIQfsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707683954; c=relaxed/simple;
	bh=W80r4kbaGQP/B0vqZ3irgLvCtBb0jITDfW2UuYf1wYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pOUcHC1DPYEKbcJrk2lE6LrZfe9qfUioWq8mCIeB0OzapvMI1J+OxPJl2ifAXFXgYk/WUyhZcT8tDbuUVBuOhz9xnbkqZ4+744FadkTcx4jL6uUiImrzqIb5sXF8lli1PcyYheipHX5/f/LCB2S39Rh6HOUWAB0IPHUQaiVtfgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=HMF85bLo; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="HMF85bLo"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 511764CEBA2;
	Sun, 11 Feb 2024 14:39:05 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 511764CEBA2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1707683945;
	bh=GR43HhiY3mLizgIxGcKQMI8KZ+/Af7wmKYM12r6aFEY=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=HMF85bLooXM7+KTb+LIK9LPuuF+UztjyFIscY9MJsZXIXa47jHuZvdyfYO6ypKh5U
	 Zw92gF89K9JuhRlhHN27QYzShUQqp9eCwKPyc41yaS2EAszhzcXHzeGjbNnZ/SiyZX
	 n10BLlEadzKIcAAcIEC9r+6PVnZ8Eoqg0FpPCJwZ/yvTUoe9SVx23TYXLU78XN92oy
	 um+Hs1I99c8+E8vzGmvqsafEmv8M860nF2whwlmyyZMNerbUHqrwIF8rHTc4CUP7S1
	 JrIRo4OjY1oS9SX9tdlrNrC+o4RVosn2KYkGyFrI/uE4jpLsCImKK3+3GvHMIoBxrb
	 xLN67ZBmdgGFA==
Message-ID: <6ecca473-f23e-4bb6-a3c3-ebef6d08cc7e@sandeen.net>
Date: Sun, 11 Feb 2024 14:39:04 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: XFS corruption after power surge/outage
Content-Language: en-US
To: Jorge Garcia <jgarcia@soe.ucsc.edu>, linux-xfs@vger.kernel.org
References: <CAMz=2cecSLKwOHuVC31wARcjFO50jtGy8bUzYZHeUT09CVNhxw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAMz=2cecSLKwOHuVC31wARcjFO50jtGy8bUzYZHeUT09CVNhxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/9/24 12:39 PM, Jorge Garcia wrote:
> Hello,
> 
> We have a server with a very large (300+ TB) XFS filesystem that we
> use to provide downloads to the world. Last week's storms in
> California caused damage to our machine room, causing unexpected power
> surges and power outages, even in our UPS and generator backed data
> center. One of the end results was some data corruption on our server
> (running Centos 8). After looking around the internet for solutions to
> our issues, the general consensus seemed to be to run xfs_repair on
> the filesystem to get it to recover. We tried that (xfs_repair V 5.0)
> and it seemed to report lots of issues before eventually failing
> during "Phase 6" with an error like:
> 
>   Metadata corruption detected at 0x46d6c4, inode 0x8700657ff8 dinode
> 
>   fatal error -- couldn't map inode 579827236856, err = 117
> 
> After another set of internet searches, we found some postings that
> suggested this could be a bug that may have been fixed in later
> versions, so we built xfs_repair V 6.5 and tried the repair again. The
> results were the same. We even tried "xfs_repair -L", and no joy. So
> now we're desperate. Is the data all lost? We can't mount the
> filesystem. We tried using xfs_metadump (another suggestion from our
> searches) and it reports lots of metadata corruption ending with:

I was going to suggest creating an xfs_metadump image for analysis.
Was that created with xfsprogs v6.5.0 as well?

> Metadata corruption detected at 0x4382f0, xfs_cntbt block 0x1300023518/0x1000
> Metadata corruption detected at 0x4382f0, xfs_cntbt block 0x1300296bf8/0x1000
> Metadata corruption detected at 0x4382f0, xfs_bnobt block 0x137fffb258/0x1000
> Metadata corruption detected at 0x4382f0, xfs_bnobt block 0x138009ebd8/0x1000
> Metadata corruption detected at 0x467858, xfs_inobt block 0x138067f550/0x1000
> Metadata corruption detected at 0x467858, xfs_inobt block 0x13834b39e0/0x1000
> xfs_metadump: bad starting inode offset 5

so the metadump did not complete?

Does the filesystem mount? Can you mount it -o ro or -o ro,norecovery
to see how much you can read off of it?

If mount fails, what is in the kernel log when it fails?

> Not sure what to try next. Any help would be greatly appreciated. Thanks!

Power losses really should not cause corruption, it's a metadata journaling
filesytem which should maintain consistency even with a power loss.

What kind of storage do you have, though? Corruption after a power loss often
stems from a filesystem on a RAID with a write cache that does not honor
data integrity commands and/or does not have its own battery backup.

-Eric

> Jorge
> 

