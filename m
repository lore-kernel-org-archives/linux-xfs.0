Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791CB148FED
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 10:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720519270; cv=none; b=AoQKXsNHDBk0Gtjexx6evxg+L5btLW+jRZ0c9m/u2GEeDSfy1xcdv6NSmkk8I+KkvLcUJFHcc7/HCFvJ91O14Q1wszoIYqqLRp5WByhMEdjc8jkkCHAzx1ZxaBbQAWke/X1T3gnjE7TWxlPYXI+TwNakif4i04nEBGB/GaMchsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720519270; c=relaxed/simple;
	bh=9ueNuiutMQdYjBBVy8y/1iLagBTJT4VLnrJ3yrSnyh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHvBtEz2a7SZrPhAYMU62fZOibU1vSCvCdcGQjLxQ3Lw7zakK92ckbEjjGrk4aZFsB8FKp8MsQe3ghIBnCDD3pO3Mv3bppYWKcsveHCNdLfrmsAj/EgdsWQQJHiH6GiMNfu+kenTrgmRyjn/FxgsMgy6tlcRLuS/iZvg1hajXP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=FOp4W4pN; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FOp4W4pN"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-70364e06dc6so971855a34.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 03:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720519267; x=1721124067; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t6GqL4s/zuXrjlFTwp5KKRhkQcfRKfIo4KZZ76Fh4W0=;
        b=FOp4W4pNCbku8D4/48FIbhZxyuOaWcLTx8jsX73lkzQu7RZQYCPNVLPSOozHNG+erx
         xoWuvh9LtyTvnHFm0RHMibAOUAlSfqOa1oqk2wwyZ5uSX4CQNJdskWi42NG8wQGgXKM1
         WtPByeCmdq3hnzztU286o/QI7UJU0uOP4kAn5FVqkIvvw+iEq7YtFvSUY6z346BppSAX
         vzFbjf3kPyQ7AI7jemlKa40lUfJ+QDB5NfUTEmcvUEqdVPyhKxrrW0dcwm5JrfLdGEwZ
         TjY+aGb1cShwgSEeqUK2ZMzIo8VW5JczDeAlm1Ajwej70CTxp3ac7Gl/c+izhOjqNZbl
         J0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720519267; x=1721124067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t6GqL4s/zuXrjlFTwp5KKRhkQcfRKfIo4KZZ76Fh4W0=;
        b=UgtYq29RypYptZCV9diYBZhWV8TiLRMcJhOEhE6Q0pHgNZ3UFN2z1nk2p16+dCrg1H
         1xX//12DVrWyQhbtAW4UxC/EkJ2/AII3P5o0iKaHept/rXlPikiH1S74PNpt3OrAe8QB
         TkcL+pusWF/kLRsws8R1zGdvGtLwa5WLeyO8rT0TSz7g8GTqo51nXfLXj4eRoe4r1Kgr
         88SfEe9Nweb7T/aoUh5X/juwW/NYFnOpqgEvi0n0TnPSARfT7HYYGtCnC5XVie7d8q1W
         1jaIpiA+SgO4reBrlbrqOqBGaDb9JdkmC8kmEhiRqzVi3KsQumhFuwoQNmcWkR6adknk
         ZCpg==
X-Forwarded-Encrypted: i=1; AJvYcCXkz7d6GWhdCrF6RvcKTDI89TZ/velpKABnve1BF6PFOXLD+lW4vpxzFPxqY7OT7ND32h9iAmRi89FRhZBeF4Ug8M4aG+9Oaxo/
X-Gm-Message-State: AOJu0Yx5gQv8+52wuuMQs2P4Mf+nNnx/YWEmUfQ+Zf1xt57YkBMd/zKS
	3KTe+HU9ynQioEHTl0jPtstQMl9oHRoUHho2xUTElfEfjyMp/sQ7OI9sj63ZS1yBxBeALqasRNy
	U
X-Google-Smtp-Source: AGHT+IERY7UIVBrMpT7+BBj6ED5PP+BktYSZv+kPxdgPSWPDwoYLpTkI5YLbdH8OsoiJfGDfZanlJw==
X-Received: by 2002:a05:6870:9727:b0:24c:b654:c17a with SMTP id 586e51a60fabf-25eaec07747mr1516360fac.45.1720519267437;
        Tue, 09 Jul 2024 03:01:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b4389c175sm1440814b3a.12.2024.07.09.03.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 03:01:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sR7ei-009ZO2-1I;
	Tue, 09 Jul 2024 20:01:04 +1000
Date: Tue, 9 Jul 2024 20:01:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: convert comma to semicolon
Message-ID: <Zo0KYMJkWYirUx1R@dread.disaster.area>
References: <20240709073632.1152995-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709073632.1152995-1-nichen@iscas.ac.cn>

On Tue, Jul 09, 2024 at 03:36:32PM +0800, Chen Ni wrote:
> Replace a comma between expression statements by a semicolon.

Fixes: 8f4b980ee67f ("xfs: pass the attr value to put_listent when possible")

> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>  fs/xfs/xfs_attr_list.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 5c947e5ce8b8..7db386304875 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -139,7 +139,7 @@ xfs_attr_shortform_list(
>  		sbp->name = sfe->nameval;
>  		sbp->namelen = sfe->namelen;
>  		/* These are bytes, and both on-disk, don't endian-flip */
> -		sbp->value = &sfe->nameval[sfe->namelen],
> +		sbp->value = &sfe->nameval[sfe->namelen];
>  		sbp->valuelen = sfe->valuelen;
>  		sbp->flags = sfe->flags;
>  		sbp->hash = xfs_attr_hashval(dp->i_mount, sfe->flags,

Looks good,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
