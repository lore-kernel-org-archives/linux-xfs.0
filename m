Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDE915AC4
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 04:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709700047; cv=none; b=AkMTRfA6b1hnvbWe7zF1rAgm9FWwSGoZDqSm3ob8MwcZXDcBNx/Dz8wTd7HMbCLTPD1NH7vhxvSxgclxUqslCgw0Z2IWZlDSefA9PqHMXwvGxbd2Yb0Wb6a6fbOxGj0i5r3Aui4aonyIDXoxEt8aYYd3m9RWMv5VKZnXoaKykT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709700047; c=relaxed/simple;
	bh=PtNdxv6rI9Ner1GG9UTGt5i75eVpnfAgzMJ1toFiiuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vyk7BoPAu2U7TKuWmMZBsr1SbxbrHlBAjNAmC2ZmVCWlCgSy1FiVvejna1s5bgAgE5tzzlxEKWx+qtQQkWGjBWhGHjBIn+fWkiTvsRGBbKVwygO2QKt6i0UuSiG5xZ5ffWxEfbac5ZHfNa5KjPQTRDzaGTjInHavyoKTG/05g7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kQ2swAUD; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kQ2swAUD"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e56787e691so346766b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 Mar 2024 20:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709700044; x=1710304844; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kihfEKq1k0EEEoP/lcOIqtO+9Ee5yo6KBZd0Ch7Wxys=;
        b=kQ2swAUDY8ZJJEPQF9j2FjxN85s/Pi/19Wn717pUooini8Xz7ewPSjv2h5VHrzoRMM
         XAhqJUAZtlltMyS+xn4T5FZbcVYN2zZaFc6ckAXmtzwwr/xigJG4+aqu6TVBvN9RWAeV
         Raa4SYrHUKil/V4WQKJbgAKaXJraOZ1pF8kToWGoQo/y9AUkiSdD3HB0XrokCCIkREUl
         4/ksO399r7n5iZfByvK3LkQkEW7F0USfamuFwcUUvVp5gUd4sLdSxtipiXRd19ELZ9CL
         0XXdQ6zPhh0ZZd3AsDHDbUNIXKHMX4egrKVOI+AyRbfuNuQFATJJpRM8F4CNx0P+bGI3
         0xyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709700045; x=1710304845;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kihfEKq1k0EEEoP/lcOIqtO+9Ee5yo6KBZd0Ch7Wxys=;
        b=BRheqy90BFR0AmBJclx1IX0a8SQ0pftv+h0uhDLzIxEiN75sNijPaEvYi14z/27K4X
         PjEpe1BoKiCzOJW5ZdAZpgR64fZDdfVSf1zVVUXzajjAP0eTxfvQvLr9w4ndN6C1dzNf
         MdP2mkv1M4b/Q/QDGLZbW+UyMyvujAWK78OIZQ1En+kvZGLRYCCpFFsP2+gL6c4s6eIG
         agbqHkH6u/hRT47XfnlLj/MzBfORZ4rWB7/dMDn1oV5z8mEsV3fW18SDIL0VLwJnF35U
         hrO2c8scjOcMvdndkQjIkL7tKieHaKHfqUDggb1HQ7FgSVR/cqbILm5gxWOBrdJO+ogv
         +Xtg==
X-Gm-Message-State: AOJu0Yw3mFHS9NTOJ//JtFSHZ727tPXcWKd6mNxTi1IkE7yu4eCS2ifb
	eDm9Hzszd7YNhIyvyHJKqmwcd969vVQhe4l144/UpYxcp/H+4PTbuxtoWABRRAI=
X-Google-Smtp-Source: AGHT+IEXOp8wBFezTXhUuS8twpUqHWXwXoza6FsPySVwW7Qqxh7nt8hpWgXEg5KoRNb842WHqQIcXQ==
X-Received: by 2002:a05:6a20:9150:b0:1a1:4aea:c665 with SMTP id x16-20020a056a20915000b001a14aeac665mr5244536pzc.19.1709700044458;
        Tue, 05 Mar 2024 20:40:44 -0800 (PST)
