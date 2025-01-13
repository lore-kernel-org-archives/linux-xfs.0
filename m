Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A439E28FD
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 07:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752687; cv=none; b=N6k7HTptNfu8lFVofSFzUg1HuWhElakide8hB1YcqvrdG9/wq45K7MDgIKocWF1vGS9Ej1dlYhG4kVd8t+KQqroSAVO0AIuyjwRKXJbpxLFYNSoyyTRYDsInYMmLd3Spe48tKEYR9sHORFF+/BtnRXv8GqTLwfwA4/mfasSFjLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752687; c=relaxed/simple;
	bh=qBYThQteG0s5cw07DEIOHl5T+5WaZeawwk3HVABht9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u4DDqc5OCtHUqFlXNRETGL8Qw7dkcpSlWZFjj5V//bzMdIE9GY1zTBeYxu458eRy0FadhKZ4PPoayM2W9Xokc4ePmBzOtU7cshcCNIcbCZX6k9fctoA+vAN6tHgn6q9WJGSxVsEkFc7WfPly1Dm7KEFzRmgIkQqkd0LnUFhYOEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMIn3ypH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMIn3ypH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE2EC4CED6;
	Mon, 13 Jan 2025 07:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736752686;
	bh=qBYThQteG0s5cw07DEIOHl5T+5WaZeawwk3HVABht9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UMIn3ypH0pwddRs7d+BWx3ws0wgj45uZ3MMVYLAUmGXssf5yjDbt/Ep7MZ00sTd6z
	 B5T+Z4hJypA2PntIxNZ8zkKyTTCh7Eo3CZERFKolnrTTTAnCMErjgWi5wzFxlfFglQ
	 TdqwrxsveOEOMexOYkSO72zBhDCIYnXBGihPYHSz1Oqmw616zcqwi2hztxgNn7hH4O
	 KGNcsKj+3QP/Ru1K3wPGmStTr8oAaIALlMrtkFBQglFJQ2lPC7Kme++65kaMt0Im3x
	 rPPGbOfukZ1HQhXPnmWNr11CPSJa5vdI+1Uao+GGFtVw52ak6qMmWwQ9dRjDdKIS7Z
	 ZH8EnrtjrAVoA==
Date: Sun, 12 Jan 2025 23:18:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: move b_li_list based retry handling to common
 code
Message-ID: <20250113071805.GB1306365@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-15-hch@lst.de>
 <20250107065547.GE6174@frogsfrogsfrogs>
 <20250107070322.GA14713@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107070322.GA14713@lst.de>

On Tue, Jan 07, 2025 at 08:03:22AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 06, 2025 at 10:55:47PM -0800, Darrick J. Wong wrote:
> > On Mon, Jan 06, 2025 at 10:54:51AM +0100, Christoph Hellwig wrote:
> > > The dquot and inode version are very similar, which is expected given the
> > > overall b_li_list logic.  The differences are that the inode version also
> > > clears the XFS_LI_FLUSHING which is defined in common but only ever set
> > > by the inode item, and that the dquot version takes the ail_lock over
> > > the list iteration.  While this seems sensible given that additions and
> > > removals from b_li_list are protected by the ail_lock, log items are
> > > only added before buffer submission, and are only removed when completing
> > > the buffer, so nothing can change the list when retrying a buffer.
> > 
> > Heh, I think that's not quite true -- I think xfs_dquot_detach_buf
> > actually has a bug where it needs to take the buffer lock before
> > detaching the dquot from the b_li_list.  And I think kfence just whacked
> > me for that on tonight's fstests run.
> 
> Ooops :)

...and I think this is now in -rc7 so no worries here.

> > > +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> > > +		set_bit(XFS_LI_FAILED, &lip->li_flags);
> > > +		clear_bit(XFS_LI_FLUSHING, &lip->li_flags);
> > 
> > Should dquot log items be setting XFS_LI_FLUSHING?
> 
> That would help to avoid roundtrips into ->iop_push and thus a
> dqlock (try)lock roundtrip for them.  So it would be nice to have,
> but it's not functionally needed.

<nod> Sounds like a reasonable cleanup for someone.

For this change,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

