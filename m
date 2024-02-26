Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9218A130AF9
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 21:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708982304; cv=none; b=g360EgZiEyTa3BNNLBoE7Sz9BWb/Ezx6xxBG7rUm//sU6tKdd3oDCwOb9wrzlAhvSUR4tEmGFjq0rdFxx6La4PVnQHFBsoCIwpUBLd/tplXuNUS7ouXgqKi7ss4tWWGbg1GoR7Nz8xEwgl2n38jFMHEOwkgzH4x0onK0RHwtVQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708982304; c=relaxed/simple;
	bh=eaIp+fx10BWGs+4xS6PS0LUQ/7o+RRQRSzDpSW83ah4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LcMsJHV6FBfIaKElS7oEMmqVex+Z/kd4ovL0UHPczNlx8ZXKx7dvBhrBW0VzOj/wYe9XxQkAeJfSG07hOrfR8MkPc4Ik+cvaJdxCwDxY+G57gTpGQ2gnSJfSTyt/GQEkpQvYrJuIa/m8diaHP+XzHp6r9ew6A8+9H80OuvPBmCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=a/5yuU3X; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="a/5yuU3X"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5d4d15ec7c5so2851498a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 13:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708982302; x=1709587102; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I9bpXPsVA2dblkxjM286LakoqzaJhRDzLGBOQQdyQhQ=;
        b=a/5yuU3XTKNhRHnA1h5/96avhI9D7bcCM+PMtBGSEoo6fkYz9n7pN+iVQtN9yqMRWB
         t2gJc2NlJ0Tcnsjjupc6g7qIatR52QxiPDLqk+zyslJKPV+N/eKS1OLhUrOawQcuZHFv
         eWxm08Sk2F9ulhVVMpbVXhS4ge6O+PEvREgr7Qmof302Jh0ocq/ye9I74yL7cagphs9p
         44IhjO/udqgVt1vygaciNe7QMSJjAcjkLX1znxvt2AA8tB7JT9fLTekq1dHES70Cbh4J
         4RX1V3T22NcbUJmZqqDW/on3MmpF9tjtgzi66jfLk+u/5mUQZpd4838i1D5TOtOR3rrl
         3WZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708982302; x=1709587102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9bpXPsVA2dblkxjM286LakoqzaJhRDzLGBOQQdyQhQ=;
        b=vkVnG2kX1t7d2ne1O68TGh4GhHGcxrCYQtGvqcXhasrb9B1gT4wM0NojKrC1mDKD5f
         YajfjPSRwb36X3yOoFRsBsP9JPKjNaO5/7KXjqmoFfwNhrcaC8kXeZZWdurVV/rTmTC5
         WfophM5qAZBAL99AvEumhOznNtAMIQSrTbNe291H6oG5EA5r4ubG8bwV+zZNwcdc5veZ
         9I7j3jCZru69hHb6n45edmA5D0CUAq/YJg44dkk5MFbxtYg8ksrpYE+CWD2lJJkdw3Ti
         aWPncZm+Y1lTzFAx0dOHJeFWhlkZhjExSNQ4kGFA63z39WXocvfwskNyT163atz7cgrA
         xpZg==
X-Forwarded-Encrypted: i=1; AJvYcCXPhZc0DDSDq+dcNm6EuInvymQoXlNHkYkF6iTxQVQXE6ZF3XABO53UvwO/3VJEwU31WLWye7KZ/Qg9i5BYcccLZM7GhhXRgtbt
X-Gm-Message-State: AOJu0Yx7zWw2SLiOGqLXTkNJk8rGD0Qm1PzB9HeBwnJQ0VlJcTltnWSz
	JDVkvPDc1e5jmi1rEjEMDzh34ZeRQ4FjYIaCjClWLA1r23eDg1khWBCKYLqJbvA=
X-Google-Smtp-Source: AGHT+IEaS3503yij5SnTzXRX9ma5fz0nrIGs9M8iQXzfkpIF9Fk1rga0qUb/2ASG3WoYZeBci0kbFg==
X-Received: by 2002:a17:903:32c6:b0:1dc:b3bb:480a with SMTP id i6-20020a17090332c600b001dcb3bb480amr1448955plr.49.1708982301931;
        Mon, 26 Feb 2024 13:18:21 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id y11-20020a170902d64b00b001db94bead0asm127599plh.193.2024.02.26.13.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 13:18:21 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1reiMc-00Bv0s-2p;
	Tue, 27 Feb 2024 08:18:18 +1100
Date: Tue, 27 Feb 2024 08:18:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, chandan.babu@oracle.com,
	akpm@linux-foundation.org, mcgrof@kernel.org, ziy@nvidia.com,
	hare@suse.de, djwong@kernel.org, gost.dev@samsung.com,
	linux-mm@kvack.org, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 13/13] xfs: enable block size larger than page size
 support
Message-ID: <Zd0AGgE6nP9BUS5O@dread.disaster.area>
References: <20240226094936.2677493-1-kernel@pankajraghav.com>
 <20240226094936.2677493-14-kernel@pankajraghav.com>
 <ZdyRhpViddO9TKDs@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdyRhpViddO9TKDs@casper.infradead.org>

On Mon, Feb 26, 2024 at 01:26:30PM +0000, Matthew Wilcox wrote:
> On Mon, Feb 26, 2024 at 10:49:36AM +0100, Pankaj Raghav (Samsung) wrote:
> > @@ -1625,16 +1625,10 @@ xfs_fs_fill_super(
> >  		goto out_free_sb;
> >  	}
> >  
> > -	/*
> > -	 * Until this is fixed only page-sized or smaller data blocks work.
> > -	 */
> >  	if (mp->m_sb.sb_blocksize > PAGE_SIZE) {
> >  		xfs_warn(mp,
> > -		"File system with blocksize %d bytes. "
> > -		"Only pagesize (%ld) or less will currently work.",
> > -				mp->m_sb.sb_blocksize, PAGE_SIZE);
> > -		error = -ENOSYS;
> > -		goto out_free_sb;
> > +"EXPERIMENTAL: Filesystem with Large Block Size (%d bytes) enabled.",
> > +			mp->m_sb.sb_blocksize);
> 
> WARN seems a little high for this.  xfs_notice() or xfs_info() would
> seem more appropriate:

Nope, warning level is correct and consistent with what we've used
for these experimental warnings.

	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");

i.e. A message that says "Expect things not to work correctly in
your filesystem" is definitely worth warning level meddaging.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
