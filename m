Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574162253FC
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 05:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122113; cv=none; b=JF8uvEDfDcW5wjK1blo4S36b8BUMfIGRhtMVtXc37cHmC6Re4E9ErNaIyPzCwNK6ESxh7h5mAqudS4+xIzcPfzVrVC87HVOtQ5sfJOUCbD7INkxzfq1IZERfpCy9BV7x8NoI69PvsHVF+c/oQWj7+WPB45SQ47pgV2DagMCoAyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122113; c=relaxed/simple;
	bh=VSe52d84XqlpppwNKATrpWKazJlS1YvwNN0jzBiwTPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oDXZRWlP1KFGeKm3LBMoXZHRgdxVc9Oa/Lbmd2XfwAd2Mgw+1WOW5eVN2GuxksaFnNjifUlykhoG6StqNAFaqAnIE72i9fRr3D/0MWycE3rsTus+AMYG2ePZlwNwFj/GA2JXKDAVn6zhqrMtRNG01bnplpStvj/jydAyje1+2V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 77C62227A88; Fri, 19 Dec 2025 06:28:29 +0100 (CET)
Date: Fri, 19 Dec 2025 06:28:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, aalbersh@kernel.org, dlemoal@kernel.org,
	hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: adjust_nr_zones for zoned file system on
 conventional devices
Message-ID: <20251219052829.GA29856@lst.de>
References: <20251218160932.1652588-1-hch@lst.de> <20251219021001.GA7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219021001.GA7725@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 18, 2025 at 06:10:01PM -0800, Darrick J. Wong wrote:
> Hrm.  So we're moving the XFS_RESERVED_ZONES addition code out of
> adjust_nr_zones to here.  The conditional changes to rtsize because
> previously the only way we'd do the addition is if !rgcount, which means
> we were really only doing it if rtsize != 0.
> 
> And now that we always call adjust_nr_zones that part needed to be moved
> up.
> 
> I think I understand what's going on here, so

Yes.

