Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B5E5662
	for <linux-xfs@vger.kernel.org>; Tue, 26 Dec 2023 20:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
References: <20231215013657.1995699-1-sam@gentoo.org>
 <20231215013657.1995699-2-sam@gentoo.org> <ZYEwFUy6bFO3h7Lz@infradead.org>
User-agent: mu4e 1.10.8; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sam James <sam@gentoo.org>, linux-xfs@vger.kernel.org, Felix Janda
 <felix.janda@posteo.de>
Subject: Re: [PATCH v3 2/4] io: Assert we have a sensible off_t
Date: Tue, 26 Dec 2023 20:49:31 +0000
Organization: Gentoo
In-reply-to: <ZYEwFUy6bFO3h7Lz@infradead.org>
Message-ID: <87v88k1yeq.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Christoph Hellwig <hch@infradead.org> writes:

> On Fri, Dec 15, 2023 at 01:36:41AM +0000, Sam James wrote:
>> +	/* We're only interested in supporting an off_t which can handle >=4GiB. */
>
> This adds a < 80 character line.  Also I find the wording a bit odd, the
> point is that xfsprogs relies on (it or rather will with your entire
> series), so maybe:
>
> 	/*
> 	 * xfsprogs relies on the LFS interfaces with a 64-bit off_t to
> 	 * actually support sensible file systems sizes.
> 	 */
>
> And while I'm nitpicking, maybe a better place would be to move this to
> libxfs as that's where we really care.  If you use the C99 static_assert
> instead of the kernel BUILD_BUG_ON this can even move outside a function
> and just into a header somewhere, say include/xfs,h.  Which actually
> happens to have this assert in an awkware open coded way already:
>
> /*
>  * make sure that any user of the xfs headers has a 64bit off_t type
>  */
> extern int xfs_assert_largefile[sizeof(off_t)-8];
>
> Enough of my stream of consciousness, sorry.  To summarize the findings:
>
>  - we don't really need this patch all
>  - but cleaning up xfs_assert_largefile to just use static_assert would
>    probably be nice to have anyway

Thanks, I agree, but I think static_assert is C11 (and then it gets a
nicer name in C23). If it's still fine for us, I can then use it.

Does it change your thinking at all or should I send a v4 with it
included?

Thanks,
sam
