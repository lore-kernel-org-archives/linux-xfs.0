Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8304D2E92BC
	for <linux-xfs@vger.kernel.org>; Tue, 28 Oct 2025 22:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761690540; cv=none; b=q74+gmBj/xI3fQOKs4fXOqO8Qae0vrY7sG3Ts4YI8hKPZ4Ddz3fGLR6CcqhMEGA2jKdgCRj0/VIYFQP3vcVBewBjHnxv7Wpyk4fG9w2x0HlhuP7kajSLE3+PpfBSQGeN9GwydXfdlmPF4Yt2wvi6FOMhXvg+AbP95sbbBa1snUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761690540; c=relaxed/simple;
	bh=R327mkMbhOhLjP1FNeOIfxfJUXB78fgCTiAQuSDWDzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bwq6CJxdpeZgqkAp60kmh6i2j13KmdLN4o9mCjECobYstgTnlauXQ0caalclDVZRqzJ4o1bcUv7fO5rbCodVV2F9MJ75mmZdXNKm8gh128eKqpZt7nAzYw//FsXwURoD/9MHLuJaVIdapdWsJDYS5Jeoi7FlbNks9LkLpysYzRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=MGyUq52J; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="MGyUq52J"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-34029c5beabso1611772a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Oct 2025 15:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1761690538; x=1762295338; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CAU2TLyqRUUdNsn0cYS98k9VY4+CKit2Kh6z3BNF2wM=;
        b=MGyUq52JEaDOU9YWtztQ8gloryZWlhve5rjz7NrSZkfh8Gg818LGG9ew7xhTJApDhJ
         5BQaUzCwEQUCrMdUByxd6398w6skMq57qbscYK4Xb+tODfbqC3Xa9iqkVpsa2Wi1+uxC
         eO8+Kwz4jSLP6rRW4zPZ4P16lsMBR4R4WS36vi1NyJPlFwdr//IatMwWdqwkRRvbtvfM
         JXIZsuuXbfJVnA7zANKCC3HwWYmYRdcuepLA/Wb9tiD0EIBnfOVQY7Lk8MX9wxNIoWdN
         zdOq3AAxCFIGPzcKgz7UJNlELLPd9VztaOVPfuQhphhP7AhYDlIa5ZLAnX6jmY+/pRgA
         C0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761690538; x=1762295338;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CAU2TLyqRUUdNsn0cYS98k9VY4+CKit2Kh6z3BNF2wM=;
        b=GnJKCHGDT/TftDs7DWAxYE8SKTb5NlFC+OANrnFdBWh4pN2EW67X8gKTRl7xQi6BQ0
         JYEQmSnPmNTsCppd4LkAffFcCjjrP+5RJT50juPKaHL0dF/ZUkUHTyGMRoZ73Jjoh3Nq
         xfeU1N8ZBogciesaobMTmgDdPCag8oZSX06aO+Q3a5BZ1j3DKz11w5nFkidf88LSbwPV
         pXIB8qT3zukIvjcDhM+koHgZoZCtJl9oF7m9fICCnXYasc2CyyR7GKtkmRCdEP4bHwB8
         Y0DFC1idYNPuie82Q25vlTXzss+G2rttm9uhdt8QDDepfOAYTFmxStZvwHHM2mROYX1Y
         i/rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgaffTckjC070EiXS25YevusDmtErUZ9H4lDUVbIq4eu46E4Ly69VdLcvQYgPGT4a4PhN4n+biq3g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNwljSLyY3dghMwW2Aqqq80iGirFVouvDazui6EE9Ks/mFQRMo
	80WIzN7WqBsEKG3abUcD02UgGOAbIvR7EiqfNoBGtZjq8h/kysPApzYLPPbDHqHzdqI=
X-Gm-Gg: ASbGncuGnu1Uc55J+RNSCvro7n0sYrc8AIJFqM4fftAFbARyeMZ2WFL+c9RBMI3fGe1
	3ql6mlWFfCfJ3v+SemxrKsLKxbe9kY9s3xlXRQ5zud+PJRZOw9PkjGBjJe9aG2q9h1ZlbcfREug
	3E7z22x8Vnnm7mSXZ+4FYImTPqG5PrsJsxEz9TCXsJrjMuwLO8RoXH6QX7xPdbmXgNM3Q4YD+vZ
	VLlpuNFCTbKhFb0eliSjwuIuuNLSOpWPBKMcozH4FtK0emT69brh6Wc/8dfaq/Mx2QTb2X3fGOP
	gdlMKL5e+ZEAbogGklOTJGtsy9obR6wgwsPS/oGqUQP4gXhJorjySUBGQwy4MmQfJ3/FO53tRgT
	N62oczW8MFjse7muwgng64R9VOgEq/Kw3pOU5KBevoqgZ2PngYW+qFKUNxKIFvSr0U863cqf1Gf
	qnwXoqrVzcGFJ7XTtnctgmQTtNDDz5S4d7zyrih/clx+kT4oLI+g8=
