Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0F66FD3
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2024 01:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721351434; cv=none; b=AMpD7fYbOe1ai9paLxwgFXwlNv/mPrOUYKjBx696LC2oTlunSxVcah1Yzmh8EU/tuYj+BqYW9OiZDM4rJPWVvvgfFnUbB53KadJd2VkWkIaNf8F2J3QsHkjX16T35OgLwFc8afCoUcr0nbjQJ80iqRVEUx1zi1MgFhrsQbdquEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721351434; c=relaxed/simple;
	bh=utoP46i0nXJXkXrB3myP6modHNXo5yz+0FAK+z8vrb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o3BrsVoIw1JXF8KqHE5e6YPA/BO+pfV7wpTy1JpUbRMUi/liL3Srjg867HyzDWuXTN032TeUwL3qkLa8sxeyh4xgCVuX6TkMPDO8G8auzcFyCnFa+ZFszUb5mTsGQ9si98ViQYMmGBubW/ZYlO9Y2E73sdedwWecalaFhyKuFe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=hxwiJICe; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="hxwiJICe"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70af3d9169bso333378b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 18:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721351433; x=1721956233; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P59MpYGvmPLUnqs1i435FB+k8QzDCMlxUyrm6xO4IyQ=;
        b=hxwiJICeL4MC7D8N2S0TYI9l9pM8wf9aQKXpwYhO/XyDvqz/Tuq73x665Ngdfdc9C4
         xQ9+Ogk0mFSox23nI0vvrIfBGR0ri2Zp+O4F+GItBYRn2h87HszJZbEPQsvZrre0dLdt
         lH+SvL2oUEUYXwoupY2HeHuSY/F7ZD9OAz0Rq/QB9CmOpn8kRpgNYjwnSwRymKMVouXr
         7tgjs3eO4HI36u0N4nSpXRtl+y9T9G70cJ5aqPa/IZHVK2funAjDEchmO/gIn1DGymW5
         0OLkkyOruWfKR3HNTbiFdz+YpImYdbNbA8K5ieNuWO6QaYXUdh2WONexiNFvdAj0SSYx
         44LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721351433; x=1721956233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P59MpYGvmPLUnqs1i435FB+k8QzDCMlxUyrm6xO4IyQ=;
        b=UdcMltB2J12PKFkuhw+pCbFFdxYa6NaGM/Q3SmNPeGYcyMuaVrL8ULYNHTThGOrRDz
         cNu5KLjipkRX+2q7WL1XjgdzoELsog/TuK4FUa3hvcC0krnHcO4TXngP6jm7/kSMRc/J
         KKxTNbJziWW+b59ep27+yMiph5RQABqCeTbiewvak6PWHSofgJ3y5TH4C+hx2sM8mV7M
         Gqk3u0Ni8+E2rbimMJBZL3B8zDKs5oeNvZ2ciP/kBrde16kpU8LhjeRjH774BgKV7A6E
         Xnfa8aiOiy5BYTY15qvUYF7FHJCY/A1e/HYrHDsiqhZ8ilU7mXCMbfx/GdBPaiFTTtRC
         FzMA==
X-Forwarded-Encrypted: i=1; AJvYcCXv5JesviuzodvynnRRPlEW5OzfmdMqFZHB4/SazhtyeY8szTd+tk0XkVU8L64i3HuDPJt6fSASkBzOj+nL1j8ZPkrajLGashun
X-Gm-Message-State: AOJu0Yz7i5Bq6J7AvDOyRjf8B5lFu7Ql2hjqJaWoT+pc4YC0zIJUvIJc
	DB1GJCGFLn5+0Pa5UEGVRPyA+l0cL+gq2TiH0Ew+9h+NKYc0OjuFU0g3zA7uYgg=
X-Google-Smtp-Source: AGHT+IGETU1xARy+jx6+KgsJkEh7z4iil/Vr10IAbqSdjQOTt2IMAigyY/j9xgPAgrt/+u+cx13Pdg==
X-Received: by 2002:a05:6a00:3d4a:b0:70b:20d9:3c2a with SMTP id d2e1a72fcca58-70cfc9f7f7bmr1567546b3a.28.1721351432563;
        Thu, 18 Jul 2024 18:10:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff4b0a77sm159142b3a.47.2024.07.18.18.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 18:10:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sUc8i-003Fzc-2j;
	Fri, 19 Jul 2024 11:10:28 +1000
Date: Fri, 19 Jul 2024 11:10:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC 0/4] iomap: zero dirty folios over unwritten mappings
 on zero range
