Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE344052DE;
	Mon, 24 Aug 2026 13:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787579572; cv=none; b=ioKfoQrikHmGz4cT39RAvI2UNUImtIC6n5bPJpi5xkP3qkCDSHDemM3h9Z1oOf2+8wR2DlwtGGGsps3/AAZMlSnX8oCtqUvilo1r8CyQYyH86d6/TrF6WiyrmG8WpEcHkeB7oEVKetD63QwGmbNDLium49j5i9c/vghf+M/Ad34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787579572; c=relaxed/simple;
	bh=fUfjUCkiaM90io/n8Y7zz+NQRpbgcwJgatrGWCPIf2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dHvv8flOyaY6P55/Yi8MzBimD6pWkGHOjfhnkOvhv4WFqgkTH0WNspv61zKhii/Excaxap0VDU655Dob57crl7Im5rz9Iy6qb81Q/HskOg5DGCIgZoJZa91IeW6FHXP2zte975S9TXRrvN4K1CdqaVbhLtaC505pmZmnApwATPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=G6vz/uwB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=k0OgL+8/; arc=none smtp.client-ip=202.12.124.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="G6vz/uwB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="k0OgL+8/"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id B3FA01300084;
	Mon, 24 Aug 2026 09:52:49 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 24 Aug 2026 09:52:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1787579569; x=1787586769; bh=zD00BnjS9t
	sCP+uch931+VaqPVYRemIFkBWowtNOyZA=; b=G6vz/uwBrBJbGD9KPp6R6rpDT4
	x9qUAI0yUYMB99QZaRFSRHD+laZWtSFYySDls8y8mZf8XZ9DKONeXHD+E+hyipqj
	Ex7CKV+D9/04tnWV34dpicZq+0MiUei2BwVL0DRDW2gVpo2ylK+DFcHV9D7idq+1
	jQ1IkgagtGlq8dwVz61kcAlg4UCu2ZoHuuEc6ItXouqDjlyNkxshHIpJAcXuv+u5
	fqpP9RIH1IlTht5o88+fOD3Rygif/A4VQ8mKht8sEo5E9zMgEGhs1SikLhOyFsTn
	2u2YDL63Or60+4xjSOn3/oumODArME5KZVg8mF5xZnocdPxlWm1ccuWPRgsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787579569; x=1787586769; bh=zD00BnjS9tsCP+uch931+VaqPVYRemIFkBW
	owtNOyZA=; b=k0OgL+8/VRJZlTRux9iIop5FUNtzRJuHdr3D5O97slOIrvsmAIb
	3vc/HFDi2/hGRUPzAxAVNI26KwD07c+qEI0UkLtqdVGaOsftZYNBKuIORpUyQRru
	SJ1i/czyKl0GZ6MAKXnufPXeLoQeAb7AsFRVuQMYm2AwUZMiqb9QnMT0arb61Xfo
	iB6Vzc7pb2pDwEpM1/6iG5aZIN5ylPK5QUOJK6uDL27I9bAY8gvYf+4MGs+KONgg
	53Ds/cN6guJwiGwcw3r/dzlm823o79cckmlC6u8JjEhD/kGDsBNjsTTChmBEDtzu
	8hT0MGMCPilp5ooSxXri2qmv6dOpci+e0Gw==
X-ME-Sender: <xms:sUyMakzOP9AQhap9mWc57DEJCIKukqgcxRHapaU819tfIzSGKXrI_Q>
    <xme:sUyMaqpEBfiQacue1Qg30PcgNvv80FxA6XXtJOl1yRT8kEuHktfvOFHCLzomd7OKg
    0xqV6GPilIw_68bcnAG0Vp4cCxZWCqeb0K3QV1UPSccuF9CEA>
