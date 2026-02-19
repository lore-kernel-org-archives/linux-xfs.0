Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8547D285C84;
	Thu, 19 Feb 2026 12:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771505757; cv=none; b=QKEhL/QtyWW1E4fXr+iA3DyndL6pQZmREyX+KOofGhRlT6WY8i77L0I2RYmPliJUfgizzjqi6cgGGgrataXmjba2LHWyPZ+iZR7U2GkfKgmrnRZD6JdMGhADUgzZECL58ckHj2/9El5/qivSi+ZR036ed5qFBPl3d2jhEElrWB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771505757; c=relaxed/simple;
	bh=VoryyMu/go+dzmPJVolQ5YB12tcxQOpUPrNeYKqVxDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAGy2RaZ4+HqF6rSvnM3v7P8TFgdqA1EQt9FPT6/OhpAed02d7u1VeOc+bnCEE0j3QwkZsiVHID79pSmMeom2uphYWOkk/z/r+kZN5NIsIjZF62Eh/GjsrudpGoCMkP1Komaie9BPMkCpXcrZf7ZbvneQ6NF5bf5QFJUCDEABXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azcrN5dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azcrN5dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937AFC4CEF7;
	Thu, 19 Feb 2026 12:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771505757;
	bh=VoryyMu/go+dzmPJVolQ5YB12tcxQOpUPrNeYKqVxDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=azcrN5dcQ8pVl+b5WOb8P1bxyHSFdi1UfioTCJ5AJ1bgkZUu9vl/QxTBBMOHuH6tD
	 70TwJ+SsSjqio747jFoJ0HJThgdm5P9UvxNFmcAp0shy7IP+rcln0X7ysT1PDohLHR
	 +HF7i+LAYMEMgwhk1Mfg4irAQELEGdhoaah6+KsyXtYCBK6KrGu8QvQ5QE/9DK1H0h
	 +bTddSEA2ReaIEyTPDsuEcckk8vFXGSiDpVBSG/VduEX2i5yUUM7cMs74apa8nRY/7
	 mpy+HWPPS5z5npGjHi6SI/Z7FESgys0HN0cHduRguVNPkHDsgCCcobwcu/JDPtSAVp
	 xyC5GlsX/XUAQ==
Date: Thu, 19 Feb 2026 13:55:51 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: djwong@kernel.org, hch@infradead.org, david@fromorbit.com, 
	zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, 
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, nirjhar.roy.lists@gmail.com, 
	hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Message-ID: <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1771425357.git.nirjhar.roy.lists@gmail.com>

On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> This series adds several tests to validate the XFS realtime fs growth and
> shrink functionality.
> It begins with the introduction of some preconditions and helper
> functions, then some tests that validate realtime group growth, followed
> by realtime group shrink/removal tests and ends with a test that
> validates both growth and shrink functionality together.
> Individual patches have the details.

Please don't send new versions in reply to the old one, it just make
hard to pull patches from the list. b4 usually doesn't handle it
gracefully.

> 
> Nirjhar Roy (IBM) (7):
>   xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
>   xfs: Introduce helpers to count the number of bitmap and summary
>     inodes
>   xfs: Add realtime group grow tests
>   xfs: Add multi rt group grow + shutdown + recovery tests
>   xfs: Add realtime group shrink tests
>   xfs: Add multi rt group shrink + shutdown + recovery tests
>   xfs: Add parallel back to back grow/shrink tests
> 
>  common/xfs        |  65 +++++++++++++++-
>  tests/xfs/333     |  95 +++++++++++++++++++++++
>  tests/xfs/333.out |   5 ++
>  tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/539.out |  19 +++++
>  tests/xfs/611     |  97 +++++++++++++++++++++++
>  tests/xfs/611.out |   5 ++
>  tests/xfs/654     |  90 ++++++++++++++++++++++
>  tests/xfs/654.out |   5 ++
>  tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
>  tests/xfs/655.out |  13 ++++
>  11 files changed, 734 insertions(+), 1 deletion(-)
>  create mode 100755 tests/xfs/333
>  create mode 100644 tests/xfs/333.out
>  create mode 100755 tests/xfs/539
>  create mode 100644 tests/xfs/539.out
>  create mode 100755 tests/xfs/611
>  create mode 100644 tests/xfs/611.out
>  create mode 100755 tests/xfs/654
>  create mode 100644 tests/xfs/654.out
>  create mode 100755 tests/xfs/655
>  create mode 100644 tests/xfs/655.out
> 
> -- 
> 2.34.1
> 
> 
