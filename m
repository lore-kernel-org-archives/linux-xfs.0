Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8F026FD9F
	for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 15:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740756462; cv=none; b=g/KwvYGV9v2la7DkN0dmFGhZiOA7FrxRLFw4iXi2Ycak6Wyr6AjjWTXvq4v69D2gsVn7WKFNWxexTGF0UcW4ISAuSgLsjXZ98MTUp/Cm5ccequPVw86DPtE2es4Oo1wII+CWTbn3ltIriItW00G1w3PYFWzlCrydfp60zeyRaas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740756462; c=relaxed/simple;
	bh=AUZMqLO9BBKCVHi04UBu7cFGbjAM3/shXXPj4bdwORA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXEhp7muyHYmAYn9xYZPOaOHf/8NxoOnidjOEcjz85CLuiIdD19Eu/GYvJ1vICKLx2SQ/TMnX9WNA9T1bMV4/u6+qb5P7WPXjSc10xksMzFjQaEUgl4IC98PRVLTG2lfbqMXlIqDRkiNQDP13erctbGhn3a6q9EwkshQ6DibKdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TP80r9Zz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TP80r9Zz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740756459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dK7vRWx+SjgZWEb+itXJhcCQPriivqdv8BekdfJycFQ=;
	b=TP80r9Zzc4ox4ZGbc6oYhDIhk0ylAwwCmrrwt4Yz423VfjKWB47Gr9GawJTRRe2Wz1Izd2
	+XA701NXu9iCh0n78IkdXaumhQzJiznUUC7CxTm/jsVUTYAtYRvtUcOdTTJbost2J7AB4E
	v43FIMSRle80UrIAGJg9jQmy+UHPKRM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-NYwr9UsKP6CPohtaaBJwGA-1; Fri,
 28 Feb 2025 10:27:36 -0500
X-MC-Unique: NYwr9UsKP6CPohtaaBJwGA-1
X-Mimecast-MFC-AGG-ID: NYwr9UsKP6CPohtaaBJwGA_1740756455
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5261D19540ED;
	Fri, 28 Feb 2025 15:27:35 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.50])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A81319560AE;
	Fri, 28 Feb 2025 15:27:34 +0000 (UTC)
Date: Fri, 28 Feb 2025 09:27:31 -0600
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_repair: -EFSBADCRC needs action when read verifier
 detects it.
Message-ID: <4rpfn4nxntgg6hwqtei7nhhuw7n5jl57xvtnb7zagzus5y4i2s@triion65snds>
References: <20250226173335.558221-1-bodonnel@redhat.com>
 <20250226182002.GU6242@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226182002.GU6242@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Feb 26, 2025 at 10:20:02AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 26, 2025 at 11:32:22AM -0600, bodonnel@redhat.com wrote:
> > From: Bill O'Donnell <bodonnel@redhat.com>
> > 
> > For xfs_repair, there is a case when -EFSBADCRC is encountered but not
> > acted on. Modify da_read_buf to check for and repair. The current
> > implementation fails for the case:
> > 
> > $ xfs_repair xfs_metadump_hosting.dmp.image
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> >         - found root inode chunk
> > Phase 3 - for each AG...
> >         - scan and clear agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> > Metadata CRC error detected at 0x46cde8, xfs_dir3_block block 0xd3c50/0x1000
> > bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> > corrupt directory block 0 for inode 867467
> 
> Curious -- this corrupt directory block fails the magic checks but
> process_dir2_data returns 0 because it didn't find any corruption.
> So it looks like we release the directory buffer (without dirtying it to
> reset the checksum)...
> 
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> >         - process newly discovered inodes...
> > Phase 4 - check for duplicate blocks...
> >         - setting up duplicate extent list...
> >         - check for inodes claiming duplicate blocks...
> >         - agno = 0
> >         - agno = 1
> >         - agno = 3
> >         - agno = 2
> > bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> 
> ...and then it shows up here again...
> 
> > Phase 5 - rebuild AG headers and trees...
> >         - reset superblock...
> > Phase 6 - check inode connectivity...
> >         - resetting contents of realtime bitmap and summary inodes
> >         - traversing filesystem ...
> > bad directory block magic # 0x16011664 for directory inode 867467 block 0: fixing magic # to 0x58444233
> 
> ...and again here.  Now we reset the magic and dirty the buffer...
> 
> >         - traversal finished ...
> >         - moving disconnected inodes to lost+found ...
> > Phase 7 - verify and correct link counts...
> > Metadata corruption detected at 0x46cc88, xfs_dir3_block block 0xd3c50/0x1000
> 
> ...but I guess we haven't fixed anything in the buffer, so the verifier
> trips.  What code does 0x46cc88 map to in the dir3 block verifier
> function?  That might reflect some missing code in process_dir2_data.

0x46cc88 maps to xfs_dir3_block_verify (bp=bp@entry=0x7fffbc103610) at xfs_dir2_block.c:56

> 
> > libxfs_bwrite: write verifier failed on xfs_dir3_block bno 0xd3c50/0x8
> > xfs_repair: Releasing dirty buffer to free list!
> > xfs_repair: Refusing to write a corrupt buffer to the data device!
> > xfs_repair: Lost a write to the data device!
> > 
> > fatal error -- File system metadata writeout failed, err=117.  Re-run xfs_repair.
> > 
> > 
> > With the patch applied:
> > $ xfs_repair xfs_metadump_hosting.dmp.image
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> >         - found root inode chunk
> > Phase 3 - for each AG...
> >         - scan and clear agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> > Metadata CRC error detected at 0x46ce28, xfs_dir3_block block 0xd3c50/0x1000
> > bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> >         - process newly discovered inodes...
> > Phase 4 - check for duplicate blocks...
> >         - setting up duplicate extent list...
> >         - check for inodes claiming duplicate blocks...
> >         - agno = 0
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> > bad directory block magic # 0x16011664 in block 0 for directory inode 867467
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > Phase 5 - rebuild AG headers and trees...
> >         - reset superblock...
> > Phase 6 - check inode connectivity...
> >         - resetting contents of realtime bitmap and summary inodes
> >         - traversing filesystem ...
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > Metadata CRC error detected at 0x46ce28, xfs_dir3_block block 0xd3c50/0x1000
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > bad directory block magic # 0x16011664 for directory inode 867467 block 0: fixing magic # to 0x58444233
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > rebuilding directory inode 867467
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> > cache_node_put: node put on refcount 0 (node=0x7f46ac0c5610)
> > cache_node_put: node put on node (0x7f46ac0c5610) in MRU list
> >         - traversal finished ...
> >         - moving disconnected inodes to lost+found ...
> > Phase 7 - verify and correct link counts...
> > done
> > 
> > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > ---
> >  repair/da_util.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/repair/da_util.c b/repair/da_util.c
> > index 7f94f4012062..0a4785e6f69b 100644
> > --- a/repair/da_util.c
> > +++ b/repair/da_util.c
> > @@ -66,6 +66,9 @@ da_read_buf(
> >  	}
> >  	libxfs_buf_read_map(mp->m_dev, map, nex, LIBXFS_READBUF_SALVAGE,
> >  			&bp, ops);
> > +	if (bp->b_error == -EFSBADCRC) {
> > +		libxfs_buf_relse(bp);
> 
> This introduces a use-after-free on the buffer pointer.
> 
> --D
> 
> > +	}
> >  	if (map != map_array)
> >  		free(map);
> >  	return bp;
> > -- 
> > 2.48.1
> > 
> > 
> 

