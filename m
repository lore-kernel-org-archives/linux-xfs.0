Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44F03B995D;
	Thu,  8 Oct 2026 13:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466360; cv=none; b=bAGw3DClDqn7ir9YTsX714HiYy0AAssK8lDPLNykvNFnvsTlcCmIyB66lUitAoXHeBENbzAMH55ZDDPH9pKeXcxV9V+HD6IGgewAc2I3ZQTYF81jOPsfoRVcJvXyAVMKtmjuprT3127HYT40QyzHUvJ0YWzhZwa+j9RQKrOxMMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466360; c=relaxed/simple;
	bh=P+i8jFrw4bioM1ETA5c9JpgPOlPJjBTAXbD7Wmo4VGU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=G/OurlA4QJB4pTIpt/7mCbr0EXbGscgPacwFaSbtjX7db0VIwHrPN1GLyuOybPn8W1p4Ub+L6JSxmT9MxiyNJdSfjxxmgMQLyFVmAvV2d8u+IqpM+e8jlQV0Me6PLLH4f16Xv0flMFb5827ivOgZyw5z2eIBoklGuOV5KVepj+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obvwlhaL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obvwlhaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB7C1F00893;
	Thu,  8 Oct 2026 13:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791466359;
	bh=pDGIgUmWSizZ2q8pulEBRdNZWa1HiE+EywbEXbpZKMU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=obvwlhaLI73yeXv8F/U8NNWlkozhR719Ezke14tFWKlOGHp6kXx4suokLEfOd7NcE
	 nPQzafcPdne3vWQQl15t5NETR1kYwY4GPiwhL0dH5A5afACbZ+AvF0gYyig58e4h3k
	 fhUOAJsH/qVJVBA6AQy5Uu9xarSSV5xNk8/tGa9F1+4gvbiItgINR4/SPua45IHcoY
	 7sGRUtznTiKkZfOGaWVYxZ1iY1FNCKfKixKvxYeN8gUXcIHfQO65nc6/YInIFfEapC
	 JW8ndW1vCxRQJonuQbYpCUCq30lrzScHE0IYcg43LJY+f1Tl9cWvKMyWDKNwup91Zr
	 sBhrsZbVSbXqA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Cc: djwong@kernel.org, stable@vger.kernel.org
In-Reply-To: <20260929231305.1368713-1-sandeen@redhat.com>
References: <20260929231305.1368713-1-sandeen@redhat.com>
Subject: Re: [PATCH] xfs: validate rc_domain in xchk_rtrefcount_mergeable
Message-Id: <179146635755.378461.11489363786005785265.b4-ty@kernel.org>
Date: Thu, 08 Oct 2026 15:32:37 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 29 Sep 2026 18:13:05 -0500, Eric Sandeen wrote:
> xchk_refcount_mergeable validates that the domains match, but this
> was omitted from the realtime version of the check; fix it.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: validate rc_domain in xchk_rtrefcount_mergeable
      commit: f04361fb8694bff98ec61e2e2030a1993426fdca

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

