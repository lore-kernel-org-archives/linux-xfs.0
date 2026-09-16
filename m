Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BA64A7CBB;
	Wed, 16 Sep 2026 22:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789597744; cv=none; b=tAVgLjXm6kyRw16q6mtaSaoqvFw10IKEwUIuqUfsg1rx1pC+tWL6t97Jqa0LtfxWJcu2Nv5N2+OQTB1/XUvtFQ61Z3/WB3M8t6LGhcUwwT/cmq9lHXjqRPFYqGZTwlyl8SbZ6qKhF1+6Nm2u7W4X4CK4Tx+0JG6BkfMn4OpMNz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789597744; c=relaxed/simple;
	bh=LCCwGJWes8CCvhYnDdeHIDQ6A6QEAsC8/FqVSRoXw84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdQ7ScHdoBsohtIBZ19kizM43YQwjnu2llMWI6jMOnsnhpcIDuSGG/fDnRndWEh3kdEEi5nXvz4jF7GIXfn705ZbalxHbZN84t+UQNOPYyPeeYvns/G1LnGrKlTwW3ZhM0Z9XEq9tpIv3ah2FgIzo8vsXiX2pvVG09OGHOwcxZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6/0yvxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6/0yvxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5181F000FF;
	Wed, 16 Sep 2026 22:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789597735;
	bh=805rxjatP6SVa0O1Cm9mS+l0NMV7lkA1IXIy6Lke4oA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a6/0yvxYh6HUEMlbCiIlH/GoEeOr/7BUNzi5HsDDCRoLVpUqfW78TN+M67BhjBvew
	 z9adG+SqMA3wTUq7b38fuTm6EBFDvs1lZDu97jG5rc0OLGUKKP/xfPAe/b0AGRgCCq
	 Puwd8GkrrZYJB1wa+tuGiNA073dnx7ZnAGK5QF34aCQDQJNqEATsJKhBxi9x9oY62y
	 C7Kz2D/+uOjrH6j+mUtDFRXLEoWQj7yk4l6G1yHhoHoMdtvOOUujVHwTpF3ruPt1w1
	 oKdsI5flxcL9olzwDiFYh5Ymz+xagI0UNldAIoOFIuB57UJyWX7KTX439CtSnkYZWm
	 rC+2dRj3RZaKg==
Date: Thu, 17 Sep 2026 08:28:46 +1000
From: Dave Chinner <dgc@kernel.org>
To: Jeffin Philip <jeffinphilip14@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] xfs: change xfs log item refcount design
Message-ID: <aqsYHjEp-7TM1h8F@dread>
References: <20260911102502.163566-1-jeffinphilip14@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911102502.163566-1-jeffinphilip14@gmail.com>

On Fri, Sep 11, 2026 at 03:55:00PM +0530, Jeffin Philip wrote:
> This patch series is the first of the series where we attempt to convert
> the XFS Log item reference counting design to be more generic
> compared to the previous type-specific state to fix the "zero
> refcount but in AIL means alive" state. The patch series follows
> instructions outlined here[1].
> 
> Obviously, the wrappers will be integrated in type-specific functions
> later on.
> 
> No behavioral change as of yet.
> 
> [1]: https://lore.kernel.org/all/aqI6v-_dc2DDSbgB@dread/
> 
> Jeffin Philip (2):
>   xfs: add lockref and generic helpers for refcounting
>   xfs: change xfs_trans_ail_delete return type to bool

It's great to see you starting on this, but there's not much point
in just posting wrappers that aren't used by anything. Until there
is code that uses them, we can't really say anythign useful about
the wrappers. e.g.

Is the API optimal? Don't know.

Is open coding the init correct for the generic case or is that just
projecting an antipattern from the BLI reference counting? Don't
know.

And so on. Hence it's best to present the wrappers with the code
that then uses them so we have the necessary context with which to
review them.

Cheers,

Dave.

-- 
Dave Chinner
dgc@kernel.org
