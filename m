Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DE52C68F
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 14:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707143692; cv=none; b=ghaevMgNonfAXCEuY/vKLhxs8Rb3aCcR1ehO/NNp1+Wc7hTdwZhhCmhbYaqmcd2s8Wo8twYIv73v+iUWSr8lx1IyDWmqJXlutGlyJA5/w7s/sNrvgbSTxMX30nXV6kmTRyk45pkTAg/r4VYCyih3pTazXTaHx4y1obOJftxl6tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707143692; c=relaxed/simple;
	bh=eGXRH2qUbJwP/r9xqMxU48HU/W/cApK2D5jJe7ZD314=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D2Te4popecKkW7ErS/P2VJXDV8sLszB+g2KJ7VwHzej0cTjisswHrA+dbeqks3qpkVIkEoGxupfnZBUBuTEwf5Amy0a3DtOm1O3/B1ZM1ZV1DUGyI2V2PsFS/udWLqcwbdxIR7TE2fHOhm119XnuLbrxVTPdlG7ELMChua2nb6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1oTO7in; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1oTO7in"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990C1C433C7;
	Mon,  5 Feb 2024 14:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707143692;
	bh=eGXRH2qUbJwP/r9xqMxU48HU/W/cApK2D5jJe7ZD314=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l1oTO7inUzkQn6wGQ8S0SaINiE/GXSHPTbiZKC4qm/p4orhHT0dupIGsClVDlcdeR
	 3iwm2k3GSNl1MeyQREbuTJ/luoQqIk4B5DkZghYHLVPhfv29uxlLpYe9ScL0kdkwp4
	 QdZqoj9gdYZd8UsF2aBUxEzbYxgEwvLchkXRXD0ekIIj+6LwGe2VSXefUmMiNtvuUs
	 z63gLgZRQ8uxI+923qITXOsrmYxmpSeNbNVJmm/FsEGqTKdlkolFvcc8jNCpsA8oi2
	 +34tv4UPh++sWS3ZWIcp8/tHusikiwCNy5eatMDdCC/Jh4SMlFwz+6Nf9lAn7NzUuq
	 7F/0ZEuD/ZcBg==
Date: Mon, 5 Feb 2024 15:34:48 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Abhinandan Purkait <abhinandan.purkait@datacore.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_repair reports filesystem as in consistent even on ensuring
 consistency
Message-ID: <s47hgpezn6mqglztj3f2i6jmmtz2vpgqwnhdg3dlunv27asg3z@qoo2isxem76e>
References: <m3mapuevaU1Ewlj3ubotLeoYTX9XzJbH-GtTPPopSbnmcZ6Tp9HaUnD-XDnzRPl9DGrMzPXxlE09YJ02q5lr0A==@protonmail.internalid>
 <B46A6877-1782-4AC7-91FB-F8F3082827A5@datacore.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B46A6877-1782-4AC7-91FB-F8F3082827A5@datacore.com>

On Mon, Feb 05, 2024 at 01:13:02PM +0000, Abhinandan Purkait wrote:
> Hi xfs folks,
> I have been trying xfs filesystem consistency for a snapshot use case. I tried using xfs_freeze before taking snapshot, but xfs_repair shows the filesystem as in consistent.
> 
> I will write the steps below:
> 
> 1. I have a block volume provisioned by OpenEBS Mayastor as backend. Let's say the blockdevice is nvme0n1
> 2. I created a filesystem mkfs.xfs -f nvme0n1.
> 3. I mounted the filesystem on mydir.
> 4. I ran fio --verify_dump=1 --bs=4096  --random_generator=tausworthe64 --rw=randrw --ioengine=libaio --iodepth=16 --verify_fatal=1 --verify=crc32 --verify_async=2 --name=benchtest0 --filename=mydir/test --time_based --runtime=60 --size=120M
> 5. Now while fio is in progress I issued xfs_freeze -f mydir
> 6. Took the block level snapshot.
> 7. I unfroze the filesystem xfs_freeze -u mydir
> 8. I let the fio application complete.
> 9. Now while checking the filesystem consistency on the snapshot, using xfs_repair. I issue xfs_repair -n loop8, where loop8 is my snapshot filesystem
> 10. I get the below
> 
> The filesystem has valuable metadata changes in a log which is being
> ignored because the -n option was used.  Expect spurious inconsistencies
> which may be resolved by first mounting the filesystem to replay the log.
> 
> What am I doing wrong here? Is this way of checking filesystem consistency incorrect?

xfs_repair is not telling you the filesystem is inconsistent.
It is telling you there is metadata in the journal to be replayed, so the
filesystem should be mounted so metadata can be replayed.

> I have noticed that even without any operation the filesystem gets reported as inconsistent, for example issuing a simple xfs_freeze on a newly created  xfs filesystem volume and then unmounting and running xfs_repair -n somedevice also shows up as inconsistent.

I don't know what kernel you are using, and the behavior differs slightly from
kernel to kernel.
In simple words, even after you freeze the filesystem, it might still need to do
some work when you unfreeze it, and this will be done at the next mount.

So, what you are seeing is not an inconsistent filesystem, but the journal
working the way it is supposed to work.

Carlos
