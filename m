Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8923E2AD21
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 23:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742601462; cv=none; b=FB20prYte++d43xnINOyF09jwfyW5DcI2eClCS/8ZnSxMZ//lGNXRmdqrqon16ncwwq7SEUJPMHNAKZy0ZO5WMwjEQqHcCprEIoqPBpWk/VGsfhbntp11OoKRLYgwxLa7e3X9ZKEw4fmNT7u0RW50duQvveo5RJwNnCBMaR1e50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742601462; c=relaxed/simple;
	bh=p+FWnQY+kBkqJPrbIe1lwfISqYzdnBDgs1SIFqmrfoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHOxut9uSDwJa33NuYWc6vFt8vCGjDsUR1FLNknJS+4qaYi+60nDokgexIP38ssq6BCKXqizQsKoxJph+7ApyQ5cJsb9jU9bHXz3jDmSGuNaW33t5HW2m1277Z4SkgX/FByrQjd62+yQlPufQbTGSIMENxcbwKgkrcNe7NloUVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Crkh6Wh7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Crkh6Wh7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742601459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b6FOyESpSnsMwfe0ZJ0Qx8yIgNz023CmNa+FxgkIaR8=;
	b=Crkh6Wh7KS5V2ezJgukokbnCb55r+3k/5wlOGe3P8peVhwF+sENoRBCXwB8J5Zz35hLIp5
	Be3HBfRwyAl/3ZNy7uUi9k2A1FHeRPsrzR+rRE/Nf5Tk48rihmtTVtsMiFTYh/dRD/CLZf
	O2eLdGNUKTmZOMligke4MAJDGn26kUI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-yBhmH5yBNQSGyeArdk3dAw-1; Fri,
 21 Mar 2025 19:57:35 -0400
X-MC-Unique: yBhmH5yBNQSGyeArdk3dAw-1
X-Mimecast-MFC-AGG-ID: yBhmH5yBNQSGyeArdk3dAw_1742601454
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 295E118007E1;
	Fri, 21 Mar 2025 23:57:33 +0000 (UTC)
Received: from redhat.com (unknown [10.22.65.116])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF95419560AF;
	Fri, 21 Mar 2025 23:57:31 +0000 (UTC)
Date: Fri, 21 Mar 2025 18:57:29 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@infradead.org
Subject: Re: [PATCH v2] xfs_repair: handling a block with bad crc, bad uuid,
 and bad magic number needs fixing
Message-ID: <jdvz5azjkollyfaso5u6ayxduomjkeo47u4pioy5btoqjbjkfw@ol5sgtfe3vtw>
References: <20250321142848.676719-2-bodonnel@redhat.com>
 <20250321152725.GL2803749@frogsfrogsfrogs>
 <Z93N12zwQeg6Fuot@redhat.com>
 <20250321203914.GA89034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321203914.GA89034@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, Mar 21, 2025 at 01:39:14PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 21, 2025 at 03:36:39PM -0500, Bill O'Donnell wrote:
> > On Fri, Mar 21, 2025 at 08:27:25AM -0700, Darrick J. Wong wrote:
> > > On Fri, Mar 21, 2025 at 09:28:49AM -0500, bodonnel@redhat.com wrote:
> > > > From: Bill O'Donnell <bodonnel@redhat.com>
> > > > 
> > > > In certain cases, if a block is so messed up that crc, uuid and magic
> > > > number are all bad, we need to not only detect in phase3 but fix it
> > > > properly in phase6. In the current code, the mechanism doesn't work
> > > > in that it only pays attention to one of the parameters.
> > > > 
> > > > Note: in this case, the nlink inode link count drops to 1, but
> > > > re-running xfs_repair fixes it back to 2. This is a side effect that
> > > > should probably be handled in update_inode_nlinks() with separate patch.
> > > > Regardless, running xfs_repair twice fixes the issue. Also, this patch
> > > > fixes the issue with v5, but not v4 xfs.
> > > > 
> > > > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > > 
> > > That makes sense.
> > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > > 
> > > Bonus question: does longform_dir2_check_leaf need a similar correction
> > > for:
> > > 
> > > 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
> > > 		error = check_da3_header(mp, bp, ip->i_ino);
> > > 		if (error) {
> > > 			libxfs_buf_relse(bp);
> > > 			return error;
> > > 		}
> > > 	}
> > > --D
> > > 
> > 
> > I believe so, yes. Basing the v4/v5 decisions on an assumed correct
> > magic number is not so good. I'll fix it in a new version or separate
> > patch if preferred.
> 
> It's up to you, but since this fix has already earned its review, how
> about a separate patch? :)

That's what I'll do. Thanks again for the review :)
-Bill


> 
> --D
> 
> > Thanks-
> > Bill
> > 
> > 
> > > > 
> > > > v2: remove superfluous wantmagic logic
> > > > 
> > > > ---
> > > >  repair/phase6.c | 5 +----
> > > >  1 file changed, 1 insertion(+), 4 deletions(-)
> > > > 
> > > > diff --git a/repair/phase6.c b/repair/phase6.c
> > > > index 4064a84b2450..9cffbb1f4510 100644
> > > > --- a/repair/phase6.c
> > > > +++ b/repair/phase6.c
> > > > @@ -2364,7 +2364,6 @@ longform_dir2_entry_check(
> > > >  	     da_bno = (xfs_dablk_t)next_da_bno) {
> > > >  		const struct xfs_buf_ops *ops;
> > > >  		int			 error;
> > > > -		struct xfs_dir2_data_hdr *d;
> > > >  
> > > >  		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
> > > >  		if (bmap_next_offset(ip, &next_da_bno)) {
> > > > @@ -2404,9 +2403,7 @@ longform_dir2_entry_check(
> > > >  		}
> > > >  
> > > >  		/* check v5 metadata */
> > > > -		d = bp->b_addr;
> > > > -		if (be32_to_cpu(d->magic) == XFS_DIR3_BLOCK_MAGIC ||
> > > > -		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
> > > > +		if (xfs_has_crc(mp)) {
> > > >  			error = check_dir3_header(mp, bp, ino);
> > > >  			if (error) {
> > > >  				fixit++;
> > > > -- 
> > > > 2.48.1
> > > > 
> > > > 
> > > 
> > 
> 

