Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A9230E0DC
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 11:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756381452; cv=none; b=fm+mnfJUSirdo/UvNmJjTKIWJy33V06HvyNP2Ziog26mkKxwCdn37tkwKDxL9etwiPvObMFW1vW4B3gPZWPQqXUaM4jHjijquOCh1BTyzAz/irLPDcttpUifpwhZS06dXX9CxQiIp1eaHeO2Swp5aJStnNmrhBFsuyxwDMeH53M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756381452; c=relaxed/simple;
	bh=TYdcapiRrVKnywSl7eRnTkAyLH+aiR2D0xmIznmx/Mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wc3vfi2yvqY2Bubsv7inYXnn9g7g2/6E7LaFIo92+GEH1DOy/Sj1Fqel+oFWB4qgIDJ18EEBJKa5gL6NYJZpa/sdmc/gCeGOMGH/z3uFsU44fpVPKhnLN+Ved155KpAXN9hDY3ddsilpXKOLWmKoY4/8LCExdkXfBrbTe6oFDp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=LPCl9jKp; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="LPCl9jKp"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e96f14a6e97so592203276.2
        for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 04:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1756381448; x=1756986248; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+FGeBYhRtmGGR0HZaldkiKYi6XUYkbn8o1nO1HEFQ1Y=;
        b=LPCl9jKpj/X9NmbKVwd8YA9lNulAQJqJZfMpflouzjjyJtBLXs1WTrf1ZM4MPjHm8l
         fB/g1cXazuhnSv/NCTkD4hf8UXtyxkyDmntXXcVA8CI/epLnv22FA25XGcAXJh1/T2Wt
         KvsXBegSd7A3Lxe1WaxIgG0MyB6ZiMs3OjADaac80lMIUhgJDeUAaiU+McofHhO/4MrF
         i3ohzeFtyt2c8Zl6NoD+lQZIxRe4fuATYjinzIlI0mRGge/tnGuUvHuxnW+NfCxqZS6w
         Tp5Cu8KBGDZtOWWiXFsdhzIXr/99xCI4RRUm7ZLUJNePXMSuAtprWoSeOYzKwYS0TXPT
         OHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756381448; x=1756986248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+FGeBYhRtmGGR0HZaldkiKYi6XUYkbn8o1nO1HEFQ1Y=;
        b=aFh6WIT+dPckaugXIYQ9ty9wsZn+7C+px08Vl840OztufxRZN4HC+d605SPJtb20b+
         uKk8biueuoD8PTrlxOECGkwJ04lVWDwTPe6a2Rw0GJAg/UZ5RIAtIoQYnknnc3xhOggC
         bfhGWdef9mq5+ID5ZsSbAYDeobeih2bCu+ltx4nCk2BhY803YNcB+4SiRLZbdESIMN2n
         r5OAiLemJFV9jA+GhC8CazO5h6ItvpOjmw+q5DIxLBgOtw2zGfdAUfohGqRPSvQ9oXV7
         +nhBzIPhsTRTkmO22UEXszSAmy+kFihdoipRMYfk9dRrJ4h7YPSYvR8QcfdrX/dxqVO0
         pn9w==
X-Forwarded-Encrypted: i=1; AJvYcCXzH5QuMc92zSTAWM1VB3/WnxMHazpKv6dTG6OpKvNyOwkQL54tbuDvmMCmzX2b8m6iZQHDg6m2xnI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDFMWbXH2Nl5mxuXH3gW0EW1cs178pj3A5WA+gkwX3XQ3B/n0J
	qfRaY/RRF3pojwGh2udK8kABNG9n6fS0haP9PqbRNZt3ZxMkHommQnxkP1SU3NovL4R+PH10g77
	/M+oo
X-Gm-Gg: ASbGncuG7aRKMlGkGeDAgsHx6YS3ljOq62j2Clt9gGfCRzScwhVIgUHDBZVeGB6g3lJ
	0ogWbycxvjPntWcZtddp5yE+1tn4o+ehLha9W1+KCm9dNtMkUC5/2Gppaw4wZ6b+04OlEyurwSl
	IBglate3U9OcF3bsRyZ1b+nTl5pRn+4EYGYKi8z4/Mzy9/mIMbmJcKKsiCZ0AMEB/0ApO/XeSfH
	eCKApg4bHE5WmBl4lnpNqWl4rmSBwMON9wCeQi2uUaM7qBiI+QWA8yKN0qZgwpYYuNIBYl1U1s5
	Y5YNJ6xame1WHfnas5QlnNwm+1PlIVucgTgcThyB6TBoqSN3JsTuHF4Xr4MWmyz/9sIu/9BeQFj
	CvGjXFW5hkUvf+qqlnM8ZzlTCN12V9GY0/59WZr0kkLlDdpeiyB7ICxJvrhjO3xeNtcZe5A==
X-Google-Smtp-Source: AGHT+IG0MlSCL3zV5JCbSMDpck09+IKuR/tMouroHgHxjXh1bQ7JVTvYaZPq8wTRbmoR5Hgale9PJQ==
X-Received: by 2002:a05:6902:10c3:b0:e95:3e05:a634 with SMTP id 3f1490d57ef6-e953e05a74cmr15942947276.42.1756381448092;
        Thu, 28 Aug 2025 04:44:08 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e96d47cea7bsm2668464276.10.2025.08.28.04.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 04:44:07 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:44:06 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, viro@zeniv.linux.org.uk,
	amir73il@gmail.com
