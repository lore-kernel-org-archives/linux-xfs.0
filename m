Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC648248F48
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 22:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757717468; cv=none; b=sSSy7S3VCf6h63q/tBozFuJn5+zo1gBZb0XX4L3HAKLzbqxmdUXzApLQMhHcMKbNidXulrFmVsVHyb8iZvHipee67YMSe+aOxe/hUQCFKmueF3bOnvkGYT//LK314eDyewAzoRCwVgFXwl+Y8wRbfBpJDvqipyzFx90UlZECo3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757717468; c=relaxed/simple;
	bh=YOXcGHfg2mf4W3/s6seV2E8GnSQ53UsIc+2kJtFCJdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUDetAgfcxVUc+Ceii5w8PSbChEfMmX0APdQ4GSe+7eMVTi7T3buD1RqzWj9o/PqDHQqoqrpcHzDcsOxVTqz4n9WcZiFA0bxcCfeeI2chzDRR7SIpZnh3rqpOZ+2g9e0zZxP+wKSLlxG1FC3ikbH+bX/iEtd0SPfQKnvgKOCX0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xdTHJ/FW; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xdTHJ/FW"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76e4f2e4c40so2212860b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 15:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1757717465; x=1758322265; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wA+M8hQ1q9cqIOe9bR5VV7iDvsTvhsx295cm0pL5JYQ=;
        b=xdTHJ/FWK5bDHUhULoHRw2ysK+jsIpnSQGK/wNSSPCAv8hrQeqEhlh+meor4HHqlki
         4ZUchM1WaFDtQA1VQ+NrAUK07Sv5rfBtQOA1aJOo8oxRybCq9Xr/EavGYvfRxZmGLIRJ
         V4CeAcdkR67z5HXhFqFBMTvDCr4vw4eTTQJF7oS0MFsdK7RPgFV6Jo9C+r8lymDl/56s
         zCnp+6rQqMZFNWhZ6qh/q0G3hF8hLVnjgVuoY5Sg+/nBk40tLpPyWJBir4Aff0LKOwKx
         N01kXNNOEM3DYMXwft93TQyL5wAsrYY0Iw9YmdEeHYaYfF31LpX6nXcjOhvPiQDAslaY
         6Asg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757717465; x=1758322265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wA+M8hQ1q9cqIOe9bR5VV7iDvsTvhsx295cm0pL5JYQ=;
        b=L9saNluHMDqV6vQA2/BhS47SZde7vyRIy15+N47VDiHqe2GTyzWKh84doJi0DGVt1P
         MeAQRdv3LS/bruCWWkNfhqUoOdy4gGtwo19ryhtH5SjSdF8tT5QAv348pwvzBFd29Jxw
         lpacjN6P4zYsTWILrZsPgvMNylKllPY9TNSuP4wKUM4W8Oor2zEBo3LqHlWs9/gYdkay
         t6O+4DfKD75QG5vyoh7UeavE/zBMM7Wdzgy/L2LHXsAKgsMTZBu3mfkGmhpxRXolDjea
         9AP2phw0SPQG4gVBRx+B42g4RRmuM4zMlAp9DJzmCMq4HigbHSuZ3p7kzyD8k+KOD2Os
         8Tsw==
X-Forwarded-Encrypted: i=1; AJvYcCWzSuqX1lZEFIgs1wORdLC8RW0yGozdwfQqv/llQpEbB+h2JxmqLrNxSdKO7St9kSB4kS1qERBC6Ik=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUtEFcAEC/1r71Mw1JOZn/N0uTFX0Ts5A09VhuhICzUoMzEgHX
	7a2eTrGvaDcRK3bq1vMd53cLkcpYk11BtVtYvZ/t8oEyTc/AFfPcUG+Zvn5RP1ujqOE=
X-Gm-Gg: ASbGncvd/tHATmt3V+aMrv9qr2l16ez+ymmA4vlmHZ2o6jpFlnVOgoEdtxIglovs5Zn
	L10Dw3rCL2932cWe7qHEF2wknr6/YU0svixMSglJFjY4iLRbo72T0y6GSm8g8hJ0BpZT6Nd1uZi
	VwxOUgbNmh/v2buzCnZ9DRk1XMBAO0rJVDzfutWtNmXZ69tz0LEGB6Krg7QvStI35/pn0+hm9js
	+g2qRJ3yVO5CZM51yCJeJmpLMkyDShaIJwWmcG/Qee3Qma6NisBnLhtu79GPifWEmSzIgRUcMot
	lghi8Lf5/if1kVuTGhCjpMUBlneeS/oBkRPn27zYRAa7vxnm6RJnlfd09FScqEDRY6PW/gzvjdj
	P9Eoi+z5SYPwoRmAqlasDiN57hviqm8wzspO8gOA1+Ha+Wb5iZN5V/DEdlUFM48ALzP2zVJnUZ5
	IzSVIlTx3G
X-Google-Smtp-Source: AGHT+IFo1lDPGPa9ujzGqWPBkLJtotrvuieRUCiBB83GkElVpJ3pJIT5oPAa+9yUOLlt5ADMfKXopA==
X-Received: by 2002:a05:6a21:32aa:b0:243:a251:cf51 with SMTP id adf61e73a8af0-2602c71d334mr6093077637.54.1757717465166;
        Fri, 12 Sep 2025 15:51:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760793b6b1sm6487510b3a.20.2025.09.12.15.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 15:51:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uxCbe-000000019Z1-08rs;
	Sat, 13 Sep 2025 08:51:02 +1000
