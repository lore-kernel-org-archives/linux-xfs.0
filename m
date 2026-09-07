Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6820C3AD531;
	Mon,  7 Sep 2026 06:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762508; cv=none; b=O15Ys7Rmyl11lScGbDoWszixUWrRD2n7/o+LqYe9EeFa6glUQZLIBmiHyd+o/1/Lf7gwMhXVq6Sz/w+eB+/Pt/OcJKNfjKwey/bjOuaXiBxUgX/QoEPXbSt3iu0H40Bd2nRtATVmvo4e0OcStSroyRv5UkNlBpUkBSVxj18egvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762508; c=relaxed/simple;
	bh=K7I3ZrDTvKqy3FJxYrllvNKPkgegr37bXi7teC48IJ0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sApvggH0Wb2RY4h4zLw590r83Fjen2nzII/bv2++JvJ03wg+sVACXrOVfHA3jILMivZdrikuLdfy0gWwvtWMQH6UGeo8Fqkbs4lhp5e5HgbDIW17qRAH546DJp4mzlVMhzNiFNh+PkcWZP6YDP5xOkevpHm7/r9fh15rqCUHa9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMLLDW4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMLLDW4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E781F00A3A;
	Mon,  7 Sep 2026 06:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762505;
	bh=iy9wUOfM54cEO8X/CFuG8nbS1g3ikvJ/10COS/7Fwyw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DMLLDW4hLiAHZpI68fTGTFEZuJHoY7y5yMXVnMouFXFjnUrM9i+Bzv8Nr4SSGaa1X
	 UCHKJby2QpeSLKu87kYVIrzU3L9DG2deGkfFsrSL8/A8Li8Y3BKBwxB1tVbK/iSNf9
	 vz/pPmdGyZxWaDyOBLynMuwlwOPeHfQ2VaF12ubcr9s862fR4LiNge38TjY/na/ElR
	 kjIRiim75A2Ru+WoBcY3hyt0Z29v5OrwcT6dj2xTEXf+h/ecSMn0eN8iwhLnoLh+Ot
	 FOTh+abEcvpZIkftmiAZI0oND+1Th81JOpN4WKTCTnxcAqf0h8glkM9sk+KYnpYJHg
	 z/3yJH60EZv+g==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: cmaiolino@redhat.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
References: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v3 1/5] xfs: LLM-inspired bug fixes, part 5
Message-Id: <178876250419.13884.755470661457092767.b4-ty@kernel.org>
Date: Mon, 07 Sep 2026 08:28:24 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 01 Sep 2026 22:41:32 -0700, Darrick J. Wong wrote:
> Here's a fifth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> v2: add RVBs
> v3: add even more RVBs, finish review
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: fix unit conversions in per_binval computation
      commit: 05cff7c2b79f76c7cfe90613a60e16aaaa051ef7
[2/6] xfs: fix short ifork reaping computation in xreap_bmapi_binval
      commit: eacb8479507756c3305994e87fb2fb1183827e98
[3/6] xfs: fix name string recording in slowpath pptr tracepoints
      commit: 72d0a3e4405c1353869bfbbc67c7b8a29df7afd0
[4/6] xfs: don't leak dqacct if rhashtable insertion fails
      commit: 2eac8d01d2c776fc26b0ac74aebdf91bc4490891
[5/6] xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
      commit: aa301322f72f82f26e4ba0826018d41388ab9896
[6/6] xfs: fix media verification ioctl for internal rt volumes
      commit: f789d291bbdac6bc02d9d77e0141e138626c17a8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

