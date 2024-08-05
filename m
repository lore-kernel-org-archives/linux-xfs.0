Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE53558A5
	for <linux-xfs@vger.kernel.org>; Mon,  5 Aug 2024 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722868944; cv=none; b=WnkX+tjHZ2tN/tg2nqaCo0SAUs9eZz0aW13InRfcvUAU0beK3zOVnUVQIZiUv0umkl+LIaFCYDNYQ9zbFSfLGqaLNp/v02lGb//6xOLX2UtO8YbHUo8ijGzzYRQbCvxsk30iwbJa+Is5vEbSEUc9iQrFMWCngrBtXpckWfiSjmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722868944; c=relaxed/simple;
	bh=hBVUxClpg3paQ7P4r99qVgqBGsPxmjj8osTltxGJzOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wh1chVHPYlPAsW0EuzHefXoIS9mSMYn+u4nQNdP72BL/idineyJB2r84wfVCZpcj04ZmmweBCYIuvp6tFRLh10DDYNsSVbZNuCZndurycORUmwY0E1uy1lEX5kc6Y/Z/6FepRZ1aclffB31BhiCY8ecSIN10Kf0zyfGjHwAt+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a9EsoTqv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9EsoTqv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722868942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sp8RD4dutXHhTk18oPlY2mJaopVgWePgCH4j3eNqxFE=;
	b=a9EsoTqvJjrlQvUk8gfWxS2ZZqG7ez6cHzfDsfNzO2tctNMdbk/c4O2Ygc5g8A+/JgCBdA
	1izUhrlEBGwfCHtYMBtMIu8IOszJfBZtTAP8N+hO6c/OTBEkHeGsMI9x0NI9kv5ZyurMIt
	UaR5mAX6xLhpqUGJtm9tJZ74sKjsUdE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-bg3e7_XBMi-vus_X0ryzkA-1; Mon,
 05 Aug 2024 10:42:19 -0400
X-MC-Unique: bg3e7_XBMi-vus_X0ryzkA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B45541955F41;
	Mon,  5 Aug 2024 14:42:18 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.103])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA71F1955E70;
	Mon,  5 Aug 2024 14:42:17 +0000 (UTC)
Date: Mon, 5 Aug 2024 09:42:15 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <ZrDkx1gFEGDCvUmS@redhat.com>
References: <20240802222552.64389-1-bodonnel@redhat.com>
 <20240802232300.GK6374@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802232300.GK6374@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Aug 02, 2024 at 04:23:00PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 02, 2024 at 05:25:52PM -0500, Bill O'Donnell wrote:
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
> >  db/iunlink.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/db/iunlink.c b/db/iunlink.c
> > index d87562e3..3b2417c5 100644
> > --- a/db/iunlink.c
> > +++ b/db/iunlink.c
> > @@ -72,6 +72,7 @@ get_next_unlinked(
> >  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
> >  	ret = be32_to_cpu(dip->di_next_unlinked);
> >  	libxfs_buf_relse(ino_bp);
> > +	libxfs_irele(ip);
> 
> I think this needs to cover the error return for libxfs_imap_to_bp too,
> doesn't it?

I considered that, but there are several places in the code where the
error return doesn't release the resource. Not that that's correct, but the
scans didn't flag them. For example, in bmap_inflate.c, bmapinflate_f()
does not release the resource and scans didn't flag it.

Thanks-
Bill


> 
> --D
> 
> >  
> >  	return ret;
> >  bad:
> > -- 
> > 2.45.2
> > 
> 

