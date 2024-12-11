Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E6B1E9B3C
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733952062; cv=none; b=mQfXhCbx9lnVSkpWvs9RACk1KKHq9qu65PFJqRW8vedM/1yTB4+0Q7P1mQ1JNPVsMgJt3YLt+TJ4JakcVSlwRDFqqb9taAWvFKOHa6ojF/qje/K3raIrBcAd7iHckwhAkZmte5QdChzbqdTGo9pjJ4AduiYozsEegqk05BmDmTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733952062; c=relaxed/simple;
	bh=Ec5lLpC71EayugZrO7GusugIBq/JCbPo0+ovlOWLf1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5T/CcJSCCTrOV+WQTcsgr83PI7F0UTjbZ7NbB56EwWm+vlAeWLOB0cJKU65jPRbngykV0pzBkG8FOXhmriWBrL7bkFTOT6fEUZg71hGGEtGu+sPgnywQYy2OeNfoGDoHkcYd1zWg/Zg6DK7AQ+dMoBieliBVDXu6PY5ct5jhL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJ7wVEoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJ7wVEoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F550C4CED2;
	Wed, 11 Dec 2024 21:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733952061;
	bh=Ec5lLpC71EayugZrO7GusugIBq/JCbPo0+ovlOWLf1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kJ7wVEoSJ6oEIdX0yKFxfz4fZliXuc0xuv1jBMGcMQfDdXztWNqB0gtZmNSHwYNW5
	 YRX+NI9M4HKpinUhY35kzMfYiSs3dz2HIMJ4s7X72kZsUVsCZ8Dk8zNUM4vAvp9WyF
	 78FO2cWOqZOXF6Ut4oVvtk0EvBKZf52cF/MLrUD3gb6yVVaCsjz73LfJOho9QVa+Uc
	 DRT8dvhm6KLb2V+/fbvwitcjJ0NmcvdawMYVEQuy4CmzI/aT1JQOjhMytLmAvKw1r6
	 Gw7SiqKtOHtFRnQw6MOhGTVJdnvqQdQhnAhzL5btSt1NXAp3+4BtrZeHS26XSsK5Y5
	 kybKElJOt89gQ==
Date: Wed, 11 Dec 2024 13:21:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/41] xfs_repair: update incore metadata state whenever
 we create new files
Message-ID: <20241211212100.GO6678@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748710.122992.8928188548717908519.stgit@frogsfrogsfrogs>
 <Z1fPAUIK4dKEIBcD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fPAUIK4dKEIBcD@infradead.org>

On Mon, Dec 09, 2024 at 09:17:53PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2024 at 03:47:43PM -0800, Darrick J. Wong wrote:
> > +{
> > +	struct ino_tree_node	*irec;
> > +	int			ino_offset;
> > +
> > +	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
> > +			XFS_INO_TO_AGINO(mp, ino));
> > +	ino_offset = get_inode_offset(mp, ino, irec);
> > +	set_inode_is_meta(irec, ino_offset);
> 
> Nit: I'd do away with the ino_offset variable here.

<nod> I'll clean this one up similarly too:

static void
mark_ino_metadata(
	struct xfs_mount	*mp,
	xfs_ino_t		ino)
{
	struct ino_tree_node	*irec =
		find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
				   XFS_INO_TO_AGINO(mp, ino));

	set_inode_is_meta(irec, get_inode_offset(mp, ino, irec));
}

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you!

--D
