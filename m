Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB34217F2C
	for <linux-xfs@vger.kernel.org>; Sat, 26 Oct 2024 21:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729979262; cv=none; b=lkskS+G1npteRN2nvDpI8g4tnrfnQNyFEWiPvOBiH1qYxn6AY/6iFC95H8Bva0ejQeTzRLZNjOuleNrjn6idWC9thwhVyHZ8E4Je5P6uEsofAUEe9rXbRULIFnmU82mHxzS/YI/jVcy1Fq1ipQ7qLks4hKdgJNJE7aRmouHvCKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729979262; c=relaxed/simple;
	bh=kOunigTNUzL1uokkAdZjxADYmJLJ19HVKts3eCyHEGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mfy8nYuKyFuz4oF8tkBcCp8NJZTo1mcpBGduanbmJJNflP6iEqVv3ZJJLf04vcBY/dYPikwjH1gVotJfMwtxjHrCjTd1s0I+2++4YXim0lDiHV4JaYIKONdAkURxcXIQJpQfFUXUSoKCySjFvWBhdQydMIBySeY3oiT/4kM24e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LiIBcn+Q; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LiIBcn+Q"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2e2c6bc4840so2345227a91.2
        for <linux-xfs@vger.kernel.org>; Sat, 26 Oct 2024 14:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729979259; x=1730584059; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0a+jmVPJvabVF4kTOwttNoHbd1NtV8i8T1qu9qK2Fxw=;
        b=LiIBcn+QKs/f8KMj2DEgjM6O5BjOHtiPWGTPZK1IqTgR+hKzikjaxpzVK8+avp/IB1
         Kt1Xydche831lLdHqJFT0SAvz+ZhaRFBo8jy+0QZXNaJ6yVTwWcMIvPvwZeNNlkwEx14
         mJTDn4apxtiNFOBUwrV+2zi2zKhNOwBGqoOuQoYBFjR9lwO0Ntj1sU09yRg/FwDUs4Qk
         mhDanbz4lZLWNGDacBvDeEkfsk2Y+Ha/RTxQIMCKDhcSJCjjX5GO+BTa/qbRydYhSQNe
         2YWoq9Hc6lhTS2eCViOJum4++Io3fa9s1mllTfshqwg5WvMSldVxOmbPc2YFAMoUbd/z
         9Cog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729979259; x=1730584059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0a+jmVPJvabVF4kTOwttNoHbd1NtV8i8T1qu9qK2Fxw=;
        b=hnP3LI2MEJLGVZhKQWPH8f3mBg6BjhlckU9Z+GoPH6rsg40jH9k+MytgYcxrKhjzku
         3rfclz07WB5QlT8CXA2VLPI8AN5HMHFoOohcKre8NrbSM2o/MOAxMCra0NcFp7AHrkq6
         KXLXivpAJ38179SDFGVdogDd8oH5SghaxtMyyID1MxMAhIwXTW2PCjrsgaCsDzRWCKhQ
         00d6HhCncFe6f+N1QL2qQpSHDyT60ELMQflzyqHTu8dioXmaAtNkOOSqEd/vgRNU3ehu
         SgWTx/WHTGq+fAMGKcft0dF9XHKQ287zCGagcRFkYBbF5v2zna9kY1M4yobAZIbQ0llr
         qalw==
X-Gm-Message-State: AOJu0Yz6pGsRKhOscvaGP2CM6gMEYXBqc0L8sNAdqLtQ7hLsVUQ3QZcQ
	7UOFOpMERr3epKIDlWWjLhHoaSSmOPe0Gu9UIRt7VAt8cVtp+FU0O/uY2NBYrWE=
X-Google-Smtp-Source: AGHT+IFGaSSpO4jomjH1YVc5HKfDHsXPb0gUYEfSkf3zetOG3D2Ib9PVcxMRwX1na/HeToJt84bqwg==
X-Received: by 2002:a17:90a:ad93:b0:2e2:e530:508d with SMTP id 98e67ed59e1d1-2e8f107f404mr4309344a91.19.1729979259313;
        Sat, 26 Oct 2024 14:47:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e77e56f468sm5970902a91.41.2024.10.26.14.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 14:47:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t4odC-006CUX-1i;
	Sun, 27 Oct 2024 08:47:34 +1100
Date: Sun, 27 Oct 2024 08:47:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: allow sparse inode records at the end of runt
 AGs
Message-ID: <Zx1jduWy+v0VLjWB@dread.disaster.area>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024025142.4082218-3-david@fromorbit.com>
 <20241024170038.GJ21853@frogsfrogsfrogs>
 <Zxs+HQGuJziECU5i@dread.disaster.area>
 <20241025221919.GP2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025221919.GP2386201@frogsfrogsfrogs>

