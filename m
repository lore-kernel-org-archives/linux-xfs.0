Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700152;
	b=WaLqe/7IdEoSSujUf8+O/A0R8H4OapkoOjYuz+R9wJeebG6RrkXTU5bf8pMjgiiqZNF0
	 OPYTus0j+Vl46kcxLskSYlckgiM07uLqFbtOuiRKILEova3AWLZTfwNw2RZp5Iam0urbi
	 l7gAJ1/96U5U7s566aUG1gOXNwie49917LKCCQqpAaxwJR3nKoQdkr1HyJuB/IJoabGeK
	 PT9CIHTc6jNMc1MYrYWeZ+LhuXW7blK8awx0afrAhIXoAa+pmfQqEb2QkS0vhos2KpAPV
	 qVoNCWCACmDBLrVOFZ6lUr3is/kzE8ng3EoPLUV/zTOHrFfbOASiBi7uh64DN0/UZQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700152;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=gxsoD+1AIorzMN6ftpvqvD5McYOdU2nQhJzwWXn/xJ0=;
	b=oMjktKWihvShJ5I1thBQhDI5LD0KRSJ/RmcJab/6NJvH5I4VVRfc5GYbJG2Khnq3jFSl
	 k9eC11yibn1MOinqN2onBzRUp2XOBbgcvF+cXrrPsR1+OHcgjPXVJ2Dn/96UgYW+p8wWP
	 V2kHlp4TlLWACzV+Q6TJCTnxwqh6RQBchS8EUCpo9P2yM8xiMZ9dJYP3fq7c7tIdUmDsu
	 yHKWO9P73mGO9AEy1QXKlx7BJJiKFdiGfZp+0efAn5v28HqRvu0E8w9h1S/1/G6ANZQU+
	 uVksTpJlSzvSaqmK+JJTDqbTxsTtDQCbg1B6S5KILWmnLb63RjejU1aO3R+XYQ87hsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hLM3ymAb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55710606A33D;
	Tue,  3 Nov 2026 10:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hLM3ymAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6612A1F000C1;
	Tue,  3 Nov 2026 10:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700151;
	bh=gxsoD+1AIorzMN6ftpvqvD5McYOdU2nQhJzwWXn/xJ0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=hLM3ymAb6apG8R89uHdW50Ysf4SMewDJENmbnZaPwLctmbDIDcdIK3uGeqH9B06ic
	 9FeWm+RIymPRGv5nNMxRsXbvbcZ4lvYE4i6hCTl21nyUjsAaTjqqw4fbiLjkGALwCh
	 3xo5IrIdjNy9UslIIWznstcpozCq6e5naQyRVpnl499bWtSHGKkLCHPygrTPriZWqx
	 PghRhPUiilGLffIvyt6MnSb7TRZuO664i78pLICfjsbZCSwHJ6nstGsbAi4A+0yb0w
	 xDk6tv8HUxwWTdlfQ0HyNdAt5qnfEp+xaE0vebu6Kyzn4KYirvNUHjvEKBotnLJ973
	 Y1YRp73XhN/fg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261026-xfs-fitrim-skip-v1-0-cddd8414f99c@samsung.com>
References: <20261026-xfs-fitrim-skip-v1-0-cddd8414f99c@samsung.com>
Subject: Re: [PATCH 0/2] xfs: discard every free extent in a whole-AG
 FITRIM
Message-Id: <179370015013.413123.5201894669879295169.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 11:02:30 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 26 Oct 2026 10:54:04 +0900, Daejun Park wrote:
> A whole-device fstrim walks each AG but the last by length. Two bugs
> in that walk leave free extents undiscarded, while fstrim reports the
> whole range as trimmed. Patch 2 depends on patch 1.
> 
> The new fstests case xfs/842, sent separately, fails without this
> series and passes with it. ./check -g trim shows no regressions
> (generic/038 and 500 were not run).
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: don't skip free extents in later batches of a whole-AG FITRIM
      commit: 595e67d7261673d03c96950ffbb2e545c00376ed
[2/2] xfs: don't skip free extents of the longest length in a whole-AG FITRIM
      commit: 5745f4f10a1a16aa5bb020acc38afa33f2d5ff99

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

