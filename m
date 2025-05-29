Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDE71DB924
	for <linux-xfs@vger.kernel.org>; Thu, 29 May 2025 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748544940; cv=none; b=px/i1N39A0etDIowb8zJWNAVcgW99TawRA7YPbg0kriyJesCHKnda/RZFHpz+DBPyz2oF16YHzujjLQAgcVmlhjFQGT4SuqESP4TxMXznWmXpFrSYSEou7zqfE/ARjtYjKh3gHODVZHNZsxhEVdSf4iV2cHUUJC5/LwFp5t7Ybc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748544940; c=relaxed/simple;
	bh=nDaG6wX3Fa1juFstEkxHjtWan42R5z9neNtshsXqCrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qOhkLF8Cw13wnW5HB6Vt37v5P+xX6oRCZDS3jRmr9eTpqWdmgRKPxTq/1SGhyUrnxDwbievCpnB4xK2Yi8Px3re0eUKoIjdT3ZBefx+50O5Yy1Pxm3G4MonL+azJsUp5CT6kM0Tvrq9fjsph9tuE+HvA9dYybyJg6h6zoS3bIbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=gjV16BCk; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KwyuBiQ2; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="gjV16BCk";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KwyuBiQ2"
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 26B1D1140141;
	Thu, 29 May 2025 14:55:37 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 29 May 2025 14:55:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1748544937;
	 x=1748631337; bh=b6J1waQKcPr7V2Fyn93DyVgOV/l9tWsU9tqGaxyVdBw=; b=
	gjV16BCkYklk7krC24uck2IajeUaavfYgYS5Gt7cI/on5Ewd2DWBX+Ut5oa1cKIK
	PgaBOf+83Sy413xixDEGftnTeSYUuMDQCsTl8YAWJwBec9hZJi1EozeXASswQTm1
	FJXgJSdG5vB47sOPklf2xodUW1XW8bXvNTxGvEiaScuLD4hU41ZTbNJ+neQLfQul
	yYj0oPO5/iEg7DB7vLAUMjT/QL5siIlt9sipFUR+9S5wGvhk+IVE9iSdF+weUwjw
	XPGLbQzqNiL14mL2vcAk8gorhMdHaYysKlHi5N3izz0gWuDtx3xVZBJzm8Q0AWnn
	hYYmCcLX/b+T3N3rpGwMDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1748544937; x=
	1748631337; bh=b6J1waQKcPr7V2Fyn93DyVgOV/l9tWsU9tqGaxyVdBw=; b=K
	wyuBiQ2kYxx7psKDzYKJNGoDr4fxB37Z2ojd/1nCdZkNSA8Eo8AhsrN062bDcbHn
	n8rmop0n1wLEJzanPObCrftxeDkUNyjDW7SFGhJM1vZCgV3tv1rlZauKbpb94BkS
	sjC9xc/6oB/pt9K3JD/SRAFWc7VbKBnlx/GPimfoMeLu7vWU25iFYnFHarEMqRZp
	dT8+b63Q+YccLfjjKQlr+NBQaz346APDIScKmcnErqF/xgUAE8OFWHPugC6Rl9zd
	IztAMg3h75oIG39za5CJfe9cdGn9Ijmn9eLBn0wTOtEB7GrwGY4xFgBNkgbC7BoE
	lvAU0UuHewrHAg5NTVpRw==
X-ME-Sender: <xms:qK04aFAnCdJVf99Xgc9BoyXz834t01hZdBvrh_8z24W-ZCIyZIN8FA>
    <xme:qK04aDi57YzYxU1KyWI5jQlLPt18QceTgyh5v8fRylrptC0SQxnKL-fVr8zyg7_Pf
    LeNG-XNiF_uc1JXzqI>
X-ME-Received: <xmr:qK04aAmFoNyr-HPT0w20_zqxJ8bOSvrWG0KgowLxoxh_lPIBhYggkuJpWq6YQFU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddtgddvieeludculddtuddrgeefvddrtd
    dtmdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggft
    fghnshhusghstghrihgsvgdpuffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftd
    dtnecunecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhm
    pefgrhhitgcuufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqe
    enucggtffrrghtthgvrhhnpefgueevteekledtfeegleehudetleettdevheduheeifeeu
    vdekveduudejudetgfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthho
    peefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrohihsehkrghrlhhssggrkh
    hkrdhnvghtpdhrtghpthhtohepuggrvhhiugesfhhrohhmohhrsghithdrtghomhdprhgt
    phhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:qK04aPwmDt9xpTLWNNDmufMFiqsvKhTdiTd6SkIWj-izTzWI4ancPQ>
    <xmx:qK04aKTFoGQvJ8IkVFDOBy_MlOKzwp5mlCw0N_1hX4szb8vufvoV1g>
    <xmx:qK04aCYbHDYVHPnQoUlBsaOuG--xCeuLEeRGopO2j0O0F80Wtyzysg>
    <xmx:qK04aLREAbiNfya0ybXc0_lLgKmb-nZnywt2qxKAC2cQOZreznkPeA>
    <xmx:qa04aOD1z4gxLaA1d_HIgr6ndCn3xa1iQsK0eDWN47i-qXMvAnCY_2Fw>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 May 2025 14:55:36 -0400 (EDT)
Message-ID: <9a075d69-14ec-4585-9678-c62d30136c48@sandeen.net>
Date: Thu, 29 May 2025 13:55:35 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: XFS complains about data corruption after xfs_repair
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
 Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
