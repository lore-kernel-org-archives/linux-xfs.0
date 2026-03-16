Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CA01EFF8D;
	Mon, 16 Mar 2026 22:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699419; cv=none; b=dtHAmWduIdhPOx36PXEK8iSA2sWzM3eGyPBUMOYRus/HAka9fv48ObMEQ3BhME8ZJ1avuceKAcWVvhSMzMkGSH8/poSD5mUcoPvtZbvFbLqjUl1QTyzKxK80ZU0gDhdZ1G7un0XmOplq3QKmEiilNvCm/HA3nzcUFI5PqW/9Mds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699419; c=relaxed/simple;
	bh=9/ddb1SP6k/xG0ZpOihKYWzLNg8v3bBmiO7ve/RoWv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1YcXnjebLbRMvc4VHTMQMU9oqdcXJTTkCLwjwwtgUv0huHS2nsSJjYJ73hSYeRHtGbU2u19vlRbs20oY1IQblmnr6IxGBOVkN1guenB4qzOrDxLLSy2fePV7oBsdSOMkgs0rWt9xi2JZ5pfM0a6XAJtafr0+UbrEnupl51YgGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJ0F5g/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJ0F5g/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B90C19421;
	Mon, 16 Mar 2026 22:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773699418;
	bh=9/ddb1SP6k/xG0ZpOihKYWzLNg8v3bBmiO7ve/RoWv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fJ0F5g/mo2CuhG6kFeUm9KVXbdiWRW/jnPFVhUUuJofUkzzvn5T73kYgORTO1b3vl
	 5WAc654SBlmJ7s3r0l/fWiNc0cyISlTEoeiwmAl9zCwTXXLOHrZjQd8aXqlf/wi+nz
	 ltkumVy1IwP2hjGTzIAq+IynLDvN5YLbc477yIAMAdqvFAymwU/JYw2ZX8nE9xxR4E
	 7yBtosddFr/FQ8HQp7z3BK0wj+uaQOHyDbB3rDxa1H6zqWObWO5W6Jrc1G2Eehruae
	 odOma2+F3vnNp9E4Gbh9MmmjyXWcM19x1fMhLSUY/ALYZ4pDPfoGUz9qvvtoprLY6f
	 /ADvlumVVBDLA==
Date: Mon, 16 Mar 2026 15:16:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
	fstests@vger.kernel.org, amir73il@gmail.com, gabriel@krisman.be,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
Message-ID: <20260316221658.GO6069@frogsfrogsfrogs>
References: <177311403420.1186306.10503664469609309721.stgit@frogsfrogsfrogs>
 <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>
 <abfIexgmKjS1Q7bN@infradead.org>
 <20260316162147.GW1770774@frogsfrogsfrogs>
 <20260316184041.ji5slfx4yvtfwwzq@doltdoltdolt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316184041.ji5slfx4yvtfwwzq@doltdoltdolt>

On Tue, Mar 17, 2026 at 02:40:41AM +0800, Zorro Lang wrote:
> On Mon, Mar 16, 2026 at 09:21:47AM -0700, Darrick J. Wong wrote:
> > On Mon, Mar 16, 2026 at 02:08:11AM -0700, Christoph Hellwig wrote:
> > > On Mon, Mar 09, 2026 at 08:50:08PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Test the fsnotify filesystem error reporting.
> > > 
> > > Still would be helpful to explain what is being tested and how and
> > > the source of the test tool.
> > 
> > "Use dmerror to inject a media error for a file's storage, then run some
> > IO and make sure that fanotify reports the IO errors."
> > 
> > (I'm not sure what the process is for updating commit messages once
> > something's in patches-in-queue...)
> 
> patches-in-queue is a scratch branch, I always re-push(-f) to this branch.
> So please feel free to tell me what do you want to update in this patch
> (I'm going to make the next fstests release soon:).

Just the two changes I've mentioned so far in the threads, please.

I've more fixes to make to these tests, so I'll send those patches
shortly.

--D

> Thanks,
> Zorro
> 
> > 
> > > > +#ifndef FILEID_INO32_GEN
> > > > +#define FILEID_INO32_GEN	1
> > > > +#endif
> > > > +
> > > > +#ifndef FILEID_INVALID
> > > > +#define	FILEID_INVALID		0xff
> > > > +#endif
> > > > +
> > > > +static void print_fh(struct file_handle *fh)
> > > > +{
> > > > +	int i;
> > > > +	uint32_t *h = (uint32_t *) fh->f_handle;
> > > > +
> > > > +	printf("\tfh: ");
> > > > +	for (i = 0; i < fh->handle_bytes; i++)
> > > > +		printf("%hhx", fh->f_handle[i]);
> > > > +	printf("\n");
> > > > +
> > > > +	printf("\tdecoded fh: ");
> > > > +	if (fh->handle_type == FILEID_INO32_GEN)
> > > > +		printf("inode=%u gen=%u\n", h[0], h[1]);
> > > > +	else if (fh->handle_type == FILEID_INVALID && !fh->handle_bytes)
> > > > +		printf("Type %d (Superblock error)\n", fh->handle_type);
> > > > +	else
> > > > +		printf("Type %d (Unknown)\n", fh->handle_type);
> > > 
> > > 
> > > Isn't this always going to print unknown for normal xfs mounts without
> > > inode32?
> > 
> > Yes, though generic/791 filters out the file handle and (TBH) I don't
> > really want people getting ideas about cracking file handles.  Probably
> > we should just eliminate this whole part of the function, but that would
> > make future forklift upgrades from the kernel harder.
> > 
> > --D
> > 
> 
