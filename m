Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="U7tJR3QQ"
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE43419BC
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 00:50:53 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1fa21f561a1so2049192fac.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 00:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701247853; x=1701852653; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYXSXkaMtC15qsDcPr/TTfVheSuOP1FzJ66FIQNOxts=;
        b=U7tJR3QQmhRzC0U1jTzz+rCEt8e/QkKgxdNZ5mmbtLzJchlyR/OebRKUIkUoIfO7b2
         d8yAeWKQsxxkAJu3zJZqTy05D+9XLvdl0h3GMfPzj6iHXUAMDiBF8HhWjXGiOT2Nuz8Z
         lLuzBCesb62JLBYYH0gsk1GQVqJi/l8TMa/8bb1LK+noadPqcfmNQV2X68xPTdWfDWdJ
         X3OhjY9LQaLF7rxMLNnFl7BPlrN0OilTiaHtK2hb13Gtq3MBjhDkwUUBWObnL7kHECUA
         ED5fA14d/LFdkpKt7a89nl16+E6foiAr5bbweTqorxhVJ/cPrhoPUAG+1IpG305/+Lup
         CX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701247853; x=1701852653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYXSXkaMtC15qsDcPr/TTfVheSuOP1FzJ66FIQNOxts=;
        b=axNfKTmpodG70hJxBgefJGE0UdDlieTC4+/6A8jWjhn6yi9Dx/Eks2amgxPhhbeoc0
         TfI6IPGZnZ7bUzVi2qkLb/NoX3qDd4BycCi1fpIoMAdk4qtSfWLuD69FMTHSou5nehiK
         CJmG86YkhLi2OIDHC/Bb2BouQ/Naup/rcvI2cP/iCFdBvl4itQxC2xyqAIxiGOLGq2Uj
         WUW9fE2234z935DiirdhYJMawioQ+NpptquqQntSL521uwEXwgAEubPzggfSiGhIRWYC
         et19J2A5i5Jg9zOTn1KotW9koRCCuHUlbpm+yK0OiPpNSLAVws91szYPcg3jQXSDDLLq
         xsVg==
X-Gm-Message-State: AOJu0YzIPMh96YAHqNr0FkkHkXLiAar0zDFuPgadJroZsdlzWgT2AwyL
	RviqjOAgLMfZSn0rIaah7GiZKw==
X-Google-Smtp-Source: AGHT+IFlAixmOkdEDtxGfEJ9lx0Lw0rR4W/R4CexjDMnl8uFGG693OejX8yVG2qZwlv9TCQdJRYbOw==
X-Received: by 2002:a05:6870:9d8d:b0:1f9:5699:e53c with SMTP id pv13-20020a0568709d8d00b001f95699e53cmr23027716oab.36.1701247853109;
        Wed, 29 Nov 2023 00:50:53 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id hy13-20020a056a006a0d00b006cbb71186f7sm10357652pfb.29.2023.11.29.00.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 00:50:52 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1r8GHS-001RGM-0j;
	Wed, 29 Nov 2023 19:50:50 +1100
Date: Wed, 29 Nov 2023 19:50:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com, me@jcix.top
Subject: Re: [PATCH 2/2] xfs: update dir3 leaf block metadata after swap
Message-ID: <ZWb7aiXDIC/BNl3L@dread.disaster.area>
References: <20231128053202.29007-1-zhangjiachen.jaycee@bytedance.com>
 <20231128053202.29007-3-zhangjiachen.jaycee@bytedance.com>
 <ZWZ0qGWpBTW6Iynt@dread.disaster.area>
 <20231129063433.GD361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129063433.GD361584@frogsfrogsfrogs>

On Tue, Nov 28, 2023 at 10:34:33PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 29, 2023 at 10:15:52AM +1100, Dave Chinner wrote:
> > On Tue, Nov 28, 2023 at 01:32:02PM +0800, Jiachen Zhang wrote:
> > > From: Zhang Tianci <zhangtianci.1997@bytedance.com>
> > > 
> > > xfs_da3_swap_lastblock() copy the last block content to the dead block,
> > > but do not update the metadata in it. We need update some metadata
> > > for some kinds of type block, such as dir3 leafn block records its
> > > blkno, we shall update it to the dead block blkno. Otherwise,
> > > before write the xfs_buf to disk, the verify_write() will fail in
> > > blk_hdr->blkno != xfs_buf->b_bn, then xfs will be shutdown.
> > > 
> > > We will get this warning:
> > > 
> > >   XFS (dm-0): Metadata corruption detected at xfs_dir3_leaf_verify+0xa8/0xe0 [xfs], xfs_dir3_leafn block 0x178
> > >   XFS (dm-0): Unmount and run xfs_repair
> > >   XFS (dm-0): First 128 bytes of corrupted metadata buffer:
> > >   00000000e80f1917: 00 80 00 0b 00 80 00 07 3d ff 00 00 00 00 00 00  ........=.......
> > >   000000009604c005: 00 00 00 00 00 00 01 a0 00 00 00 00 00 00 00 00  ................
> > >   000000006b6fb2bf: e4 44 e3 97 b5 64 44 41 8b 84 60 0e 50 43 d9 bf  .D...dDA..`.PC..
> > >   00000000678978a2: 00 00 00 00 00 00 00 83 01 73 00 93 00 00 00 00  .........s......
> > >   00000000b28b247c: 99 29 1d 38 00 00 00 00 99 29 1d 40 00 00 00 00  .).8.....).@....
> > >   000000002b2a662c: 99 29 1d 48 00 00 00 00 99 49 11 00 00 00 00 00  .).H.....I......
> > >   00000000ea2ffbb8: 99 49 11 08 00 00 45 25 99 49 11 10 00 00 48 fe  .I....E%.I....H.
> > >   0000000069e86440: 99 49 11 18 00 00 4c 6b 99 49 11 20 00 00 4d 97  .I....Lk.I. ..M.
> > >   XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 1423 of file fs/xfs/xfs_buf.c.  Return address = 00000000c0ff63c1
> > >   XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
> > >   XFS (dm-0): Please umount the filesystem and rectify the problem(s)
> > > 
> > > From the log above, we know xfs_buf->b_no is 0x178, but the block's hdr record
> > > its blkno is 0x1a0.
> > > 
> > > Fixes: 24df33b45ecf ("xfs: add CRC checking to dir2 leaf blocks")
> > > Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_da_btree.c | 12 +++++++++++-
> > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > > index e576560b46e9..35f70e4c6447 100644
> > > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > > @@ -2318,8 +2318,18 @@ xfs_da3_swap_lastblock(
> > >  	 * Copy the last block into the dead buffer and log it.
> > >  	 */
> > >  	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
> > > -	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
> > >  	dead_info = dead_buf->b_addr;
> > > +	/*
> > > +	 * Update the moved block's blkno if it's a dir3 leaf block
> > > +	 */
> > > +	if (dead_info->magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
> > > +	    dead_info->magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) ||
> > > +	    dead_info->magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC)) {
> 
> On second thought, does this code have to handle XFS_DA3_NODE_MAGIC as
> well?

Yes, it does. The code to decode the block as a danode instead of
leaf1/leafn block is a few lines further down.

This code does not support ATTR_LEAF blocks, however.
xfs_da_shrink_inode() will only try to swap blocks on the data fork,
never on the attribute fork. That's largely a moot issue, though.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
