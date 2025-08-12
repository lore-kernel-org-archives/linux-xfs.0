Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCE71A9FA6
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 07:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984001; cv=none; b=qmdtomgUSSCuDz24oG8hUPvBX9MtK7dOmnNHMjaONRPQBrsF9ELqyl3w1l8HdRWy9nKEsZ6oFy0z26L8GLjGoH6Iq3yfc1O9108g4sn4sFRhPByj1xPWW7xcIxHCxgQ6Lj6HujqCNWFt7Ug7HJrE8g+qMDyPgnXElutXfieQlfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984001; c=relaxed/simple;
	bh=tWG9HqoBEutpGkDIxefvQoDh+WUgKahObG9z974SrEA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sNjkN1BEDbZOMxzcQvkeYDtppbEuhsYIYazdRInoZa4dptOX/hjDS5bUWh5tzopF+QOFyTWPeQ6IESkIUmuQSa/gea4BXhq6wVsMdT1z+B6oVn0td7npbomHKWlYl6iBHHKyufGMDdoFoXb7+kiIfAekwd7HDBjtNC6GoS1bnlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ug2i0dWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ug2i0dWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DC7C4CEF0;
	Tue, 12 Aug 2025 07:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754984001;
	bh=tWG9HqoBEutpGkDIxefvQoDh+WUgKahObG9z974SrEA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Ug2i0dWTi2YoBhiqQuv8Gc9P0Sv2kKbrYRcVXj+89Leo9dKh+XEBh91HLWCN50X1h
	 lJGx0pgEaby4AWSt1fPXQmkL01TNtsaoxaiIZhaZMeNiYr1u0IW1kyFolD697TKQZA
	 EtwMNGXshq5Rzsy+2vx7/FkQZWgAvMvEAhRJ/3BDE5lUolMD8gQ+xb87EqYjvZMjBN
	 Wid5OMI/X2p0XRsotRCjR4JciPsKuseqN2P5RcgR1tBBDcLa2NHKevNnTvfkYrrCAu
	 T7yXXfBIahBjH+D8XathQeOttxN6QBPXEcP0X5GLr5X9aEgUm71+hp1FFNM/N6xsT6
	 WvK32L0L4eX4w==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
In-Reply-To: <20250731141941.859866-1-hch@lst.de>
References: <20250731141941.859866-1-hch@lst.de>
Subject: Re: [PATCH] xfs: fix frozen file system assert in xfs_trans_alloc
Message-Id: <175498400023.824422.4701464763309155508.b4-ty@kernel.org>
Date: Tue, 12 Aug 2025 09:33:20 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 31 Jul 2025 07:19:41 -0700, Christoph Hellwig wrote:
> Commit 83a80e95e797 ("xfs: decouple xfs_trans_alloc_empty from
> xfs_trans_alloc") move the place of the assert for a frozen file system
> after the sb_start_intwrite call that ensures it doesn't run on frozen
> file systems, and thus allows to incorrect trigger it.
> 
> Fix that by moving it back to where it belongs.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix frozen file system assert in xfs_trans_alloc
      commit: 647b3d59c768d7638dd17c78c8044178364383ca

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

