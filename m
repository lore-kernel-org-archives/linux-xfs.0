Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03D0345CA8;
	Wed, 19 Aug 2026 23:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787181887; cv=none; b=G1Z0/EHylY+PxkhQwkqMVGHem/vujqosR6QIhMK9muo/oW6Ov1/xgn8DSlwfzFJ3QI4E3uzVHkwkqwe8Zs1azoVcbX0XQ+Ti6sU29kVIzDTZr87xwkXnOwyftxmLJtms1/3nsIle+UOnLX9V6eIlmKGDabRVj19YY8y/uLevRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787181887; c=relaxed/simple;
	bh=yGzYprbhQWs48l4ZpNSsMEDtg2F5WtBiCcuAqkdwOA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTevi7GVuu4GfSITeH365QDwVvYsQIC4rNliAiYIdoyWZU4WJsaU+RPcBdmYYoo8+2X5B0Y1dw0kjK8BVjAdNYwhx3KsokYWLTBluL7xi1XbqFCJIj8OLTI0jMZevrNz800qki5lC6MywYlbyGkXiV+nWtImDyN2UoxfSf+BJE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=duQP3cpb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="duQP3cpb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 54DCD1F000E9;
	Wed, 19 Aug 2026 23:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181886;
	bh=sVdjCZdzb9b+pwktxqHeYShjn6w16T/REVsbT+FLn7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=duQP3cpbG17noWffOiNrpVCs912V7ihlM9TYziOqoq00gwDHj352lytc7cgbZoA7h
	 R0zHY6a4s3k7v6Ky3dp2I8/bWzmcU2IGioR1CUNmcwUIaBcK40SHL7x304KwImNkY5
	 5DBR1vjuDHA3HYZxDVRtwaUCvPi+ObcYWfqCgMyhz51wGkDedLmq/6KxeHdSpavZLu
	 HAY5n53OFRaYABYlBVJiNWcK9sObKxb/qJwoC2rJPX2BsOUzj5Zv2AfBPdfrEqeuOo
	 03HTcb2yYX66FHIacGwf9SKJJLsWlC27DUZBXVb2PlN2sB26uwzPPE/usoT4cOGhnK
	 eEjwIVmrzxOmg==
Date: Wed, 19 Aug 2026 16:24:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: don't modify file attributes or poke fsnotify
 for dry runs
Message-ID: <20260819232445.GE6072@frogsfrogsfrogs>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659861983.833922.10991178975977666480.stgit@frogsfrogsfrogs>
 <aoVMFaHJoBl-xYAb@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoVMFaHJoBl-xYAb@infradead.org>

On Tue, Aug 18, 2026 at 11:24:21PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 12, 2026 at 10:26:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM points out that a dry run shouldn't poke fsnotify because we don't
> > actually change the files.  I noticed that we also shouldn't be removing
> > file privileges when doing a dry run.
> 
> > +++ b/fs/xfs/xfs_exchrange.c
> > @@ -701,6 +701,9 @@ xfs_exchrange_contents(
> >  	if (error)
> >  		goto out_unlock;
> >  
> > +	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
> > +		goto out_unlock;
> > +
> >  	/*
> >  	 * Finish the exchange by removing special file privileges like any
> >  	 * other file write would do.  This may involve turning on support for
> 
> This just skip removing the privileges.  I guess the commit mentions
> this on the side, but this is probably the important part, so my
> emphasis it?  It would also seem easier to move the check into
> xfs_exchange_range_finish next to the code that it guards.

Yeah, I'll move it, and rearrange the commit message.

> > @@ -783,6 +786,9 @@ xfs_exchange_range(
> >  	if (ret)
> >  		return ret;
> >  
> > +	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
> > +		return 0;
> > +
> >  	fsnotify_modify(fxr->file1);
> >  	if (fxr->file2 != fxr->file1)
> >  		fsnotify_modify(fxr->file2);
> 
> Move the fsnotify calls into an if statement instead of the
> early return?

Done.

--D
