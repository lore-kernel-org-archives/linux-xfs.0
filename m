Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C248B14E2F2;
	Thu, 29 Jan 2026 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769698954; cv=none; b=EADO4yYV/guOE+pjCFS249aUy/XGXgyy2tqsTmebJR2ZoVTr7LeLiBJDHyEyzUzpHDa+guikcOUqR6Xj474E9l3H3DNJkmhSLpM/YV30Xwr+350HKieMoi7+8ilhAAQko6hZj9JXgC3uCzCtbDkGk7FbSzl8wNXEHNSx/elvNc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769698954; c=relaxed/simple;
	bh=J+y3lhsdVJJhsaNBmnJtoAxChDaUcHRnC/rbUBl8U08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltNoNbgukSHOuyhN/S5S8czqfhSStnlEV/u1DZuTxZj6HEcIfhaFE50sJlq7K6fEisgB6PH6sgaqcE4HnMP2J0kzjpI97S8hjcbQLH5FPfnoOqMkwblrOWRkYJY/WrzF9yjMAEUVpHiJlkU9XJY9NoL052TDlZjx/1sjdOWmiPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HVQbK445; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HVQbK445"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA438C19425;
	Thu, 29 Jan 2026 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769698954;
	bh=J+y3lhsdVJJhsaNBmnJtoAxChDaUcHRnC/rbUBl8U08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HVQbK445T75/BICAAaBr7m65y74gAqiVvZR1vn3jccmqx+jhyuXKDkdUXGhh7dxW2
	 sv1xv2AdjSJlqCOFW0jzrI7Xrcy5s3J9IP+MOxXQTV+bhnXRk2mkcUXH66BZLJP0+t
	 u05mvnbj0pVv9lrkB6UbrgGOzCk9NKYbHJ/ZFHTwjdKTML1VbhnmBeeAr5HanFGHmn
	 3rYLuf5oIPtArGlpguX0JFNhVHh8EIFqaePWBHqkInFb3V7b3wksHV88ukfvZjAqnQ
	 iygH7Bd1O8ISGZ+b67v9yIIWtcX4x2jvRJjRrd8zlP0v/OtAa9xQCvny10pYUU0a0t
	 xLhqSBnTQ/FlQ==
Date: Thu, 29 Jan 2026 16:02:29 +0100
From: Christian Brauner <brauner@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org, djwong@kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH v2 2/2] fsverity: add tracepoints
Message-ID: <20260129-abgraben-atemzug-b46d8fdfcb64@brauner>
References: <20260119165644.2945008-1-aalbersh@kernel.org>
 <20260119165644.2945008-3-aalbersh@kernel.org>
 <20260121003917.GC12110@quark>
 <20260124184954.GC2762@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260124184954.GC2762@quark>

On Sat, Jan 24, 2026 at 10:49:54AM -0800, Eric Biggers wrote:
> [+Cc fsverity@lists.linux.dev]
> 
> On Tue, Jan 20, 2026 at 04:39:17PM -0800, Eric Biggers wrote:
> > On Mon, Jan 19, 2026 at 05:56:43PM +0100, Andrey Albershteyn wrote:
> > [...]
> > > +	TP_printk("ino %lu data size %llu tree size %llu block size %u levels %u",
> > [...]
> > > +	TP_printk("ino %lu levels %d block_size %d tree_size %lld root_hash %s digest %s",
> > 
> > Would be nice to make these consistent.  3 of the parameters are the
> > same, but the naming and order differs slightly.
> > 
> > [...]
> > > +	TP_printk("ino %lu pos %lld merkle_blocksize %u",
> > > +		(unsigned long) __entry->ino,
> > > +		__entry->data_pos,
> > > +		__entry->block_size)
> > 
> > Likewise here.  So now we have "block size", "block_size", and
> > "merkle_blocksize", all for the same thing.
> > 
> > > +	TP_printk("ino %lu data_pos %llu hblock_idx %lu level %u hidx %u",
> > > +		(unsigned long) __entry->ino,
> > 
> > And here's data_pos as a %llu, whereas in the previous tracepoint it's
> > just pos as an %lld.
> > 
> > > +TRACE_EVENT(fsverity_verify_merkle_block,
> > > +	TP_PROTO(const struct inode *inode, unsigned long index,
> > > +		 unsigned int level, unsigned int hidx),
> > 
> > And the 'index' here is what the previous one calls 'hblock_idx'.
> > 
> > I think consistent naming would be helpful for people trying to use
> > these tracepoints.
> 
> Andrey, let me know if you're planning to send a new version with the
> naming cleaned up, or if I should do it in a follow-up patch instead.
> 
> Christian, can you let me know if it's okay if I take this series
> through the fsverity tree, or do you want it to go through the VFS tree?

Yeah, I can take them no biggie.
Tracepoints, heh, who would've thought.
