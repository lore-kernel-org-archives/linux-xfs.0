Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAFC1E4AB;
	Sun, 11 Jan 2026 00:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768089675; cv=none; b=HOBBkBZzwTd7Ayd8YoCuC6Njj5TcGfFbefNr8F9S9WujqgVrI2bzMA/KdkY+tinmS28+YHZQJirR2eKWEEinQAgJBpHtYxv8zwdKV58wQaGNPTOL7Y0NDgQmvg/UVFI4xkWHRfWIBLI8v1eE0kKKmrihE9iM5TYzJSmrvPy2TeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768089675; c=relaxed/simple;
	bh=k5mWieDTfmIMuo32ViSIMufD3Amit+i2TLcf+BZWPRo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZfLgnbm16o9LEnf6xfejtuzWSohsde0SlQnfHzBQUJZpXZXWVc6Nzu9mVba3q4I677CfqvmqAjtN6wwpMc7Pplkxp3CTBMF1LVp11hTkT81Kw+WF7WVEvlk7eftZ77VZA7VYmDtRj4ciwlYbvxPNPpkstnw15fgKII+x99mDhB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vqAHs5Yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vqAHs5Yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EE7C4CEF1;
	Sun, 11 Jan 2026 00:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768089675;
	bh=k5mWieDTfmIMuo32ViSIMufD3Amit+i2TLcf+BZWPRo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vqAHs5Yi0iS6qHhB2gAAeueCh8cSW7WPTmTzCPbCu2nEUZbxA/gAgm2h7Izy/xxA2
	 8xvwErEsk7oiKvm5JOr+ejdMzSmjsEsbF8RG7j8NbGjqx0r6TJlygaEHBaEy5c1EPQ
	 /7JAlo1fxoppFgHfKoH3NKre9R5/WI61/g9vE8yU=
Date: Sat, 10 Jan 2026 16:01:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Carlos Maiolino <cem@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@kernel.org>, Andy
 Shevchenko <andy@kernel.org>, linux-xfs@vger.kernel.org,
 linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-Id: <20260110160114.3a1976a90c13a2c79c16e611@linux-foundation.org>
In-Reply-To: <aWE2w-zUnq3FPANJ@smile.fi.intel.com>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
	<aWAOJwMURdOl_lqG@smile.fi.intel.com>
	<a0fb5777b167803debb2c6b77f41e82967fba3b7.camel@yandex.ru>
	<aWE2w-zUnq3FPANJ@smile.fi.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Jan 2026 19:11:31 +0200 Andy Shevchenko <andriy.shevchenko@intel.com> wrote:

> On Fri, Jan 09, 2026 at 02:41:55PM +0300, Dmitry Antipov wrote:
> > On Thu, 2026-01-08 at 22:05 +0200, Andy Shevchenko wrote:
> 
> ...
> 
> > > 2) missing Return section (run kernel-doc validator with -Wreturn,
> > > for example).
> > 
> > Good point. Should checkpatch.pl call kernel-doc (always or perhaps
> > if requested using command-line option)?
> > 
> > OTOH 1) lib/cmdline.c violates kernel-doc -Wreturn almost everywhere
> > :-( and 2) IIUC this patch is already queued by Andrew.
> 
> Andrew's workflow allows folding / squashing patches.

And replacing and dropping and reordering...

Please, just do whatever you feel most appropriate.  I'll cope ;)

