Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433A649CF40;
	Thu, 10 Sep 2026 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053135; cv=none; b=tmUZ35ifv2M6HzAFKEl5NUBoK3BTfa49VmCovNEDI+sImwxVu327UTJKWP2r1RQ7rEO4d05FhiJkSat8jtF3O+8mUuLUxUYQYy0nih3+41dPirSpDCj95HymGh+xCUiGyAPgmc91bmth/Pg8wzQgZgZYITbBkj0hIpv/L9xeAlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053135; c=relaxed/simple;
	bh=pz9zSip1lMk1Nr4nKF7jofEa0orwD+FmAM3RoymraqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u3WLIpE9+Abw7+Buji5rFcjKC6GLLT1mdVzWC+LFUlzk74T731sC32Qr+6QhODgjXzzWAlbhTsBSZyzx4KA60St0kU98CaeEuXA+tr9aParwiQGdreOCu4QZI77S3V5sdfdaMo2H+A+Vv6/Z9Qlmc1nfaqtViZXTiZFbyynloKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9Ukx+S5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9Ukx+S5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411C61F000FF;
	Thu, 10 Sep 2026 15:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789053127;
	bh=x/R1LbM+eF/GDGvhS+5wzOAueal9TQij8xv9x+P+lFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D9Ukx+S5wTv1Tg34vEtjTo4H5h96V8AtLvKJi+cDT5xOw92ZwygUBuNmRMu4KcqB/
	 cUwJjokU0YZgZr2QRyU5nod8x+8/ry7EIxDkI5zP4fIt4x0DNrqhTMZIVM8mU5FE2C
	 GmXb6FtZLS0X+1bXMdt+KCrJEKedNhZa4+zJdz4aezyFmyuzI0spXnDI7SmAvlmCqw
	 LyboXtpeL7vQooiobaMtf/XT/VP3inMBbB+fL9cNXp6fC9Ldo8xCgprpXErMnQeK6U
	 VjZTGTkupmnfaf0k7L9roz2k3pWjHOXeLNPA0NYCggLqeAUmueMBLMz3denXzeLSNQ
	 cDdMrdkRWd11g==
Date: Thu, 10 Sep 2026 17:12:03 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shigeru Yoshida <syoshida@redhat.com>, 
	Deepanshu Kartikey <kartikey406@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix double mutex_lock() call in
 xfs_ioc_health_monitor()
Message-ID: <aqLICraoDc_Jvlif@andromeda.toxiclabs.cc>
References: <20260910132956.538828-1-syoshida@redhat.com>
 <20260910145720.GB6238@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910145720.GB6238@frogsfrogsfrogs>

On Thu, Sep 10, 2026 at 07:57:20AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 10, 2026 at 10:29:55PM +0900, Shigeru Yoshida wrote:
> > Commit 4870da4f49ae ("xfs: take hm->lock in xfs_ioc_health_monitor()
> > before insert") intended to protect the __xfs_healthmon_insert() call
> > with hm->lock, but the second mutex operation was accidentally left as
> > mutex_lock() instead of mutex_unlock(), causing self-deadlock. Change
> > the second call to mutex_unlock() as originally intended.
> > 
> > Fixes: 4870da4f49ae ("xfs: take hm->lock in xfs_ioc_health_monitor() before insert")
> > Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> 
> The original patch I reviewed unlocked hm->lock correctly, not sure how
> it got corrupted by the tooling such that we need this.  I think cem
> fixed it already(?) but in case anyone needs it,

yes, it's fixed already... I had not a single clue what happened, I
haven't changed any patch manually on this batch, might have been the
tooling with some weird fuzz to fix context conflicts, but most likely I
screwed up somewhere.

Whatever the reason, this is on me for not having double-checked the
result once I pulled the patches in, so I'm really sorry for that.

And thanks again Yoshida for having spotted it.

> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_healthmon.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> > index 6dc3f69d6798..c3749675ef19 100644
> > --- a/fs/xfs/xfs_healthmon.c
> > +++ b/fs/xfs/xfs_healthmon.c
> > @@ -1225,7 +1225,7 @@ xfs_ioc_health_monitor(
> >  	running_event->domain = XFS_HEALTHMON_MOUNT;
> >  	mutex_lock(&hm->lock);
> >  	__xfs_healthmon_insert(hm, INSERT_HEAD, running_event);
> > -	mutex_lock(&hm->lock);
> > +	mutex_unlock(&hm->lock);
> >  
> >  	/*
> >  	 * Preallocate the unmount event so that we can't fail to notify the
> > -- 
> > 2.55.0
> > 
> > 
> 
