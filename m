Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385CB2C1B1
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708473348; cv=none; b=oq36ptYveFzybq0H2tYMPhoEa1NDG/I+0BjbUr97SfiC3mFXZwk1vaZUsctqwdGBpulJukldK3ZCxAfNFJ4LWgwLcPGpfgTiXFFqngztSE2G6p4A3Jai30s6hMtwYj9JndSX+mPv7s5vFRmKOtCNsKrQRPVBtNRAUb/pmO+d4JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708473348; c=relaxed/simple;
	bh=y5PYHyd/H/pPgwgAspNoKjkpUAooayv/vKzKiAwatVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZPD/plEL7IENY7GpzUOV0GFrFi8m5Z4A8fR2vAxEbZTUipwcIBHw7epA5hVKvwsNuLFl6RbZxK3/2EVzLEWWcdl8jv2rJoFG8ONfn7rCJZbzYaYHJlTKW5+l4ka5FewYuiJHx02yE7Eu02hAlOrLUBSQ9+ASjX82WtuENY2kmQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=DtjQ7WiV; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="DtjQ7WiV"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dbae7b8ff2so25003415ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 15:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708473346; x=1709078146; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wCeoJ7wd2Ym9WpusOgs2eL3q4fWqznt5WpzS/+ydovM=;
        b=DtjQ7WiVDnW4DGdGk/RFACCBz1zwio+68kf6noNNlvzVt+B0R4vZU3asl+4NDMry3u
         eebzi9PPyFN58giHNs58Kua25NMXHsZMjL5DYRnUAdV9nrz7QWnHhgmfdFH1BzA6L5Qz
         0M8HbVqwl+ArOvGxz7clH7yzbYNahUb8TplhvjiZKNTbl7Ocrma9eu9fFSDoLx3GBr3g
         Kln7LroitQe8ieFDJUvdJD0VrvObNUrTYUeU3iLZV2C6Rjwmanrn831/rtBYrWvg0903
         rS9UJgFVVvCyQBO6Lpx+KnrwMfRl0kD542jH9ifCCTsM1XbjmddNriXUOPry7+dCxJkx
         Nsfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708473346; x=1709078146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wCeoJ7wd2Ym9WpusOgs2eL3q4fWqznt5WpzS/+ydovM=;
        b=iQ5rb2YoR0ltIFCCBR37Tj6Kb+VcvJS8PRdwwo2Z3PDACBYg8a5QmyV8G1s8rVjwwL
         0MzIRyHxBUB9qXJ1h9NLwsXxBEBbgm63ZXFlHW7/wPqE8kG9qTuWo6YuFcDKrBmWLVUU
         a+voyH5DR0GRXIFyGGdWnNFwvfq4E0KMeWb4mp+iNyBDp29xYXZ5uqc2aRRFfPLwT0NC
         OeviP3Bsi5mrB8Lj6Rwk8ngtj5dr/0rKTjDHOcM6iXB7VCb3h4Jl+jlK102mZ00+9WX5
         /O34n5UvwgPx15unhG42SEeFMpHDNfUtC4pIsDTXQuMScLgdPXIYidNqchMzl5DrKDNY
         b4zg==
X-Forwarded-Encrypted: i=1; AJvYcCX4DNFQj1JmeKo933qiCfkh1yY7MiqCGKYraO9hN81rwFgkFUAf40iAnV+ZnepHKPeTcR5xa+ddrq75jW9dPwayvPuYf5GTt/vI
X-Gm-Message-State: AOJu0YzW4IYTgi+mkh9t5vJZipQ77/ShLpWj5FqMnBtxZNVhd2/wj/oA
	OsAPihF2QSkpoydbhxQCYth95OTLKHyVpnC/C3jYcxXD/oue3xa8m7kbFvsD1+o=
X-Google-Smtp-Source: AGHT+IEzYVQ1RXOWRhg73P6iXAoqf2eMAnWBvhQQZaaY74jbe7V1cTJ22dYomzA8shnl3c12ErUytw==
X-Received: by 2002:a17:903:32d1:b0:1db:d2f7:6884 with SMTP id i17-20020a17090332d100b001dbd2f76884mr10136234plr.25.1708473346591;
        Tue, 20 Feb 2024 15:55:46 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id c20-20020a170902c1d400b001dbc3f2e7e8sm6584954plc.98.2024.02.20.15.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 15:55:46 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rcZxf-009HQO-2D;
	Wed, 21 Feb 2024 10:55:43 +1100
Date: Wed, 21 Feb 2024 10:55:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 08/22] xfs: use VM_NORESERVE in xfile_create
Message-ID: <ZdU7/1C+6GS/HBvf@dread.disaster.area>
References: <20240219062730.3031391-1-hch@lst.de>
 <20240219062730.3031391-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219062730.3031391-9-hch@lst.de>

On Mon, Feb 19, 2024 at 07:27:16AM +0100, Christoph Hellwig wrote:
> xfile_create creates a (potentially large) sparse file.  Pass
> VM_NORESERVE to shmem_file_setup to not account for the entire file size
> at file creation time.
> 
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/xfile.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 090c3ead43fdf1..1cf4b239bdbbd7 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -68,7 +68,7 @@ xfile_create(
>  	if (!xf)
>  		return -ENOMEM;
>  
> -	xf->file = shmem_file_setup(description, isize, 0);
> +	xf->file = shmem_file_setup(description, isize, VM_NORESERVE);
>  	if (!xf->file)
>  		goto out_xfile;
>  	if (IS_ERR(xf->file)) {

Make sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
