Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5330D322753
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 16:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756310928; cv=none; b=irK5YWN5zEHSqNI3uAi79UrFHvAQdiRLCazNGzplmJjPZL2+V/8ExcyVYlF30fZpA9L3lkLY2hSftTwb5+51fcP0kIgzUW2XRC52nBH1Ern1fRRl3K66iAceKd/LdwucLYY36HTcd92Q7f713KH8W1u/GZQzyXnv6nBMX/tc0YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756310928; c=relaxed/simple;
	bh=1J49svBdPM1VsPk/B72U0p4aTK9KkUwye6nSh+AaCGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hN1HtndAMbYnTYvAvsG1zpvJpz7Tt2Ql20XM2lapof+pkoeADG2VW0KVfN0usRqdv8Fn2myYppC+SzzWQHmGYc+CRRBWvcFIw0D/fQSvW++yAKio/g7ZPhlKIyQa9efL5xQ8KRFEueiDNlbzTd9LUT9/bvBp7/X2v6iLSj1jQzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=HHL+i8Qb; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="HHL+i8Qb"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e94d678e116so6158790276.2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 09:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1756310925; x=1756915725; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F8MBCOALyLW29tRaKLBmkUdjU0e3m81ua8qM6QlxUc0=;
        b=HHL+i8Qb7TjRo63pGyUAf/QBI3i8b+LbB5ClIfySonbFJLPphyvz6fbpxfI+4XTmvi
         x/HeVAhiJhGSd+lkAihoEOLEBMVa8qn6iuywEC7eaeZOxz5EXgHv/rLSvs1RvENrv1Af
         xUMjIK2b1i02uyJFNniB9wlv63A2IMOG+5RoZ0k66RoUiZj0B9uXRf5sUHOKZ0iLGiuK
         pRQVc7EIvcW2q2nL+W1eZ6qPvKpYY/iC+zJVEJzSlIO+ogcbgSxtSKO+MO1tGHq/iXUs
         akyUEI1PxTccrbNO/QQtRqJhGKZCdGb5bf+FGSsD0rITcQV+TPtqkKNBcj/cd0BLEax3
         FRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756310925; x=1756915725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F8MBCOALyLW29tRaKLBmkUdjU0e3m81ua8qM6QlxUc0=;
        b=WXrpNZB2XXqGZXvmRajCkYqemnqfNbQi2xv56zNFloc4k2G9MgT6qdmjjjPrigg5KP
         9iuLqebJ+Z9rbXYhFqfU3YEebOIOJF1LKGRhoVDjbSowsr+cpm9Mkl+6VnYtwrzcWfwv
         aMKyJo2GZmrh7Sofz/T3PP2+Fk09kp/3PcsJBBsulgFkxT+eJaXEi5EqJxDeeSHNlu59
         HAVh3xsCqfPADAF63EMiqjCXrBtW3fvBpjm7llIkyJ/RbOU0sQGrOGYrkb6zoHckD5L4
         fv18IYD4w+4gPsME4bad8MQaFCv7rA72I+I+A0FyQX3+sk99UEU6qVJiAR45xiGju1M4
         YwWw==
X-Forwarded-Encrypted: i=1; AJvYcCUz+KiOkMWYRWIc24OwdZtXLA3Erv8tG53140ZlW7aXiyj0OGAWnYJPnGU2ZEsOBLE6jtzOHQ3/0m4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDBRgAqrT3wnnEUyfV0WpMgRc2aAjPTvZk14NVcD8sIS1fHCws
	2liRJraoZTtEIpN4o9KMKNKPVFwlAxHX/+XYtfr9axeT8Rrs9/OMVe8jv8wrY9G5wq0=
X-Gm-Gg: ASbGnct7lCJTLIik1Z0M3ayhwub+pCwRvfFF+mNyLYRkO0nSBr7/GwcMjD1x1U4r4BB
	Nh9+d8hfQW83s0iA7isMfA7ihb1XvBVbTraAoHY7CO3SLfk29dmC3/HNRHqxym9Ia+r5FHSdNef
	nyBYBpAuCdvVjSntQVAMgae6YDJ4WhVDK3yhSSjIf/Zv22lPDupCPaUYboeJmZLLahV/X1FZUfh
	mAP1uASSTVvxbkrlUhA55cTOeK8Xo7QX17jjpuzzrkDL8hcdPWXV1+kTC+IxB97+a2oecxjw0PM
	QqcFF4wuFatINqmGwvavz+WBmRjW48T5aOIo4iTUTGo55u5k2zaIBqBJmlw7LSMcp/Ytt6BFVki
	kYeF9qjh/EdQPt5jjJvqeixmGSUFTXTooRbHI8KWTUSSkEQPfFct7ORRhFHpZ3cDtQJv3FBDd31
	9rQyZM
X-Google-Smtp-Source: AGHT+IE9MI02/EGLcEuj8RLfzQi94HthTqFKcq8Wp5g4r4kb41qy9Cy6X8/9v/mHfADNFNYHinugpA==
X-Received: by 2002:a05:6902:e0b:b0:e94:f463:884d with SMTP id 3f1490d57ef6-e951c3ff649mr20553107276.45.1756310925213;
        Wed, 27 Aug 2025 09:08:45 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e952c358cf8sm4133687276.23.2025.08.27.09.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 09:08:44 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:08:43 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, viro@zeniv.linux.org.uk,
	amir73il@gmail.com
Subject: Re: [PATCH v2 17/54] fs: remove the inode from the LRU list on
 unlink/rmdir
Message-ID: <20250827160843.GB2272053@perftesting>
References: <cover.1756222464.git.josef@toxicpanda.com>
 <3552943716349efa4ff107bb590ac6b980183735.1756222465.git.josef@toxicpanda.com>
 <20250827-bratkartoffeln-weltschmerz-fc60227f43e7@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827-bratkartoffeln-weltschmerz-fc60227f43e7@brauner>

On Wed, Aug 27, 2025 at 02:32:49PM +0200, Christian Brauner wrote:
> On Tue, Aug 26, 2025 at 11:39:17AM -0400, Josef Bacik wrote:
> > We can end up with an inode on the LRU list or the cached list, then at
> > some point in the future go to unlink that inode and then still have an
> > elevated i_count reference for that inode because it is on one of these
> > lists.
> > 
> > The more common case is the cached list. We open a file, write to it,
> > truncate some of it which triggers the inode_add_lru code in the
> > pagecache, adding it to the cached LRU.  Then we unlink this inode, and
> > it exists until writeback or reclaim kicks in and removes the inode.
> > 
> > To handle this case, delete the inode from the LRU list when it is
> > unlinked, so we have the best case scenario for immediately freeing the
> > inode.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> 
> I'm not too fond of this particular change I think it's really misplaced
> and the correct place is indeed drop_nlink() and clear_nlink().
> 
> I'm pretty sure that the number of callers that hold i_lock around
> drop_nlink() and clear_nlink() is relatively small. So it might just be
> preferable to drop_nlink_locked() and clear_nlink_locked() and just
> switch the few places over to it. I think you have tooling to give you a
> preliminary glimpse what and how many callers do this...

Fair, I'll make the weird french guy figure it out.  Thanks,

Josef
