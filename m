Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD55628137A
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 19:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756149975; cv=none; b=eWM6IeZvm2b0lsoNrXpvr3EqnLiTUBEgyS1Ran934uJJfApUpa7ThBXbWmCUEL5HtQ4uMsfj/Q0YrsDwtpVsFsQOCJvHShEVR5HQgiwVvhgYcTX+B8/ijZ/E5BMHiDoGijFSfUTUYSTUoB7EmPcaTIoTXoZOK6Teck70+lxxDnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756149975; c=relaxed/simple;
	bh=OVo/nnDHoAM+dyoQZoqa2tMCaLxG9KPpqdz7u06+QkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IZWpBdpbS1sIq47U1AeQtbC5wA5uFx3RBqTJQn5VlVo28cHYEMPdDcmwS1hzO1UWZZotlNMAPuIQSoAmLoEsy++OTeZHw2idEOIbU+3kmBNnRVMH20swUL8m8evBbhZPWL2ijBninDat2DwpwBAZwcRqfVdN4Dx/nb5kw/Ealek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=gifK/GuQ; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="gifK/GuQ"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e96c6201654so1263214276.2
        for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 12:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756149973; x=1756754773; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mp7hrAC+z9ITkZMGbXSePlctrkwigE1uRQddy7FPWjw=;
        b=gifK/GuQq9K4U4Oe8HSxzb1UVEs7xOFF9LajWJLKNk6i8UnYSHAC4oVSHbclZQH2oR
         8Uis8HWxt3BZihbqMX6lvEh3OdyD1AXGVtj9aJ+nY0EuOucJ85zNGOek4Zrev1kf0jSr
         EigyG7m0CKuiaLswo0rW5ybSxIA0HyHdRob6iBdkNHEXVwvJCy6jHSW54MWXu23E/UNF
         mVKpSgnT7IiW2T6ibj/uCtWCCJPi4pNdIt/zLidST0x9cuToz6/JVmZvCp/6ifHUmfiv
         l7QEJm8P4vy8XM1T1D9dcE2KbWYj45SAkVJU1PpWMlQ0sijVxQkJQfCu1aRQQrNievNy
         Pk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756149973; x=1756754773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mp7hrAC+z9ITkZMGbXSePlctrkwigE1uRQddy7FPWjw=;
        b=ZjO1xR0cNc9sMiAjS6opcpfVmzlYeeCn/JJezlFqIULUMLhZkXICMyntJk4BPxdLGk
         L099VuqROPS0zbGf7gITqo7Un+dE4YfUuqIJhpJdgyG5PYqqtBt6ktNSv6oJIkARYTGi
         jyg7Pwks05v0TYKwrMtcDsLhx/qbz8uYg8q/kxsdtka+M63xSQByB3ehHfasibpCXUeR
         xduj0751jLeiGhqbga8CvsoWGDIaBoGHsXyaRrDctMrlw3p8/dAViRR7Q1FKH+K5NOcJ
         QWHTP9wAw14DloCiA0+F/WOMH1wOwMAcDIFp7BxU3wWX6LPrVewFa4Cab6q4gT1MldjF
         nx1A==
X-Forwarded-Encrypted: i=1; AJvYcCXYbc37NfalLNmRFiDTli46TLRO7u2T1EO+w5DchwJYNS2tGbXcCaZsv5YSBIyTUSTUSHgYfB/T0NE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy0Qx8JKfF9q2wtP2PJf49P+YSVtEGnOY+o/shaznJdjOnnocF
	G4mnkJBH/8NTk6ttOrLluUIAr79rqC2GIxFZVnIa113E/Ot5SrQTx5idr+oNrJFWg9E=
X-Gm-Gg: ASbGnctpxsk1Vp1H+Zr7qAcoE1ooG8aiFJ8oE+OR6vxOuMnJ1tGedHD+ESXusF8n1X8
	KOc4YCn1MfrCurxz5eOUk9FNKK1MQhjxoeQ5oJPPauWs5eFX9enh2yeSzhn+rwKRccugtTjJcba
	xaIILKFLaOAZyxE9X6sGoU/S2DuFmaYW6KPgAucaKhMusRYPdsTmMbwPjn4gsONdc+QD0icteQI
	dJjU4eTPIx029CbSpzEIs2VDklpCBvjO2STrpjTNS7btga+QVZpn5rnptc0yrcEYKWXnfSIawS5
	uBLvSDdRip966BBMdZhLCo/iHwqK7NY7FryDd28HvmNIDWIjURWBcPZ/rh2YPvCRXVFbWvRoqD2
	AhL67Zrca/pb+n3jIlvbXVTCl58UZBkUvXhlw+zRwZDARazFuSTNdOZtzA2S4iB1UskVasDrhw7
	I6z4AF
