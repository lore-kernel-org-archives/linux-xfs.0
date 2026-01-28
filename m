Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7501C1D86DC
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 05:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769576640; cv=none; b=SSkCGaQuJv1ux8RZghp3F4sE1nSg3j4a6sgBORgqs8KGWo28QvP94ri4J1RcoGJKzoZ55E/UZm0MRwyd1RHSozoW1lH4OvUXaIs8xP2723yVFThUix2hjizHXj8Dd8jpYfb/77ykDv2s/0YEceJYoB6LEHVS8tWR0m3kNiFMDhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769576640; c=relaxed/simple;
	bh=AUpxfnOIDNP5EMdGPqH+aXUYRZEgLnNObo+h72RQ8Ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rlr/rQobBw0YrcjD+LwjWOBjDncLO0roBkerHpdYR+kt+jGFg4+f1EvAbyy2UiGfM8UmM9OR57fRZeQzXCjGYttfvcWk2zBjMQQBKc7rrffMU2Ho7y0B6TfTD0kkzrwlpSwhuqU77DW/jwSveUhgRAC8GL46E2LenSWFGUYrqrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 386D8227A8E; Wed, 28 Jan 2026 06:03:55 +0100 (CET)
Date: Wed, 28 Jan 2026 06:03:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Message-ID: <20260128050354.GA620@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-5-hch@lst.de> <20260128013525.GD5945@frogsfrogsfrogs> <20260128034459.GB30989@lst.de> <20260128050255.GL5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128050255.GL5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 09:02:55PM -0800, Darrick J. Wong wrote:
> > Talking about dmesg - one thing that annoys me for both of them is
> > that the messages is prefixed with the file system ID, but then
> > also adds ', on filesystem \"%s\"' at the end, which is a bit silly.
> 
> <nod> I think it's silly too.  Want to send a patch for me to rvb?

Once I get through the rest of my urgent and medium priority queue,
sure..

