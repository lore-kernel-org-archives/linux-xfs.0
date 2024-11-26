Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736D61DB361;
	Tue, 26 Nov 2024 18:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732645415; cv=none; b=Vw5gXflCH6UoxE3FBPvuQAPOz+uJkRwONYaN99pu5yr232JjE+7k9oyo2x5XpwYPMhSKfnWNYAQGaWQUZX3EeIorOS4Xhfq5BWtv9m615FAamM2XLuL6K8GPGa0d1XjE4fSLKOS6u8TCqy5kJ/FNy1vULW/dkiMAjqTWLk05H+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732645415; c=relaxed/simple;
	bh=oRCQPkvUx3vAejKxbIe/n2lHvxG7kxJFhMhg64gu2tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/fuW1RnVWrfwi7G/5NMlNy3XZOsXpRWvVgswi8HAYPRrHy7b8tWg/WBk4LeRGCrYmn6YNtXiyjEmmKWoq+ga+zQQ5qRj1QDrbLBEVgADxTRz7EE9+BoqIiChi3P6f/UmHvBoyORormxDpGv70u0yMWguvNuYf/6o42PeSc1G3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MwIdkcsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MwIdkcsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF959C4CECF;
	Tue, 26 Nov 2024 18:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732645414;
	bh=oRCQPkvUx3vAejKxbIe/n2lHvxG7kxJFhMhg64gu2tw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MwIdkcsxVbshwEXSR0GQG4ZMLyZ12h77AvkMJGNTr/yAo8CV0X+aSTfXeO5/Da9kg
	 p5MXjtEOWdSMvxSBgSGZ+N07EO6dBDzGTpeArSVVFj+n5bW7N3YjIjWHEpJobEgYER
	 OVE8RsR2XENMJb/A1e6KA2QoWdas9qA4cm6lZOsZds3y9XSQja3BLwlKCs+3o54Ysn
	 mNsEf0uR7CcJqGzgk0aPPcoVKK35f6OiJXwKaiBF3no5VKRB2wBGQ0ONIwyv7riokM
	 2xD0Dffnyykt34mehOALb6ziLMrxDDl3j5h64/8IxAMchtnDqoyxfeDUHI9drrNQUd
	 FioXELAJd+o0Q==
Date: Tue, 26 Nov 2024 10:23:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/21] xfs: don't lose solo superblock counter update
 transactions
Message-ID: <20241126182334.GL9438@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398074.4032920.16314140758572044747.stgit@frogsfrogsfrogs>
 <Z0VZH45ZY44o4Bjq@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0VZH45ZY44o4Bjq@infradead.org>

On Mon, Nov 25, 2024 at 09:14:07PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 25, 2024 at 05:28:53PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Superblock counter updates are tracked via per-transaction counters in
> > the xfs_trans object.  These changes are then turned into dirty log
> > items in xfs_trans_apply_sb_deltas just prior to commiting the log items
> > to the CIL.
> > 
> > However, updating the per-transaction counter deltas do not cause
> > XFS_TRANS_DIRTY to be set on the transaction.  In other words, a pure sb
> > counter update will be silently discarded if there are no other dirty
> > log items attached to the transaction.
> > 
> > This is currently not the case anywhere in the filesystem because sb
> > counter updates always dirty at least one other metadata item, but let's
> > not leave a logic bomb.
> 
> xfs_trans_mod_sb is the only place that sets XFS_TRANS_SB_DIRTY, and
> always forces XFS_TRANS_DIRTY.  So this seems kinda intentional, even
> if this new version is much cleaner.  So the change looks fine:

<nod> I don't think this one was absolutely necessary, it just seemed
like a cleanup to put anything that set TRANS_DIRTY before the
TRANS_DIRTY check.

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But I don't think the Fixes tag is really warranted.

Dropped.

--D
