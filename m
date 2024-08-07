Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98AA4653A
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 18:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723056054; cv=none; b=t9MkCs77yzGflKOf4ybdA/9qfDocJB5haOdmK+VzOGU+YbyT7CotAFPhkkjwD5Um15qDngj+JwKeqqjboM/VXeNNrTU8cGlNZIeyKtUns+wzZLix0HE8QBPCqtS6201E0K0c4dNqH1U0aM/OVMebnEMbPHhDdtHla2+RflF5Idc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723056054; c=relaxed/simple;
	bh=CDt00zUqR2T+HPdhvPnuh50FrPosjc8ieot7ckezSrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dz8RfYOfTblUEbiQgxVBXYZYgjhWZbY71UbrYuokY6iPNqRizN27ngPEXYjpi5lr56xxPyHzHa8L8tbkNp7yV7L2bWd/WIz4Nc76UBMDJ7N2s182MvoH2WDVV8Zjr1KEqiJmNgquzjVwS5F/JBlu3BfAM+UuGlnEjdigHNlylqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xw9wv6VF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xw9wv6VF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723056051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yYQsIzuu5XGAxO2YfPZxFVL72FfNcMa0YdUGal9qg9o=;
	b=Xw9wv6VFq18HZk9eklfGQ8nDRgtX0V4p7UcJrr6H10PeSMBeoaJhuZEIXwBgRFvhsY5IRG
	NPqMnmtgFvT/yOqlFALzf1YVJ8Ew3ddXJNIcbnI6ZR/LGeyAtisfeauxJmtmlUMoBvJxNv
	7O/M5kF2ujiHoYZDUPZFKTrrkyRGJZc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-wi21TBW2NN6c7Xe8OFoodg-1; Wed,
 07 Aug 2024 14:40:50 -0400
X-MC-Unique: wi21TBW2NN6c7Xe8OFoodg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5E971955D44;
	Wed,  7 Aug 2024 18:40:48 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.103])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C49BD300018D;
	Wed,  7 Aug 2024 18:40:47 +0000 (UTC)
Date: Wed, 7 Aug 2024 13:40:45 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, cem@kernel.org
Subject: Re: [PATCH v2] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <ZrO_reVdaat8GOz1@redhat.com>
References: <20240807181553.243646-2-bodonnel@redhat.com>
 <20240807183143.GL6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807183143.GL6051@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Aug 07, 2024 at 11:31:43AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 07, 2024 at 01:15:54PM -0500, Bill O'Donnell wrote:
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
> > v2: cover the error case.
> > ---
> >  db/iunlink.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/db/iunlink.c b/db/iunlink.c
> > index d87562e3..bd973600 100644
> > --- a/db/iunlink.c
> > +++ b/db/iunlink.c
> > @@ -72,9 +72,12 @@ get_next_unlinked(
> >  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
> >  	ret = be32_to_cpu(dip->di_next_unlinked);
> >  	libxfs_buf_relse(ino_bp);
> > +	libxfs_irele(ip);
> >  
> >  	return ret;
> >  bad:
> > +	libxfs_buf_relse(ino_bp);
> 
> What if we got here via the first 'goto bad' in this function?  We'll be
> feeding an uninitialized variable into libxfs_buf_relse.

ugh. Missed that, thanks.

-Bill


> 
> --D
> 
> > +	libxfs_irele(ip);
> >  	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
> >  	return NULLAGINO;
> >  }
> > -- 
> > 2.45.2
> > 
> > 
> 