On Fri, Oct 25, 2024 at 03:19:19PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 25, 2024 at 05:43:41PM +1100, Dave Chinner wrote:
> > On Thu, Oct 24, 2024 at 10:00:38AM -0700, Darrick J. Wong wrote:
> > > On Thu, Oct 24, 2024 at 01:51:04PM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Due to the failure to correctly limit sparse inode chunk allocation
> > > > in runt AGs, we now have many production filesystems with sparse
> > > > inode chunks allocated across the end of the runt AG. xfs_repair
> > > > or a growfs is needed to fix this situation, neither of which are
> > > > particularly appealing.
> > > > 
> > > > The on disk layout from the metadump shows AG 12 as a runt that is
> > > > 1031 blocks in length and the last inode chunk allocated on disk at
> > > > agino 8192.
> > > 
> > > Does this problem also happen on non-runt AGs?
> > 
> > No. The highest agbno an inode chunk can be allocated at in a full
> > size AG is aligned by rounding down from sb_agblocks.  Hence
> > sb_agblocks can be unaligned and nothing will go wrong. The problem
> > is purely that the runt AG being shorter than sb_agblocks and so
> > this highest agbno allocation guard is set beyond the end of the
> > AG...
> 
> Ah, right, and we don't want sparse inode chunks to cross EOAG because
> then you'd have a chunk whose clusters would cross into the next AG, at
> least in the linear LBA space.  That's why (for sparse inode fses) it
> makes sense that we want to round last_agino down by the chunk for
> non-last AGs, and round it down by only the cluster for the last AG.
> 
> Waitaminute, what if the last AG is less than a chunk but more than a
> cluster's worth of blocks short of sb_agblocks?  Or what if sb_agblocks
> doesn't align with a chunk boundary?  I think the new code:
> 
> 	if (xfs_has_sparseinodes(mp) && agno == mp->m_sb.sb_agcount - 1)
> 		end_align = mp->m_sb.sb_spino_align;
> 	else
> 		end_align = M_IGEO(mp)->cluster_align;
> 	bno = round_down(eoag, end_align);
> 	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;
> 
> will allow a sparse chunk that (erroneously) crosses sb_agblocks, right?
> Let's say sb_spino_align == 4, sb_inoalignmt == 8, sb_agcount == 2,
> sb_agblocks == 100,007, and sb_dblocks == 200,014.
> 
> For AG 0, eoag is 100007, end_align == cluster_align == 8, so bno is
> rounded down to 100000.  *last is thus set to the inode at the end of
> block 99999.
> 
> For AG 1, eoag is also 100007, but now end_align == 4.  bno is rounded
> down to 100,004.  *last is set to the inode at the end of block 100003,
> not 99999.
> 
> But now let's say we growfs another 100007 blocks onto the filesystem.
> Now we have 3x AGs, each with 100007 blocks.  But now *last for AG 1
> becomes 99999 even though we might've allocated an inode in block
> 100000 before the growfs.  That will cause a corruption error too,
> right?

Yes, I overlooked that case. Good catch.

> IOWs, don't we want something more like this?
> 
> 	/*
> 	 * The preferred inode cluster allocation size cannot ever cross
> 	 * sb_agblocks.  cluster_align is one of the following:
> 	 *
> 	 * - For sparse inodes, this is an inode chunk.
> 	 * - For aligned non-sparse inodes, this is an inode cluster.
> 	 */
> 	bno = round_down(sb_agblocks, cluster_align);
> 	if (xfs_has_sparseinodes(mp) &&
> 	    agno == mp->m_sb.sb_agcount - 1) {
> 		/*
> 		 * For a filesystem with sparse inodes, an inode chunk
> 		 * still cannot cross sb_agblocks, but it can cross eoag
> 		 * if eoag < agblocks.  Inode clusters cannot cross eoag.
> 		 */
> 		last_clus_bno = round_down(eoag, sb_spino_align);
> 		bno = min(bno, last_clus_bno);
> 	}
> 	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;

Yes, something like that is needed.

> > > If the only free space
> > > that could be turned into a sparse cluster is unaligned space at the
> > > end of AG 0, would you still get the same corruption error?
> > 
> > It will only happen if AG 0 is a runt AG, and then the same error
> > would occur. We don't currently allow single AG filesystems, nor
> > when they are set up  do we create them as a runt - the are always
> > full size. So current single AG filesystems made by mkfs won't have
> > this problem.
> 
> Hmm, do you have a quick means to simulate this last-AG unaligned
> icluster situation?

No, I haven't been able to reproduce it on demand - nothing I've
tried has specifically landed a sparse inode cluster in exactly the
right position to trigger this. I typically get ENOSPC when I think
it should trigger and it's not immediately obvious what I'm missing
in way of pre-conditions to trigger it. I've been able to test the
fixes on a metadump that has the sparse chunk already on disk
(which came from one of the production systems hitting this).

-Dave.
-- 
Dave Chinner
david@fromorbit.com
