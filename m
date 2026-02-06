Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D037229994B
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 05:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770356173; cv=none; b=COcl+brAMvS6hJouzwNtcRgh4RIv56U+4IRLF3gD6hzjGrLOVGdUZd/6Oto6ZbALyz7nkCyhEOAcj/FKzCc2LQY5G6HotQlLpN7tZuAgTWLRe43gs60P5CZhj+3eTVt7gpcStl9+cj1TnG0j3Rp0A+IzoKAbhWpnFGU0adZgHU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770356173; c=relaxed/simple;
	bh=H81CFjeDSTAqNLLg0xiimtK9iXI3k9R0CkV3504hHoQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=L66veAwdYKT2TqWb9iGbJAU9ECIzrmgZQ3fCz3iV0iYfzSiOJ5kvSO0cScFFhSF+RU+RPg07d5A55fdRkVJLPDTQ7H1s8QmtJbvutS6DZAjqbz6LKqiLptQee39qLak/0JFUHj+lify0uCnj5BRXe1xyNdJiIvRDOYJaWUqRE7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mNIutWwl; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mNIutWwl"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0d52768ccso10875875ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 21:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770356173; x=1770960973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fRGlRAio2Tk60tj3s00QBPQfJSe7aETEyN4NWVC2M0I=;
        b=mNIutWwlXOlG3quThqcTSHcTpz33t/dNEYUJvN5n3du0yRCxbXAxW/8iBpDd6tmF63
         s/6OeI/aXJq2WzP1+UZxm/eoh0aDIgoqbE9VNOC9gk5sa9op/O0NCapHPiRZrs1H/IuR
         OTVEkEmyf7NS9JgAXuYKSZNB4eo7bwHxYghuFakzl7LYCump+LGPu7ZcMXPZWJDuk2DT
         n/jb9jjx0SP5MMrG43bzotLPBLWeAJczGeIK9nN+7hKhcncjynOhD5w8zKf4fuTXfcDK
         9rx9XyzZn4/zE4wRXmeYAwREOR/Vj7UNhnE9ZBq0B6uCfQhwp/V7XSrKRj7tGa3NL0Sy
         csfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770356173; x=1770960973;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRGlRAio2Tk60tj3s00QBPQfJSe7aETEyN4NWVC2M0I=;
        b=QTl68EnaFdQ1vTsmbakgKGdyYl/xhZv2WKC8jmU0gVec12/XXbXFPr1WLp27CPZVj8
         iINszJT+CWBLRx2N0dh4J3zjlHubJRKG+Im9zrb+ISAlkFcVOn1hGeRoN4J+VQxLtluH
         VjHF8UG+RSAaSzVTbqteEXCa0TGN+iF7HCZs5bw/7WRBxKYXk8R5oI8kJZq+0aA+uyeG
         Ltkj+KHfI0s8UHk8XqIcgQBB2EWqikUEjYCxuOsKxfcWVNDozRdwUZWcIgU+lawOqOd0
         DBxFeAqoQ6gow7BUpJigqSZoynHQ5AUTR3WMFWKK0kRAJxT1H5/YY8hr+6u5OILCPYCt
         75xQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYOXlMvo3hj5utHfNlpYd1hboBKD1afHqDGCQpBikY+d7guXaiSi9em3WUFDelTuH7rNbrZ522OvQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNeD9p9sHRIziY6eQas5s6FwbAHjWxbeI+e5PggBivZXrii5sm
	7beHxcn0XB8Agrx2gLKS+uaRXVsO381uyjP5Fau8we5Nj5mHGeqPShIE
X-Gm-Gg: AZuq6aIH8cT7W/LuLbSlgFVd9YINJykKgOdFGgqBV/gkRu6+llxOe2SV24CQdrkpDF1
	pLKrGatEj2PBAcqYg1alZWtXU+MomPQS2VxBY2YbNy9whUnQeKW+Tw9SGpOl7vsJWEvEU2UsuL+
	4sFlx/hSGdx9dnaPKNL7g3JrxRVBTtNzPDdc8bnjMyT6iz6JijBdptL5ipQH8xRXUaBlRGnxRHK
	rKkI5azLjhB8PCY2peSfXviFYQ0/t0v2cJrflm0HHpoaqTqeLnfsCoF5w/Jm8l/UflkB1nNkjqO
	o4hP2mmC1wqytUL+HDcal+avmD31P6qq7x+nr+eDcWf6saFbU95gWCXOAmia66MN5TkCkNwhAdK
	cj4T8LV87cLcrg9TPzi8RDFKUM0VAnmOnSEcyhM2SLGjP1wP5PtaXHp/Yo6lkQfwycPzc/X2QTj
	EflBhZa3BSBQiGNQuZtGI6N8rT7zXscZYDE5vnWHOMbjl58H3gkg3a8gL8TfkgzA5b
X-Received: by 2002:a17:902:da8f:b0:2a7:80bf:3131 with SMTP id d9443c01a7336-2a95196c7a7mr18061535ad.58.1770356173033;
        Thu, 05 Feb 2026 21:36:13 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a951a64ebesm11846575ad.2.2026.02.05.21.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 21:36:12 -0800 (PST)
