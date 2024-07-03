Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53709522F
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 02:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719974859; cv=none; b=Elk8KoQSocAUJT74yjtEojWOzEWNHrovriMNJXnywVuEyRfeIOaODh6Gs70PJt7H2MfNA/QKmB2McSnCYsD62YtlI+mIghfmzUh6s4dzAFes93tELS+8CYPqeN4HYvPAdOmcMEBmfHMe0hS5X2hAkKjdzSLx26MjqccJvL+bPUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719974859; c=relaxed/simple;
	bh=TrZ7+oQb74cbkgMHqPnd+f7x5jc6ge5OdLfNc04Rzkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MlExF+wOPYF+mWkfi/gDu/kzgnIsW3iOv5FSD8TJQ4jFR2h+UnhAVP/kt6ZYyM5rbuPsU5Se2FTXzIkQMjPD/P4ZVXW+bABmZoKcM/NsmYjcmdpOk0BhGlmOyLrxdKB55d+J6GhbvMZsbho0a/KvI/jot65qIF8PR5IjHP5gMKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6BZQgp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6BZQgp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD124C116B1;
	Wed,  3 Jul 2024 02:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719974858;
	bh=TrZ7+oQb74cbkgMHqPnd+f7x5jc6ge5OdLfNc04Rzkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P6BZQgp6sISqoYqfwmY6Oh1AtgCNqfkGh7QpK5WBMeIBZGX9MMgPFBLC9lpZDArFX
	 Xdr4jId4jBuuPcadX9xITb1ZTQftos4qCcNsVrXpfarOn4PBnsPHTzDZ72jmvJII/C
	 TJ8CIBlfJ5ZHXXbz+s7kFOhCnvnV50KfSvpD1Bp8jsAWgAg9Olo+9Cbf/w2ViRHyo3
	 JtyOtlhuo7V50kERfTGTu9kWpptgCs0auFCDB/SmzSy6lrNT+hl0DrK3bcnmN4pYvY
	 7YkomxlgVRiivp6tDh+GrldsqgLJUVFTkD4SjYO55Vb03dBx9TRaJFTHPLBJRYQ/kO
	 RXGihq/zQnytA==
Date: Tue, 2 Jul 2024 19:47:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] libfrog: hoist free space histogram code
Message-ID: <20240703024738.GU612460@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
 <171988118595.2007921.8810266640574883670.stgit@frogsfrogsfrogs>
 <20240702053238.GH22804@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702053238.GH22804@lst.de>

On Tue, Jul 02, 2024 at 07:32:38AM +0200, Christoph Hellwig wrote:
> > +struct histent
> > +{
> 
> The braces goes to the previous line for our normal coding style.
> 
> Also the naming with histend/histogram the naming seems a bit too
> generic for something very block specific.  Should the naming be
> adjusted a bit?

Hmm.  Either we prefix everything with space, e.g. "struct
space_histogram" and "int spacehist_add(...)"...

Or change "blocks" to "value" and "extents" to "observations":

struct histent
{
	/* Low and high size of this bucket */
	long long	low;
	long long	high;

	/* Count of observations recorded */
	long long	nr_observations;

	/* Sum of values recorded */
	long long	sum_values;
};

struct histogram {
	/* Sum of all values recorded */
	long long	tot_values;

	/* Count of all observations recorded */
	long long	tot_observations;

	struct histent	*buckets;

	/* Number of buckets */
	unsigned int	nr_buckets;
};

int hist_add_bucket(struct histogram *hs, long long bucket_low);
void hist_add(struct histogram *hs, long long value);
void hist_prepare(struct histogram *hs, long long maxvalue);

and then hist_print/hist_summarize would have to be told the units of
the values ("blocks") and the units of the observations ("extents") to
print to stdout.

The first option is a bit lazy since there's nothing really diskspace
specific about the histogram other than the printf labels; and the
second option is more generic but maybe we should let the first
non-space histogram user figure out how to do that?

<shrug> Your thoughts?

--D
