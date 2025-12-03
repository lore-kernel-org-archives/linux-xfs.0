Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC3B482EB
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 00:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764723226; cv=none; b=AtGH3TSN8vx4y56O9JC1nRQgUsIv0Q98OL5a/8/QKpKsGumtk2phaQ6ks1kQCAF6jOEk/ls6Gu16rrMxIdZZFOnrDwKrm1Xe6PxOwp8R3GmNy+aUJiBGzqQDm83+pdkkoxY8IkaVeNO9xjpp4PvH3LBYmM/SPwgsziOQTNz6UFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764723226; c=relaxed/simple;
	bh=YW5ymQPjVRZ+natP6nVhNQyAoC+L6rHM+Lnsg22H4f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QdGacHAMt64+AFumbh6f+olPFoSvUpivBmrUqCDiGeXJtIl3nYVC0usMBzZG0idfnGGn2PsOXw2t8HzTWcJNe4+hTbv6B7EOuOtbSiH14MzNcqRkPTdfMDfhxoLU6B+MK+T81I3cZRpVo9AJU4hpx7K/OM4cn8CGfOuPTXGiChk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMOS4Jlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMOS4Jlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E164C4CEF1;
	Wed,  3 Dec 2025 00:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764723226;
	bh=YW5ymQPjVRZ+natP6nVhNQyAoC+L6rHM+Lnsg22H4f0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eMOS4JlozyW3JP31cp/Hj+zOnV/bsnEwTR7a8aPCo2bBOtuUGcnR0Pt6bAV9H/tiS
	 WsqD2FLpTD6BF1qXQ/FoaFkSXstrLYbHsaIy/575u7/jhAdATRp2Ebyr5kznTgTJ4V
	 e9oRlT8g1dn1j63GZ24D3lDy6oxvPyn2HOfG+4AqYF3CVU9W00LSXiuZeMOinNUGbt
	 FvgfiV6FH4e+MyFObvM6B5KAFuHSccg3XJkmqYB226b8eaWJ6APLVCW4v45mhjfYdz
	 h1vO87DOsl/w5dXO9u0LLs+dB3wXzVo7m8D1YeS2YByrVCY79YkodHdUYhs7k89AWk
	 Ra7h8kMjPEZ5g==
Date: Tue, 2 Dec 2025 16:53:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: enable new features by default
Message-ID: <20251203005345.GD89492@frogsfrogsfrogs>
References: <176463876373.839908.10273510618759502417.stgit@frogsfrogsfrogs>
 <176463876397.839908.4080899024281714980.stgit@frogsfrogsfrogs>
 <aS6Xhh4iZHwJHA3m@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS6Xhh4iZHwJHA3m@infradead.org>

On Mon, Dec 01, 2025 at 11:38:46PM -0800, Christoph Hellwig wrote:
> On Mon, Dec 01, 2025 at 05:28:16PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Since the LTS is coming up, enable parent pointers and exchange-range by
> > default for all users.  Also fix up an out of date comment.
> 
> Do you have any numbers that show the overhead or non-overhead of
> enabling rmap?  It will increase the amount of metadata written quite
> a bit.

I'm assuming you're interested in the overhead of *parent pointers* and
not rmap since we turned on rmap by default back in 2023?

I created a really stupid benchmarking script that does:

#!/bin/bash

umount /opt
mkfs.xfs -f /dev/sdb -n parent=$1
mount /dev/sdb /opt
mkdir -p /opt/foo
for ((i=0;i<10;i++)); do
	time fsstress -n 400000 -p 4 -z -f creat=1,mkdir=1,mknod=1,rmdir=1,unlink=1,link=1,rename=1 -d /opt/foo -s 1
done

# ./dumb.sh 0
meta-data=/dev/sdb               isize=512    agcount=4, agsize=1298176 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=4096   blocks=5192704, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0
Discarding blocks...Done.
real    0m18.807s
user    0m2.169s
sys     0m54.013s

real    0m13.845s
user    0m2.005s
sys     0m34.048s

real    0m14.019s
user    0m1.931s
sys     0m36.086s

real    0m14.435s
user    0m2.105s
sys     0m35.845s

real    0m14.823s
user    0m1.920s
sys     0m35.528s

real    0m14.181s
user    0m2.013s
sys     0m35.775s

real    0m14.281s
user    0m1.865s
sys     0m36.240s

real    0m13.638s
user    0m1.933s
sys     0m35.642s

real    0m13.553s
user    0m1.904s
sys     0m35.084s

real    0m13.963s
user    0m1.979s
sys     0m35.724s

# ./dumb.sh 1
meta-data=/dev/sdb               isize=512    agcount=4, agsize=1298176 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=4096   blocks=5192704, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0
Discarding blocks...Done.
real    0m20.654s
user    0m2.374s
sys     1m4.441s

real    0m14.255s
user    0m1.990s
sys     0m36.749s

real    0m14.553s
user    0m1.931s
sys     0m36.606s

real    0m13.855s
user    0m1.767s
sys     0m36.467s

real    0m14.606s
user    0m2.073s
sys     0m37.255s

real    0m13.706s
user    0m1.942s
sys     0m36.294s

real    0m14.177s
user    0m2.017s
sys     0m36.528s

real    0m15.310s
user    0m2.164s
sys     0m37.720s

real    0m14.099s
user    0m2.013s
sys     0m37.062s

real    0m14.067s
user    0m2.068s
sys     0m36.552s

As you can see, there's a noticeable increase in the runtime of the
first fsstress invocation, but for the subsequent runs there's not much
of a difference.  I think the parent pointer log items usually complete
in a single log checkpoint and are usually omitted from the log.  In the
common case of a single parent and an inline xattr area, the overhead is
basically zero because we're just writing to the attr fork's if_data and
not messing with xattr blocks.

If I remove the -flink=1 parameter from fsstress so that parent pointers
are always running out of the immediate area then the first parent=0
runtime is:

real    0m18.920s
user    0m2.559s
sys     1m0.991s

and the first parent=1 is:

real    0m20.458s
user    0m2.533s
sys     1m6.301s

I see more or less the same timings for the nine subsequent runs for
each parent= setting.  I think it's safe to say the overhead ranges
between negligible and 10% on a cold new filesystem.

--D
