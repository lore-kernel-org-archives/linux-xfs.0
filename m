Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B4624A049
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 15:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756306915; cv=none; b=r3d0dR+2Vqn7sNsqe0dMT7QhssxLiP0ELO9Dua23SHRu8W4ixxqW0mLaNFa/+6VVqCeXCchW3fTBADdkyFDFlV0PYxwMxiiyxKoBy4TOezZpLv4wpdm1u127ba/wWBHXLW4W6hYVQqBSM7q0eqbiRa/gdAuOz6VDx0uyjH6KrRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756306915; c=relaxed/simple;
	bh=p7Femr3MH0SjlXMwhy+YuUVugyvqfq1RJmpvLJsYpAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzDBXTbcLlT+sAV1/Uubrv5KXph9YhHSPifCWBVdTa3yf5/xJBsQU0dyFt31hxvM+9bSiZ/nMG1j13bEIpgaSqeSWSt6r3d5IYGzLRYqGrjKKCxQBAurXWIzyArS3xRGygvdn0oC2W0gDddWtze/x5SeCJlO8HueEP/B/m4cy/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=uohQEfG2; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="uohQEfG2"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-30cce534a91so2835887fac.0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 08:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756306912; x=1756911712; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4OCXs+jnWwR7FWJtHtpNrO1FLD08aYIad5UriCvf31Q=;
        b=uohQEfG2lfr91kj+fbtq2m4eT1w89G+yRlflrNGD8QkQMKmXjVHFRtwoyKbLT5zhqt
         95b744cRPPMZwiu9v6uW2BHNIbZ2eAECLWEMTfg9WXnuWjC6Cl6ukRVThsd4/m6yRogN
         wGJ40HsB8ZiK4T4n+B/0bzWsRzBOOS7WyS8ljYHRUJb7HqxT3T8ZLSbIi0eRrSBmiiop
         VaR4H9It4wS7Q3bsttaDNQ18bRLcvdNWYBQwenwvuxJlPbVXgYZOKUuku2QUkC/1bQUI
         WXOOiVI5aOOfgR0sm68mq2c5aQxKzviBxNO2pdyxJX/80RXNeyxYg6EwpIiCraFKdCVR
         BXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756306912; x=1756911712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4OCXs+jnWwR7FWJtHtpNrO1FLD08aYIad5UriCvf31Q=;
        b=ac998D61rrEYIfYy9NIr7QYLoFnzkhz0f7dTzW+lr1U6/hGVdYwl7GLunr9pYzzm1J
         cwH2l1SzMWsz3IPWobrKR6C1CVXqNOVvECMaiw0jrWzku0NRgNu5GS7mNNY0j0nqfKgp
         sMSaFT95YZZg71RMrQVgUmq5y4WOHrcsgc/jW0b6z+HDx9+CAhP3FJ+xCpsk31mGqv32
         wQPtCysk00JZCTYQB0Lk64yvz5FarOcfddQlUanqbvk0sGfDeBMNmMRy8uxS49D+B5+v
         IV9hrwVRNfdfOlj9zWFq/jGyL4hvrtJ9QzRQAsxT5IrIjspd8hLw4QuUuyF2ER6j42Td
         NgIA==
X-Forwarded-Encrypted: i=1; AJvYcCUisFb7nbXSI4doy1At7i6bCtrWFf5fZhWwrP8RVOdTzeFCb4sGiccc8syTasGWO3CM5ZYB7kvkcik=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz9svVAv0IyFDNH7GPK/hniY1HWIgCyijcrmFAl2JjpJuejYxU
	vHeahohJZzvglEvcyw1ILMRX6h3YYLRvUhrx8aFpsTedtuWVj7px8eRlSbyodNjyjU0I0oFPm4X
	BMuSh
