Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938591F0E48
	for <linux-xfs@vger.kernel.org>; Thu, 13 Mar 2025 19:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741892885; cv=none; b=bRM3YybaLnwfZsWVxHee0b+tg+c+kRInLnHLuFiNuzqQeGW31Z01wXO22laOK3Q2itN8fZz0TtUqcna2iLP3l+3J0CS8mp1jgz55m62DNf3nv1U0YyL7pVjVcX2eW81FPv66/Lc0MusnNzsvvBwV+ANz4pP6PRISCzP9PSD4LIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741892885; c=relaxed/simple;
	bh=Ir0jx5mxAEglMnn8AjI2CEXz+lU+2qb2LhZjh+UNy0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sl9fkXk/mQ9pzPTvfJqscygJueH4+FT04VDZO3mcDdT8wiymQJ2WUcI6jOSVJ5JVbL880ZXwMNaBNchrgdVpzkthWuGD+6EWbjXUsd9ghL94g/7HjJTaMYKY0O29TjlVBM5DZsc7U4JS/nMFOgWuru36I//2Xw1rHfrB3/go+Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E4Jafm2v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E4Jafm2v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741892882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ItdsDzG0rCDb8rseoOYNlqS5EEJrlKtFw2JUZ7bifsQ=;
	b=E4Jafm2vdqxnKp6xzAkHAWjeXzR+1sMlxnXavuF/Ib4QZyKUEV8nrjGbqNtdm4NdEl+sey
	2EQ1ky1rvXLbzGn47op6wpqzi9fTBJzxdu/szKnSY0zI/NIziTXApl/UPqqo903E5qUDrp
	7sXp88dU8KqHcfV2sMIqdREllwId1X4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-Uh3DQXPTOEyDi8eXjniYEw-1; Thu, 13 Mar 2025 15:08:01 -0400
X-MC-Unique: Uh3DQXPTOEyDi8eXjniYEw-1
X-Mimecast-MFC-AGG-ID: Uh3DQXPTOEyDi8eXjniYEw_1741892880
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e8fb5a7183so23689866d6.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Mar 2025 12:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741892880; x=1742497680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItdsDzG0rCDb8rseoOYNlqS5EEJrlKtFw2JUZ7bifsQ=;
        b=Refo/55oCeJsDsjtzRszr+sfwemMv+m9J4fd6XTYzDCMeJT29xWCOxBcuVizclGOEI
         7fIFYk2GPS5OmZfGgnWTXpqpxJqyXDQAoAbDfwHYoulNt96agn9HNYQA6g3cm/voGmAF
         Us7HJDcFopQKbjNXfygh5CCvz6A2N6HmJ9OJSjHnUBAFghKwYjYopFOQwZqpsFFr2RDv
         ABGUVlwbowgTi54gXpdtP/f0+Sr2qSi2CGLd3FYd/rC/wgS9IDQzIJ6sp8d9qhHTClup
         Fd3es1+4DPvA/0om3PQO/I4MFOz5UMo54LpraD2lc1gNU3okFM1zX2dYNlk2N4lZo1ip
         p8rg==
X-Gm-Message-State: AOJu0YxE5rNnokLsK86JI5ITPEPnmQTkCJbly98CG4qIVdDMSCB5Ya2x
	+M1OKJb3R23STVE7PwxM1ZynsYzBpaW6i4vh+8stnJesRc66/9H7KrDBqGBFqioJDUoHBLjk6xR
	tz+EBWREgfIW0bqWB4z+//MzHNodqKbCPMBzz+YJSGSi2oJCsgIKvVIRIiIv6n+Og2A==
X-Gm-Gg: ASbGncuhspGZk9nEMrAon+ZxSAjjfPZuRyRRLIhZh/abHSDZbUxtDc0lbMWKwH8GEpE
	8WGFXqDd7o/Ywo9b/t6FZ7ulWgDtZtCFdNLuhjwB+POpH6fW3LHg5H+GHPZuT2YjH1McB4bF+kO
	1o0NTqSbB6KF+2Aq8xT0z6DUoBJNBqiw9uopUO20CoYmKXl4mcd8LoUNbCIS2XEW73wZGh0NhBX
	4xa4OZiLsSjSzK+fpbJnAl29oi+M7QtnK4PW11DF+mWpVGsd8ZTQRDrvEXO3HhC4w4f3sWXdJah
	+vMT2S4ZvUfuzwnSIRoLVxB3JEsiIUU+9cyNnPju4LcGP6Mq
X-Received: by 2002:a05:6214:e48:b0:6e8:f1c4:f9e8 with SMTP id 6a1803df08f44-6eae79a34ebmr13615086d6.3.1741892880201;
        Thu, 13 Mar 2025 12:08:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFDgh9GLZMibJWXbVlOnzLMUv5IPUOrg/U6YvkVQ29qFP0X6JzI+YXTmtiVC/At2s0P1QbWA==
X-Received: by 2002:a05:6214:e48:b0:6e8:f1c4:f9e8 with SMTP id 6a1803df08f44-6eae79a34ebmr13614816d6.3.1741892879856;
        Thu, 13 Mar 2025 12:07:59 -0700 (PDT)
Received: from redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eade24ea6esm12761086d6.52.2025.03.13.12.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 12:07:58 -0700 (PDT)
Date: Thu, 13 Mar 2025 14:07:57 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_repair: -EFSBADCRC needs action when read verifier
 detects it.
Message-ID: <Z9MtDf3zW8yt98mt@redhat.com>
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

I'm not groking why this is a case of use-after-free, and why it
isn't in other cases? Where is the use after this free of bp?

Thanks-
Bill


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

