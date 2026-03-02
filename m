Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BCB379ED3
	for <linux-xfs@vger.kernel.org>; Mon,  2 Mar 2026 19:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478146; cv=none; b=XeFQ1h9At/xUhIqxjw6fv60PmSw38x3hebVqGNE0YqLjoJD5OMn7QzaEs58y04HnIODFR7sIAYnQprTjBNJq5RXdwohn0Z7G8bDM8gPdLhok7RH67ZWbAy/JD2S/3a85/N6iJVJbbq0KmlgLtZHX9MmINUSkHisjSuLEb8Shx0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478146; c=relaxed/simple;
	bh=pkE5vXf70vnGD399VLgOo9tTEX4QxFZG3PvMLjRXFKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzdppTb27ffhU978Vf7NSy8cyXVrZv3N8bIAlMtFd4YnV5yIzqZnrMNs/HyFDpOTMTvNCZ07DNYjN3SWzwvbzU5k6X5BiGdxOvO7yLAgDmPK/NW4Gd83V6wRXfKWcSXEf0qMoavU7508NFmizRgWxwih5vBjntRvWFbnSwEP4PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h8YRpSmz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8YRpSmz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772478139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TWDE6sXzjENCCwqb1yfPznHQ3HgxzICnviqOlijThDM=;
	b=h8YRpSmzmV2cGznwcVJGTJdR9LjvPuScKDRc+PdPtNj4L2+m9/nzB1R6SEWgT01cPonJGy
	lBow3EIPN1lGuCLUJ9Dpssb3fqy+rJZl2sBz9nY6YW4se591h0ehGa6dxN5GVcbI6mmwWK
	t7rLAEd1uc/7wHiaBraX3nX1B0pXp68=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-97-e5MCu135P8e_dOZEO1KDNg-1; Mon,
 02 Mar 2026 14:02:15 -0500
X-MC-Unique: e5MCu135P8e_dOZEO1KDNg-1
X-Mimecast-MFC-AGG-ID: e5MCu135P8e_dOZEO1KDNg_1772478134
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6995195609E;
	Mon,  2 Mar 2026 19:02:13 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B6981955F22;
	Mon,  2 Mar 2026 19:02:12 +0000 (UTC)
Date: Mon, 2 Mar 2026 14:02:10 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] iomap, xfs: lift zero range hole mapping flush
 into xfs
Message-ID: <aaXesgEmu46X7OwD@bfoster>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-2-bfoster@redhat.com>
 <aY6_eqkIrMkOr039@infradead.org>
 <aY9hY7TwgMXJNzkI@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY9hY7TwgMXJNzkI@bfoster>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Feb 13, 2026 at 12:37:39PM -0500, Brian Foster wrote:
> On Thu, Feb 12, 2026 at 10:06:50PM -0800, Christoph Hellwig wrote:
> > This patch makes generic/363 and xfs/131 fail on zoned XFS file systems.
> > A later patch also makes generic/127, but I haven't fully bisected
> > the cause yet.
> > 
> > I'll see if I can make sense of it, but unfortunately I've got a fair
> > amount of travel coming up, so it might take a while.
> > 
> > If you want to give it a spin yourself, you can just add '-r zoned=1'
> > to the mkfs arguments for the test and scratch device.
> > 
> > 
> 
> Ok, thanks for testing and reporting. I'm a little buried atm as well,
> but this isn't the most pressing series anyways. I'll dig into these
> tests when I spin back to this..
> 

I got a chance to look into this. Note that I don't reproduce a
generic/127 failure (even after running a few iters), so I don't know if
that might be related to something on your end. I reproduce the other
two and those looked like straight failures to zero. From that I think
the issue is just that xfs_zoned_buffered_write_iomap_begin() minimally
needs the flush treatment from patch 1. I.e., something like the
appended diff allows these tests to pass with -rzoned=1.

Technically this could use the folio batch helper, but given that we
don't use that for the unwritten case (and thus already rely on the
iomap flush), and that this is currently experimental, I think this is
probably fine for now. Perhaps if we lift zeroing off into its own set
of callbacks, that might be a good opportunity to clean this up in both
places.

I'll run some more testing with this on -rzoned=1 and barring major
issues plan to include this in the next version of the series..

Brian

--- 8< ---

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index fcb9463d0d8c..5b709b86d7cb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1590,6 +1590,7 @@ xfs_zoned_buffered_write_iomap_begin(
 {
 	struct iomap_iter	*iter =
 		container_of(iomap, struct iomap_iter, iomap);
+	struct address_space	*mapping = inode->i_mapping;
 	struct xfs_zone_alloc_ctx *ac = iter->private;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1614,6 +1615,7 @@ xfs_zoned_buffered_write_iomap_begin(
 	if (error)
 		return error;
 
+restart:
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
 	if (error)
 		return error;
@@ -1655,6 +1657,17 @@ xfs_zoned_buffered_write_iomap_begin(
 			 * We never need to allocate blocks for zeroing a hole.
 			 */
 			if (flags & IOMAP_ZERO) {
+				if (filemap_range_needs_writeback(mapping,
+						  offset, offset + count - 1)) {
+					xfs_iunlock(ip, lockmode);
+					error = filemap_write_and_wait_range(
+							mapping, offset,
+							offset + count - 1);
+					if (error)
+						return error;
+					goto restart;
+				}
+
 				xfs_hole_to_iomap(ip, iomap, offset_fsb,
 						smap.br_startoff);
 				goto out_unlock;