X-Gm-Gg: ASbGncvgi00QGJlpwqaSSBXlUiiJZKT1e8wdzwoUBPUkrR2wZBaK3j187qACrYaN5kl
	MQyrwUoXLH6AZlCqEXppxomPXHQHhUskvSe9l8ZiLqvJVWrbi1pobDW7TIjYtm8WZ5O/C+k1Y8h
	I9CMl0JYNYOnJAUV6Mg2Kte7ZM8CJzu7I7Wh2nSiEp7Tduh54UzqypUIJ9EzXjxSW/cupv0d726
	vJ3KLxMx/xslMDN0p/pjY58ODwZ4w5EgNPKz/Ky7sJy5Ya0MqLgEGZJshLyTEm6vVXA7daspINK
	II832YQt7X7StJoGHlzg2IE2FbVErxJFMH7o2tqoXtCcyx2M8Yw+Aai8qRzqLYTATp0vhDq/ptT
	cQdZR6Dl24gAhxutLauFy38ac31KonAbmM03lBp08tEexuBM3ASq2NdwD/VM=
X-Google-Smtp-Source: AGHT+IFyYOwHMJoEXmOQ8uGAH/l+ZKAO0DrXblFReatS3WwuC7vhpTGGm7wAutkG59wh9SZ1OWY6PQ==
X-Received: by 2002:a05:690c:6805:b0:71f:95ce:ac82 with SMTP id 00721157ae682-71fdc2a89e0mr220525927b3.9.1756306491322;
        Wed, 27 Aug 2025 07:54:51 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-72151e8f522sm1970907b3.3.2025.08.27.07.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 07:54:50 -0700 (PDT)
Date: Wed, 27 Aug 2025 10:54:49 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, amir73il@gmail.com
Subject: Re: [PATCH v2 03/54] fs: rework iput logic
Message-ID: <20250827145449.GA2271493@perftesting>
References: <cover.1756222464.git.josef@toxicpanda.com>
 <be208b89bdb650202e712ce2bcfc407ac7044c7a.1756222464.git.josef@toxicpanda.com>
 <rrgn345nemz5xeatbrsggnybqech74ogub47d6au45mrmgch4d@jqzorhulkvre>
 <n6z2jkdgmgm2xfxc7y3a2a7psnkeboziffkt6bjoggrff4dlxe@vpsyl3ky6w6v>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n6z2jkdgmgm2xfxc7y3a2a7psnkeboziffkt6bjoggrff4dlxe@vpsyl3ky6w6v>