References: <9EA56046-FECD-42C5-AEF6-721A8699A45B@karlsbakk.net>
 <aBaaDGrMdE6p0BiW@dread.disaster.area>
 <BFF21A51-ECA7-454B-8379-F456849D16AC@karlsbakk.net>
 <92DD8C35-E3F2-43D9-BF4B-19C442A13DA6@karlsbakk.net>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <92DD8C35-E3F2-43D9-BF4B-19C442A13DA6@karlsbakk.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/25/25 5:39 AM, Roy Sigurd Karlsbakk wrote:
>> On 24 May 2025, at 03:18, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:
>>
>>> On 4 May 2025, at 00:34, Dave Chinner <david@fromorbit.com> wrote:
>>>
>>> On Sat, May 03, 2025 at 04:01:48AM +0200, Roy Sigurd Karlsbakk wrote:
>>>> Hi all
>>>>
>>>> I have an XFS filesystem on an LVM LV which resides on a RAID-10 (md) with four Seagate Exos 16TB drives. This has worked well for a long time, but just now, it started complaining. The initial logs were showing a lot of errors and I couldn't access the filesystem, so I gave it a reboot, tha tis, I had to force one. Anyway - it booted up again and looked normal, but still complained. I rebooted to single and found the (non-root) filesystem already mounted and unable to unmount it, I commented it out from fstab and rebooted once more to single. This allowed me to run xfs_repair, although I had to use -L. Regardless, it finished and I re-enabled the filesystem in fstab and rebooted once more. Starting up now, it seems to work, somehow, but ext4 still throws some errors as shown below, that is, "XFS (dm-0): corrupt dinode 43609984, (btree extents)." It seems to be the same dinode each time.
>>>>
>>>> Isn't an xfs_repair supposed to fix this?
>>>>
>>>> I'm running Debian Bookworm 12.10, kernel 6.1.0-34-amd64 and xfsprogs 6.1.0 - everything just clean debian.
>>>
>>> Can you pull a newer xfsprogs from debian/testing or /unstable or
>>> build the latest versionf rom source and see if the problem
>>> persists?
>>
>> I just tried with xfsprogs-6.14 and also upgraded the kernel from 6.1.0-35 to 6.12.22+bpo. The new xfsprogs haven't been installed properly, just lying in its own directory to be run from there. I downed the system again and ran a new repair. After the initial repair, I ran it another time, and another, just to check. After rebooting back, it still throws thesame error at me about "[lø. mai 3 03:28:14 2025] XFS (dm-0): Metadata corruption detected at xfs_iread_bmbt_block+0x271/0x2d0 [xfs], inode 0x2996f80 xfs_iread_bmbt_block"
>>
>>> It is complaining that it is trying to load more extents than the
>>> inode thinks it has allocated in ip->if_nextents.
>>>
>>> That means either the btree has too many extents in it, or the inode
>>> extent count is wrong. I can't tell which it might be from the
>>> dump output, so it would be useful to know if xfs-repair is actually
>>> detecting this issue, too.
>>>
>>> Can you post the output from xfs_repair? Could you also pull a newer
>>> xfs_reapir from debian/testing or build 6.14 from source and see if
>>> the problem is detected and/or fixed?
>>
>> I couldn't find much relevnt output, really. I can obviously run it again, but it takes some time and if you have some magick options to try with it, please let me know first.

Generally best to just pass along the full output and let the requester
decide what is relevant ;) (you may be right, but often reporters filter
too much.)

> 
> So, basically, I now get this error message in dmesg/kernel log every five (5) seconds:
> 
> [sø. mai 25 12:12:40 2025] XFS (dm-0): corrupt dinode 43609984, (btree extents).
> [sø. mai 25 12:12:40 2025] XFS (dm-0): Metadata corruption detected at xfs_iread_bmbt_block+0x2ad/0x320 [xfs], inode 0x2996f80 xfs_iread_bmbt_block
> [sø. mai 25 12:12:40 2025] XFS (dm-0): Unmount and run xfs_repair
> [sø. mai 25 12:12:40 2025] XFS (dm-0): First 72 bytes of corrupted metadata buffer:
> [sø. mai 25 12:12:40 2025] 00000000: 42 4d 41 33 00 00 00 f8 00 00 00 01 10 26 57 2a  BMA3.........&W*
> [sø. mai 25 12:12:40 2025] 00000010: ff ff ff ff ff ff ff ff 00 00 00 06 61 32 b9 58  ............a2.X
> [sø. mai 25 12:12:40 2025] 00000020: 00 00 01 27 00 13 83 80 a4 0c 52 99 b8 45 4b 5b  ...'......R..EK[
> [sø. mai 25 12:12:40 2025] 00000030: b6 3e 63 d8 b0 5e 20 5f 00 00 00 00 02 99 6f 80  .>c..^ _......o.
> [sø. mai 25 12:12:40 2025] 00000040: 7f fb a7 f6 00 00 00 00                          ........


You might consider sending a compressed xfs_metadump image off-list to me and/or Dave.

xfs_metadump obfuscates filenames by default and contains no data blocks, but sometimes
strings slip through so I generally suggest not posting to the list.

But with the metadump perhaps someone has time to do more investigation, assuming it
reproduces with the metadump image.

-Eric
 
> roy
> --
