Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2521A2F26
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723223025; cv=none; b=EmGWPJgTbTnqwrYDeNWRlVHiSujr8jneYQ0hSB/KN5GR/1AYH6FrmILm78QbeZTZgiPHJCmVeCshJFsq77yBEwpDaP0VzD+9LidEM5Om2HMJ1eloouehvZQ+rOh+tAYUJhCLN4kCAeX+A6Q5B0oq8Ia8yDZuIKWPM42SbgZf3UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723223025; c=relaxed/simple;
	bh=j1SAKNe/ObdD1mOWDTqrNaZ5FWRVoxn1wOJLXcW+QsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJVzNtWu9cjfePwcD5hYrbFHFOukHTj25IMnAqIvziXQYa9t8aisNRk3USRW3GeQ3PgZg6lS6GEpYjHLwidCf3BAL3p3Q0CeT/ep1cdG98XQOTpaM/ColQQgohx1FRX41pmArSWuZ1PE2WiLUO10vwv9axlJ9Drn37cdgipYWa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IPoygAgx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPoygAgx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723223023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xS1SyGaTPQnE48Lt78hDgmAuc3enPNFIRo4hbTPpszc=;
	b=IPoygAgxcpAAQdWRQBP7GE0ol9dvGY0CsjBvssj09lsmXduPxxpeXfYLxzwJRDE3XPdk4t
	WIUSN8QMLyii1lgH2gteRMETM0LVYwZd0JMH2PiBz/GfiAvDprF2++iG7+gESMwInGWm+2
	9DM3y8+AAGB13TkD0OWhsxTCxbcbDsE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-75-5Bqn7ktYOVSxwVKEk5ED6A-1; Fri,
 09 Aug 2024 13:03:39 -0400
X-MC-Unique: 5Bqn7ktYOVSxwVKEk5ED6A-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5C041955BCE;
	Fri,  9 Aug 2024 17:03:38 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.103])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 526D6300018D;
	Fri,  9 Aug 2024 17:03:37 +0000 (UTC)
Date: Fri, 9 Aug 2024 12:03:34 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, cem@kernel.org
Subject: Re: [PATCH v4] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <ZrZL5igIzyngHIHl@redhat.com>
References: <20240809161509.357133-3-bodonnel@redhat.com>
 <20240809162326.GX6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809162326.GX6051@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Aug 09, 2024 at 09:23:26AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 09, 2024 at 11:15:11AM -0500, Bill O'Donnell wrote:
> > Fix potential memory leak in function get_next_unlinked(). Call
> > libxfs_irele(ip) before exiting.
> > 
> > Details:
> > Error: RESOURCE_LEAK (CWE-772):
> > xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
> > xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
> > xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
> > #   74|   	libxfs_buf_relse(ino_bp);
> > #   75|
> > #   76|-> 	return ret;
> > #   77|   bad:
> > #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
> > 
> > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > ---
> > v2: cover error case.
> > v3: fix coverage to not release unitialized variable.
> > v4: add logic to cover error case when ip is not attained.
> > ---
> > db/iunlink.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/db/iunlink.c b/db/iunlink.c
> > index d87562e3..98d1effc 100644
> > --- a/db/iunlink.c
> > +++ b/db/iunlink.c
> > @@ -49,8 +49,12 @@ get_next_unlinked(
> >  
> >  	ino = XFS_AGINO_TO_INO(mp, agno, agino);
> >  	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
> > -	if (error)
> > -		goto bad;
> > +	if (error) {
> > +		if (ip)
> > +			goto bad_rele;
> 
> When does libxfs_iget return nonzero and a non-NULL ip?  Wouldn't 'goto
> bad' suffice here?

Yes, and I thought that in v1. My mistake here. I'll send a v5.
-Bill

> 
> --D
> 
> > +		else
> > +			goto bad;
> > +	}
> >  
> >  	if (verbose) {
> >  		xfs_filblks_t	blocks, rtblks = 0;
> > @@ -67,13 +71,16 @@ get_next_unlinked(
> >  
> >  	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
> >  	if (error)
> > -		goto bad;
> > +		goto bad_rele;
> >  
> >  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
> >  	ret = be32_to_cpu(dip->di_next_unlinked);
> >  	libxfs_buf_relse(ino_bp);
> > +	libxfs_irele(ip);
> >  
> >  	return ret;
> > +bad_rele:
> > +	libxfs_irele(ip);
> >  bad:
> >  	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
> >  	return NULLAGINO;
> > -- 
> > 2.46.0
> > 
> > 
> 

