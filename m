Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D40E325736
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 15:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765381481; cv=none; b=Y8w620TRM9I77DyA+zz9WDp8HDwxMr2LsFZ+e3+0uLvsSYcPYLXJFPEDRB1Bc7f32ClWIM8urEjchOh2YpBfMJ4KRbGoJezzDnE7BNAZ8MoaEBxGah1QYW7kggbVFG5URRwSTJFBQs96piEbeL/78U1EloNeiVqRTLj5jI51YjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765381481; c=relaxed/simple;
	bh=z+Sz2E9pYLf9jPEH2pW5uAAuf09MVQlBMOZYSusGLa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cq1ikF0sJf8L8+q3t2Zy79TdugS90lNc6pkd/WvsPkI2hdPNKbDvo/kIWqgvvGwfwM4Xnvwm4o0SjiuSajk/ZM5+9kS1e3pAc7rYKlwt0hRXktIDz1kHdb3vNwQ4/C1X4tEeIq4QymtzpIdyicjHHYaMj/NFWpd1ESFJHCQG2wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMQkspE4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMQkspE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF912C4CEF1;
	Wed, 10 Dec 2025 15:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765381480;
	bh=z+Sz2E9pYLf9jPEH2pW5uAAuf09MVQlBMOZYSusGLa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iMQkspE42dlHm66h2e4t/L4jHu2LhhIvWhhJXS9om7w9PT7Vd7BrWncTe44dd8loT
	 /rvUuJoACKgDaPm3cswfiS9N3gilS+No2hBMjdiXbINuAILJ2UdEhrFJaQPwX7qQ0B
	 O0tyyrUEhnf3QW+pu/Qr+x1xkhRAAvnQORnVSfe9aSrSEHHTCuLYkzEQB34BDL0iwU
	 syPv22DtIyOKhGe8TlgPPvhjKGBF/InGkGBVV13B/zZF9/v7x/V3v+kbexvyd009S4
	 xLzz/riNsZMu1yYRWBidLYiOy+AvIL+ortMXh5wEJcEuznePJJEmQknaVZrTYHIwO7
	 4mAOo2FIEaX5A==
Date: Wed, 10 Dec 2025 07:44:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_logprint: fix pointer bug
Message-ID: <20251210154440.GA7725@frogsfrogsfrogs>
References: <20251209205738.GY89472@frogsfrogsfrogs>
 <twgfncanrsgunjvdrijj3lhyjbemeybtjidplfxnjmjmzukchh@mhlm543xexwp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <twgfncanrsgunjvdrijj3lhyjbemeybtjidplfxnjmjmzukchh@mhlm543xexwp>

On Wed, Dec 10, 2025 at 12:10:08PM +0100, Andrey Albershteyn wrote:
> On 2025-12-09 12:57:38, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > generic/055 captures a crash in xfs_logprint due to an incorrect
> > refactoring trying to increment a pointer-to-pointer whereas before it
> > incremented a pointer.
> > 
> > Fixes: 5a9b7e95140893 ("logprint: factor out a xlog_print_op helper")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  logprint/log_misc.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> > index 16353ebd728f35..8e0589c161b871 100644
> > --- a/logprint/log_misc.c
> > +++ b/logprint/log_misc.c
> > @@ -992,7 +992,7 @@ xlog_print_op(
> >  			printf("0x%02x ", (unsigned int)**ptr);
> >  			if (n % 16 == 15)
> >  				printf("\n");
> > -			ptr++;
> > +			(*ptr)++;
> >  		}
> >  		printf("\n");
> >  		return true;
> > 
> 
> Hmm, checking the results I also see the segfauls in 055.full but
> test is passing. Is there any xfstests setting to make it fail on
> coredumps/segfaults?

Well in theory it already captures coredumps ... if they're named "core"
and get written to $here.  But then coredumpctl intervenes and whisks
them all away so fstests never sees them.

Starting Nov 2025, fstests can query coredumps from systemd:
https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?id=9886baabdec372387b5e874fdcaf59390a75f4a9

though obviously this isn't compatible with check-parallel because
there's no good way to tag a process tree for coredumpctl so that you
can query dumps only from that tree later.

--D

> -- 
> - Andrey
> 
> 
