Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zBV5Atqz"
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABF9198D
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 14:42:11 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1cff3a03dfaso12425135ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 14:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701211330; x=1701816130; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LY+eF4fRJxCib25TrWRyYGxNTsQZ3hwqESyxdlDErAc=;
        b=zBV5AtqznHOSrulHmYQAAZWAetxNJAEPaEwWABBcYgv41JnWnijV33jQ0SMnv24wz3
         rDbsgPbjt2tsJJ3N9FZjDOysttZAYYqUwHEYlrotUrCrIuO85piPZSlvcZ0rmBbsK7bv
         Xe9qwEaUDtdP0MOrzmTaPl7qr7wlFNc6q2Arm/O+ZWNxQz40ti19JaRhbxqQAeogFni6
         +atNT567C2dpql7kR/NnFHiB6bqsDAUA/LZcI5CCVFikVYg6/2+pms7M80XjYCluQLKO
         CxIH43g9cq38Ga/PTTXKc/5IYjVv3+FJp66sKS86XA1m7rUTCPh4Z7R4e/d7lP/zPRy6
         rfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701211330; x=1701816130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LY+eF4fRJxCib25TrWRyYGxNTsQZ3hwqESyxdlDErAc=;
        b=QhxLU2IkwTlHU74zl3YnQteSmyHSDZyfq05KgL6PBZXCYuYBxV81e05C323NO8QtuQ
         YkKgjPP2s1/drUJ0syqemb4+L9FrAdk3YMSUfPTxDydX5LBPVnDGSDgS2scxgiFoVN0O
         8hS+83/ZGJBSAEAOYye1lCVCl1KkPytL6K2lgst3XW1+36Nm3ol+Mpsoyx+ys+HFL5Hi
         Ye2rsLodKVyb2xzKCBmQm2s6tZ4zC7vtGj6+ZMVTSmHkQyYmdWetCtBbWns3dcU35coF
         9JIS9lXrbCd4u+IImLQHd2Ipq/1Ai+FCuZm6l/nlM6dqd3W9tbEDB/2RHjVawpH5eh1H
         ArdQ==
X-Gm-Message-State: AOJu0Yz9LcCu48JfWBwLiDYQ7Y9bTFTq4sZDdphSIdQtGPSumKPgJvJY
	/dXLHg8xwdqqk3qvnuXrtMPu9ghRvyLmBjZdPJU=
X-Google-Smtp-Source: AGHT+IHIGVDUopI4qWf4Y3iOBficziSlJriaU1hsy1V7+vx2z562UQcmzyvts6N/FFnHeZF2T3NrRA==
X-Received: by 2002:a17:903:2291:b0:1cf:cd31:459d with SMTP id b17-20020a170903229100b001cfcd31459dmr9908360plh.21.1701211330371;
        Tue, 28 Nov 2023 14:42:10 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id a5-20020a170902ee8500b001cf8a4882absm10816322pld.196.2023.11.28.14.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 14:42:10 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1r86mN-001Fj0-2E;
	Wed, 29 Nov 2023 09:42:07 +1100
Date: Wed, 29 Nov 2023 09:42:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: XBF_DONE semantics
Message-ID: <ZWZsv7opPyeOJwJM@dread.disaster.area>
References: <20231128153808.GA19360@lst.de>
 <20231128165831.GW2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128165831.GW2766956@frogsfrogsfrogs>

