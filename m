Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD93DD520
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 02:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724897111; cv=none; b=UjoxTD8jW+neA0wOJUhz7bFcvPURBaBeF5GszEOE/249LnNcuxIzQ6p0+Bq59qP02juKCOD/pt8U3B/H61QF6L7gH66CZoUk7oJX+FQ9bG5L4xNwfhf77qSBQuPAE2h4z4qsQcUD/mufEil8bt1xBzjhdICiDSPwYRoZud/tOwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724897111; c=relaxed/simple;
	bh=ZUkRlQ7SZPF2sDIDnjzXeJ0QBdyngpxoDfej7FBN/P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6DWIvCIrbAnLjhkBJcVBsjTM6C8hDK4rE3DswjWexwdmOmTLupYe3ZImS9FB0XAFbiWPNTAHSMIicL5HddTUNrxq5VzNkxzsrus12r3jctDbk28PvfYRX94urf35gSsAddHd1NGtEXAYGT1NtxYD6eVTl62gaBaP36SpQZ9D14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=v/leBPwY; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="v/leBPwY"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-715e3e03831so150648b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 19:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724897109; x=1725501909; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GpZABvjl8E8dqIYG4Ac/fqu/W5ztOLNi1HfyikdtObw=;
        b=v/leBPwY/zlNSdXyrdGrU5HWLtBizY6oRqvhKb9FLg5JOi6NMeHZc4oMb/YYPywfh+
         PAjfySHbruFVNDbi1hNylli097ZcbxzcUD2P5jhrWTdQcb58q8+/BlYZSH4ixgVOumtM
         AIwkUNpc+oFp6WFsFbUChaGUqO8W06fSS/lfBhqmFeJkPdTfAtoS3mmVZz9RPEYa93Js
         tjCJHDPUtT73mx9PxF9sFIyeJ5NemGcnx2DZdw2pG7RSGTKMpns+i8IKiZMyOjV6h6y/
         FpjS8hzmyPhEFrtcC8XP6lIo7A20Cz9EpMBwwGVtuvBo7i2xqv7kiUtPjivjRRD0L6Am
         rEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724897109; x=1725501909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GpZABvjl8E8dqIYG4Ac/fqu/W5ztOLNi1HfyikdtObw=;
        b=KOCDJXi8TUyjhAz9lpSNZZJ3RLVod5n8No2SRnuK6K+dHJzrRxS3WVeiLAFmFigNZz
         aFbNdEfz/tvGagwFgBfXCNa0dsjLkosBs0M7ULQDU1zWu7DlLuMLYM5WFv0WPGzn0iq3
         wkf2shX0tmKuimEJkaoVRA+X0m1w9Du/8UTk9Ux+q2T6VaNznRSo1VrQQl1uWEy1a8DP
         y3bRnkVtBIfWlQIt4uZg+LGq8cn8m4AMv7N8mrqcHdq3S3RGei+RkRYLOosB7h8VaIyE
         FGU+XTYX+8N9aLTEuX00qvlzCQ1qFQHRMlV5f2gpoHi1vY7axIYqbVZEdtdLf0na59Ar
         S+/g==
X-Forwarded-Encrypted: i=1; AJvYcCXrwO+cEKxx357PQII46H4k6mD33JAPq0hWO1+Eao2OIPBfr6tDXLJ/ibnvN0k30Se+X0k2TYOciqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdJ9/McoiOcJZhzkCBqlbRBkniagbI/moRhyFZnDIRsx9tx5ui
	ZcLgxpZ8DPH+ne/ejr1UgGz8/bpB7hBJc3PB1fL2dSKMQx+XvTu8K45NbD5PH7WzHIrikQrY4Nk
	h
X-Google-Smtp-Source: AGHT+IEfTNK4i50Jkpr4PANYyl/+xLEFNazozpSG+K1JtbZGVVYyFtypGiJj/+i7jvELgXg3+ANY7w==
X-Received: by 2002:a05:6a00:21c9:b0:714:2881:44cc with SMTP id d2e1a72fcca58-715dfaf3a0bmr1736357b3a.10.1724897109082;
        Wed, 28 Aug 2024 19:05:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-715e56d8075sm127884b3a.159.2024.08.28.19.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 19:05:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sjUX4-00GP9b-0E;
	Thu, 29 Aug 2024 12:05:06 +1000
Date: Thu, 29 Aug 2024 12:05:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: move the zero records logic into
 xfs_bmap_broot_space_calc
Message-ID: <Zs/XUl2ImQHFxhKP@dread.disaster.area>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131591.2291268.4549323808410277633.stgit@frogsfrogsfrogs>
 <20240828041424.GE30526@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828041424.GE30526@lst.de>

On Wed, Aug 28, 2024 at 06:14:24AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 27, 2024 at 04:35:01PM -0700, Darrick J. Wong wrote:
> > This helps us remove a level of indentation in xfs_iroot_realloc because
> > we can handle the zero-size case in a single place instead of repeatedly
> > checking it.  We'll refactor further in the next patch.
> 
> I think we can do the same cleanup in xfs_iroot_realloc without this
> special case:
> 
> This:
> 
> > +	new_size = xfs_bmap_broot_space_calc(mp, new_max);
> > +	if (new_size == 0) {
> > +		kfree(ifp->if_broot);
> > +		ifp->if_broot = NULL;
> > +		ifp->if_broot_bytes = 0;
> > +		return;
> 
> becomes:
> 
> 	if (new_max == 0) {
> 		kfree(ifp->if_broot);
> 		ifp->if_broot = NULL;
> 		ifp->if_broot_bytes = 0;
> 		return;
> 	}
> 	new_size = xfs_bmap_broot_space_calc(mp, new_max);

I kinda prefer this version; I noticed the code could be cleaned
up the way looking at some other patch earlier this morning...

-Dave.

-- 
Dave Chinner
david@fromorbit.com
