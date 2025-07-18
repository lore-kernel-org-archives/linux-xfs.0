Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48F82D876B
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 12:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752843325; cv=none; b=JubIwNgUNoD1KgDLIOF8ohf0El2q0fm6LsyLTmHyncyRJX+suqOEPSFEwzJyTwJN+k5904MTCnBtVF9S74PF2P8qzBsgdRKjSSQAw1iXF0eFb768rzMObJJVbAasaBAZ2Xoyc+adEy/+4xoV1en2T3pR3RV96lDKoWhnKQrlDvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752843325; c=relaxed/simple;
	bh=+f/KTu+mqgZsthitIBXjwCIAJFH/nw8dY6TEEWZNPTE=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=keTxOWYBdRspgliMt4l4dEBzfJ+fCQQ9XExtw7Qy4/GfF53SqHwrJ+TL6o6kt1fr0BdBSmMDRWS3Wz08OuyzO2puURA//JzpkUidXDniuM+bX9vYtw8eZcgK5/2PjWZoCaIJemsWjripm6RVtrbcm2p8k3dC5QRZIiQ7SYOLTpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPkh152y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPkh152y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE9FC4CEEB;
	Fri, 18 Jul 2025 12:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752843325;
	bh=+f/KTu+mqgZsthitIBXjwCIAJFH/nw8dY6TEEWZNPTE=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=OPkh152y6AesCxWzRmztU4SZMJuCDTeLinkRAXzNwzJJ9LWugTWCokmVQs1v6Q6J9
	 5ElWYYClIQUz3rFeaHp9LyP2tYCoLRQDwLA9RVDaQO5x0h316mWYPUv8p0zWQz0UVM
	 qEWOGRTSEK5Da9XvZ3M2lx/H2bjSCgU7/DLkqjXU5J1TSjKoynKEqMS3uQty0wQmS5
	 p+KPUbutq1YrcOgayNV0iMcitf6waoBLnUj9vv4DM7QVhlpPOwJs4fh+RVKKAtIA7C
	 laWuZE22PI7902f9Jy17fbGc6h6cRrKmDdHPg9ZRE2Cq/MLjouvVL5+C4L88F/NFvp
	 /qE8EbJKZxtSg==
References: <20250716121339.GA2043@lst.de>
 <20250716153812.GG2672049@frogsfrogsfrogs> <20250716160234.GA15830@lst.de>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org, Fedor Pchelkin <pchelkin@ispras.ru>
Subject: Re: flakey assert failures in xfs/538 in for-next
Date: Fri, 18 Jul 2025 17:49:29 +0530
In-reply-to: <20250716160234.GA15830@lst.de>
Message-ID: <87wm85acaw.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Jul 16, 2025 at 06:02:34 PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 16, 2025 at 08:38:12AM -0700, Darrick J. Wong wrote:
>> I've seen this happen maybe once or twice, I think the problem is that
>> the symlink xfs_bmapi_write fails to allocate enough blocks to store the
>> symlink target, doesn't notice, and then the actual target write runs
>> out of blocks before it runs out of pathlen and kaboom.
>> 
>> Probably the right answer is to ENOSPC if we can't allocate blocks, but
>> I guess we did reserve free space so perhaps we just keep bmapi'ing
>> until we get all the space we need?
>> 
>> The weird part is that XFS_SYMLINK_MAPS should be large enough to fit
>> all the target we need, so ... I don't know if bmapi_write is returning
>> fewer than 3 nmaps because it hit ENOSPC or what?
>> 
>> (and because I can't reproduce it reliably, I have not investigated
>> further :()

I think you are right. Most likely we were able to successfully allocate less
than XFS_SYMLINK_MAPS (i.e. 3) and the next allocation only found free extents
whose length were larger than 1 FSB.

The test fills 90% of the filesystem and then punches holes at every other
block used by each of the "filler" files. So the filesystem could have some
"free extents" whose size is larger than 1 FSB. These larger free extents
allowed the block reservation to succeed.

During the test run, we could have consumed all the 1 FSB sized free extents
and hence a later allocation attempt can fail since we were trying to allocate
only 1 FSB sized extent.

>
> I guess the recent cleanups are not too blame then, or just slightly
> changed the timing for me to have a streak to frequently hit it.
>
> xfs/538 is the alloc minlen test that injects getting back the minlen
> or failing allocations if minlen > 1.  I guess that interacts badly
> somehow with the rather uncommon multi-map allocations.  The only
> other one is xfs_da_grow_inode_int, and that only for directories
> with a larger directory block size, and as a fallback when the contig
> allocations fails.  It might be worth crafting a test doing a lot
> of symlinking while doing that error injetion to trigger it more
> reliably.

I have modifed xfs/538 to perform only write* and symlink
operations. Unfortunately, the test hasn't failed yet despite running for 27
iterations. I will let it run during the weekend.

-- 
Chandan