X-ME-Received: <xmr:sUyMavn5OQg_QDPhqlJAV8wyda5B_IRZh6nM-RtUOuGtv3OZyRuqeIwWrPbD0zXCM_8JqMAsY1CCjqmD0dMpxXUdewpeQzI59Dt_IvX6Bc0>
X-ME-Proxy-Cause: dmFkZTEPn1zsIOPKOAqDfn4v6wjQvPSeR6w6xBDZDwNrVoBNFuHflUDaBa/OrLbn41U77i
    EB7lSjaDunC6FmNX8baljOdoWdSzXiuGLxMsuQjWfc35kQ34AzqqqWH/emt+yIdAsN19zL
    cxURTm3UgXLxdxOMfEsDOy4PFM6wVRJjIN6rOBnjGhJ/PkeWup4AS0OA1BhyMaY9zi+f5o
    qf0ZSbxnZhhfYF7yJjxatRECbIvFXZHzbZ6d5asxO4W6/M6L4/E30YqleLYnEJx1fJeLnK
    FtvaYD5XhGxmO9jl0m6xZ6FJ0LB8Mn/+Yz3/qG64QKpWTFmm2RR54ru2ZLcGwDrzUXxLap
    bPY9rfDf72H2lfttfD6I8vuC/XhkZ4249w/eF3PTCNn38rxKmcyU9ahHLQ1LTVrQS5rsSy
    KGKfOn1pYZ6vWJi4lhRKHvWG1q+su5YiDQAbY13y1spoIl642XseFOAyWAW2LvDwEEBz8t
    l9stysJ0b61nc2Cx5q96XBkVwK8mxD+xwh6B5tyXXhJZOKQGxBzN5D+CiTK1jxNOuVaAPa
    2nq1AKvjVGbynX73GM974IqxvgfIP1ZfsEycpOAjpmAXc2izNFp4AEeFUjmWEhG2F4dy34
    +41cJr5+JY2Y7KUCIzK8aoTRySc0hvj1lkxVyoF5a6URHVppOctW85Jjeyvw
X-ME-Proxy: <xmx:sUyMalrQkYIgHEckIeAKMCE8D6pRGc2kaLc3QhMzQJC3uu8vD0tnrg>
    <xmx:sUyMaoabsfmBz_cg4rPvPKUoosuzT5CWG4B2m4NkMS2AizsN5HikjA>
    <xmx:sUyMarHLpqODMlOMYGe4kvRBdG-iothFTc-QOwtaxrhozA_Pdl_12g>
    <xmx:sUyMaoxW0BPWdxByEAqO3250RmiSzbXxoWGcb2jJ2JRcwuO6dC1hzw>
    <xmx:sUyMasCZIQIwwwU3_SlmMTStVqntYxZCnns9bDqyGh_aqPL5m4eZrAjm>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 09:52:48 -0400 (EDT)
Date: Mon, 24 Aug 2026 15:52:45 +0200
From: Greg KH <greg@kroah.com>
To: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Cc: stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-kernel@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
	syzbot@syzkaller.appspotmail.com, Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10.y] iomap: adjust read range correctly for
 non-block-aligned positions
Message-ID: <2026082434-freeway-legwarmer-84e6@gregkh>
References: <20260820-cve-2025-68974-5-10-v1-1-26ff0db1f8e8@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820-cve-2025-68974-5-10-v1-1-26ff0db1f8e8@bootlin.com>

On Thu, Aug 20, 2026 at 07:03:07PM +0200, Miguel Gazquez (Schneider Electric) wrote:
> From: Joanne Koong <joannelkoong@gmail.com>
> 
> [ Upstream commit 7aa6bc3e8766990824f66ca76c19596ce10daf3e ]
> 
> iomap_adjust_read_range() assumes that the position and length passed in
> are block-aligned. This is not always the case however, as shown in the
> syzbot generated case for erofs. This causes too many bytes to be
> skipped for uptodate blocks, which results in returning the incorrect
> position and length to read in. If all the blocks are uptodate, this
> underflows length and returns a position beyond the folio.
> 
> Fix the calculation to also take into account the block offset when
> calculating how many bytes can be skipped for uptodate blocks.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Tested-by: syzbot@syzkaller.appspotmail.com
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
> ---
>  fs/iomap/buffered-io.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)

Don't we also need this for 5.15.y first?

thanks,

greg k-h