On Wed, Aug 27, 2025 at 04:18:55PM +0200, Mateusz Guzik wrote:
> On Wed, Aug 27, 2025 at 02:58:51PM +0200, Mateusz Guzik wrote:
> > On Tue, Aug 26, 2025 at 11:39:03AM -0400, Josef Bacik wrote:
> > > Currently, if we are the last iput, and we have the I_DIRTY_TIME bit
> > > set, we will grab a reference on the inode again and then mark it dirty
> > > and then redo the put.  This is to make sure we delay the time update
> > > for as long as possible.
> > > 
> > > We can rework this logic to simply dec i_count if it is not 1, and if it
> > > is do the time update while still holding the i_count reference.
> > > 
> > > Then we can replace the atomic_dec_and_lock with locking the ->i_lock
> > > and doing atomic_dec_and_test, since we did the atomic_add_unless above.
> > > 
> > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > > ---
> > >  fs/inode.c | 23 ++++++++++++++---------
> > >  1 file changed, 14 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/fs/inode.c b/fs/inode.c
> > > index a3673e1ed157..13e80b434323 100644
> > > --- a/fs/inode.c
> > > +++ b/fs/inode.c
> > > @@ -1911,16 +1911,21 @@ void iput(struct inode *inode)
> > >  	if (!inode)
> > >  		return;
> > >  	BUG_ON(inode->i_state & I_CLEAR);
> > > -retry:
> > > -	if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock)) {
> > > -		if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
> > > -			atomic_inc(&inode->i_count);
> > > -			spin_unlock(&inode->i_lock);
> > > -			trace_writeback_lazytime_iput(inode);
> > > -			mark_inode_dirty_sync(inode);
> > > -			goto retry;
> > > -		}
> > > +
> > > +	if (atomic_add_unless(&inode->i_count, -1, 1))
> > > +		return;
> > > +
> > > +	if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
> > > +		trace_writeback_lazytime_iput(inode);
> > > +		mark_inode_dirty_sync(inode);
> > > +	}
> > > +
> > > +	spin_lock(&inode->i_lock);
> > > +	if (atomic_dec_and_test(&inode->i_count)) {
> > > +		/* iput_final() drops i_lock */
> > >  		iput_final(inode);
> > > +	} else {
> > > +		spin_unlock(&inode->i_lock);
> > >  	}
> > >  }
> > >  EXPORT_SYMBOL(iput);
> > > -- 
> > > 2.49.0
> > > 
> > 
> > This changes semantics though.
> > 
> > In the stock kernel the I_DIRTY_TIME business is guaranteed to be sorted
> > out before the call to iput_final().
> > 
> > In principle the flag may reappear after mark_inode_dirty_sync() returns
> > and before the retried atomic_dec_and_lock succeeds, in which case it
> > will get cleared again.
> > 
> > With your change the flag is only handled once and should it reappear
> > before you take the ->i_lock, it will stay there.
> > 
> > I agree the stock handling is pretty crap though.
> > 
> > Your change should test the flag again after taking the spin lock but
> > before messing with the refcount and if need be unlock + retry.
> > 
> > I would not hurt to assert in iput_final that the spin lock held and
> > that this flag is not set.
> > 
> > Here is my diff to your diff to illustrate + a cosmetic change, not even
> > compile-tested:
> > 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index 421e248b690f..a9ae0c790b5d 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -1911,7 +1911,7 @@ void iput(struct inode *inode)
> >  	if (!inode)
> >  		return;
> >  	BUG_ON(inode->i_state & I_CLEAR);
> > -
> > +retry:
> >  	if (atomic_add_unless(&inode->i_count, -1, 1))
> >  		return;
> >  
> > @@ -1921,12 +1921,19 @@ void iput(struct inode *inode)
> >  	}
> >  
> >  	spin_lock(&inode->i_lock);
> > +
> > +	if (inode->i_count == 1 && inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
> > +		spin_unlock(&inode->i_lock);
> > +		goto retry;
> > +	}
> > +
> >  	if (atomic_dec_and_test(&inode->i_count)) {
> > -		/* iput_final() drops i_lock */
> > -		iput_final(inode);
> > -	} else {
> >  		spin_unlock(&inode->i_lock);
> > +		return;
> >  	}
> > +
> > +	/* iput_final() drops i_lock */
> > +	iput_final(inode);
> >  }
> >  EXPORT_SYMBOL(iput);
> >  
> 
> Sorry for spam, but the more I look at this the more fucky the entire
> ordeal appears to me.
> 
> Before I get to the crux, as a side note I did a quick check if atomics
> for i_count make any sense to begin with and I think they do, here is a
> sample output from a friend tracing the ref value on iput:
> 
> bpftrace -e 'kprobe:iput /arg0 != 0/ { @[((struct inode *)arg0)->i_count.counter] = count(); }'
> 
> @[5]: 66
> @[4]: 4625
> @[3]: 11086
> @[2]: 30937
> @[1]: 151785
> 
> ... so plenty of non-last refs after all.
> 
> I completely agree the mandatory ref trip to handle I_DIRTY_TIME is lame
> and needs to be addressed.
> 
> But I'm uneasy about maintaining the invariant that iput_final() does
> not see the flag if i_nlink != 0 and my proposal as pasted is dodgy af
> on this front.
> 
> While here some nits:
> 1. it makes sense to try mere atomics just in case someone else messed
> with the count between handling of the dirty flag and taking the spin lock
> 2. according to my quick test with bpftrace the I_DIRTY_TIME flag is
> seen way less frequently than i_nlink != 0, so it makes sense to swap
> the order in which they are checked. Interested parties can try it out
> with:
> bpftrace -e 'kprobe:iput /arg0 != 0/ { @[((struct inode *)arg0)->i_nlink != 0, ((struct inode *)arg0)->i_state & (1 << 11)] = count(); }'
> 3. touch up the iput_final() unlock comment
> 
> All that said, how about something like the thing below as the final
> routine building off of your change. I can't submit a proper patch and
> can't even compile-test. I don't need any credit should this get
> grabbed.

Thanks for this Mateusz, you're right I completely changed the logic by not
doing this under the i_lock.  This update looks reasonable to me, thank you for
the analysis and review!

Josef