Date: Sat, 13 Sep 2025 08:51:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, cem@kernel.org, chuck.lever@oracle.com,
	jlayton@kernel.org, amir73il@gmail.com
Subject: Re: [PATCH v3 10/10] xfs: add support for non-blocking fh_to_dentry()
Message-ID: <aMSj1kiRMfP8fZD4@dread.disaster.area>
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
 <20250912152855.689917-11-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912152855.689917-11-tahbertschinger@gmail.com>

On Fri, Sep 12, 2025 at 09:28:55AM -0600, Thomas Bertschinger wrote:
> This is to support using open_by_handle_at(2) via io_uring. It is useful
> for io_uring to request that opening a file via handle be completed
> using only cached data, or fail with -EAGAIN if that is not possible.
> 
> The signature of xfs_nfs_get_inode() is extended with a new flags
> argument that allows callers to specify XFS_IGET_INCORE.
> 
> That flag is set when the VFS passes the FILEID_CACHED flag via the
> fileid_type argument.
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> Acked-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/xfs_export.c | 34 ++++++++++++++++++++++++++--------
>  fs/xfs/xfs_export.h |  3 ++-
>  fs/xfs/xfs_handle.c |  2 +-
>  3 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index 201489d3de08..6a57ed8fd9b7 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -106,7 +106,8 @@ struct inode *
>  xfs_nfs_get_inode(
>  	struct super_block	*sb,
>  	u64			ino,
> -	u32			generation)
> +	u32			generation,
> +	uint			flags)
>  {
>   	xfs_mount_t		*mp = XFS_M(sb);
>  	xfs_inode_t		*ip;
> @@ -123,7 +124,9 @@ xfs_nfs_get_inode(
>  	 * fine and not an indication of a corrupted filesystem as clients can
>  	 * send invalid file handles and we have to handle it gracefully..
>  	 */
> -	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
> +	flags |= XFS_IGET_UNTRUSTED;
> +
> +	error = xfs_iget(mp, NULL, ino, flags, 0, &ip);
>  	if (error) {
>  
>  		/*
> @@ -140,6 +143,10 @@ xfs_nfs_get_inode(
>  		case -EFSCORRUPTED:
>  			error = -ESTALE;
>  			break;
> +		case -ENODATA:
> +			if (flags & XFS_IGET_INCORE)
> +				error = -EAGAIN;
> +			break;
>  		default:
>  			break;
>  		}
> @@ -170,10 +177,15 @@ xfs_nfs_get_inode(
>  
>  STATIC struct dentry *
>  xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
> -		 int fh_len, int fileid_type)
> +		 int fh_len, int fileid_type_flags)
>  {
> +	int			fileid_type = FILEID_TYPE(fileid_type_flags);
>  	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
>  	struct inode		*inode = NULL;
> +	uint			flags = 0;
> +
> +	if (fileid_type_flags & FILEID_CACHED)
> +		flags = XFS_IGET_INCORE;

XFS_IGET_INCORE doesn't guarantee non-blocking lookup behaviour. It
never has and it never will. It simply means we return inodes that
are already full instantiated or it fails with either EAGAIN or
ENODATA.

IOWs, XFS_IGET_INCORE exploits the internal XFS inode cache
architecture (cache lookups are done under RCU locks, so cannot
block). The resultant cleanup that needs to be done once a ilookup
fails before another attempt can be made is done outside RCU, and
the lookup is most definitely allowed to block in those paths before
it returns -EAGAIN to the outer lookup loop. It is mostly pure luck
that we don't have any sleeping locks in various internal "need to
retry the lookup" paths right now.

Exposing XFS_IGET_INCORE functionality to the outside world does not
fill me with joy, especially to a userspace ABI.  i.e. this takes a
rarely used, niche internal filesystem behaviour, redefines how it
is supposed to behave and what it guarantees to callers without
actually defining those semantics, and then requires the filesystem
to support it forever more (because io_uring is kernel/userspace
ABI).

IOWs, this is a NACK on using XFS_IGET_INCORE for FILEID_CACHED. The
semantics that are required bu io_uring are non-blocking lookups,
and that should be defined by a new flag (say XFS_IGET_NONBLOCK)
with clearly defined and agreed upon semantics.

Indeed, this shows the semantic problem with defining the generic
filehandle behaviour as FILEID_CACHED. io_ uring does not want
-cached- inode lookups, it wants *non-blocking* inode lookups.
These are *not* equivalent lookup semantics.

e.g. find_inode_fast() has FILEID_CACHED compatible semantics - it
will return either a referenced, fully instantiated cached inode or
null.

However, find_inode_fast() does *not have non-blocking behaviour*.
If it finds an inode being freed, it will block until that inode has
been removed from the cache, then it will retry the lookup and
return NULL because the inode is no longer found in the cache.

IOWs, "only return in-cache inodes" is fundamentally the wrong
semantic to implement for non-blocking filehandle decoding. The API
needs to ask for non-blocking lookup semantics, not "in-cache"
lookup semantics.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
