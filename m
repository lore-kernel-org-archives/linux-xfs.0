Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BC14A842A;
	Wed,  2 Sep 2026 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788362403; cv=none; b=cOI27P5Tyj5EfcBz5s4ufDS3w5Fi6ah4sfBsLgOkAytOOt+VtXO4Ebv4Qymn+T8Jsi1dbEl3rjI2rpYyzHUv774W4K45KalX7n8UQoMiW55+I5+ybv+PjQnetqpYz9K5/dK8Z+uIeSO+vbVfB93eN5N81aLl1Ml/wHXYx+dO0JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788362403; c=relaxed/simple;
	bh=uFP8J5EXMhs00kk7jsBpSsGRsisagizHUXhpkHa/viI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLbwzZYQK3nWTtabGJl3O837lmuKNuyGHQfTjaHIHy9cXlEOiw+MJJjYQV4HdwAqaNqIYAGTYOhv7galPcAatUIgoFxwkUJPNpLidzuPxOlcmS00aP6zDp0aDXsDKlv54M2p28NtmdFVP1QFQD4nQql6X1AqIebs6LUUKYAh3dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTJnupJ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTJnupJ+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 687111F000E9;
	Wed,  2 Sep 2026 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788362401;
	bh=yMg+OKFdRgSNdKbjVBuTc1zv/0phWnw3115wFmKeG5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RTJnupJ+9eLFLky2Gcodkqh38eIHRwy9yCIAiGJwIYftk9rFBCKrG4YFcch2CeCwG
	 pA11kbvQXgmBU+uLgs21RzUaZqkitcqQCNdHbdvwfzd5CeWVU/3YB43hp/R39NuH5D
	 36Qn2Mx0Xgx3i6RBewDHNjXztCTtRDWhMwtIxyV18PHuOP0AstmGG4Gxq3JhnPUGTu
	 Jx2GQYSLPwNR9WnyyrD6It1mst6I3toBj/4WqJsnzVQcrQd3f0H1gARTjiQFHWvK44
	 /NpthswKWkhh+2xeMrUrN7hbyu57V0y3v0a5H6Lt4y+o+CNzJTHb2Sn3z631GF023h
	 0xaXhFwLIksQg==
Date: Wed, 2 Sep 2026 08:20:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: basic functional testing of media verification
 command
Message-ID: <20260902152000.GK839663@frogsfrogsfrogs>
References: <20260826183105.GX839663@frogsfrogsfrogs>
 <20260902072933.GA26979@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902072933.GA26979@lst.de>

On Wed, Sep 02, 2026 at 09:29:33AM +0200, Christoph Hellwig wrote:
> > diff --git a/common/xfs b/common/xfs
> > index 81add2086866c8..8dec3475579e40 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -1786,6 +1786,9 @@ _xfs_filter_mkfs()
> >  	}
> >  	if (/^\s+=\s+rgcount=(\d+)\s+rgsize=(\d+) extents/) {
> >  		print STDERR "rgcount=$1\nrgextents=$2\n";
> > +	}
> > +	if (/^\s+=\s+zoned=(\d+)\s+start=(\d+) reserved=(\d+)/) {
> > +		print STDERR "zoned=$1\nrtstart=$2\nrtreserved=$3\n";
> >  	}'
> 
> How is this related?  Maybe split it out into a well-doumented patch?

The test sources $tmp.mkfs and reads the rtstart= variable that is
created by the addition to _xfs_filter_mkfs.  I'll split this into its
own patch with a separate justification.

> Also does the ' after the } break the usage?

No, because it's an awk script embedded in a bash string argument.

> > +
> > +# Make the data and rt volumes small enough that this won't take forever
> > +# on large slow devices.
> > +_scratch_mkfs_sized $((600 * 1024 * 1024)) | _filter_mkfs 2>$tmp.mkfs >> $seqres.full
> 
> Split the overly long line?

Ok.

> Otherwise this looks good to me.

Thanks!

--D