Message-ID: <Zpm9BFLjU0DkHBWc@dread.disaster.area>
References: <20240718130212.23905-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718130212.23905-1-bfoster@redhat.com>

On Thu, Jul 18, 2024 at 09:02:08AM -0400, Brian Foster wrote:
> Hi all,
> 
> This is a stab at fixing the iomap zero range problem where it doesn't
> correctly handle the case of an unwritten mapping with dirty pagecache.
> The gist is that we scan the mapping for dirty cache, zero any
> already-dirty folios via buffered writes as normal, but then otherwise
> skip clean ranges once we have a chance to validate those ranges against
> races with writeback or reclaim.
> 
> This is somewhat simplistic in terms of how it scans, but that is
> intentional based on the existing use cases for zero range. From poking
> around a bit, my current sense is that there isn't any user of zero
> range that would ever expect to see more than a single dirty folio.

The current code generally only zeroes a single filesystem block or
less because that's all we need to zero for partial writes.  This is
not going to be true for very much longer with XFS forcealign
functionality, and I suspect it's not true right now for large rt
extent sizes when doing sub-extent writes. In these cases, we are
going to have to zero multiple filesystem blocks during truncate,
hole punch, unaligned writes, etc.

So even if we don't do this now, I think this is something we will
almost certainly be doing in the next kernel release or two.

> Most
> callers either straddle the EOF folio or flush in higher level code for
> presumably (fs) context specific reasons. If somebody has an example to
> the contrary, please let me know because I'd love to be able to use it
> for testing.

Check the xfs_inode_has_bigrtalloc() and xfs_inode_alloc_unitsize()
cases. These are currently being worked on and expanded and factored
so eventually these cases will all fall under
xfs_inode_alloc_unitsize().

> The caveat to this approach is that it only works for filesystems that
> implement folio_ops->iomap_valid(), which is currently just XFS. GFS2
> doesn't use ->iomap_valid() and does call zero range, but AFAICT it
> doesn't actually export unwritten mappings so I suspect this is not a
> problem. My understanding is that ext4 iomap support is in progress, but
> I've not yet dug into what that looks like (though I suspect similar to
> XFS). The concern is mainly that this leaves a landmine for fs that
> might grow support for unwritten mappings && zero range but not
> ->iomap_valid(). We'd likely never know zero range was broken for such
> fs until stale data exposure problems start to materialize.
> 
> I considered adding a fallback to just add a flush at the top of
> iomap_zero_range() so at least all future users would be correct, but I
> wanted to gate that on the absence of ->iomap_valid() and folio_ops
> isn't provided until iomap_begin() time. I suppose another way around
> that could be to add a flags param to iomap_zero_range() where the
> caller could explicitly opt out of a flush, but that's still kind of
> ugly. I dunno, maybe better than nothing..?

We want to avoid the flush in this case if we can - what XFS does is
a workaround for iomap not handling dirty data over unwritten
extents. That first flush causes performance issues with certain
truncate heavy workloads, so we really want to avoid it in the
generic code if we can.

> So IMO, this raises the question of whether this is just unnecessarily
> overcomplicated. The KISS principle implies that it would also be
> perfectly fine to do a conditional "flush and stale" in zero range
> whenever we see the combination of an unwritten mapping and dirty
> pagecache (the latter checked before or during ->iomap_begin()). That's
> simple to implement and AFAICT would work/perform adequately and
> generically for all filesystems. I have one or two prototypes of this
> sort of thing if folks want to see it as an alternative.

If we are going to zero the range, and the range is already
unwritten, then why do we need to flush the data in the cache to
make it clean and written before running the zeroing? Why not just
invalidate the entire cache over the unwritten region and so return it
all to containing zeroes (i.e. is unwritten!) without doing any IO.

Yes, if some of the range is under writeback, the invalidation will
have to wait for that to complete - invalidate_inode_pages2_range()
does this for us - but after the invalidation those regions will now
be written and iomap revalidation after page cache invalidation will
detect this.

So maybe the solution is simply to invalidate the cache over
unwritten extents and then revalidate the iomap? If the iomap is
still valid, then we can skip the unwritten extent completely. If
the invalidation returned -EBUSY or the iomap is stale, then remap
it and try again?

If we don't have an iomap validation function, then we could check
filemap_range_needs_writeback() before calling
invalidate_inode_pages2_range() as that will tell us if there were
folios that might have been under writeback during the invalidation.
In that case, we can treat "needs writeback" the same as a failed
iomap revalidation.

So what am I missing? What does the flush actually accomplish that
simply calling invalidate_inode_pages2_range() to throw the data we
need to zero away doesn't?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
