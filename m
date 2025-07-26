Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192301DD525
	for <linux-xfs@vger.kernel.org>; Sat, 26 Jul 2025 03:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753501923; cv=none; b=AE46fVmaTTRpKNW96cEoqttfNwVphRkMqGkqOlbtvVDq+0sWlRo8A9VHa5PyHMGb/4nzExUskDzrzDuHS5nEB2hcUNa4HTbN2FDO4Va4bARegZAnzJ/ThZfjGehqsXIC4F+H/DGCdTA3yiStXcPjDhfWS8hSArgMZjjVbBKXHE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753501923; c=relaxed/simple;
	bh=T4wr8nnJjER6D9zGAs8IiqQxrrmE4wgH45CXBo8toG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/6FJwWG1u06mgrxyNfy24/DCSeOn2LP7vbR/GJ3kjTQHsEcTvCY+Y0v4X3AicLFNo53f6kowdN0Jr7RttynyUKI80z6ZlA8M6SYuPlfCzsiuOvINDjoVd9dmiqDgF4TLwv8Krvw2uP+cRp6uzbI6LsNAF5Jk5/YmNiYUekX6c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuyUR2k3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuyUR2k3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE14C4CEED;
	Sat, 26 Jul 2025 03:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753501922;
	bh=T4wr8nnJjER6D9zGAs8IiqQxrrmE4wgH45CXBo8toG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MuyUR2k3bZibbl/Shq+J5BOdevvUvHiv/MA9T000YjRSHjTo9i8WXKJ+0GEXUybVq
	 wJUhJQPUJga9yAtA9l5BlFH74AddEv2MSUAs98E6e3LLaEuKHF7LVRb02VT+hmoAkW
	 mySdKN7ahll7/5XBqTjkqez7FMevwaWXDTSBVUyTs9jtGwrXIt+z/7m4qBJtQ/OQnp
	 bQbGste25CGTeP30916sK3XgiU8PypYqWryTUBMvpxPxzKD+IT8ooX+5rIqmaQjeLx
	 vSi2WD7podrwEkyP1p8hvke0kpLHgMYD2eBW5mn89+nFnBCzspsaNiLQUdkpwls1Jy
	 rR+H71OPcyQrQ==
Date: Sat, 26 Jul 2025 05:51:58 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "hubert ." <hubjin657@outlook.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Message-ID: <6tqlc3mcf3ovkbzf4345m7oztoeagevfycpdnxizrtdbhq53p2@mrlmjhs6n7gy>
References: <f9Etb2La9b1KOT-5VdCdf6cd10olyT-FsRb8AZh8HNI1D4Czb610tw4BE15cNrEhY5OiXDGS7xR6R1trRyn1LA==@protonmail.internalid>
 <CH3PR05MB10392E816C6A1051847D214A2FA59A@CH3PR05MB10392.namprd05.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH3PR05MB10392E816C6A1051847D214A2FA59A@CH3PR05MB10392.namprd05.prod.outlook.com>

On Fri, Jul 25, 2025 at 11:27:40AM +0000, hubert . wrote:
> Hi,
> 
> A few months ago we had a serious crash in our monster RAID60 (~590TB) when one of the subvolume's disks failed and then then rebuild process triggered failures in other drives (you guessed it, no backup).
> The hardware issues were plenty to the point where we don't rule out problems in the Areca controller either, compounding to some probably poor decisions on my part.
> The rebuild took weeks to complete and we left it in a degraded state not to make things worse.
> The first attempt to mount it read-only of course failed. From journalctl:
> 
> kernel: XFS (sdb1): Mounting V5 Filesystem
> kernel: XFS (sdb1): Starting recovery (logdev: internal)
> kernel: XFS (sdb1): Metadata CRC error detected at xfs_agf_read_verify+0x70/0x120 [xfs], xfs_agf block 0xa7fffff59
> kernel: XFS (sdb1): Unmount and run xfs_repair
> kernel: XFS (sdb1): First 64 bytes of corrupted metadata buffer:
> kernel: ffff89b444a94400: 74 4e 5a cc ae eb a0 6d 6c 08 95 5e ed 6b a4 ff  tNZ....ml..^.k..
> kernel: ffff89b444a94410: be d2 05 24 09 f2 0a d2 66 f3 be 3a 7b 97 9a 84  ...$....f..:{...
> kernel: ffff89b444a94420: a4 95 78 72 58 08 ca ec 10 a7 c3 20 1a a3 a6 08  ..xrX...... ....
> kernel: ffff89b444a94430: b0 43 0f d6 80 fd 12 25 70 de 7f 28 78 26 3d 94  .C.....%p..(x&=.
> kernel: XFS (sdb1): metadata I/O error: block 0xa7fffff59 ("xfs_trans_read_buf_map") error 74 numblks 1
> 
> Following the advice in the list, I attempted to run a xfs_metadump (xfsprogs 4.5.0), but after after copying 30 out of 590 AGs, it segfaulted:
> /usr/sbin/xfs_metadump: line 33:  3139 Segmentation fault      (core dumped) xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1

I'm not sure what you expect from a metadump, this is usually used for
post-mortem analysis, but you already know what went wrong and why.

> 
> -journalctl:
> xfs_db[3139]: segfault at 1015390b1 ip 0000000000407906 sp 00007ffcaef2c2c0 error 4 in xfs_db[400000+8a000]
> 
> Now, the host machine is rather critical and old, running CentOS 7, 3.10 kernel on a Xeon X5650. Not trusting the hardware, I used ddrescue to clone the partition to some other luckily available system.
> The copy went ok(?), but it did encounter reading errors at the end, which confirmed my suspicion that the rebuild process was not as successful. About 10MB could not be retrieved.
> 
> I attempted a metadump on the copy too, now on a machine with AMD EPYC 7302, 128GB RAM, a 6.1 kernel and xfsprogs v6.1.0.
> 
> # xfs_metadump -aogfw  /storage/image/sdb1.img   /storage/metadump/sdb1.metadump 2>&1 | tee mddump2.log
> 
> It creates again a 280MB dump and at 30 AGs it segfaults:
> 
> Jul24 14:47] xfs_db[42584]: segfault at 557051a1d2b0 ip 0000556f19f1e090 sp 00007ffe431a7be0 error 4 in xfs_db[556f19f04000+64000] likely on CPU 21 (core 9, socket 0)
> [  +0.000025] Code: 00 00 00 83 f8 0a 0f 84 90 07 00 00 c6 44 24 53 00 48 63 f1 49 89 ff 48 c1 e6 04 48 8d 54 37 f0 48 bf ff ff ff ff ff ff 3f 00 <48> 8b 02 48 8b 52 08 48 0f c8 48 c1 e8 09 48 0f ca 81 e2 ff ff 1f
> 
> This is the log https://pastebin.com/jsSFeCr6, which looks similar to the first one. The machine does not seem loaded at all and further tries result in the same code.
> 
> My next step would be trying a later xfsprogs version, or maybe xfs_repair -n on a compatible CPU machine as non-destructive options, but I feel I'm kidding myself as to what I can try to recover anything at all from such humongous disaster.

Yes, that's probably the best approach now. To run the latest xfsprogs
available.

Also, xfs_repair does not need to be executed on the same architecture
as the FS was running. Despite log replay (which is done by the Linux
kernel), xfs_repair is capable of converting the filesystem data
structures back and forth to the current machine endianness


> 
> Thanks in advance for any input
> Hub
