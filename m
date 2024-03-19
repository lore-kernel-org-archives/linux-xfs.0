Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99DE633
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 00:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068945; cv=none; b=SuJBI9v8T4tog9scEC7NdGpJsC7drvzKjqXenV9B7BIb+R0v9k9tPA+Jr9HtBddK9jl8F12B5S9kfMSmCcPQp3aFDqRE2b3FYzJimTBj5wQTYxhrDJF5r9ydanCvyH75OvAE2ExlxZCz6dUNsQO4XKoeBeYCCrtpFa6uEtHuTvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068945; c=relaxed/simple;
	bh=4cWD8IG4gVGiQGrcNxBtU++hLFIc5E57whvnEJ7aJe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oRO55zXvk7ygx9si/Yx8C5eGJYGEx5VgvAIDG5F1CXBfMbpvKOyZpeoosVik9bErFOgg1QEfUuH/8SiC2WPpmKtAmjpzxzZUsoaaNLq3Ktfae1McsfmjQgXFaPLlSgj/XuMavS9RMYpgR/2YspMzjSs2aVwO32YU9Z+iXM7o2AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=lQh+1/Cr; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="lQh+1/Cr"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dddbe47ac1so17709115ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 17:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711068943; x=1711673743; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=BsfO+CLAsWTNw6PWeCfjLK5xvJALMzLomuu7B9NzRX8=;
        b=lQh+1/CrRsCyYJ4Pyh2Vty2xzyuq+7dkOy9BqowWlsTHc/YdtL3+LHGIcOlpMF+9C+
         VuNkCGeL9cKw3l2PNUwee8ObCp1bdktY6lqvZ7nhZGm1fenmBPT0KlyANOULHzvHQeH2
         gbJKB+vQY97O84P8Ky9MZfDvIBKDcV293T+vYSMdw9BCbLgixBv0nq/agl+zpBmPgVcp
         mPagrddIdX6sVEzMHvdBuTxryW7Bv0W1D52f/jgWZS/FI6QaJvK6gIKzOp8zcuSvVg7g
         jMLoFcnNEUifrEOn13fdYm6eUdW1P2++xihUGH4363rgTFBSRJ9uwLCrFZfEbLDeSFlV
         Sl3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711068943; x=1711673743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:resent-to:resent-message-id:resent-date
         :resent-from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BsfO+CLAsWTNw6PWeCfjLK5xvJALMzLomuu7B9NzRX8=;
        b=F3TZiBPE5YNN3KIVPCUs/5VDHg6ZagE/hjfoEVGGg9lbiv5Ob8lmaFiH2gMLN4wkBz
         +E3OuYr6timeC6UBEdm250pspTPZBL8O143hzHH2toCyA3sUZRJ0ABLqm57rKmHLXTfE
         VZyZ0KNP1BWsayveroVA1TUSW2dkr3j3uQ/kz3y8YYNG1liEsEWC2TwGzWdxsDhLanOe
         lmI64QaFXNHfOMICrXFyHcCwjHctiRKIC1uH6Wgl4PD+JYVpD1PKFmtYZU584GTORyZC
         dtUZQ+qsPFtpnW30w1cFYYS6d5szYlC9sYD+yT6kZ9kQNbI4m259MtQtpar32pRWIPos
         hGng==
X-Forwarded-Encrypted: i=1; AJvYcCU+QQT2+2wYa3XpYzrnRokqWBIQAIZG74QtHOFRMbV5S23HkLrAjlhJS7RO4XpGMIIo6H8rcAwpWjh7vHYx7gVterD1BYaGJot7
X-Gm-Message-State: AOJu0Yx5e+2TG/j7Hf7tF2/pesgyGYT55RXud9PJF3UUPpfqkrbKzri4
	hQtaYyvBl+r9iikaUOQsdX7JNHEihetrpjV1LrpvcrXQwt5+F8FkWwy4ALvQvQ+QYnmywe7xHFM
	J
X-Google-Smtp-Source: AGHT+IFQEgL+RL1egCK+VADB9m2DsuaPoYHeBKGxD0WDpWrVM88c0Jneq1nYtGcJgtkqeUT6M14tqw==
X-Received: by 2002:a17:90b:4f4a:b0:29f:931a:8b63 with SMTP id pj10-20020a17090b4f4a00b0029f931a8b63mr842892pjb.17.1711068942880;
        Thu, 21 Mar 2024 17:55:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id lb11-20020a170902fa4b00b001d949393c50sm497973plb.187.2024.03.21.17.55.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 17:55:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnTC8-005Tnf-0U
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 11:55:40 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 11:55:40 +1100
Resent-Message-ID: <ZfzXDK5JJmbrkKr0@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 08:13:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandan.babu@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: compile out v4 support if disabled
Message-ID: <Zfn/8e7MhbFcvHL0@dread.disaster.area>
References: <20240319071952.682266-1-hch@lst.de>
 <20240319175909.GY1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319175909.GY1927156@frogsfrogsfrogs>

On Tue, Mar 19, 2024 at 10:59:09AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 19, 2024 at 05:19:51PM +1000, Christoph Hellwig wrote:
> > Add a strategic IS_ENABLED to let the compiler eliminate the unused
> > non-crc code is CONFIG_XFS_SUPPORT_V4 is disabled.
> > 
> > This saves almost 20k worth of .text for my .config:
> > 
> > $ size xfs.o.*
> >    text	   data	    bss	    dec	    hex	filename
> > 1351126	 294836	    592	1646554	 191fda	xfs.o.new
> > 1371453	 294868	    592	1666913	 196f61	xfs.o.old
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_mount.h |  7 ++++++-
> >  fs/xfs/xfs_super.c | 22 +++++++++++++---------
> >  2 files changed, 19 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index e880aa48de68bb..24fe6e7913c49f 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -327,6 +327,12 @@ static inline void xfs_add_ ## name (struct xfs_mount *mp) \
> >  	xfs_sb_version_add ## name(&mp->m_sb); \
> >  }
> >  
> > +static inline bool xfs_has_crc(struct xfs_mount *mp)
> > +{
> > +	return IS_ENABLED(CONFIG_XFS_SUPPORT_V4) &&
> > +		(mp->m_features & XFS_FEAT_CRC);
> 
> Can you save even more text bytes by defining
> xfs_has_{nlink,v3inodes,projid32,lazysbcount,pquotino,attr2} to 1?
> And I guess defining noattr2 to 0?

That sounds like a new __XFS_HAS_V4_FEAT() that has a thrid
parameter to define the value when V4 support is not compiled in.

e.g.

#define __XFS_HAS_V4_FEAT(name, NAME, v5_support) \
static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
{ \
	if (!IS_ENABLED(CONFIG_XFS_SUPPORT_V4))	\
		return v5_support; \
        return mp->m_features & XFS_FEAT_ ## NAME; \
}

That way we have a single macro that tells us that it is a V4
defined feature, and the documents the support of that feature in V5
filesystems. And when it comes to removing v4 support, we have clear
code documentation as to which features we need to remove or make
unconditional across the code base.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
