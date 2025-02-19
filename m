Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE95D21516F
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 18:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989857; cv=none; b=GNMmFuUHFbVQHSKIVPHPmgteWVcLZyhQhFC5cVLe3Br/TRRPt4cDvggWxt+R41UvUJc/Kze55oEXYG/4jzcWEYrFnuj+peooVwK20Wq28vE18E07pqGOtzO9eCRxGRgCtWcBxcUg3RtE/dGSlr/B3Tc0JcTnPb1bs5b9YAHAdNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989857; c=relaxed/simple;
	bh=D+m+H6Cgwd7TtyfA47RlrWdbrqTdyDkfgxxsc2e7OKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XIu+A4Gp4XGUgbHgE8+DwPe5BgnxwZ0m/mAz6RxVNM+h8yYezk3Cn9HwuBp86y5LEypzwCcrwjk8L4Jv7tBJvcvokDUhFsg/eCpIW0NHtDD/MXUlZJyS4jNDEBLEtAMeCTfuNv4GpZtAPXknqEMk67GYnoNRtGSLJKbG/idFKcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzNMvsqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzNMvsqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190F0C4CED1;
	Wed, 19 Feb 2025 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989857;
	bh=D+m+H6Cgwd7TtyfA47RlrWdbrqTdyDkfgxxsc2e7OKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VzNMvsqAZ2ynkTOYGXlvSLcJIemwkenLbpO6X7lalwSQblvB4xph/fkGT+s4ZIgxw
	 B4UG2ggwd/ly50d9clspAbBLiwvuAlS/Hwd0TF2dkNP63kIH6ES8W5YiWer7W4QT0R
	 xODe5k1bKL+fO1dv3yZlGg3qvX4e74cLd9sWu/GMPMRlXvjhEorULV7n2xxOIS+rS0
	 WEuucFG4GNqFe47NNk7bHTLRwlUJT1qPtCPMI5GF2fLr1/zgKBY3XQXia2x6cV5F4w
	 XmIc6fNwDvfInLlWZdS2XCDPhiMUJINNfd+DKH+Ru6DO986tpPmc1jBgbCd/Tlsijz
	 EVT/m2wtib1wQ==
Date: Wed, 19 Feb 2025 10:30:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_db: add command to copy directory trees out of
 filesystems
Message-ID: <20250219183056.GR21808@frogsfrogsfrogs>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089664.2742734.11946589861684958797.stgit@frogsfrogsfrogs>
 <Z7RGkVLW13HPXAb-@infradead.org>
 <37ea5fed-c9ad-4731-9441-de50351a90d7@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37ea5fed-c9ad-4731-9441-de50351a90d7@sandeen.net>

On Wed, Feb 19, 2025 at 12:04:36PM -0600, Eric Sandeen wrote:
> On 2/18/25 12:36 AM, Christoph Hellwig wrote:
> > On Thu, Feb 06, 2025 at 03:03:32PM -0800, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <djwong@kernel.org>
> >>
> >> Aheada of deprecating V4 support in the kernel, let's give people a way
> >> to extract their files from a filesystem without needing to mount.
> > 
> > So I've wanted a userspace file access for a while, but if we deprecate
> > the v4 support in the kernel that will propagte to libxfs quickly,
> > and this code won't help you with v4 file systems either.  So I don't
> > think the rationale here seems very good.
> 
> I agree. And, I had considered "migrate your V4 fs via an older kernel" to
> be a perfectly acceptable answer for the v4 deprecation scenario.

I thought about that some more after you and I chatted, and decided to
go for a userspace rdump because (a) other people asked for it, and (b)
the "use an older kernel" path has its own problems.

Let's say it's 2037 and someone finds an old XFSv4 filesystem and decide
to migrate it.  That means they'll have to boot a kernel from 2030,
format a new (2030-era) V5 filesystem on a secondary device, and copy
everything to it.  If that old kernel doesn't boot for whatever reason
(outdated drivers, mismatched mitigations on the VM host, etc) they're
stuck debugging hardware support.  If they're lucky enough that the 2030
kernel actually boots with a 2037-era userspace, then they've got a
fresh filesystem and they're done.

If instead it turns out that 2037-era userspace (coughsystemdcough)
doesn't work on an old 2030 kernel, then they'll have to go install a
2030-era userspace, boot the 2030 kernel, and migrate the data.  Now
they have a V5 filesystem with 2030 era features.  If they want 2037 era
features, they have to move the device to the new system and migrate a
second time.

Contrast this to the userspace approach -- they'll have to go find a
xfs_db binary + libraries from 2030.  If that doesn't work they can try
to build the 2030 source code.  Then they can create a new filesystem on
their 2037 era machine, mount it, and tell the old xfs_db binary to
rdump everything to the new filesystem.  Now they have an XFS with
2037-era features, and they're done.

Frankly I'm more confident in our future ability to help people
run/build userspace source code from years ago than the kernel, because
there's so much more that can go wrong with the kernel.  We guarantee
that new kernels won't break old binaries; we don't guarantee that new
hardware won't break old kernels.

--D

> Christoph, can you say more about why you're eager for the functionality?
> 
> Thanks,
> -Eric
> 
