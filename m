Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE323CF42
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 11:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705924671; cv=none; b=N1e2DVqdYxMWjJxO+Zeg0RPairlSsJ/vYtbB0ShHAFhiJAqs6lLIRZC5ReElg4hcSOX4OUQNf7uylZIleQKTwD/e4gvWbcuu+R3M+NOAxsnLj3lqy7z19vSc1biTwN9kdCl9K4E6mPzT1Vd9LVrrgAL7QmvXzPI8WSdx/IJhN20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705924671; c=relaxed/simple;
	bh=cK3im9H7Q8AE6SR2ozCMNOW40gVL67VsCO0qJnI2f8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LoyRQh9QiyxnZg2TQSF4FL1mHfaay8XjfTZ8uOoViC5MqnKIgKl5MVJhsADJnSXOydNckE5YmaXPCk4viq/T65GGIcebvd9k9U89D6sAGBDCzfKtIXtWBhshVu+YIRqP8sCo+3vcXfNnJleYExcLnv5P0pkK5AESKdz5iOgWem8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=JJHoVumX; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="JJHoVumX"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6ddee0aa208so2248255a34.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 03:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705924669; x=1706529469; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rBTCIVRECIvcLt6MaQno7tlMWYABkSGiG66d1TLm//8=;
        b=JJHoVumX50yJvQ4sxf7PLoBEBV91v8wzJAtdRp2CmW5pBTxMflUgrglIuE6GwoAKX7
         Fv+PUQVvkG5l/nYxT0vS1o3B18p6nwaYTZCVMEtYFps3ba1bWr5/GGv43b2gSSiFN/8P
         lsME59DS3p7uwrEXn/UIx97cdjuFbURYsIn0JZuzaJhqp5satu2WOeuWpVVNvivRcFhl
         R1F6RFu6vjyP5tdFtm5RfaCcu91wu3/pWtCQHuUt6dTUKhpSVjn1L9c8dFXZdvV4gJ3l
         YCGo5w4fvJqFpmh5oUdinN5ozaHdhNu26hGr5vQpl8bdwSe9M1yU+y6PL76tYruXQtbU
         QmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705924669; x=1706529469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBTCIVRECIvcLt6MaQno7tlMWYABkSGiG66d1TLm//8=;
        b=Klyg/sxb0VIhZzF09xovwMJVL0JQHSldiHmNVpIFTOEc3LrdC2tewQsvNwKArVxxwP
         XIZUUSvl02j8kQE6ocRpE+XfzZsOOMzNAlI+E5/kkq917gndlntBO+PLkDNQ0YB3Jw2I
         mV4UAkXssDQOU3gjJqKCAopp7oK4EFeATUFTs1QEs2h5W/mzkAxrnVUAtBO8aGlsh/Al
         PI1l75NdRv+BAxYSoptTUrld0ylj2vmtzbO6RqwEXYiCeAVFbIlmDmiYUH+WWp1GaX4x
         sjiab0mfD2YRibtOaM0wt0+Ai1bBkSkJpps7N/Y13TkSNpmlosCWrGvKCN5bIO/UfiAY
         Kxbg==
X-Gm-Message-State: AOJu0Yzu66ySyG++ql56yHkwZSRvCPDGurS24BzVQ303850mZcuSFHbm
	wi55Qj0S9VWR+gyPlKdKR8M04X/RqOzOFfM+Y4eeNSMfJQCQf/PDKlOKcDspTKuilWxrbEaeX4y
	F
X-Google-Smtp-Source: AGHT+IG1mTJ4MmTpOsgs4i6bFvFqiyjvVZWwtCZ27AojSnabkbNWPld4qMXAwbH3QYm6tNCqfYSYeA==
X-Received: by 2002:a05:6359:2102:b0:175:b707:c92a with SMTP id lp2-20020a056359210200b00175b707c92amr2484028rwb.33.1705924667818;
        Mon, 22 Jan 2024 03:57:47 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a00140200b006db0c82959asm9423428pfu.43.2024.01.22.03.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 03:57:47 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rRsvw-00DlCx-1R;
	Mon, 22 Jan 2024 22:57:44 +1100
Date: Mon, 22 Jan 2024 22:57:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] xfs: convert buffer cache to use high order folios
Message-ID: <Za5YOCbA2rJTjdqp@dread.disaster.area>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-4-david@fromorbit.com>
 <Za4PI5h2BQ8DoPrN@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za4PI5h2BQ8DoPrN@infradead.org>

On Sun, Jan 21, 2024 at 10:45:55PM -0800, Christoph Hellwig wrote:
> > +	int		length = BBTOB(bp->b_length);
> > +	int		order;
> > +
> > +	order = ilog2(length);
> > +	if ((1 << order) < length)
> > +		order = ilog2(length - 1) + 1;
> > +
> > +	if (order <= PAGE_SHIFT)
> > +		order = 0;
> > +	else
> > +		order -= PAGE_SHIFT;
> 
> Shouldn't this simply use get_order()?

Huh. Yes, it should.

I went looking for a helper and didn't find one in the mm or folio
code. Now you point it out, I find that it is in it's own asm header
(include/asm-generic/getorder.h) so it's no wonder I didn't find
it.

Why is it in include/asm-generic? There's nothing asm related
to that function or it's implementation....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
