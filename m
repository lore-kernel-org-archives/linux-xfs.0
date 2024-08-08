Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4CD3398E
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 19:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723146109; cv=none; b=WoN0f0Cr55dhUiVDYal8UoGkArDAqNL0GKo+PmeOmHpfRogg5wg9/GRsnkx+FYt7yosSE+BITecLWwa2rHnly+h2WBA6cYFYaz5mraq5XmOrWXQO+39349Vh8X2oaSPccJRLGvTQbFNEvl7XwK7787q4cFw4/IVq/twFfSQd6dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723146109; c=relaxed/simple;
	bh=BUYDq/10RCQWZP11bHFre3zqt4HggAOsr00lZlWoIho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1+1KrBCyF4R3AJWhpEkWMxqqozq2nBN/HmQQuGw95rb8Uy2ukbU3w9uYfk9tQ/MeM7gpfUO3MvWjG9WbjvhaXqKDidW0/PChDrwJUMW1PtcNTcMjtKVVfzJtB4HCIvHHhHcC2AoiEbIjHwmZBE7ZtPAdWisGPRv7bl6tAVPs+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c2M7yOgQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c2M7yOgQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723146107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9UUVV0BPeQtkREcy7OxEz7yMLAmze1t++k5ZEhUUHXM=;
	b=c2M7yOgQaILAbokXApUqPqMaEzzf7cxTmh4LGj1y5rQ8ZkGwBLHoYFVqA9OTy61I3XlEpa
	GGPWFZyyqHhcz/e+fJiUho3rb+PIzEz1qB3mSz0UEzcVoDBy9qZiZtBhNYIGUNFpwApMR3
	52XoYEV0UJM+mOJR4VhnWtQeTlhTv5s=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-yEC4jNT2OcepT77SmFtSDA-1; Thu,
 08 Aug 2024 15:41:44 -0400
X-MC-Unique: yEC4jNT2OcepT77SmFtSDA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 783421955D47;
	Thu,  8 Aug 2024 19:41:43 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.103])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 723A819560A3;
	Thu,  8 Aug 2024 19:41:42 +0000 (UTC)
Date: Thu, 8 Aug 2024 14:41:39 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH v3] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <ZrUfc57VJ-RPreCL@redhat.com>
References: <20240807193801.248101-3-bodonnel@redhat.com>
 <20240808182833.GR6051@frogsfrogsfrogs>
 <3a91d785-8c8f-4d2b-998f-a4cd92353120@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a91d785-8c8f-4d2b-998f-a4cd92353120@sandeen.net>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Aug 08, 2024 at 02:00:22PM -0500, Eric Sandeen wrote:
> On 8/8/24 1:28 PM, Darrick J. Wong wrote:
> > On Wed, Aug 07, 2024 at 02:38:03PM -0500, Bill O'Donnell wrote:
> >> Fix potential memory leak in function get_next_unlinked(). Call
> >> libxfs_irele(ip) before exiting.
> >>
> >> Details:
> >> Error: RESOURCE_LEAK (CWE-772):
> >> xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
> >> xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
> >> xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
> >> #   74|   	libxfs_buf_relse(ino_bp);
> >> #   75|
> >> #   76|-> 	return ret;
> >> #   77|   bad:
> >> #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
> >>
> >> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> >> ---
> >> v2: cover error case.
> >> v3: fix coverage to not release unitialized variable.
> >> ---
> >>  db/iunlink.c | 7 +++++--
> >>  1 file changed, 5 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/db/iunlink.c b/db/iunlink.c
> >> index d87562e3..57e51140 100644
> >> --- a/db/iunlink.c
> >> +++ b/db/iunlink.c
> >> @@ -66,15 +66,18 @@ get_next_unlinked(
> >>  	}
> >>  
> >>  	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
> >> -	if (error)
> >> +	if (error) {
> >> +		libxfs_buf_relse(ino_bp);
> > 
> > Sorry, I think I've led you astray -- it's not necessary to
> > libxfs_buf_relse in any of the bailouts.
> > 
> > --D
> > 
> >>  		goto bad;
> >> -
> >> +	}
> >>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
> >>  	ret = be32_to_cpu(dip->di_next_unlinked);
> >>  	libxfs_buf_relse(ino_bp);
> >> +	libxfs_irele(ip);
> >>  
> >>  	return ret;
> >>  bad:
> >> +	libxfs_irele(ip);
> 
> And this addition results in a libxfs_irele of an ip() which failed iget()
> via the first goto bad, so you're releasing a thing which was never obtained,
> which doesn't make sense.
> 
> 
> There are 2 relevant actions here. The libxfs_iget, and the libxfs_imap_to_bp.
> Only after libxfs_iget(ip) /succeeds/ does it need a libxfs_irele(ip), on either
> error paths or normal exit. The fact that it does neither leads to the two leaks
> noted in CID 1554242.

In libxfs_iget, -ENOMEM is returned when kmem_cache_zalloc() fails. For all other
error cases in that function, kmem_cache_free() releases the memory that was presumably
successfully allocated. I had wondered if we need to use libxfs_irele() at all in
get_next_unlinked() (except for the success case)?


> libxfs_imap_to_bp needs a corresponding libxfs_buf_relse() (thanks for clarifying
> djwong) but that libxfs_buf_relse() is already present if libxfs_imap_to_bp
> succeeds. It's not needed if it fails, because there's nothing to release.
> 
> When Darrick said
> 
> > I think this needs to cover the error return for libxfs_imap_to_bp too,
> > doesn't it?
> 
> I think he meant that in the error case where libxfs_imap_to_bp fails, libxfs_irele
> is also needed. (In addition to being needed on a normal return.)
> 
> -Eric
> 

