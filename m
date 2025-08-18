Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213A01E25F2
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 22:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755554990; cv=none; b=JrvHKSysJ+7AjGECzeRBPSjqU1pC6t5fN0nUFHyqo2lZ8f6CimpAV30x9D9MGWt0z+E/FaMCtboHKcEZnuAffkhcW3QvCm0C+epKmv2M2rnBsNAYaFC+QauEP693WogAjw+mZYpbpQWrN5Jv/hjeSzwqohKY1ku5ol/4b7LB6n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755554990; c=relaxed/simple;
	bh=VCpm8+DbNdAKqoplxuzStfqi72NuoPKYYQb2AYul2rA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1GHLsVQwKTAnaE8K9v9uSp4bBbt2XNutoRy1osKtSAmEl/VdOnW99YdgHKsD2DwBKGUZGKixXn7amnGihtDKG7NfOiUBUBYbeKjpRwfscN6pewk69eokbLSv+Nn5eGIcaojoRDf+wB1mUDkl5knGLbQmWiyiKJmIJSyZJHB56Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=p+bpA59P; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="p+bpA59P"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76e2ea94c7cso4035555b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 15:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1755554988; x=1756159788; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xhzDVz94ESUVdf0BnD/mcFuzRSoyO1q39qZTNBuuV4M=;
        b=p+bpA59P9/uq2BCIdd51Fv2vuczv5LJI52wkHfkhL1pll8QBeGihdAgWFRYBNmx/Ob
         NLAa8vm0yxSbOxmpRvr7fNDE5FqvjSSAontO5jmXylZUyR1iBDgeeL2P96bN41yLiGZ3
         Njhb50sp2VL/0J4hCiGy0DBgH1TvKqvDxMxA0m3jVaGKSn6zMnYsoBXaVZH5i3i2Q05T
         uzd9hAvXDmXbyKS2dEGpXqridzl2RxyhAX2zURPXZSOzypp3oFQFoEiqHcwEstdytEZa
         74X59bTDpvws+VVmIyjDpyPirzYed8xS1OhND2O/RwUMyIBDhaqrYPNHrw/0k45Jncg2
         vQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755554988; x=1756159788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xhzDVz94ESUVdf0BnD/mcFuzRSoyO1q39qZTNBuuV4M=;
        b=d1L40Etszeqxooy1fJ59ntXc2jorAolKKOY2dGMy08J6Mk/t648hGegrchSvRd++Fw
         p8wkiy0zKNOU78LmmKGcon8jS2JO98YE0MAACj6nVgfhEOq7Q6RPire16/mfI8fnJ43+
         sMfaH4MSBYlazIe5D25K6SuGuOPlLYc0bfJScnZdSh9+XBxUphe01ZWEVyjvUEfMkAh1
         xDlaIBeodCeuvznyBBAabPGh/T57nRTJ4feSpPqbHWWp/QkK5z7m4R10gaOOMHqqnhPi
         qwCIbOkU/m+3HAQAz//4+TKQLcpTIFLqSmEDZ9KTMV6MKkJHCgyW+aIihUHWs/Fjq57s
         nZRw==
X-Gm-Message-State: AOJu0YzvT/ZQuY4KlBYgE3tEmXJHtDCTerCLuo8w6lIsKKC06ycSbGam
	WC6clrJ6ouSqU1yZzngoADW4FrE9UxZOencbcWwZpDOd/oc4CZnDxbeA46myVwWeqk6FCWQ/vVI
	U8GEg
X-Gm-Gg: ASbGnctSHZiHRlJaS10NUPD2J10FCcL2IaPkEO6XVmJHPtJvROx1PEshdtgIwwPqXqg
	6PvymGr6ElgccL9cf07bKVLeRxjHYp4YSG8T3uYRCzplxKIyUqLwhfDW1w1FUOfE5Phkh5Eb12t
	Yv09NIU5IbEU/e1oxqhX7beN5nt5031ek4Ic4Cyq6loxhIONETn2H1RTCVDTHqwLjWlBjShAzh0
	vK0QwmFD2e+5AFrxH8Aagn79AMFbqcg5d4IgJxncy9AJK9Q4nC4rgxa2fEDdfGbs9RABeRPiyXZ
	wAE+6h38nRShJPKAcVYz+PV+RpK2dhMjL00ZWiNT3Uopl6YLYxyvSQ0VIkvkFjUAL7m3tPbmNoe
	d9GHug2Sow7WW6WYrMhwjhqFWcs7+037FgiN8XESfSrapQ+kgj1v0yATKJzeZ7ROX0vfh92mihA
	==
X-Google-Smtp-Source: AGHT+IFD33oix4KpVF6ntlTNjPgm9mYkRt0VT14zWelpSIqntVvL52rlrxfJRKzXdEt+UXAGgOR5TA==
X-Received: by 2002:a17:902:db0b:b0:244:6c39:3361 with SMTP id d9443c01a7336-245e04c5173mr2867035ad.44.1755554988325;
        Mon, 18 Aug 2025 15:09:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d5a9b9esm89678875ad.167.2025.08.18.15.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 15:09:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uo82z-000000087nv-0Hrn;
	Tue, 19 Aug 2025 08:09:45 +1000
Date: Tue, 19 Aug 2025 08:09:45 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <aKOkqUL17skszJ4e@dread.disaster.area>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>

On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
> We had a report that a failing scsi disk was oopsing XFS when an xattr
> read encountered a media error. This is because the media error returned
> -ENODATA, which we map in xattr code to -ENOATTR and treat specially.
> 
> In this particular case, it looked like:
> 
> xfs_attr_leaf_get()
> 	error = xfs_attr_leaf_hasname(args, &bp);
> 	// here bp is NULL, error == -ENODATA from disk failure
> 	// but we define ENOATTR as ENODATA, so ...
> 	if (error == -ENOATTR)  {
> 		// whoops, surprise! bp is NULL, OOPS here
> 		xfs_trans_brelse(args->trans, bp);
> 		return error;
> 	} ...
> 
> To avoid whack-a-mole "test for null bp" or "which -ENODATA do we really
> mean in this function?" throughout the xattr code, my first thought is
> that we should simply map -ENODATA in lower level read functions back to
> -EIO, which is unambiguous, even if we lose the nuance of the underlying
> error code. (The block device probably already squawked.) Thoughts?
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f9ef3b2a332a..6ba57ccaa25f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -747,6 +747,9 @@ xfs_buf_read_map(
>  		/* bad CRC means corrupted metadata */
>  		if (error == -EFSBADCRC)
>  			error = -EFSCORRUPTED;
> +		/* ENODATA == ENOATTR which confuses xattr layers */
> +		if (error == -ENODATA)
> +			error = -EIO;

Not sure this is the right place to map this. It is only relevant to
the XFS xattr layer in the kernel, so mapping it for everything
seems like overkill.

I suspect that this error mapping should really be in
xfs_attr3_leaf_read() and xfs_da_read_buf() so it is done for
xattr fork metadata read IO only...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