On Tue, Nov 28, 2023 at 08:58:31AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 28, 2023 at 04:38:08PM +0100, Christoph Hellwig wrote:
> > Hi Darrick,
> > 
> > while reviewing your online repair series I've noticed that the new
> > xfs_buf_delwri_queue_here helper sets XBF_DONE in addition to waiting
> > for the buffer to go off a delwri list, and that reminded me off an
> > assert I saw during my allocator experiments, where
> > xfs_trans_read_buf_map or xfs_buf_reverify trip on a buffer that doesn't
> > have XBF_DONE set because it comes from an ifree transaction (see
> > my current not fully thought out bandaid below).
> 
> LOL, guess what I was looking at yesterday too! :)
> 
> > The way we currently set and check XBF_DONE seems a bit undefined.  The
> > one clear use case is that read uses it to see if a buffer was read in.
> > But places that use buf_get and manually fill in data only use it in a
> > few cases.  Do we need to define clear semantics for it?  Or maybe
> > replace with an XBF_READ_DONE flag for that main read use case and
> > then think what do do with the rest?
> 
> I thought XBF_DONE meant "contents have been read in from disk and
> have passed/will pass verifiers"

Effectively.

> > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > index 8e886ecfd69a3b..575922c64d4d3a 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -253,7 +253,6 @@ xfs_trans_read_buf_map(
> >  		ASSERT(bp->b_transp == tp);
> >  		ASSERT(bp->b_log_item != NULL);
> >  		ASSERT(!bp->b_error);
> > -		ASSERT(bp->b_flags & XBF_DONE);
> 
> I don't think this is the right thing to do here -- if the buffer is
> attached to a transaction, it ought to be XBF_DONE.  I think every
> transaction that calls _get_buf and rewrites the buffer contents will
> set XBF_DONE via xfs_trans_dirty_buf, right?

It should, yes. Otherwise the initialisation data in the buffer has
not been logged and may result in writeback and/or recovery being
incorrectly ordered w.r.t. the transaction that initialised the
buffer contents.

> Hmm.  Maybe I'm wrong -- a transaction could bjoin a buffer and then
> call xfs_trans_read_buf_map before dirtying it.  That strikes me as a
> suspicious thing to do, though.

It also seems to me that it doesn't solve the problem of buffer
invalidation followed by a read operation in commit context.

Having though a bit more on this (admittedly they are feverish,
covid-inspired thoughts), I suspect the real problem here is
requiring xfs_imap_to_bp() to ensure we can pin the cluster buffer
in memory whilst there are dirty inodes over it.

If we go back to the days of Irix and the early days of the linux
port, we always pinned the inode cluster buffer in memory whilst we
had an inode active in cache via the inode cluster hash index. We
could do lookups directly on in-memory inode cluster buffers rather
than inodes. Inodes held references on the cluster buffer, and when
the last reference to a cluster buffer went away, it was removed
from the inode cluster hash.

i.e. we never had the inode cluster buffer RMW problem where cached
inodes got dirtied without a cluster buffer already being in memory.

It was simple, and the only downside to it was that it didn't scale.

Hence we got rid of the inode cluster hash index and the pinning of
inode cluster buffers with the introduction of the RCU protected
inode cache based on radix trees. The radix trees were so much more
efficient than a fixed sized cluster hash that we simply did away
with them, and got a memory footprint improvement for read-mostly
inode traversal workloads for free.

Perhaps it is time to revisit that ~15 year old architectural
choice? We've reinstated the pinning for dirty inodes, perhaps we
should just do it unconditionally for all inodes now and reinstate
the direct inode -> cluster buffer relationship we once had.

This has other benefits as well. We can "densify" the XFS clean inode
cache by making VFS inodes unconditionally I_DONT_CACHE, and
simply rely on the xfs buffer cache LRU to hold recently used inode
buffers. It solves several nasty corner cases around inode cluster
buffer freeing and XFS_ISTALE. It allows us to avoid cluster buffer
lookups in the inode logging path. It opens the gate to shared
access to the buffer for flushing dirty inodes to the cluster buffer
without adding new lifecycle problems. It allows significant
efficiency optimisations in managing inode items in the AIL because
lifecycle discrepancies between cluster buffers and inodes go away.

And so on.

So perhaps the best fix here is reinstate the old behaviour of
inodes always pinning the inode cluster buffer in memory and hence
eliding the need for on-demand, log item/IO completion time item
tracking altogether....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