X-Google-Smtp-Source: AGHT+IHEx37a3oXB5tv663eJfw1dYbVgBWHF+M2D92Pt6vUhFsXxqSKLHwZGoJ033niO4gVVY5tSNg==
X-Received: by 2002:a05:690c:6102:b0:71f:f866:bba4 with SMTP id 00721157ae682-71ff866f374mr97051877b3.17.1756149972656;
        Mon, 25 Aug 2025 12:26:12 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18b3794sm19329237b3.63.2025.08.25.12.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 12:26:11 -0700 (PDT)
Date: Mon, 25 Aug 2025 15:26:10 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 18/50] fs: disallow 0 reference count inodes
Message-ID: <20250825192610.GA1310133@perftesting>
References: <cover.1755806649.git.josef@toxicpanda.com>
 <6f4fb1baddecbdab4231c6094bbb05a98bbb7365.1755806649.git.josef@toxicpanda.com>
 <20250825-person-knapp-e802daccfe5b@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825-person-knapp-e802daccfe5b@brauner>

On Mon, Aug 25, 2025 at 12:54:01PM +0200, Christian Brauner wrote:
> On Thu, Aug 21, 2025 at 04:18:29PM -0400, Josef Bacik wrote:
> > Now that we take a full reference for inodes on the LRU, move the logic
> > to add the inode to the LRU to before we drop our last reference. This
> > allows us to ensure that if the inode has a reference count it can be
> > used, and we no longer hold onto inodes that have a 0 reference count.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/inode.c | 53 +++++++++++++++++++++++++++++++++--------------------
> >  1 file changed, 33 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index de0ec791f9a3..b4145ddbaf8e 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -614,7 +614,7 @@ static void __inode_add_lru(struct inode *inode, bool rotate)
> >  
> >  	if (inode->i_state & (I_FREEING | I_WILL_FREE))
> >  		return;
> > -	if (atomic_read(&inode->i_count))
> > +	if (atomic_read(&inode->i_count) != 1)
> >  		return;
> >  	if (inode->__i_nlink == 0)
> >  		return;
> > @@ -1966,28 +1966,11 @@ EXPORT_SYMBOL(generic_delete_inode);
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
> > @@ -2009,8 +1992,29 @@ static void iput_final(struct inode *inode, bool skip_lru)
> >  	evict(inode);
> >  }
> >  
> > +static bool maybe_add_lru(struct inode *inode, bool skip_lru)
> > +{
> > +	const struct super_operations *op = inode->i_sb->s_op;
> > +	struct super_block *sb = inode->i_sb;
> > +	bool drop = false;
> > +
> > +	if (op->drop_inode)
> > +		drop = op->drop_inode(inode);
> > +	else
> > +		drop = generic_drop_inode(inode);
> > +
> > +	if (!drop && !skip_lru &&
> > +	    !(inode->i_state & I_DONTCACHE) &&
> > +	    (sb->s_flags & SB_ACTIVE))
> > +		__inode_add_lru(inode, true);
> > +
> > +	return drop;
> > +}
> 
> Can we rewrite this as:
> 
> static bool maybe_add_lru(struct inode *inode, bool skip_lru)
> {
> 	const struct super_operations *op = inode->i_sb->s_op;
> 	const struct super_block *sb = inode->i_sb;
> 	bool drop = false;
> 
> 	if (op->drop_inode)
> 		drop = op->drop_inode(inode);
> 	else
> 		drop = generic_drop_inode(inode);
> 
> 	if (drop)
> 		return drop;
> 
> 	if (skip_lru)
> 		return drop;
> 
> 	if (inode->i_state & I_DONTCACHE)
> 		return drop;
> 
> 	if (!(sb->s_flags & SB_ACTIVE))
> 		return drop;
> 
> 	__inode_add_lru(inode, true);
> 	return drop;
> }
> 
> so it's a lot easier to follow. I really dislike munging conditions
> together with a bunch of ands and negations mixed in.
> 
> And btw for both I_DONTCACHE and !SB_ACTIVE it seems that returning
> anything other than false from op->drop_inode() would be a bug probably
> a technicality but I find it pretty odd.

Not necsessarily, maybe we had some delayed iput (*cough* btrfs *cough*) that
didn't run until umount time and now we have true coming from ->drop_inode()
with SB_ACTIVE turned off.  That would be completely valid.  Thanks,

Josef
