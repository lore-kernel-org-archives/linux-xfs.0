Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FC082866;
	Thu, 16 Apr 2026 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776353226; cv=none; b=WVuVbbMRcF7N4CbwgcEDhAwHZ3GL+x8Z1hnx2UhxacMy435VyCt2HGO3cr4pjcLZV2JcbCRfBwnntt5ltyX83vKrNt9hV28jpjleDc9wfr9wXgO7hJepG1dYwiB+I4AOT1j7kUEHy27F/y1uoWtSxOgQbQbm541Ymr+FgD4w0Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776353226; c=relaxed/simple;
	bh=H4BmPxyqX2E4a8qYvk7g0xnwqxdhSY+TSXE2SIW32J0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZO0SGbP7k91rPtVEN2SrkOvCGq2ucISTUg1EvrkuPZ8hghn8X3bVKnM2sO/bK98tmFHhkwEOvkqnoMw+Enbqs8HEVjmkAgtvqYFsUk/esjo/2AFp6Rp24tKbyVW8DxeOuDsJgyxYpWFujreTzQWTHt7oxq0L03+CLp5gOMpUmq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wk5JJUcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wk5JJUcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1EDC2BCB3;
	Thu, 16 Apr 2026 15:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776353226;
	bh=H4BmPxyqX2E4a8qYvk7g0xnwqxdhSY+TSXE2SIW32J0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wk5JJUccoCgVfYPao+2KUosa+4qGSBvc4Nt3UX4Tv8EUx7LGabDYyCeMly4ha2Q3s
	 ekgjW43HNhDzmJOyVqGrtYhktQheQP8oFoaCzK9FNeywritXUpI7VbHgGGMjPfoP3j
	 Q+GuzmZ1V5UGH6I2O5la2JbFeu8BlmDF38/lK3QGpebQfttA9f/PhISwLan+71fI8m
	 WPwf7+AJSswFCCBHTN2axGhbcRn6ScI3stiP9qnqrOGRjB3V8vkvzxT9bYUa9eoK/m
	 2VDzvH32BTDkLN6dJNpym+L707efOO1WpMI6pZ2iA91MSXDESV8eQPgEFo1caBZGbg
	 nqeEoNYnCQA+w==
Date: Thu, 16 Apr 2026 08:27:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Fengnan Chang <fengnanchang@gmail.com>, brauner@kernel.org,
	hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [PATCH] iomap: avoid memset iomap when iter is done
Message-ID: <20260416152705.GC114239@frogsfrogsfrogs>
References: <20260416030642.26744-1-changfengnan@bytedance.com>
 <aeDjui2LGSidEHcJ@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeDjui2LGSidEHcJ@bfoster>

On Thu, Apr 16, 2026 at 09:27:22AM -0400, Brian Foster wrote:
> On Thu, Apr 16, 2026 at 11:06:42AM +0800, Fengnan Chang wrote:
> > When iomap_iter() finishes its iteration (returns <= 0), it is no longer
> > necessary to memset the entire iomap and srcmap structures.
> > 
> > In high-IOPS scenarios (like 4k randread NVMe polling with io_uring),
> > where the majority of I/Os complete in a single extent map, this wasted
> > memory write bandwidth, as the caller will just discard the iterator.
> > 
> > Use this command to test:
> > taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> > -n1 -P1 /mnt/testfile
> > IOPS improve about 5% on ext4 and XFS.
> > 
> > However, we MUST still call iomap_iter_reset_iomap() to release the
> > folio_batch if IOMAP_F_FOLIO_BATCH is set, otherwise we leak page
> > references. Therefore, split the cleanup logic: always release the
> > folio_batch, but skip the memset() when ret <= 0.
> > 
> > Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> > ---
> >  fs/iomap/iter.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> > index c04796f6e57f..91eb5e6165ff 100644
> > --- a/fs/iomap/iter.c
> > +++ b/fs/iomap/iter.c
> > @@ -15,8 +15,6 @@ static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
> >  	}
> >  
> >  	iter->status = 0;
> > -	memset(&iter->iomap, 0, sizeof(iter->iomap));
> > -	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
> >  }
> >  
> >  /* Advance the current iterator position and decrement the remaining length */
> > @@ -106,6 +104,9 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> >  	if (ret <= 0)
> >  		return ret;
> >  
> > +	memset(&iter->iomap, 0, sizeof(iter->iomap));
> > +	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
> > +
> 
> This seems reasonable to me in principle, but it feels a little odd to
> leave a reset helper that doesn't really do a "reset." I wonder if this
> should be refactored into an iomap_iter_complete() (i.e. "complete an
> iteration") helper that includes the ret assignment logic just above the
> reset call and returns it, and then maybe leave a oneline comment above
> the memset so somebody doesn't blindly fold it back in the future. So
> for example:
> 
> 	ret = iomap_iter_complete(iter);
> 	if (ret <= 0)
> 		return ret;
> 
> 	/* save cycles and only clear the mappings if we plan to iterate */
> 	memset(..);
> 	...
> 
> We'd probably have to recheck some of the iter state within the new
> helper, but that doesn't seem like a big deal to me. Thoughts?

What kind of computer is this where there's a 5% hit to iops from a
memset of ~150 bytes?

--D

> Brian
> 
> >  begin:
> >  	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
> >  			       &iter->iomap, &iter->srcmap);
> > -- 
> > 2.39.5 (Apple Git-154)
> > 
> > 
> 
