Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCAB1DFE34
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 07:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736233410; cv=none; b=DN0OnKLuXgzkjaX5ycQqZMhaS42D899KJ4KbMfY4w2cAyhpK0zWU3iAPkTfp59zCnDMwkeIZeNo1Fnl3Gr02uzjRzIdUVsGN8cJVGWyfyeF/MbjLvO7xdp3zbnUsqvCdEe1drhtoqsuslppGawmIym8Y8WyfBtcRNhLrDBwVTAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736233410; c=relaxed/simple;
	bh=EAL/h3lrVmVlnqmzWyUO9l6+qmXKV/BksXbDIV20Aw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PKU3I6ArYWHyFD96gEe7KYo/XJY5VIvxfkAe8Qd9DgBIz/nvI+3gdo1sipIuhUlXafNfBFQIF9byusyGjXkixHLUKPSX81ICFPlETOP7x1ObSnhTN89lp9uuAVmi8iynRWG5owG0kO99AetlgTQfSpwEDc2GOyHWinHkmxu9yxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E3E5A67373; Tue,  7 Jan 2025 08:03:22 +0100 (CET)
Date: Tue, 7 Jan 2025 08:03:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: move b_li_list based retry handling to
 common code
Message-ID: <20250107070322.GA14713@lst.de>
References: <20250106095613.847700-1-hch@lst.de> <20250106095613.847700-15-hch@lst.de> <20250107065547.GE6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107065547.GE6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 10:55:47PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 06, 2025 at 10:54:51AM +0100, Christoph Hellwig wrote:
> > The dquot and inode version are very similar, which is expected given the
> > overall b_li_list logic.  The differences are that the inode version also
> > clears the XFS_LI_FLUSHING which is defined in common but only ever set
> > by the inode item, and that the dquot version takes the ail_lock over
> > the list iteration.  While this seems sensible given that additions and
> > removals from b_li_list are protected by the ail_lock, log items are
> > only added before buffer submission, and are only removed when completing
> > the buffer, so nothing can change the list when retrying a buffer.
> 
> Heh, I think that's not quite true -- I think xfs_dquot_detach_buf
> actually has a bug where it needs to take the buffer lock before
> detaching the dquot from the b_li_list.  And I think kfence just whacked
> me for that on tonight's fstests run.

Ooops :)


> > +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> > +		set_bit(XFS_LI_FAILED, &lip->li_flags);
> > +		clear_bit(XFS_LI_FLUSHING, &lip->li_flags);
> 
> Should dquot log items be setting XFS_LI_FLUSHING?

That would help to avoid roundtrips into ->iop_push and thus a
dqlock (try)lock roundtrip for them.  So it would be nice to have,
but it's not functionally needed.
