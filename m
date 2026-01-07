Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584C7369216;
	Wed,  7 Jan 2026 18:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767811684; cv=none; b=nEP+yjKoirAwF2NtynN9mxFMPRqT3jvGBbxsNzQ63mtg788LtZsAmQQiXwrFufVRXCuGbXao1z7WcshhFGj6pKMuIVIwg/6pOBggb1JdT27+v5NeF+7ILf1h6T9ca1IFCWiJ+dMb7c4n/b4fH5eD/GJ3VO3o7RGQmfUt8TA4mCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767811684; c=relaxed/simple;
	bh=8SgNr7xm/kbqyxKSrYBQefsh2w1TYTV4jP74xLlifes=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=CMd7WSJh9J+bC+N8TufH3LpDk4al61p1aP566ITXv5THYwAF4LXs3RadLFxCuLyYfcb0Kb0oHCpzHGsBTi2782nCmS4mWKTDYqekLCWjM/v8OYampnSQ7c9/RnTEEg32H0ZqyQkI/XkGwSB9w7viVJ//MkBDoZXMbOATq2cWmfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1oMuZjM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1oMuZjM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED3EC4CEF7;
	Wed,  7 Jan 2026 18:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767811683;
	bh=8SgNr7xm/kbqyxKSrYBQefsh2w1TYTV4jP74xLlifes=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1oMuZjM6nHMfH6xUmJV12d30QJi6ro1mGQuCuPF7jFJB7xqLEDFBKg/gZ2VGARIww
	 bfMVwirZ2JIK99ZoUXgABcxYNZR7Uy5CFuBiswgFZVJHn28Z0qUCT69nVv4xZ4ENT/
	 DHOeQCYfpn/M4PeP91UMBTXr40HY9tU1c5o7tY8Q=
Date: Wed, 7 Jan 2026 10:48:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
 linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] lib: introduce simple error-checking wrapper for
 memparse()
Message-Id: <20260107104802.91735989425034c858730b8f@linux-foundation.org>
In-Reply-To: <20260107183614.782245-1-dmantipov@yandex.ru>
References: <20260107183614.782245-1-dmantipov@yandex.ru>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jan 2026 21:36:13 +0300 Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Introduce 'memvalue()' which uses 'memparse()' to parse a string with
> optional memory suffix into a number and returns this number or ULLONG_MAX
> if the number is negative or an unrecognized character was encountered.

I'm not understanding why negative numbers get this treatment - could
you please add the reasoning to the code comment?

Presumably it's because memvalue() returns ULL, presumably because
memparse() returns ULL?  Maybe that's all wrong, and memparse() should
have returned LL - negative numbers are a bit odd, but why deny that
option.  With the new memvalue() we get to partially address that?

