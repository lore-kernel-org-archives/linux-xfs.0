Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4941E50B;
	Thu, 22 Aug 2024 15:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724341588; cv=none; b=RRI+dkvL2M5N+dTLq1U4s3jQ276NHmWZWsgzTl+JJ4b3Yf6KabxRzzPjaquP/rI+gs5Gsd8lEJHhbHKqWsJvy2J+eITjluca+rN1n0FUikiblHSIY2lYfWOSphETbGjgSJ4kPYBlyM1dNzUPknSbUiTuU8aOPcWSck0kE2YtG4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724341588; c=relaxed/simple;
	bh=eOt8jRygP/v2t+krP/0RcccBpfA1nP8tvUrqtnRvwwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tu4ZGv4yFofDIjBV7LC4idAdjgkDx4APqBwvhURoYkDjfrFwoIwscCKYo0LA8m/5BCV7ZMMTOca83OMvkfoZvi/1Y1f9MYLwZxEi/WPMk+ODrKueEXb2WRfZ7X9bhDVBWC6AORFX5Q1xBOhiMznA+GUT0CNrR80xjy5Eie8UU3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVvtbIlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVvtbIlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C035C32782;
	Thu, 22 Aug 2024 15:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724341588;
	bh=eOt8jRygP/v2t+krP/0RcccBpfA1nP8tvUrqtnRvwwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RVvtbIlqJxFlufZALFAVqCJw1njd5jdtD+wPt0InzL5IbgyAemue5+Nt9RoYIX5F9
	 AzbYq4sBajoiOCcb6MSO2hN6bCJ7Owh3vJchi5B4pdJsrCvORAXlYlfkKz9dj4e08A
	 bBE3T0pxBFUy/NodiuDDIAiA8EhhA08DpnwQ+T5lLir3lvN5busgTTdXeQsKzYLEiI
	 fjhtw/wm9mxAQFcsm5TIZcj3bI7BROGJd0iQd60jaJCIA9KQE3DWsRSEv6xs2bEwDw
	 0HU+89EEmgeHM0d2bFJSUyaJyNbnabnDT8PkS/AKzl8FVPovpJIaeCb6J4i4EtO3YH
	 Z/cdHDdHiLDpw==
Date: Thu, 22 Aug 2024 08:46:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: anders.blomdell@control.lth.se
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	Anders Blomdell <anders.blomdell@gmail.com>,
	linux-xfs@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: XFS mount timeout in linux-6.9.11
Message-ID: <20240822154626.GQ865349@frogsfrogsfrogs>
References: <ZraeRdPmGXpbRM7V@dread.disaster.area>
 <252d91e2-282e-4af4-b99b-3b8147d98bc3@gmail.com>
 <ZrfzsIcTX1Qi+IUi@dread.disaster.area>
 <4697de37-a630-402f-a547-cc4b70de9dc3@gmail.com>
 <ZrlRggozUT6dJRh+@dread.disaster.area>
 <6a19bfdf-9503-4c3b-bc5b-192685ec1bdd@gmail.com>
 <ZrslIPV6/qk6cLVy@dread.disaster.area>
 <20240813145925.GD16082@lst.de>
 <20240813152530.GF6051@frogsfrogsfrogs>
 <AS8PR09MB65809D71E78A5E1FA20013EBE48F2@AS8PR09MB6580.eurprd09.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8PR09MB65809D71E78A5E1FA20013EBE48F2@AS8PR09MB6580.eurprd09.prod.outlook.com>

On Thu, Aug 22, 2024 at 12:25:03PM +0200, Anders Blomdell wrote:
> Anything I need to do to get this patch into the affected kernel versions?

Dave: Can you please (re)send this as a proper patch thread and ask
Chandan to add it to his fixes branch asap?

--D

> /Anders
> 
> On 2024-08-13 17:25, Darrick J. Wong wrote:
> > On Tue, Aug 13, 2024 at 04:59:25PM +0200, Christoph Hellwig wrote:
> > > On Tue, Aug 13, 2024 at 07:19:28PM +1000, Dave Chinner wrote:
> > > > In hindsight, this was a wholly avoidable bug - a single patch made
> > > > two different API modifications that only differed by a single
> > > > letter, and one of the 23 conversions missed a single letter. If
> > > > that was two patches - one for the finobt conversion, the second for
> > > > the inobt conversion, the bug would have been plainly obvious during
> > > > review....
> > > 
> > > Maybe we should avoid identifiers that close anyway :)
> > > 
> > > The change looks good:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Looks good to me too
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > --D
> > 
> 
> -- 
> Since Lund University (allegedly due to insufficient funding/manpower) prohibits
> sending email from Linux clients, mail from me will come from the address
> anders.blomdell.at.control.lth.se@outlook.com.
> 
> Anders Blomdell                  Email: anders.blomdell@control.lth.se
> Department of Automatic Control
> Lund University                  Phone:    +46 46 222 8793
> P.O. Box 118
> SE-221 00 Lund, Sweden
> 
