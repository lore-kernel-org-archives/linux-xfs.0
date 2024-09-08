Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABE516631D;
	Sun,  8 Sep 2024 14:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725805102; cv=none; b=LVh7qH74fCFbtHIB9b2qUoE2+dm2334yrG2T96pbJmlndFMRjhq/SsBvmfIljAK9/wiU3qvZXOaPgpxdpHwHyjIGW96rxzuXVvEiRgUlFbb/iY18LCXHKZBcigFCw1wkvtWJ4nTi2bvdUYaCSVm0JuX2m5vBp+KGXIpt2DW+lxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725805102; c=relaxed/simple;
	bh=2B3bGDYggMBeJGJc+cLhQOLEm7NrJWnQsiyWcfPyrKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxkzuM8w+JzZJiUMgOXwn75GL+yWUPQ22gMLtb2vv+R+PqX1jcN8OGTusljpgIbi9iWeNLIm3CV/y2kk54s9qbmCGMWQ7e+F34pjYDMDTN+c7waz3NJwLuUzpZNntW/UrKHC6mzqjCSMPnS1Z+3VPD8thxHlzIyuoIYCSZ2XI/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHvkQaJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHvkQaJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D35EC4CEC3;
	Sun,  8 Sep 2024 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725805101;
	bh=2B3bGDYggMBeJGJc+cLhQOLEm7NrJWnQsiyWcfPyrKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DHvkQaJZ5KWhqCgVwErwWAz8q3OAc7WBJGrtBJ7ucSzqrW7uixJ7a189Yd8LdIGUn
	 jfMsZ0G/NNwLAtM4BxtGSSm8AJFDHvbmQFagcJLft+4FldWbLiyW3BNxq7DGduNsDK
	 uHtS5ea6ylmqcOrxDHTmlk07Dw+eGTKgXhbxFJ8o=
Date: Sun, 8 Sep 2024 16:18:18 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	stable <stable@vger.kernel.org>, Dave Chinner <david@fromorbit.com>,
	Anders Blomdell <anders.blomdell@gmail.com>,
	linux-xfs@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: XFS mount timeout in linux-6.9.11
Message-ID: <2024090803-twerp-moaning-2bf6@gregkh>
References: <ZraeRdPmGXpbRM7V@dread.disaster.area>
 <252d91e2-282e-4af4-b99b-3b8147d98bc3@gmail.com>
 <ZrfzsIcTX1Qi+IUi@dread.disaster.area>
 <4697de37-a630-402f-a547-cc4b70de9dc3@gmail.com>
 <ZrlRggozUT6dJRh+@dread.disaster.area>
 <6a19bfdf-9503-4c3b-bc5b-192685ec1bdd@gmail.com>
 <ZrslIPV6/qk6cLVy@dread.disaster.area>
 <20240813145925.GD16082@lst.de>
 <20240813152530.GF6051@frogsfrogsfrogs>
 <2ca27751aba7c9f74c13facc7ffbbb1934dac59c.camel@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ca27751aba7c9f74c13facc7ffbbb1934dac59c.camel@infradead.org>

On Wed, Sep 04, 2024 at 08:45:14AM +0100, David Woodhouse wrote:
> On Tue, 2024-08-13 at 08:25 -0700, Darrick J. Wong wrote:
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
> 
> Is it (now commit 95179935bea) going to -stable too?

It's in the 6.10.y queue now, thanks!

greg k-h
