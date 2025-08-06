Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C670322068D
	for <linux-xfs@vger.kernel.org>; Wed,  6 Aug 2025 08:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754467599; cv=none; b=KO/IqrKlzvbivZj0AXIp2OswKPa6KdkjP67kFzf1O1v/jfU+cksPav7KqA186rI8i2ZdwkEN7z7hJgMF80+4LjFjFIzaad6v9lNlq61so8owuLeWXB/iRTr71bQ7+5QWXaVcoSdPa5ModD5zsXTy0wfrTzUKY2zEgBjwNrRr/no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754467599; c=relaxed/simple;
	bh=okCLx9ivfwRok/UoEOvdiEYEDl7oyM98a3NcqOYINNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UDCwq00gZAho2sBnuNt5k8niTNZ7QW9m1hGA3OP4EWS6+JKDv+/XT5x7S2Dy1HHldFhgLotI29nO+drOEANgekFUTnYqBvT7xsUaDpdiPHUr+248/sCxhNqgmzWnm+PyjRO69Pc1kEdIHqUUwVzcTXHmQUGIJlhvwdMsUbAFYs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=To7/jWui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="To7/jWui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD444C4CEE7;
	Wed,  6 Aug 2025 08:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754467599;
	bh=okCLx9ivfwRok/UoEOvdiEYEDl7oyM98a3NcqOYINNo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=To7/jWuiPYqYh2Jeyv5f77jtX9h6HGmBwfX5YeThEyCuYcaypi7iDIhYEJUqUh3hw
	 fShcvVQfzFXx3J6zCXGr0ieynRAez5FS1acVDU5bjoc/sTA4mOdl5E+WGY8V3P+uHt
	 EQhzKhskDTie7QG2f6uQZ62xk1Xxq2HrMpRBxgkxoF2SQ2j0pyFRmGuQyWwPpsKxd2
	 Dfkjwaiamol7G/6op0xSn2rSSIkNfRbBWvKBVofJL/77QmpYvNt2Mm4g+x+b9Ea3jn
	 6aHsHMB8sKAdlCbbpiAVFQFcnKIzwqniBKnfdINxJ3Gn7eTp8zUVkUL5L+dmFd8fZF
	 s8dpMt7FsZ1/Q==
Message-ID: <756f897c-37d3-47ea-8026-14e21ec3bb1a@kernel.org>
Date: Wed, 6 Aug 2025 17:04:05 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Select XFS_RT if BLK_DEV_ZONED is enabled
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <04bqii558CCUiFEGBhKdf6qd18qly22OSKw2E3RSDAyvVmxUF09ljpQZ7lIfwSBhPXEsfzj1XUcZ29zXkR2jyQ==@protonmail.internalid>
 <20250806043449.728373-1-dlemoal@kernel.org>
 <q5jrbwhotk5kf3dm6wekreyu5cq2d2g5xs3boipu22mwbsxbj2@cxol3zyusizd>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <q5jrbwhotk5kf3dm6wekreyu5cq2d2g5xs3boipu22mwbsxbj2@cxol3zyusizd>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/6/25 4:46 PM, Carlos Maiolino wrote:
> On Wed, Aug 06, 2025 at 01:34:49PM +0900, Damien Le Moal wrote:
>> Enabling XFS realtime subvolume (XFS_RT) is mandatory to support zoned
>> block devices. If CONFIG_BLK_DEV_ZONED is enabled, automatically select
>> CONFIG_XFS_RT to allow users to format zoned block devices using XFS.
>>
>> Also improve the description of the XFS_RT configuration option to
>> document that it is reuired for zoned block devices.
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>  fs/xfs/Kconfig | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
>> index ae0ca6858496..c77118e96b82 100644
>> --- a/fs/xfs/Kconfig
>> +++ b/fs/xfs/Kconfig
>> @@ -5,6 +5,7 @@ config XFS_FS
>>  	select EXPORTFS
>>  	select CRC32
>>  	select FS_IOMAP
>> +	select XFS_RT if BLK_DEV_ZONED
> 
> This looks weird to me.
> Obligating users to enable an optional feature in xfs if their
> kernel are configured with a specific block dev feature doesn't
> sound the right thing to do.
> What if the user doesn't want to use XFS RT devices even though
> BLK_DEV_ZONED is enabled, for whatever other purpose?

This does not force the user to use XFS_RT, it only makes that feature
available for someone wanting to format e.g. an SMR HDD with XFS.
I am not sure how "costly" enabling XFS_RT is if it is not used. There is for
sure some xfs code size increase, but beside that, is it really an issue ?

> Forcing enabling a filesystem configuration because a specific block
> feature is enabled doesn't sound the right thing to do IMHO.

Well, it is nicer for the average user who may not be aware that this feature
is needed for zoned block devices. mkfs.xfs will not complain and format an SMR
HDD even if XFS_RT is disabled. But then mount will fail with a message that
the average user will have a hard time understanding. This is the goal of this
patch: making life easier for the user by ensuring that features that are
needed to use XFS on zoned storage are all present, if zoned storage is
supported by the kernel.

> 
>>  	help
>>  	  XFS is a high performance journaling filesystem which originated
>>  	  on the SGI IRIX platform.  It is completely multi-threaded, can
>> @@ -116,6 +117,15 @@ config XFS_RT
>>  	  from all other requests, and this can be done quite transparently
>>  	  to applications via the inherit-realtime directory inode flag.
>>
>> +	  This option is mandatory to support zoned block devices.
> 
> What if a user wants to use another filesystem for ZBDs instead of XFS, but
> still want to have XFS enabled? I haven't followed ZBD work too close,
> but looking at zonedstorage.io, I see that at least btrfs also supports
> zoned storage.
> So, what if somebody wants to have btrfs enabled to use zoned storage,
> but also provides xfs without RT support?
> 
> Again, I don't think forcefully enabling XFS_RT is the right thing to
> do.
> 
>> For these
>> +	  devices, the realtime subvolume must be backed by a zoned block
>> +	  device and a regular block device used as the main device (for
>> +	  metadata). If the zoned block device is a host-managed SMR hard-disk
>> +	  containing conventional zones at the beginning of its address space,
>> +	  XFS will use the disk conventional zones as the main device and the
>> +	  remaining sequential write required zones as the backing storage for
>> +	  the realtime subvolume.
>> +
>>  	  See the xfs man page in section 5 for additional information.
> 
> 		Does it? Only section I see mentions of zoned storage is
> 		the mkfs man page. Am I missing something?

I have not changed this line. It was there and I kept it as-is.
Checking xfsprogs v6.15 man pages, at least mkfs.xfs page is a little light on
comments about zoned block device support. Will improve that there.

> 
> Carlos
> 
>>
>>  	  If unsure, say N.
>> --
>> 2.50.1
>>


-- 
Damien Le Moal
Western Digital Research
