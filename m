Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A25828A3FA;
	Thu,  8 Jan 2026 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767892010; cv=none; b=FRA1sWRsHUZ3CkQfqVBF3FZENiyGXkKx0K4WqxYIfYJR16G1+zIrwUE1oSq0z+QnbmQUNdsKdqAIQVbkXeWmwxSn8Z+juPp+arLk3eJhILxCRgeP9k2J+mdzxrnC0DoXUvvfHi2/E5l4ByBFQYVEAdFJiaaJnGN2bqSq+ETQke8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767892010; c=relaxed/simple;
	bh=01JjCrOlzJgMHZaRSSStQz3h8hcQL9B7/mLcY/B/H7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlPCilyTOSGcvV8lRGwGniZ5rutI7ij8rlAS35AAwEAWHTcF67jfT+fpDIM1gkAtU470wUlRYXAuaoNiQfn9kfdSH/0vrn5o6gjvAD237MlMEylL8UMDufMI1MS1pM6hLkpQUeBPOK0uGePaOzBp/6hll50Ssk/2g1T4Hy/mV/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLGfxNiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLGfxNiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88E1C116C6;
	Thu,  8 Jan 2026 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892009;
	bh=01JjCrOlzJgMHZaRSSStQz3h8hcQL9B7/mLcY/B/H7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GLGfxNiY6Uc/HgmDESYFBWDq4xTWiGgQrjdGekHD+yhztYb+2mxXiuqTznSqeqCfo
	 G7s/WNzT/OhK08qdhhLCYWJvogOYrHB+0y+IWccgarF3aetggMmz8QwT8cIQu3YaL2
	 wa5flHU4ZWsH3i3RbCdt9yEcrevbavY3A9T9xTXlwWogjIts9vqxg2Jnw5CBrN6agB
	 M8yNw63mnxiAft02ZCg9zXaqKDNkZhIaQSDUxCVOGmK3hOYpoSCWUKn5oHtygE2Wuc
	 6g2AbFyqI+ayNUsB4v8gzsZfCYFFEc8SppmWi1U4j5EB8ofE2Ix2De95yKqeonl4tB
	 1I6JrvtcVNRzA==
Date: Thu, 8 Jan 2026 09:06:49 -0800
From: Kees Cook <kees@kernel.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <202601080905.D1CC8CC@keescook>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108165216.1054625-1-dmantipov@yandex.ru>

On Thu, Jan 08, 2026 at 07:52:15PM +0300, Dmitry Antipov wrote:
> Introduce 'memvalue()' which uses 'memparse()' to parse a string
> with optional memory suffix into a non-negative number. If parsing
> has succeeded, returns 0 and stores the result at the location
> specified by the second argument. Otherwise returns -EINVAL and
> leaves the location untouched.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Suggested-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

LGTM, thanks!

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
