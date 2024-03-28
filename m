Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851451DA5B
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599653; cv=none; b=XrnEY0SbSj9FMKzFv60RlyKWhuKwKwCxDPiFc3fUwf+fB/hrXnOz4y5ACAfvLSEJVdvp8/glO4gB8YTdS2JdD9kI45cohp966wWUa8kq98HAJK6V6LmVdIm/U8ZDa2d5dghxo/XVl9A0INKdpdyTElm2rfhDM5lc1h10hInFcFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599653; c=relaxed/simple;
	bh=t8iDSmzyQzM8GC1Jh+pRGjpRmm5Drzm1ICFOCJE5mq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJiNkhp87IIEyCaUWWaDsVQq7LB6dwaHaQI/XIUvohx7yoCMLTb9r/7/8vnBLJQGGDmihFQhHkqRynXPVAiVGc1tZxJXe8wKNaZoOGRFuaKL1RqchCYbXOwjAwkBmgqM9pUoayBUKl6AoJkWjD4LWDwr4pGQ+xxup6Tx3jeVrDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=12twGuHL; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="12twGuHL"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5d8b887bb0cso353538a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711599652; x=1712204452; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eK7J94cltmIRT7E5tC7EK0NpRGYB1jweE4vynZDgyzM=;
        b=12twGuHLgWFqVVKzmgJ7YVywjjZ7103KVQboCJdFW6kS2pne+RVvVuRIcWq0OgkrOV
         MO9s1IBxYlr5H5MrL+Q7RGnPRXOkyXXxdQWq/r4cR7tQEHKCvKTwSPd2saoQY4MmIgr3
         vFbSh2Txj30bmLDLAsO6XiLDtkLrs+aibQW8fAKXaK9ovD28aERyG6nujZ/3KAo3T6RQ
         9ABBfcJcKoku3H09u3WflgFcPVyVXiYttdzFp/0QIRWQ83Y6Z2ATs0GAgrv2mq3ZDUqZ
         i7/ihCGZtDxBMvGjDa4CExy9HoUrJnKtJArpjTS2lIJdbvwdNcaQveRTmeDeNFnkrO/T
         VEsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711599652; x=1712204452;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eK7J94cltmIRT7E5tC7EK0NpRGYB1jweE4vynZDgyzM=;
        b=WLh8Zc3UgdRTkKs1dYebXuE3t1ErjYginyICrsn7PYukFf5NM2N95wCP/F8ABTkGio
         0peqFtRTL1meboIFC2ohbwYeQ89J7YChgJLfwyvtIouVQkr8pD4bQwGLQHpQ/Xtvr7yT
         CvyCHnqMh2euwAVt7k6m0AKIDfuwEVbmOVdRugS2MpgmamuIGZJbHYmpRYI/U/KcWjUM
         xLMy7Qz8r4XIq0/bJAMS8AwSTfAvaQBSpNkEJ4K5GNuYwHGkdEb1TEQPnjVzO1U8VPVw
         1FGX49imU1vZVLaZtlQJe2teL0XyKYGfwTvrO96x/Zhl4IsTpJKYfqU9xfCNEi4ENw3M
         YWeg==
X-Forwarded-Encrypted: i=1; AJvYcCVxE4QyNasuCyzAWjOdXfoUvTsYxWdUrEx1Ftx4edW3W3lpbbxAfQlbYOE2bEHdPlih5VM41j1V0eFNy+sZpI77JjqyDKqMfeUe
X-Gm-Message-State: AOJu0Yyeyfulfn7NwuNtt0qHFmIw1LQHY3+q2Zuzsbd5pm8Ick+dtq+K
	p/V1ZH00fv6u2mPcO9133Xd29W0dzTN6MiQejNDn/wIXgyeYexhzI8XpxtAmzbg=
X-Google-Smtp-Source: AGHT+IGc89cEbeerjwfhXYj6tBomIUfDYF8fsQT2H+PoR7fdKiw6fGEQzwfZKELPK8emW1O14Yh3Dg==
X-Received: by 2002:a05:6a20:7495:b0:1a3:4469:5967 with SMTP id p21-20020a056a20749500b001a344695967mr2502258pzd.57.1711599651788;
        Wed, 27 Mar 2024 21:20:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090341cc00b001dd6f1516a0sm391865ple.87.2024.03.27.21.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:20:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphFx-00CgLl-0r;
	Thu, 28 Mar 2024 15:20:49 +1100
Date: Thu, 28 Mar 2024 15:20:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] xfs: reinstate RT support in
 xfs_bmapi_reserve_delalloc
Message-ID: <ZgTwIfvmtCvzhezl@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-8-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:12PM +0100, Christoph Hellwig wrote:
> Allocate data blocks for RT inodes using xfs_dec_frextents.  While at
> it optimize the data device case by doing only a single xfs_dec_fdblocks
> call for the extent itself and the indirect blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Simple enough.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
