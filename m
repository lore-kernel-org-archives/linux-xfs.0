Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B5D335555;
	Mon, 16 Mar 2026 16:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773678108; cv=none; b=WydAKUOKB5K43rXussqd0mLETH4kIMC89VS1ug/io4Z6dC0pK6bSnEvXjHPtUSd7AcFrvqZrtYgA7FM43I3Vjl4mwx4Fjdt5FU4s3Z0YNPJn4qatt0kLHMA+sW9VziLYSKmebBj9A6IugEowTKZkT2zEnSU2Ht289sbyR2PFEPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773678108; c=relaxed/simple;
	bh=dyI9tEp/aDnuaVyLOvx5/2se/SO25720OBM9Gp+/oV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sworxuRLQMW3Vazb7PGgDhcQWGxgWr7VdYoLt9LQJNLgu0R4hAywk8n3aNtfjqoQ4gDIZ2Ne0KYzDIwmwQrSdK5HWdXy+M/7OJPoqjOiDRzgQ0A4ZwWbVD7hc2uRrOhqoOUPbb4uy4bPTobn34+Jq/9Alq4nkadTH5RtJYwzNpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hchLvWF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hchLvWF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38014C19421;
	Mon, 16 Mar 2026 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773678108;
	bh=dyI9tEp/aDnuaVyLOvx5/2se/SO25720OBM9Gp+/oV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hchLvWF9kkZCmRXerEI/cEOHhU9umx6H99RjETiPSuKYuOjarki0gL4nu7BW/x/q9
	 gvTnueERBkJ0Miydc8h1SFR/2O3YHoS+fVB1/WtAElbtfi/OCDuu81wA0YeV6gRH88
	 8MiAaO+mQlUTznTz/nqsAVWBRIvXYK4+A1RQMMZM+BePEHGtzZMv4F2/mY0O/7s7j9
	 PpkZC7dWmPJ+th2Nf47AQpBv99JouuP4O1mELIiA788vszrxV0t5rKafEfEEQbk6Xz
	 JECun7sKYBqXvHI6+pKdpan01IE53rAOnxYEkKChHp9iDzim+uP9Gpe0rUbnlPFFE/
	 R5gjKwe3g161Q==
Date: Mon, 16 Mar 2026 09:21:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, jack@suse.cz, fstests@vger.kernel.org,
	amir73il@gmail.com, gabriel@krisman.be,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
Message-ID: <20260316162147.GW1770774@frogsfrogsfrogs>
References: <177311403420.1186306.10503664469609309721.stgit@frogsfrogsfrogs>
 <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>
 <abfIexgmKjS1Q7bN@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abfIexgmKjS1Q7bN@infradead.org>

On Mon, Mar 16, 2026 at 02:08:11AM -0700, Christoph Hellwig wrote:
> On Mon, Mar 09, 2026 at 08:50:08PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Test the fsnotify filesystem error reporting.
> 
> Still would be helpful to explain what is being tested and how and
> the source of the test tool.

"Use dmerror to inject a media error for a file's storage, then run some
IO and make sure that fanotify reports the IO errors."

(I'm not sure what the process is for updating commit messages once
something's in patches-in-queue...)

> > +#ifndef FILEID_INO32_GEN
> > +#define FILEID_INO32_GEN	1
> > +#endif
> > +
> > +#ifndef FILEID_INVALID
> > +#define	FILEID_INVALID		0xff
> > +#endif
> > +
> > +static void print_fh(struct file_handle *fh)
> > +{
> > +	int i;
> > +	uint32_t *h = (uint32_t *) fh->f_handle;
> > +
> > +	printf("\tfh: ");
> > +	for (i = 0; i < fh->handle_bytes; i++)
> > +		printf("%hhx", fh->f_handle[i]);
> > +	printf("\n");
> > +
> > +	printf("\tdecoded fh: ");
> > +	if (fh->handle_type == FILEID_INO32_GEN)
> > +		printf("inode=%u gen=%u\n", h[0], h[1]);
> > +	else if (fh->handle_type == FILEID_INVALID && !fh->handle_bytes)
> > +		printf("Type %d (Superblock error)\n", fh->handle_type);
> > +	else
> > +		printf("Type %d (Unknown)\n", fh->handle_type);
> 
> 
> Isn't this always going to print unknown for normal xfs mounts without
> inode32?

Yes, though generic/791 filters out the file handle and (TBH) I don't
really want people getting ideas about cracking file handles.  Probably
we should just eliminate this whole part of the function, but that would
make future forklift upgrades from the kernel harder.

--D
