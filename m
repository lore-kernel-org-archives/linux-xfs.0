Received: from one.firstfloor.org (one.firstfloor.org [65.21.254.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA721DF269
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 07:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.254.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751007954; cv=none; b=GOR3/fCiN9/5qpyW1NWKor55J8JTd1mbtIKzX8VAKQXn2oHbPdi+rQ0Vtg7sHDMz1WU/AUKz+FuRvYB352YbIWTFeID8nmElvK9W+ckKr3F2pghM4ecqW8EXeQv4rbuJmdTOOnx1mIKg68twUOErBsC/6fnMVAlgDlf5oB/oTVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751007954; c=relaxed/simple;
	bh=y1xNi2rPnD0HKv3vAgGt/721Te22bJSGuRtisJqNP4A=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eIwysrg5cC3kfHijXW+RUABCx66MzAttszrrKjx2zoNYmbnqsyZ6nyF5EM0LDKFo6YAqGkVbfoX0V5Lf3jpEconxSPHMM05ZI9eOnCU2dSW9eNSxp44UY3zVfOSIuj1vEtlAfPdy7q6IYnDZmoVLnvyElwJL1EZdI2NPO0JSAbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=firstfloor.org; spf=pass smtp.mailfrom=firstfloor.org; dkim=pass (1024-bit key) header.d=firstfloor.org header.i=@firstfloor.org header.b=bMo1TnVi; arc=none smtp.client-ip=65.21.254.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=firstfloor.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=firstfloor.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=firstfloor.org header.i=@firstfloor.org header.b="bMo1TnVi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
	s=mail; t=1751007404;
	bh=y1xNi2rPnD0HKv3vAgGt/721Te22bJSGuRtisJqNP4A=;
	h=Date:From:To:Subject:From;
	b=bMo1TnViw68HD+c35ayU/qDdzRM7h6TPEbTfHHee5VJFlJoveezLB32bFzWb2Y2z1
	 v/vvp2vsQTQnsXr0R2s9qIiIxAHiLOCaJfshWqYrg6Gtt8CGseN1t3wX78ovu/+TZl
	 6a7c7iNHUQk7ESPFpa33+EnOQWrTjePyzZ97yr2w=
Received: by one.firstfloor.org (Postfix, from userid 503)
	id 729565EF35; Fri, 27 Jun 2025 08:56:44 +0200 (CEST)
Date: Thu, 26 Jun 2025 23:56:44 -0700
From: Andi Kleen <andi@firstfloor.org>
To: linux-xfs@vger.kernel.org
Subject: IO error handling in xfs_repair
Message-ID: <aF5ArCN0M9940yK7@firstfloor.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I have a spinning disk with XFS that corrupted a sector containing some inodes.
Reading it always gave a IO error (ENODATA).

xfs_repair unfortunately couldn't handle this at all, running into this
gem:

         if (process_inode_chunk(mp, agno, num_inos, first_ino_rec,
                                ino_discovery, check_dups, extra_attr_check,
                                &bogus))  {
                        /* XXX - i/o error, we've got a problem */
                        abort();
         }

TBH I was a bit shocked that XFS repair doesn't handle IO errors.
Surely that's a common occurrence?

Anyways, what I ended up doing was to use strace to get the seek offset
of the bad sector and then write a little python program to clear the block
(which then likely got remapped, or simply rewritten on the medium),
and apart from a few lost inodes everything was fine.

It seems that xfs_repair should have an option to clear erroring blocks that
it encounters? I realize that this option could be dangerous, but in many cases
it would seem like the only way to recover.

Or at a minimum print the seek offset on an error so that it can be cleared manually.

-Andi