Message-ID: <a017b49e0fb5b9f1a4f6929d7fb23897c98e2595.camel@gmail.com>
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and
 dirty-AG bitmap
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, dave@stgolabs.net, cem@kernel.org,
 wangyufei@vivo.com,  linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org,  gost.dev@samsung.com, anuj20.g@samsung.com,
 vishak.g@samsung.com,  joshi.k@samsung.com
Date: Fri, 06 Feb 2026 11:06:03 +0530
In-Reply-To: <20260205163650.GQ7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
	 <20260116100818.7576-4-kundan.kumar@samsung.com>
	 <87a16d4d9c1e568a37fa07a97dda5777e14e9a8b.camel@gmail.com>
	 <20260205163650.GQ7712@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2026-02-05 at 08:36 -0800, Darrick J. Wong wrote:
> On Thu, Feb 05, 2026 at 12:06:19PM +0530, Nirjhar Roy (IBM) wrote:
> > On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
> > > Add per-inode structures to track predicted AGs of dirty folios using
> > > an xarray and bitmap. This enables efficient identification of AGs
> > > involved in writeback.
> > > 
> > > Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> > > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > > ---
> > >  fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
> > >  fs/xfs/xfs_inode.h  |  5 +++++
> > >  2 files changed, 32 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index e44040206851..f97aa6d66271 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
> > >  	return XFS_PERAG_BLOCKGC_MARK;
> > >  }
> > >  
> > > +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
> > Similar comment as before:
> > static int
> > xfs_inode_init...()
> > > +{
> > > +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> > > +	unsigned int nlongs;
> > > +
> > > +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
> > Nit: The name of the functions suggests that it is initializing the tracking bitmap which it does -
> > however, the above line does slightly different thing? Maybe move the xarray init outside the bitmap
> > init function? 
> 
> Or just call it something else?  xfs_inode_init_perag_wb?
> 
> > > +	ip->i_ag_dirty_bitmap = NULL;
> > > +	ip->i_ag_dirty_bits = bits;
> > > +
> > > +	if (!bits)
> > Umm, !bits means agcount is 0. Shouldn't we ASSERT that bits >= 2? Or am I missing something?
> 
> Technically you can have 1 AG, but you definitely can't mount a zero AG
> filesystem.
Okay, but:
/home/ubuntu$ mkfs.xfs -f  -d agcount=1 /dev/loop0
Filesystem must have at least 2 superblocks for redundancy!
Usage: mkfs.xfs
Or maybe this restriction is just at the userspace tool level?
> 
> > > +		return 0;
> > > +
> > > +	nlongs = BITS_TO_LONGS(bits);
> > > +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> > > +					GFP_NOFS);
> > > +
> > > +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
> > > +}
> > > +
> > >  /*
> > >   * Allocate and initialise an xfs_inode.
> > >   */
> > > @@ -131,6 +150,8 @@ xfs_inode_alloc(
> > >  	ip->i_next_unlinked = NULLAGINO;
> > >  	ip->i_prev_unlinked = 0;
> > >  
> > > +	xfs_inode_init_ag_bitmap(ip);
> > xfs_inode_init_ag_bitmap() returns int - error handling for -ENOMEM?
> > > +
> > >  	return ip;
> > >  }
> > >  
> > > @@ -194,6 +215,12 @@ xfs_inode_free(
> > >  	ip->i_ino = 0;
> > >  	spin_unlock(&ip->i_flags_lock);
> > >  
> > > +	/* free xarray contents (values are immediate packed ints) */
> > > +	xa_destroy(&ip->i_ag_pmap);
> > Nit:Maybe have a small wrapper for freeing it the prediction map? No hard preferences though.
> > > +	kfree(ip->i_ag_dirty_bitmap);
> > > +	ip->i_ag_dirty_bitmap = NULL;
> > Nit: Usually while freeing the pointers I prefer:
> > t = ip->i_ag_dirty_bitmap;
> > ip->i_ag_dirty_bitmap = NULL;
> > kfree(t);
> > In this way, the pointer(i_ag_dirty_bitmap in this case) that I am freeing never points to an
> > already freed address.
> > 
> > > +	ip->i_ag_dirty_bits = 0;
> > > +
> > >  	__xfs_inode_free(ip);
> > >  }
> > >  
> > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > index bd6d33557194..dee449168605 100644
> > > --- a/fs/xfs/xfs_inode.h
> > > +++ b/fs/xfs/xfs_inode.h
> > > @@ -99,6 +99,11 @@ typedef struct xfs_inode {
> > >  	spinlock_t		i_ioend_lock;
> > >  	struct work_struct	i_ioend_work;
> > >  	struct list_head	i_ioend_list;
> > > +
> > > +	/* AG prediction map: pgoff_t -> packed u32 */
> > > +	struct xarray           i_ag_pmap;
> > > +	unsigned long           *i_ag_dirty_bitmap;
> > > +	unsigned int            i_ag_dirty_bits;
> > Not sure but, I mostly see the typedefed versions of data types being used like uint32 etc. Darrick,
> > hch, are the above fine?
> 
> Yes, please don't mix types.  Pick one type and stick with it.
> 
> (and yes I wish we could struct bitmap_t(unsigned long))
> 
> --D
> 
> > --NR
> > >  } xfs_inode_t;
> > >  
> > >  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)