X-Google-Smtp-Source: AGHT+IGyg3OATGBkb9vX4874FYJqb/XmzITag6rb76Vk8oKi5aNj0bmOrr0g5KKcD/2bNn1E787kTQ==
X-Received: by 2002:a17:90b:1810:b0:33e:2d0f:479c with SMTP id 98e67ed59e1d1-3403a285082mr571565a91.22.1761690537395;
        Tue, 28 Oct 2025 15:28:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b71268bfaa1sm11504530a12.7.2025.10.28.15.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 15:28:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vDsBR-00000003P9L-0fi2;
	Wed, 29 Oct 2025 09:28:53 +1100
Date: Wed, 29 Oct 2025 09:28:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <dai.ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
	linux-xfs@vger.kernel.org, honza@suse.de
Subject: Re: [RFC PATCH] NFSD: Make FILE_SYNC WRITEs comply with spec
Message-ID: <aQFDpZCGBpBoLBRo@dread.disaster.area>
References: <20251022162237.26727-1-cel@kernel.org>
 <aPkUGpuBfz_E0gGu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPkUGpuBfz_E0gGu@kernel.org>

On Wed, Oct 22, 2025 at 01:27:54PM -0400, Mike Snitzer wrote:
> On Wed, Oct 22, 2025 at 12:22:37PM -0400, Chuck Lever wrote:
> > From: Chuck Lever <chuck.lever@oracle.com>
> > 
> > Mike noted that when NFSD responds to an NFS_FILE_SYNC WRITE, it
> > does not also persist file time stamps. To wit, Section 18.32.3
> > of RFC 8881 mandates:
> > 
> > > The client specifies with the stable parameter the method of how
> > > the data is to be processed by the server. If stable is
> > > FILE_SYNC4, the server MUST commit the data written plus all file
> > > system metadata to stable storage before returning results. This
> > > corresponds to the NFSv2 protocol semantics. Any other behavior
> > > constitutes a protocol violation. If stable is DATA_SYNC4, then
> > > the server MUST commit all of the data to stable storage and
> > > enough of the metadata to retrieve the data before returning.
> > 
> > For many years, NFSD has used a "data sync only" optimization for
> > FILE_SYNC WRITEs, so file time stamps haven't been persisted as the
> > mandate above requires.
> > 
> > Reported-by: Mike Snitzer <snitzer@kernel.org>
> > Closes: https://lore.kernel.org/linux-nfs/20251018005431.3403-1-cel@kernel.org/T/#t
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > ---
> >  fs/nfsd/vfs.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > This would need to be applied to nfsd-testing before the DIRECT
> > WRITE patches. I'm guessing a Cc: stable would be needed as well.
> > 
> > diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> > index f537a7b4ee01..2c5d38f38454 100644
> > --- a/fs/nfsd/vfs.c
> > +++ b/fs/nfsd/vfs.c
> > @@ -1315,7 +1315,8 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
> >  	init_sync_kiocb(&kiocb, file);
> >  	kiocb.ki_pos = offset;
> >  	if (stable && !fhp->fh_use_wgather)
> > -		kiocb.ki_flags |= IOCB_DSYNC;
> > +		kiocb.ki_flags |=
> > +			(stable == NFS_FILE_SYNC ? IOCB_SYNC : IOCB_DSYNC);
> >  
> >  	nvecs = xdr_buf_to_bvec(rqstp->rq_bvec, rqstp->rq_maxpages, payload);
> >  	iov_iter_bvec(&iter, ITER_SOURCE, rqstp->rq_bvec, nvecs, *cnt);
> > -- 
> > 2.51.0
> > 
> 
> I agree with this change.  And as I just replied elsewhere, IOCB_SYNC
> doesn't cause a performance drop (at least not on modern systems with
> NVMe): https://lore.kernel.org/linux-nfs/aPkNvmXsgdNJtK_7@kernel.org/

Well, that depends on the underlying file layout. If the test was
doing IO that required allocation or unwritten extent modification,
the IOCB_SYNC performance is identical to IOCB_DSYNC because they
both have to stabilise metadata needed to access the file data.

However, if it is a pure overwrite (i.e. writing into already
written space) then the only filesystem metadata update that occurs
is timestamps. At this point, IOCB_DSYNC is *much* faster than
IOCB_SYNC because it does not require a journal flush to stabilise
metadata.

So if you didn't see any change in performance between DSYNC and
SYNC writes, then is likely that the the tests did not exercise the
pure overwrite path which many high performance applications
optimise for (e.g. databases).

IOWs, I'd definitely expect performance regressions to be reported
by users from this change further down the line...

> Only question I have:
> does IOCB_SYNC _always_ imply IOCB_DSYNC (for VFS and all
> filesystems)?  Or should we be setting IOCB_DSYNC|IOCB_SYNC ?

Yes - "all metadata" (_SYNC) has always been a super set
of "enough metadata to retreive the data" (_DSYNC)...

> (I took to setting both for NFSD Direct, and NFS LOCALIO sets
> both.. that was done by original LOCALIO author)

That's a (harmless) bug.

> Basis for my question, is that there was a recent XFS performance
> improvement made by Dave Chinner, reported by Jan Kara, for
> DIO+DSYNC, see commit c91d38b57f2c4 ("xfs: rework datasync tracking
> and execution").  Will DIO + IOCB_SYNC get the benefit of DIO +
> IOCB_DSYNC relative to this XFS improvement?

Yes, it will. But IOCB_SYNC will still be much slower than
IOCB_DSYNC for pure overwrites....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
