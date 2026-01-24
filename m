Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E4D226CF1;
	Sat, 24 Jan 2026 18:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769280596; cv=none; b=E48A+a/iNps8xfVtKUZSa5nDEHJ4tYv5GkeHCt+b8ZwRqGgwW2BqN0KBViKivJBLXKZt95s6AJoBCCvGNB3n/KHGoXdJBnZ8qpULXk9hoD5KVNH3PzoDfGVxywsEMuJEik97F0MWBw8Yczq8SB2BygcWj6awS+X6bWJ7Ue+oJcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769280596; c=relaxed/simple;
	bh=J5DDkc2IWR66fCA/uqHO7egavLiMWvA/McTLbInAty0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P8WP5nH8uJDCxaBD33xAIjOJVb3V4cdivDBII5Gf2q96BDUY8U5xpzS8pOoQMNyO4fzmxZiaSlNVqDuupG00M0GCZHP/4GICZtnStLa2l0gEJDVxiYM6QbesNdbTZi/V16WWkQIamJrXucLmh7K18gnxVrADb4Bz98uWXrDwWxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojGjuRIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojGjuRIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5F8C116D0;
	Sat, 24 Jan 2026 18:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769280595;
	bh=J5DDkc2IWR66fCA/uqHO7egavLiMWvA/McTLbInAty0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ojGjuRIP4F55MSShykh15GVw8pfXNHCoWjD+9Zg4nXeOP0QE6wygXsbUyzehRYDY6
	 OZ9dNMTcHmVRIZWyYw0CSQbqhwXnMP2fW2Ge2DDbLVrN5dZkQ0jW0qaS8fcC+JYjYl
	 aSyhDlFLuTHb++5HGdGQpzcfDIT/KhSGBsI8kElX3WGVh47xtMAvJnR8DYKMXUJhpn
	 4xy+gdoAAS7fIRR0g/N671mC2wBGMhxLlKx9qp8scLYnbc1BmqfHhysdBPnds3pwrH
	 Prg4zMZhSiwUAO+mAKT8TPDUydVF5bqJ8qN76ZEP1rqnI5fv/wptHcxz/bH8AwogeW
	 8Yyh1aUuZdE4Q==
Date: Sat, 24 Jan 2026 10:49:54 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
	fsverity@lists.linux.dev
Subject: Re: [PATCH v2 2/2] fsverity: add tracepoints
Message-ID: <20260124184954.GC2762@quark>
References: <20260119165644.2945008-1-aalbersh@kernel.org>
 <20260119165644.2945008-3-aalbersh@kernel.org>
 <20260121003917.GC12110@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121003917.GC12110@quark>

[+Cc fsverity@lists.linux.dev]

On Tue, Jan 20, 2026 at 04:39:17PM -0800, Eric Biggers wrote:
> On Mon, Jan 19, 2026 at 05:56:43PM +0100, Andrey Albershteyn wrote:
> [...]
> > +	TP_printk("ino %lu data size %llu tree size %llu block size %u levels %u",
> [...]
> > +	TP_printk("ino %lu levels %d block_size %d tree_size %lld root_hash %s digest %s",
> 
> Would be nice to make these consistent.  3 of the parameters are the
> same, but the naming and order differs slightly.
> 
> [...]
> > +	TP_printk("ino %lu pos %lld merkle_blocksize %u",
> > +		(unsigned long) __entry->ino,
> > +		__entry->data_pos,
> > +		__entry->block_size)
> 
> Likewise here.  So now we have "block size", "block_size", and
> "merkle_blocksize", all for the same thing.
> 
> > +	TP_printk("ino %lu data_pos %llu hblock_idx %lu level %u hidx %u",
> > +		(unsigned long) __entry->ino,
> 
> And here's data_pos as a %llu, whereas in the previous tracepoint it's
> just pos as an %lld.
> 
> > +TRACE_EVENT(fsverity_verify_merkle_block,
> > +	TP_PROTO(const struct inode *inode, unsigned long index,
> > +		 unsigned int level, unsigned int hidx),
> 
> And the 'index' here is what the previous one calls 'hblock_idx'.
> 
> I think consistent naming would be helpful for people trying to use
> these tracepoints.

Andrey, let me know if you're planning to send a new version with the
naming cleaned up, or if I should do it in a follow-up patch instead.

Christian, can you let me know if it's okay if I take this series
through the fsverity tree, or do you want it to go through the VFS tree?

Thanks,

- Eric
