Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D69E1624D5
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 20:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559928; cv=none; b=TQPHhb12ed/gMvq8xmxVgmRHxwVnyj3yjhXuoANOJSOmnko8VchT7dRdvVKjC/f7EPoK7Etrn4BqOE5q24TakdNy7zuMk8EyriatzISFX4VNurKZmVT5GLuXJuJ5XgyLF8p4Uh+C6Eh6Wbh2fsBNquxE+6btRibeauGP6LLMVR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559928; c=relaxed/simple;
	bh=VWY7g3BKO2AAvU82ZtjthsyIxjCEj6jVejJj6ffwey0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3HrZlAfw02E/23vvcOs30ehvKGvM2pkyu8eVqp42KhhwVGBuL5fecet6wTdEjtFHdhLMyEFwbFx4Vz1t0/Vz8cqqjZm4Z/+hIYonly0Olmw9NsVg9v+sx46C7CABXbaNlW0IyvR4FVBAtw7AI53Gn5emdz+eChvVEQvME+Zou4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k8OnMm/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k8OnMm/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8CCC4CEF8;
	Wed, 15 Oct 2025 20:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760559928;
	bh=VWY7g3BKO2AAvU82ZtjthsyIxjCEj6jVejJj6ffwey0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k8OnMm/u0qRS1SLnYGdABEHxbclg3Tg8RCUcAGi0A4tlri7jNNE75jmXc6lpV1Hur
	 ITnO0uOHMrO9eOM+6JdzLwp9HDsF2lK55x2VebFQdqDl/5o4KHttTaLnADezltxruo
	 biFsxUrxlQIdCW2f+uvzcQK2SSrwOnHNt6ZAQtoVGjetscIOny80DkbLm89gDbXJ6X
	 UfNloL5VqAbvpfLIi9CNsfTNKhRsXhGjwD5vwreoT3wUwJ7IWD02DhiJBIeoQJAggh
	 eu0stqZJn10yr7CHXRz8RjMJQePLkXfLcPBKVBuqmT2geG6Ts2aIu2HPIMZW/MFRTm
	 ql6/+RAb0NBLw==
Date: Wed, 15 Oct 2025 13:25:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: add a on-disk log header cycle array accessor
Message-ID: <20251015202527.GE6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-3-hch@lst.de>
 <20251014212717.GH6188@frogsfrogsfrogs>
 <20251015043238.GA7253@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015043238.GA7253@lst.de>

On Wed, Oct 15, 2025 at 06:32:38AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 14, 2025 at 02:27:17PM -0700, Darrick J. Wong wrote:
> > > @@ -1543,14 +1538,6 @@ xlog_pack_data(
> > >  	if (xfs_has_logv2(log->l_mp)) {
> > >  		xlog_in_core_2_t *xhdr = iclog->ic_data;
> > >  
> > > -		for ( ; i < BTOBB(size); i++) {
> > > -			j = i / XLOG_CYCLE_DATA_SIZE;
> > > -			k = i % XLOG_CYCLE_DATA_SIZE;
> > > -			xhdr[j].hic_xheader.xh_cycle_data[k] = *(__be32 *)dp;
> > > -			*(__be32 *)dp = cycle_lsn;
> > > -			dp += BBSIZE;
> > > -		}
> > 
> > Just to orient myself -- this is the code that stamps (swazzled) LSN
> > cycle numbers into the log headers, right?
> 
> Yes.
> 
> > > +static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
> > > +{
> > > +	if (i >= XLOG_CYCLE_DATA_SIZE) {
> > 
> > Does this need a xfs_has_logv2() check?  The old callsites all seem to
> > have them.
> > 
> > What should happen if i >= XLOG_CYCLE_DATA_SIZE && !logv2 ?  Should
> > this helper return NULL so that callers can return EFSCORRUPTED or
> > something like that?
> 
> It can't happen.  It is bound by l_iclog_hsize or h_len, which
> can't go into the subsequent blocks for v1 logs.  For the recovery
> case we also check for h_len being smaller than h_size, and h_size
> is fixed to XLOG_BIG_RECORD_BSIZE for v1 logs.

Oh ok.  Yeah, that's right, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

