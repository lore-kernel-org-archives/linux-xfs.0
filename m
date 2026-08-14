Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDA548AE24;
	Fri, 14 Aug 2026 16:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786724756; cv=none; b=CkVCGUt5w2P6Xs4H8IH5CW0T9YVXLP7E3IEdDj3KD4Zb0E2pJ3N6rEinDCEncqggx/8GGyceAKzXvoqIDekSCFTVVAelkt7Wj2gZ/zjTzHCGP2C9byxgpk6JFp/R6vxjAyt00QWy5Yfq7t7H2NRbBNJEZnpj0S/F6YdjMLEXQSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786724756; c=relaxed/simple;
	bh=9lCpAtPFH26nqj1EIlmp2xMnuXTwCwYBBH68dr55wkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuEZnoaolG9qn71JyCTP0rcrk/qTfn72iC/d6wDVHz3L/uen2qz8peZlUvL37Nld3PhrMLrhCBKYNgRU83bGB9XlCVriWIq5BeEz+Enm0cmNFY7rJ4DFWdar0JxM5+0nQljZHrWAH72ZQyj5fV+GyYGzv4VxpHot2tROHiDm9E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYlJdZmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYlJdZmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0501F000E9;
	Fri, 14 Aug 2026 16:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786724754;
	bh=0b6gzam2LUMQiA4iSJsBILdNnqq9/ykezyS2EvUVFh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DYlJdZmQv7kR74QXVAe11j0r4PRUyF2oTzJJMgIbFd0BzbSskDadkGmJ1BAKqYJ5f
	 k2SRa8JXvojFK5MnGLeRE+dehkxXiwk1UJaIa3yJHjqby+Jdu9czTvovXBw2hUGIpi
	 Jktk/toiqeM5nib0g00F3p63EC6jIe3as2YTWHwVioJwj9ZQ+9ZqnQZZDMF0gtQ3bK
	 b4RNhhDxzXRYoX2N+84mj8DhN3KTbLf8yeCrJ6v2WkDu7ULsugCA2QC/gCaiE4BXA2
	 Jdd04GVuosi/JKbtrBJUn7eWOWSyWlysahNaawSKrSMqSkldH7dAgAcELY92AkNfEG
	 XJkFazDp2jCBw==
Date: Fri, 14 Aug 2026 18:25:41 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen
 filesystems
Message-ID: <an9BQdSqrmzYhB3l@andromeda.toxiclabs.cc>
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
 <20260616053850.2188-3-aditya.ansh182@gmail.com>
 <20260624173531.GQ6078@frogsfrogsfrogs>
 <CAK5ssPP6FL+6i8z+0QdE-9DSp0rC_U2S20qdxY7Kmdp7RS0xRw@mail.gmail.com>
 <CAK5ssPMyJhvnEQSRoAwVNnZS-A837OOMewEAvp+ZiuWKD=vUdg@mail.gmail.com>
 <CAK5ssPPC4Ov0KBbRphC_wZBZGu1Rr4-d2At4V+ZECFcuHxbEfg@mail.gmail.com>
 <an7Dk2Tn1ibCRsv2@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an7Dk2Tn1ibCRsv2@infradead.org>

On Fri, Aug 14, 2026 at 12:28:19AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 13, 2026 at 09:43:44PM +0530, Aditya Prakash Srivastava wrote:
> > 
> > Are there any remaining concerns or feedback that need
> > to be addressed with this patch?
> 
> Still looks good to me, but I think it just go lost.  It's a bit close
> for the 7.3 merge window now, but I'd suggest you resend it in a week
> or two to get it onto the agenda for 7.4 early.

Yup, I was waiting for Darrick to follow-up then it fell on limbo.
Please follow Christoph's advice, please rebase and re-send on top of
the tree after 7.3 merge window.

