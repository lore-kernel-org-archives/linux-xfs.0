Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FB18489
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 00:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722989345; cv=none; b=bULRt9cSGKGkxMJo8EZ4+QMmST4O2J4cQS9LaxiIMtjT84Q7cktnCH1AdxpHI7jNLrozZOouzPrHfV+PkoNc7DePA9Ct2tQVc7ERnpvSpbdG/2go9jBGQRuL8KjbqxMdQQLZDZniBdTK01KIihqLOuO15ppmVx7DYwfl4V6zrgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722989345; c=relaxed/simple;
	bh=hT0MeX3lN/+luMv7GRNg6x2rm+Yc+T8HNtTHn+bEfyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7QSs70Q9n6EOdzCuBPDVn2cQ4OzL/QM2KCtZFRzOOUjqRNVyNWimhCfpxcU1L29amo6Ljnz0GmkQcAy4fU6py1cpk0mKKfam2bIXzlU0kyxLBMz+MGho0bqMrCxF0WXua/oPDrzj3u55j3DSPlcLDKIxM/ouF4HbcxfbGuLVyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=CnTs5MQZ; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="CnTs5MQZ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70d1fb6c108so968263b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 06 Aug 2024 17:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722989341; x=1723594141; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S1whsT5ZzX2NUYGE1kmzQNMAQqUazQflf6zBIIjfKBE=;
        b=CnTs5MQZ1fX9+cnh+rHK9jeB7sG4EwL69djebXabX/4WofeQtsFOQrdzXmsd9E8uX2
         CtrlbDgT777HnyOQbsSqMNMVyU8kFKSpsuAC77pCBqnJQbMXmMTBUViLvXgo/WeUZnHK
         Hsg1t0HmslbBhKAb99HIuPd67kci9ah7XJMkc5stuQShSh+HHqQmTSIUxyZ/LiHKOYSO
         lqe0FDtntLG5n+7Mkl5eSs2swyTJrJIUrJ0gPLc0N1RJlGWeFlD7XCpThF1tZeKMwlRI
         a4jYyj+9J5RylDizv2sLd4oskNSfsVOFCrkSFWns5x3tVtNhHRKmf3M97CKRs7CIQLxx
         mWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722989341; x=1723594141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S1whsT5ZzX2NUYGE1kmzQNMAQqUazQflf6zBIIjfKBE=;
        b=UJv+BEkacvsWwJ1bE3SLzXxaVtBmKSBRQyG0edmgVnUnSVOtU2ZQFMBnZgrbSe/gmJ
         q2e0YoQLgMu5oV9VBon22t/NYt0o1GvPOzp0Fxuf2FQVvq7B2epQdF2JRG9rrQARyNxb
         14q2nqeQgQgzppy+Woe7YPdlx48w8Ho122MCY11AHl0aHoQqrEacdLmnUo/s2SCL3aia
         JjrkZ21LiaTbYTc5J1LLdQQAJdb/R1FDmK2Msb02ItZA9ZiC/9NbwJ/ugwrOrHKdLfFI
         UheejiFdCAKfxcZOujgapTpI7v2JkDwsIaAjmi8UrGfQX3pmZ9vmY4reoo2RLCz43a2P
         3/Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXhYm05GlKeR9KC0UN/Pk5U1iF35/KWXPpXRWa2/fQ4ABK0tPSXsuqxBX3B3E7HTeWN2J3LB2s3ysaueQzepfMOSfpUsGlQ9eAJ
X-Gm-Message-State: AOJu0Yx0l53ILknPQSZ8mfas1U5vBv9hdgeiwC52yRQD7LAni/K8km0P
	dtuWInL6QHN/2ApvCxL7BpCPgXgC5ZUWBD4SHzC1MyHMr9e4m9YxWAgH8Bqdh1iWs+G9jVPpXhO
	s
X-Google-Smtp-Source: AGHT+IFw9vAclRmiZ92meoU01juLqJ0kfWZ8aeYdA0Fzv0l3GA6LwezqSDasXR1t6OKTGWBH1aY4EA==
X-Received: by 2002:a05:6a21:2717:b0:1c6:9fe9:c425 with SMTP id adf61e73a8af0-1c69fe9c522mr12396601637.45.1722989341469;
        Tue, 06 Aug 2024 17:09:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7b7653b4d99sm6279697a12.84.2024.08.06.17.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 17:09:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sbUEc-007wKo-2q;
	Wed, 07 Aug 2024 10:08:58 +1000
Date: Wed, 7 Aug 2024 10:08:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, chandan.babu@oracle.com,
	dchinner@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	catherine.hoang@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH v3 11/14] xfs: Only free full extents for forcealign
Message-ID: <ZrK7GrDSebnXXzF6@dread.disaster.area>
References: <20240801163057.3981192-1-john.g.garry@oracle.com>
 <20240801163057.3981192-12-john.g.garry@oracle.com>
 <20240806192738.GN623936@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806192738.GN623936@frogsfrogsfrogs>

On Tue, Aug 06, 2024 at 12:27:38PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 01, 2024 at 04:30:54PM +0000, John Garry wrote:
> > Like we already do for rtvol, only free full extents for forcealign in
> > xfs_free_file_space().
> > 
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org> #earlier version
> > Signed-off-by: John Garry <john.g.garry@oracle.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c |  7 ++-----
> >  fs/xfs/xfs_inode.c     | 14 ++++++++++++++
> >  fs/xfs/xfs_inode.h     |  2 ++
> >  3 files changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 60389ac8bd45..46eebecd7bba 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -854,11 +854,8 @@ xfs_free_file_space(
> >  	startoffset_fsb = XFS_B_TO_FSB(mp, offset);
> >  	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
> >  
> > -	/* We can only free complete realtime extents. */
> > -	if (xfs_inode_has_bigrtalloc(ip)) {
> > -		startoffset_fsb = xfs_rtb_roundup_rtx(mp, startoffset_fsb);
> > -		endoffset_fsb = xfs_rtb_rounddown_rtx(mp, endoffset_fsb);
> > -	}
> > +	/* Free only complete extents. */
> > +	xfs_roundin_to_alloc_fsbsize(ip, &startoffset_fsb, &endoffset_fsb);
> 
> ...and then this becomes:
> 
> 	/* We can only free complete allocation units. */
> 	startoffset_fsb = xfs_inode_roundup_alloc_unit(ip, startoffset_fsb);
> 	endoffset_fsb = xfs_inode_rounddown_alloc_unit(ip, endoffset_fsb);

I much prefer this (roundup/rounddown) to the "in/out" API.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
