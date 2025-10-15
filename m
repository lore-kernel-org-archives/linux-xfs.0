Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A0C1D47B4
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 04:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760502868; cv=none; b=TIQAXtpIV4c06N5ULaO7Y5owFmAUaJxOyq77chF7U0pxRLBu3Wr4NigOKlV5R25x/+XclUmiMBER7KdRvzUOhPO6D4xdvSm7kOHjy6H1Tic0Q/Giwk9rwcIdcCVbj0IYRDTL7erNp2nIYu6iW7++sLgWNolauikF41z6i5vrLEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760502868; c=relaxed/simple;
	bh=ziw5QimZfe6SHOpC06MqJN1ZIzPU8RnkNLGwJk00Y6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HztllyX70hjzsrwxNR8zN+IO8CMzNDl0Rb6m0lhu1z2I4Be5FyVAfJxW4VHeZtzynnJtNpfm61ATY7jMyUEOAv0/fq0pyThg/6yQRGSH2eeHyp14xNmOpZWvTu71abvFlrJQWClWXFeEjUWlZyqNb5n9eH5uJ64c2laSojmjYRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AD957227A87; Wed, 15 Oct 2025 06:34:22 +0200 (CEST)
Date: Wed, 15 Oct 2025 06:34:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: don't use xlog_in_core_2_t in struct
 xlog_in_core
Message-ID: <20251015043422.GB7253@lst.de>
References: <20251013024228.4109032-1-hch@lst.de> <20251013024228.4109032-4-hch@lst.de> <20251014214742.GI6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251014214742.GI6188@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 14, 2025 at 02:47:42PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 13, 2025 at 11:42:07AM +0900, Christoph Hellwig wrote:
> > Most accessed to the on-disk log record header are for the original
> > xlog_rec_header.  Make that the main structure, and case for the
> > single remaining place using other union legs.
> > 
> > This prepares for removing xlog_in_core_2_t entirely.
> 
> Er... so xlog_rec_header is the header that gets written out at the
> start of any log buffer?

Yes.

> And if a log record has more than
> XLOG_CYCLE_DATA_SIZE basic blocks (BBs) in it, then it'll have some
> quantity of "extended" headers in the form of a xlog_rec_ext_header
> right after the xlog_rec_header, right?

They are not directly behіnd the current definition of the
xlog_rec_header, but rather at each multiple of 512 bytes past the
start of the xlog_rec_header.

> And both the regular and ext
> headers both have a __be32 array containing the original first four
> bytes of each BB, because each BB has a munged version of the LSN cycle
> stamped into the first four bytes, right?

Yes.

> The previous patch refactored how the cycle_data transformation
> happened, right?

Yes.

> So this patch just gets rid of the strange ic_header #define, and
> updates the code to access ic_data->hic_header directly?  And now that
> we have xlog_cycle_data to abstract the xlog_rec_header ->
> xlog_in_core_2_t casting, this just works fine here.  Right?

Yes.

