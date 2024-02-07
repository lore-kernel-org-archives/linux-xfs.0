Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC1FFBF7
	for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2024 00:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707264851; cv=none; b=jWmYN9+0l5Qhm3xU0lM0Aa3EdUzpqOVscAghKeC0Xkj3yLPRisw0csiEOY7MQ5KXq1krrn+gADpV8ssUDxYs3Nda7Vzmq/GpP70NpaNEkjdp4jg8/tKcR7bI5ZMt1y6FFNeOPXlEZfL7mgyjKZPhYdwk7/eE07AO4nv3BEfncLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707264851; c=relaxed/simple;
	bh=b3oIpEkPYH52IsYLfbDfFRlJtmnFfxvSr5LMf7uVMyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAt2hyuZLFP5mx9tRok1ERbSQf9vR9qG8HbHRw9kZF4nnPwOcbfjfbP10I1hJXu0wnrjw6uemi3C7eHVF6Mqdl9xw4V1MSv9r1Bz8cDzLFSk7YfpuvYvLhVpfdVD98OsPeaLQHFk9kc+vl0ZhPBBduJ+VZay6Yu7qLeWzjy83RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Ft4nvT0i; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Ft4nvT0i"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d93b525959so9387975ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 Feb 2024 16:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707264849; x=1707869649; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hWFmatm9pQBmAOoOa6150RCvrr0WZ3tzlZNSaRzua84=;
        b=Ft4nvT0i8EzE0g7BOXvgZlylmIlQ6gmftbUY/PZtzn4VUSTGiapyfxqgRDIylnP9iH
         x5I6shI2x0LaWVhxz6U3ItmmpXXYrPLC3e/jaS6p8pFTg53VBbainnYWR9STLIOA+wHT
         sxu5YiPJxVqkryAPcyXebAuittClx5lh0r8Z3AADJfjsHoIEogRpTozhACgmetWWN3R6
         fBmC6W644JfQoD6LSx/48gVZ1sQafp0zgyoQ7cT3UH01LTfH8Wa2otoE6fcYFbPOeYTi
         cWj+HlUkb6nG15zltUkg+rf8D1O3nC1vZOc/8OBzWgW7+1beXm/0TZkZZReBSUUsGIhB
         qsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707264849; x=1707869649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hWFmatm9pQBmAOoOa6150RCvrr0WZ3tzlZNSaRzua84=;
        b=hHubC7bSPK4BoymoMgETGs1F3kyyhgphzL/gSDdhNLd+eIPXmJsVzl31NokpjAVbWz
         lt2sBvUvddW2Nc8Ex9gZTCLKRA8ynw+0o1ZHWGL8EUp/34vIfioMAz2U4qvAY58L7Uiy
         c7Zoh2JWduE72TOUTUa4xSEDwuSfKyBmg0CFlfbRoJbfhWvL/dosJ67GmcCP4nGd9hcs
         bVeZZIGtGhh72KM/OBu3cxbR/B5yjqxk+MqNUdTdLiA/YoA3AtSFBALfA3LBeOk1W9Lp
         5rzpItAMrC2hSjeRnLI9Q5eGHOFJuqgjaBOZbFwIPdcTQwQ2/ZyEq0tf3bEsj/OGS5hb
         LixQ==
X-Gm-Message-State: AOJu0YxAI2P5pg13ncXMUsBqPwuZZTXALPNEAaXFVjtTH8pZOOwx8hLI
	kmn/JZ9GwrJHpOpR1LiCSFK9B8QoomN0pMW51ozSlMn2VZ2dbfNbkfNfXyvlYvT9w2qet/EIIJm
	h
X-Google-Smtp-Source: AGHT+IFi3RsHn3ED7Wu13cvcYawew7pL7LDvSaR3v/RObW7/tbWjsJnXtKa4gxYuvohoiREHF6InJQ==
X-Received: by 2002:a17:903:18b:b0:1d5:8cbc:863c with SMTP id z11-20020a170903018b00b001d58cbc863cmr3867812plg.27.1707264848892;
        Tue, 06 Feb 2024 16:14:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU2oY8GJc8IME1U4/DcFAqFaFNgE3yxKVeKF+zj4gciBrgptZbRxz8D5AnLax3ggwGXZl97ZutnKYDW18VSYjOCdUD7MaYiOLAu
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090ade8e00b00296b50bb21asm2341627pjv.27.2024.02.06.16.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 16:14:08 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rXVZl-0032vO-0h;
	Wed, 07 Feb 2024 11:14:05 +1100
Date: Wed, 7 Feb 2024 11:14:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_clear_incompat_log_features considered harmful?
Message-ID: <ZcLLTb7hZqqzdEuF@dread.disaster.area>
References: <20240131230043.GA6180@frogsfrogsfrogs>
 <ZcA1Q5gvboA/uFCC@dread.disaster.area>
 <20240206053011.GB6226@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240206053011.GB6226@frogsfrogsfrogs>

On Mon, Feb 05, 2024 at 09:30:11PM -0800, Darrick J. Wong wrote:
> 
> So, if I'm reading you both correctly, I'll:
> 
> 1. change the log incompat handling code to clear them on umount only;
> 2. add a mount option to allow admins to permit setting of log incompat
>    flags;

I'd maybe turn this aroudn the other way - mount option to disallow
it, because I think the number of use cases where we don't want
flags to be set are much smaller than the number of use cases where
it either doesn't matter or using the new features is desired.

> 3. leave the xfs_{swapext,attri}_can_use_without_log_assistance
>    functions as they are in djwong-wtf so that new incompat filesystem
>    features will eliminate the need for setting/clearing the log
>    incompat flags
> 
> Did I get that right?

Sounds mostly fine to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
