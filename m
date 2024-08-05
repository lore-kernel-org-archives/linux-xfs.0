Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D54F15B551
	for <linux-xfs@vger.kernel.org>; Mon,  5 Aug 2024 15:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722872919; cv=none; b=gIqVJB2I0VFOmuZOJgwM6kPbk/aNwcUYldchN8YWsmN2LwWEogKz6PL3aDVrCfAzUboZpPo0g8VHSLXT+xJ23CerGf/XYjYbSpGvG9W6dnSlbIjJ/ROcz0fgs/kQdTe4B/ViOcFuQ+SvYUgMhTMZLEF8YoWD6YvijLvQ7iBMF/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722872919; c=relaxed/simple;
	bh=zOD2/d+TAUrmdhePJYY0MhrntgLeVSUWTgVjbcdWcyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgCgu2NDhnmC3FHLEQ0Nr7fHbHxVDVMddOY5ZvQ8yrfk2HxyQJLXjWRZnSAODreCX5X8WTNuT6bzTz9+90PdYJS8bceUlBX6i6alzldacvmSuZA26ihbSjbk/FgRgbBFskPgphZ/R0ZH2JD8hJWL1W1TfTG7+uMP2juk8vGpNa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ycg2HKBc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ycg2HKBc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722872917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UeFJc9LxLcxAiB/Dl0KEgp+UtXo5s5C+R2X+1tLIDK0=;
	b=Ycg2HKBc8lR9281buNJuhtf2ojc85Pv/ap0AdXlDYZkvN5yVxMsIAuWYF/Y1YQ29Z8RTPs
	Uc31vx8Ytwq+e/UkQiMsmmbCcWh8G7Hld0Uej7r95kWZ7fhS3iG/xfGN4NPhrAViTZMxBS
	WMP6FRdLiyCF/B1KXhWuC/3g14Aqogs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-VW39RRUbOkSeYimH1tPnnQ-1; Mon,
 05 Aug 2024 11:48:33 -0400
X-MC-Unique: VW39RRUbOkSeYimH1tPnnQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B03AE1955D48;
	Mon,  5 Aug 2024 15:48:32 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.103])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B232630001AA;
	Mon,  5 Aug 2024 15:48:31 +0000 (UTC)
Date: Mon, 5 Aug 2024 10:48:29 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <ZrD0TbXAE8mOumwH@redhat.com>
References: <20240802222552.64389-1-bodonnel@redhat.com>
 <20240802232300.GK6374@frogsfrogsfrogs>
 <ZrDkx1gFEGDCvUmS@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrDkx1gFEGDCvUmS@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Aug 05, 2024 at 09:42:15AM -0500, Bill O'Donnell wrote:
> On Fri, Aug 02, 2024 at 04:23:00PM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 02, 2024 at 05:25:52PM -0500, Bill O'Donnell wrote:
> > > Fix potential memory leak in function get_next_unlinked(). Call
> > > libxfs_irele(ip) before exiting.
> > > 
> > > Details:
> > > Error: RESOURCE_LEAK (CWE-772):
> > > xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
> > > xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
> > > xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
> > > #   74|   	libxfs_buf_relse(ino_bp);
> > > #   75|
> > > #   76|-> 	return ret;
> > > #   77|   bad:
> > > #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
> > > 
> > > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > > ---
> > >  db/iunlink.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/db/iunlink.c b/db/iunlink.c
> > > index d87562e3..3b2417c5 100644
> > > --- a/db/iunlink.c
> > > +++ b/db/iunlink.c
> > > @@ -72,6 +72,7 @@ get_next_unlinked(
> > >  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
> > >  	ret = be32_to_cpu(dip->di_next_unlinked);
> > >  	libxfs_buf_relse(ino_bp);
> > > +	libxfs_irele(ip);
> > 
> > I think this needs to cover the error return for libxfs_imap_to_bp too,
> > doesn't it?
> 
> I considered that, but there are several places in the code where the
> error return doesn't release the resource. Not that that's correct, but the
> scans didn't flag them. For example, in bmap_inflate.c, bmapinflate_f()
> does not release the resource and scans didn't flag it.

Looking at libxfs_iget(), it seems that for error cases, the resource is
released within that function.
-Bill

> 
> Thanks-
> Bill
> 
> 
> > 
> > --D
> > 
> > >  
> > >  	return ret;
> > >  bad:
> > > -- 
> > > 2.45.2
> > > 
> > 
> 
> 