Subject: Re: [PATCH v2 20/54] fs: disallow 0 reference count inodes
Message-ID: <20250828114406.GB2848932@perftesting>
References: <cover.1756222464.git.josef@toxicpanda.com>
 <df5eb3f393bd0e7cbae103c204363f709c219678.1756222465.git.josef@toxicpanda.com>
 <20250828-aufbau-abblendlicht-a9cf118d33e8@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-aufbau-abblendlicht-a9cf118d33e8@brauner>

On Thu, Aug 28, 2025 at 01:02:31PM +0200, Christian Brauner wrote:
> On Tue, Aug 26, 2025 at 11:39:20AM -0400, Josef Bacik wrote:
> > Now that we take a full reference for inodes on the LRU, move the logic
> > to add the inode to the LRU to before we drop our last reference. This
> > allows us to ensure that if the inode has a reference count it can be
> > used, and we no longer hold onto inodes that have a 0 reference count.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/inode.c | 61 ++++++++++++++++++++++++++++++++++++------------------
> >  1 file changed, 41 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index 9001f809add0..d1668f7fb73e 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -598,7 +598,7 @@ static void __inode_add_lru(struct inode *inode, bool rotate)
> >  
> >  	if (inode->i_state & (I_FREEING | I_WILL_FREE))
> >  		return;
> > -	if (icount_read(inode))
> > +	if (icount_read(inode) != 1)
> >  		return;
> >  	if (inode->__i_nlink == 0)
> >  		return;
> > @@ -1950,28 +1950,11 @@ EXPORT_SYMBOL(generic_delete_inode);
> >   * in cache if fs is alive, sync and evict if fs is
> >   * shutting down.
> >   */
> > -static void iput_final(struct inode *inode, bool skip_lru)
> > +static void iput_final(struct inode *inode, bool drop)
> >  {
> > -	struct super_block *sb = inode->i_sb;
> > -	const struct super_operations *op = inode->i_sb->s_op;
> >  	unsigned long state;
> > -	int drop;
> >  
> >  	WARN_ON(inode->i_state & I_NEW);
> > -
> > -	if (op->drop_inode)
> > -		drop = op->drop_inode(inode);
> > -	else
> > -		drop = generic_drop_inode(inode);
> > -
> > -	if (!drop && !skip_lru &&
> > -	    !(inode->i_state & I_DONTCACHE) &&
> > -	    (sb->s_flags & SB_ACTIVE)) {
> > -		__inode_add_lru(inode, true);
> > -		spin_unlock(&inode->i_lock);
> > -		return;
> > -	}
> > -
> >  	WARN_ON(!list_empty(&inode->i_lru));
> >  
> >  	state = inode->i_state;
> > @@ -1993,8 +1976,37 @@ static void iput_final(struct inode *inode, bool skip_lru)
> >  	evict(inode);
> >  }
> >  
> > +static bool maybe_add_lru(struct inode *inode, bool skip_lru)
> > +{
> > +	const struct super_operations *op = inode->i_sb->s_op;
> > +	const struct super_block *sb = inode->i_sb;
> > +	bool drop = false;
> > +
> > +	if (op->drop_inode)
> > +		drop = op->drop_inode(inode);
> > +	else
> > +		drop = generic_drop_inode(inode);
> > +
> > +	if (drop)
> > +		return drop;
> > +
> > +	if (skip_lru)
> > +		return drop;
> > +
> > +	if (inode->i_state & I_DONTCACHE)
> > +		return drop;
> > +
> > +	if (!(sb->s_flags & SB_ACTIVE))
> > +		return drop;
> > +
> > +	__inode_add_lru(inode, true);
> > +	return drop;
> > +}
> > +
> >  static void __iput(struct inode *inode, bool skip_lru)
> >  {
> > +	bool drop;
> > +
> >  	if (!inode)
> >  		return;
> >  	BUG_ON(inode->i_state & I_CLEAR);
> > @@ -2010,9 +2022,18 @@ static void __iput(struct inode *inode, bool skip_lru)
> >  	}
> >  
> >  	spin_lock(&inode->i_lock);
> > +
> > +	/*
> > +	 * If we want to keep the inode around on an LRU we will grab a ref to
> > +	 * the inode when we add it to the LRU list, so we can safely drop the
> > +	 * callers reference after this. If we didn't add the inode to the LRU
> > +	 * then the refcount will still be 1 and we can do the final iput.
> > +	 */
> > +	drop = maybe_add_lru(inode, skip_lru);
> 
> So before we only put the inode on an LRU when we knew we this was the
> last reference. Now we're putting it on the LRU before we know that for
> sure.
> 
> While __inode_add_lru() now checks whether this is potentially the last
> reference we're goint to but, someone could grab another full reference
> in between the check, putting it on the LRU and atomic_dec_and_test().
> So we are left with an inode on the LRU that previously would not have
> ended up there. And then later we need to remove it again. I guess the
> arguments are:
> 
> (1) It's not a big deal because if the shrinker runs we'll just toss that
>     inode from the LRU again.
> (2) If it ended up being put on the cached LRU it'll stay there for at
>     least as long as the inode is referenced? I guess that's ok too.
> (3) The race is not that common?
> 
> Anyway, again it would be nice to have some comments noting this
> behavior and arguing why that's ok.

Yup I'll add a lengthy explanation. Thanks,

Josef