Received: from dread.disaster.area (pa49-181-192-230.pa.nsw.optusnet.com.au. [49.181.192.230])
        by smtp.gmail.com with ESMTPSA id r28-20020aa79edc000000b006e64f75c947sm129043pfq.46.2024.03.05.20.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 20:40:43 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rhj56-00Feho-1H;
	Wed, 06 Mar 2024 15:40:40 +1100
Date: Wed, 6 Mar 2024 15:40:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH] xfs: shrink failure needs to hold AGI buffer
Message-ID: <ZefzyCsQ935fAWTR@dread.disaster.area>
References: <20240306011246.1631906-1-david@fromorbit.com>
 <20240306103314.A780.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240306103314.A780.409509F4@e16-tech.com>

On Wed, Mar 06, 2024 at 10:33:16AM +0800, Wang Yugui wrote:
> Hi,
> 
> 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Chandan reported a AGI/AGF lock order hang on xfs/168 during recent
> > testing. The cause of the problem was the task running xfs_growfs
> > to shrink the filesystem. A failure occurred trying to remove the
> > free space from the btrees that the shrink would make disappear,
> > and that meant it ran the error handling for a partial failure.
> > 
> > This error path involves restoring the per-ag block reservations,
> > and that requires calculating the amount of space needed to be
> > reserved for the free inode btree. The growfs operation hung here:
> > 
> > [18679.536829]  down+0x71/0xa0
> > [18679.537657]  xfs_buf_lock+0xa4/0x290 [xfs]
> > [18679.538731]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
> > [18679.539920]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
> > [18679.542628]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
> > [18679.547076]  xfs_buf_read_map+0xbb/0x900 [xfs]
> > [18679.562616]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
> > [18679.569778]  xfs_read_agi+0x1cd/0x500 [xfs]
> > [18679.573126]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
> > [18679.578708]  xfs_finobt_calc_reserves+0xe7/0x4d0 [xfs]
> > [18679.582480]  xfs_ag_resv_init+0x2c5/0x490 [xfs]
> > [18679.586023]  xfs_ag_shrink_space+0x736/0xd30 [xfs]
> > [18679.590730]  xfs_growfs_data_private.isra.0+0x55e/0x990 [xfs]
> > [18679.599764]  xfs_growfs_data+0x2f1/0x410 [xfs]
> > [18679.602212]  xfs_file_ioctl+0xd1e/0x1370 [xfs]
> > 
> > trying to get the AGI lock. The AGI lock was held by a fstress task
> > trying to do an inode allocation, and it was waiting on the AGF
> > lock to allocate a new inode chunk on disk. Hence deadlock.
> > 
> > The fix for this is for the growfs code to hold the AGI over the
> > transaction roll it does in the error path. It already holds the AGF
> > locked across this, and that is what causes the lock order inversion
> > in the xfs_ag_resv_init() call.
> > 
> > Reported-by: Chandan Babu R <chandanbabu@kernel.org>
> > Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index d728709054b2..dc1873f76bff 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -975,14 +975,23 @@ xfs_ag_shrink_space(
> >  
> >  	if (error) {
> >  		/*
> > -		 * if extent allocation fails, need to roll the transaction to
> > +		 * If extent allocation fails, need to roll the transaction to
> >  		 * ensure that the AGFL fixup has been committed anyway.
> > +		 *
> > +		 * We need to hold the AGF across the roll to ensure nothing can
> > +		 * access the AG for allocation until the shrink is fully
> > +		 * cleaned up. And due to the resetting of the AG block
> > +		 * reservation space needing to lock the AGI, we also have to
> > +		 * hold that so we don't get AGI/AGF lock order inversions in
> > +		 * the error handling path.
> >  		 */
> >  		xfs_trans_bhold(*tpp, agfbp);
> > +		xfs_trans_bhold(*tpp, agibp);
> >  		err2 = xfs_trans_roll(tpp);
> >  		if (err2)
> >  			return err2;
> >  		xfs_trans_bjoin(*tpp, agfbp);
> > +		xfs_trans_bjoin(*tpp, agibp);
> >  		goto resv_init_out;
> 
> Should ‘xfs_trans_bjoin(*tpp, agibp)’ be done
> before ‘xfs_trans_bjoin(*tpp, agfbp)’?

It doesn't matter.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
