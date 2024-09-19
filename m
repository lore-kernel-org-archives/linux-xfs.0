Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF3F12E4A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761900; cv=none; b=HoEKrrKghbHgLezzZFE2P3yEa9w0rhuWSf1lb+BiOyxgPvfpPXAAC5jpkVSQy3Mj3higc0K2RYNosYZsH5spH/jiTmnb8n20UlymSwCDhUY0kAZOshtrZawETKEeHLj2emPIWKGE5pEPnsyQpVQNXFG4HTNr040SUlsBGMK6VsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761900; c=relaxed/simple;
	bh=M+VB3E4DMzcggzLLtgQ5W8XbU7rtZ35qnlfB9kTa3L8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JpvlebgBnyF4wSPpIILkvsD7gN4S+uprmmmbYngy9K7xL0QFPndf889U3OApDlrRKDd7sHtSafXtHKfrgH7ugOCnEjmWWKmfRLMmWeJQwxp6n+aJpnoT1xOedmOGrz37dABdggGerjaAOdE/hGmC3lQOAXKajPw3CvtOY0BGTQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUJzQVu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUJzQVu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0E8C4CEC6;
	Thu, 19 Sep 2024 16:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726761900;
	bh=M+VB3E4DMzcggzLLtgQ5W8XbU7rtZ35qnlfB9kTa3L8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SUJzQVu7uQ+5jv153TdEj6KSzA7y1Z6RPgbZhQmkPkgd1Ph91zz1DtnGVXX47mMV6
	 ohdkdqvNJ5tt4Z33mmfq2s5XZWRYSbs+j4PegbWe93Gwz1WtWbarZofNinVqRnhD/u
	 wKAZ4tbb7JSkF825bEiWDy6i8uPuhaIYzuw+OjKmeEGa97uykY6yLRMU+V5dkmggbM
	 RagJ/bl61LKIDhaDvIKh2y92OIvgwAYu3Nw4FS6WIdpmSiIcyXaDxmCIYLeC0WWhOS
	 a8RwK586zvrDFR+x09RRuPitj+5aauFwcV2IsjbXawGCt4FjRltl4wI50FafuDldeR
	 6SZJo4nVdLyeg==
Date: Thu, 19 Sep 2024 09:04:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libfrog: emulate deprecated attrlist functionality in
 libattr
Message-ID: <20240919160459.GJ182218@frogsfrogsfrogs>
References: <20240918210010.GP182194@frogsfrogsfrogs>
 <ZuwuhwTDwvUyqXj1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuwuhwTDwvUyqXj1@infradead.org>

On Thu, Sep 19, 2024 at 07:00:39AM -0700, Christoph Hellwig wrote:
> > @@ -0,0 +1,34 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +/*
> > + * Copyright (c) 2024 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <djwong@kernel.org>
> > + */
> > +#ifndef __LIBFROG_FAKELIBATTR_H__
> > +#define __LIBFROG_FAKELIBATTR_H__
> > +
> > +struct attrlist_cursor;
> 
> Maybe this file could use a common that it emulates libattr APIs /
> helpers?

/* This file emulates APIs from the deprecated libattr. */

> > +	struct xfs_attrlist_cursor	cur = { };
> >  	char				attrbuf[XFS_XATTR_LIST_MAX];
> >  	char				keybuf[XATTR_NAME_MAX + 1];
> > -	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
> > -	struct attrlist_ent		*ent;
> > +	struct xfs_attrlist		*attrlist = (struct xfs_attrlist *)attrbuf;
> 
> Overly long line.  And as mentioned in reply to Carlos version of this
> we're probably better of just dynamically allocating the buffer here and
> do away with the casting.

I'll make a prep patch that turns all those into dynamic allocations.

> The rest looks good to me.

<nod>

--D
