Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF7C1DACA8
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 09:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728983399; cv=none; b=gMk8ydNN6bA5SH7Nsmw2ncnO+M4tO7+J5H/lAhBoEwXafSJsyvJHlSXBFwY1EoRD+fa1X0imq0HG1QwEs0LryNZ8AvvUNHJtbldpAcleo6LfTicwAVq5Cj4hrcYccl6m4LlOa6wk/4aSgrB3nJalZz/de99G80Db6iQozDPaIqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728983399; c=relaxed/simple;
	bh=X7rQ1e1gtRLVNKNjGKEYb2pzJlHj2mwf3dXGr2mbZEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JS2i4+nXGrFhamXEmwlTPUhRF80XUhvux5l9Kw8XlA2ZYwR5+psNRaBbHWDnMfQpto6x+N6dxWCjFa4J9L6Vechy1VeXfr0HRA8TI45g63WmM1xjCx4XSpCRABZRqm5SZ5Ha6ZQestMdd6/0DhoGgLYHn+y5utrZQT0xFF+ASpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=igZPQYfv; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="igZPQYfv"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-208cf673b8dso53889035ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 02:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728983397; x=1729588197; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8AhULyk6snj9S3RcuiVf6TLsKGAqPkiRMcdk1wAoLOY=;
        b=igZPQYfvHh47vdnB8yLFim03uwbi0ULKFbvM0D4aYXCSpACw64gCrU8/E1nhcASc0U
         YOboehYhSi+SgwxlFcImAuS7sPY61WCPp5mbLsBGelwYopr/9BZ67B+gOY3aD5hX6zPl
         UtsPBXCLoLndfoZnBxOqdRWnr12NO717tSQ38yDJeZxZMtid2xQz9Gm3z6wCDpkTkwxY
         I+wNJjHauaE4+x1jTJ2zcWxM01LlMkr6+wBszUDauSNT7mdKhFW6lj79ydz0aasaEcPu
         WljMm/ub9ZF82n1m0s9FmurtLWNpv+0OU8Z+KP7vy1e5zAq7PhYZ6gnG8HkF/gNfchbc
         lMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728983397; x=1729588197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8AhULyk6snj9S3RcuiVf6TLsKGAqPkiRMcdk1wAoLOY=;
        b=vfxL+GDczF7vrjPLfQGDSWmaQZGcmEIvt33MKykNsPqrJmZK4vR8vSXJSVsuNl2QNg
         Jg6q2vlh7+yaXlZAzF1eBfuxtW809UqhsyhIhCXZVGumTqlITBsvPgG/0SOVc3mzInzw
         lcAZSVXuXb2/dBAZaL+gFrS3cYBPIQWysnEgLptd3RTwojinCqq5MvOryHkKMXNZQYmD
         jnikeUBUXN+d8UaRddBJtxKIIf1tE3FADX9TRJR9oweiMV/B7Gr7vDtA7fBOMbtOEPw+
         OTWp3zZjh98iRAOFee9JiZ1eOPvWf0kj6C4dKlJH7qtcncvRg038rf/1Q7FPTou8wMlZ
         6YMg==
X-Forwarded-Encrypted: i=1; AJvYcCUbWHTYVHzNjZAJoXaAmZ0hULK7JW4uZn0oOfUHNFqxsIbadK5gtfjsK7MFMVktFWw1ilxIwaNPqiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMNMGrvtuV4HhDYBVqbOlygq8qk7RE52OTY9CtKBTgFGdMspki
	N6N/HlWpi9RdesTsGXsA8wMjtO0Ow97I+4GImAh+oMh4F1F7MRJVWduZhYZ4Gi/4x/ghpLUZ4Ka
	2
X-Google-Smtp-Source: AGHT+IGwoTYwZ06lpisK07syvetoBb7P3dzuaywipqYbWXXCS6vh1cTs5znbTIEuDJEIhGkio1HQ9w==
X-Received: by 2002:a17:902:f64f:b0:20c:d1ec:aeb with SMTP id d9443c01a7336-20cd1ec0ec4mr132762935ad.21.1728983397003;
        Tue, 15 Oct 2024 02:09:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1804c282sm7781325ad.226.2024.10.15.02.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 02:09:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0dYv-0014Or-36;
	Tue, 15 Oct 2024 20:09:53 +1100
Date: Tue, 15 Oct 2024 20:09:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <Zw4xYRG5LOHuBn4H@dread.disaster.area>
References: <20241011182407.GC21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011182407.GC21853@frogsfrogsfrogs>

On Fri, Oct 11, 2024 at 11:24:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Check this with every kernel and userspace build, so we can drop the
> nonsense in xfs/122.  Roughly drafted with:
> 
> sed -e 's/^offsetof/\tXFS_CHECK_OFFSET/g' \
> 	-e 's/^sizeof/\tXFS_CHECK_STRUCT_SIZE/g' \
> 	-e 's/ = \([0-9]*\)/,\t\t\t\1);/g' \
> 	-e 's/xfs_sb_t/struct xfs_dsb/g' \
> 	-e 's/),/,/g' \
> 	-e 's/xfs_\([a-z0-9_]*\)_t,/struct xfs_\1,/g' \
> 	< tests/xfs/122.out | sort
> 
> and then manual fixups.

[snip on disk structures]

I don't think we can type check all these ioctl structures,
especially the old ones.

i.e. The old ioctl structures are not padded to 64 bit boundaries,
nor are they constructed without internal padding holes, and this is
why compat ioctls exist. Hence any ioctl structure that has a compat
definition in xfs_ioctl32.h can't be size checked like this....

> +	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,		8);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_exchange_range,		40);
> +	XFS_CHECK_STRUCT_SIZE(xfs_exntst_t,				4);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_fid,				16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,			128);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsid,				8);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_counts,			32);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,			256);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,			112);

e.g. xfs_fsop_geom_v1 is 108 bytes on 32 bit systems, not 112:

struct compat_xfs_fsop_geom_v1 {
        __u32                      blocksize;            /*     0     4 */
        __u32                      rtextsize;            /*     4     4 */
        __u32                      agblocks;             /*     8     4 */
        __u32                      agcount;              /*    12     4 */
        __u32                      logblocks;            /*    16     4 */
        __u32                      sectsize;             /*    20     4 */
        __u32                      inodesize;            /*    24     4 */
        __u32                      imaxpct;              /*    28     4 */
        __u64                      datablocks;           /*    32     8 */
        __u64                      rtblocks;             /*    40     8 */
        __u64                      rtextents;            /*    48     8 */
        __u64                      logstart;             /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        unsigned char              uuid[16];             /*    64    16 */
        __u32                      sunit;                /*    80     4 */
        __u32                      swidth;               /*    84     4 */
        __s32                      version;              /*    88     4 */
        __u32                      flags;                /*    92     4 */
        __u32                      logsectsize;          /*    96     4 */
        __u32                      rtsectsize;           /*   100     4 */
        __u32                      dirblocksize;         /*   104     4 */

        /* size: 108, cachelines: 2, members: 20 */
        /* last cacheline: 44 bytes */
} __attribute__((__packed__));

I'm not sure we need to size check these structures - if they change
size, the ioctl number will change and that means all the userspace
test code built against the system /usr/include/xfs/xfs_fs.h file
that exercises the ioctls will stop working, right? i.e. breakage
should be pretty obvious...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
