Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F79817A303;
	Thu, 10 Jul 2025 16:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752164171; cv=none; b=s6sV+1F03N5jhBNkoi95Cxi1dMk20rnzgzyKVswgKXhTT3BYuyltuOx7ANIOnmoNMN+u5OGh/sHSVHEBPE72DXZec7tCUUUTZAN/T1mnR1J92nytSb7867pDXbylmzTD+R3q1WDw1SDW42HFvTybpZyNiYGOH1J0HLXY9kAYEuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752164171; c=relaxed/simple;
	bh=JNlbxAfssVbYCCGEfdzTOOOT9o6B9UNRsQ6TyLc+ISE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gCSflDpIdDYojk/m0P3GNasu7v+HjN6lPp0wMpiDLzoS89WSY0EwYKTcptYP01zhckHxOxP6bJnneJ1vEMGCH46kaa5yYGYfKdE//Y4Ux5NI/ldDZcX0BDVLZiuT0V9q8aJZPKfWT7yzkfXy/C4tIFnREe67XXttDWb5zzxfxQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQpSlLPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQpSlLPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3561DC4CEE3;
	Thu, 10 Jul 2025 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752164171;
	bh=JNlbxAfssVbYCCGEfdzTOOOT9o6B9UNRsQ6TyLc+ISE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iQpSlLPKNpnBuw1e2L1EhmHuWt7dQUP4a/E8W+3AQppC7GWH59BNVQ+VjCSEg+1Nl
	 jp3XzKfuLlEA4EaC5iWQqOHj+Iitv1RdwBQpEZImKBNIHYO2htVLMbcM0vBrpf3++0
	 ozDyLobciRe1JEHdM0GZErVGkmlMETV7EwJ779vdCBmhJp2OUPwrXTqivxvVrsMGnK
	 V0wbMBCVhheJn3pkN4rOdZCj91cDSKO7YM2pd42+cmfqhtT13oZWiPXXyWZsyaHMg6
	 OLWH/7oz90ByI2v2+QQlGxdpI15k88y3Oa6DedONMbvr/0n+kOGobnXegOCLgeVN85
	 pY6S1s0KWKKaA==
Date: Thu, 10 Jul 2025 09:16:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 1/2] fstests: check new 6.15 behaviors
Message-ID: <20250710161610.GC2672039@frogsfrogsfrogs>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>

On Wed, May 21, 2025 at 03:40:53PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Adjust fstests to check for new behaviors introduced in 6.15.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.

Hrm, can we get the first two patches into for-next, please?

I'll work on the last two and repost when they're ready.

--D

> --D
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=linux-6.15-sync
> ---
> Commits in this patchset:
>  * xfs/273: fix test for internal zoned filesystems
>  * xfs/259: drop the 512-byte fsblock logic from this test
>  * xfs/259: try to force loop device block size
>  * xfs/432: fix metadump loop device blocksize problems
> ---
>  common/metadump   |   12 ++++++++++--
>  common/rc         |   29 +++++++++++++++++++++++++++++
>  tests/generic/563 |    1 +
>  tests/xfs/078     |    2 ++
>  tests/xfs/259     |   25 +++++++++----------------
>  tests/xfs/259.out |    7 -------
>  tests/xfs/273     |    5 +++++
>  tests/xfs/613     |    1 +
>  8 files changed, 57 insertions(+), 25 deletions(-)
> 
> 
