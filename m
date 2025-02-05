Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251F1227BA0
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738717041; cv=none; b=AC65+A1dfSL1k03+FkvhSt8I3PHNxgY94lBrgaRGK9yKn2Fxrp+gfJ3eic5PFD67TOk30oGbpa4foKwZFOPVxmPAau630eSSzZHBr1NgMxyp36yM421MTwq2tEMBWWqpBNbj5JE5lGhqShUEw7Q9ge4HxmygCYs++ZXLRTf+Wys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738717041; c=relaxed/simple;
	bh=pK2SfrDXA+pVJW5BC2Z2h3CQmVTjHBLkFyVXGCPjZVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oe6nBQLjaCeC24lBP9M+TtknMOMHgYrXAVcUIlFT0lmNDszQmnxe+sQiYSp2iI5BA81xq7eoefNVVrClwHkEpRyHmBvv91s4FfbtjgeyFN2I1N9Jm0993qEEXtdlSwwyxfXi2ghtV5nDV8h2QDOKzQABoA+vyNMoKmjViONHzlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=a8bHckEs; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="a8bHckEs"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-218c8aca5f1so30706755ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738717039; x=1739321839; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1w8lmxUPYtdWnrxnuxXfgzNSFjebM3Vw2eHCPiCkPjo=;
        b=a8bHckEsiQfctJUXL30r4FMP8wK7CRav4/yRBKUraPLY5BhQEOVVxn224VRH6AT3vB
         8VuU7ghVGeQNYgnYPhWQnhD4ykb+sMfwDrM4B0RLTCvgbLLEBDSQT8ImvuBdKR9BtJcs
         rB4kNdXSYYHqq8ch5cPNAjvXZjwytqjg4NhY8189hgob+BP4BwCCtUWXknPjBHFO+dLu
         QUwNAFYL7ymRnmgui4PbOhTdw1DM8MeC00nJLSecqO1tNYXYxZGT/Ofs0KaCjFHgO7au
         Q1b0Zpvu3SnaEAYu4ktuc91slGOeJTzuxdfzZfJ0sbgYcXK8vpEIcXGfhy72XAv8q9el
         rn2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738717039; x=1739321839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1w8lmxUPYtdWnrxnuxXfgzNSFjebM3Vw2eHCPiCkPjo=;
        b=G5b0NSxrr6GmLUme67IRUXycKraK/vwP/bEElqHXXv0Ov+BDbfk2i+6Yq2vwQNY51e
         MFzBRvNuHMvQiDI5B/tnHJkvIh1kjv0NBP45Pz/9C43ARHwBlESPU+cfg1Vf3VMb6AmV
         JQuTJN5WvOG2/BtGAY/LN8heEzfp2x+NIjSilbOT4bsA8T+MOf2A06a7zwPjGIZ4DuwH
         gk1sKueh6yWylVEILkb3HSRB0dvwN7ZbEi3NfFzJedVayc8GNzFoz68G3NNqqkr9sccg
         gXV3QztczxK2m6X9v30ZVO7P0FKIi1WFGq09eIfnfJvQYUyTupOnydDRTph9BaKaUqHs
         oniQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYHQqxxokb9hgX7Q0kHsZUJuZk4HrYgTQgyN1q83lezzglDJGvrCpW5JfqaiZQCu/1Ih9bUZRSm9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO8dO5zYy3EVz4uewZE3Aj3csa+vMgj9mUp0aN/74amSKncdmH
	pjNtgPdnC7CM1vN51sCKXxSJfBd9+XImFd8n9SmcUHglb5MMgiZHboGC0RATtM8=
X-Gm-Gg: ASbGncvPABsgQ4uOXN9zItFQ0aKOc6KZ4cUjaSyXdS9soHCVu3wjTKiOySYiows7FSU
	LIaQ+JecaMdMeeRFo2HYyUpdtjDjl9gnhrWVkitOO1MuOCQJE3SoELvDx/AX16m/YHSkmynsW+X
	rnmeKtIzMBC8x15KMvf1GbOFKqq4BAtObtYPPUpsIv0bUY4TYt7NQMYtQ7jAFL68v14U9QZYy/+
	9F7XN9YCz6HpvFb0a45TG8bIz8Lk7S7dSw0B1qQRIYRqZ8bwQrIXh920NcoE+ZXdLfir5No8mRj
	UZJ3AX12vyMgYaX0wOB16D3ZzrtelZeY5DCfCCfZL8hhf0eegMbt/0Zj
X-Google-Smtp-Source: AGHT+IHwMPrH5qZua3AQzJuIXwhDMnvS8Ki/27xK9oskS+vcoHhCyWfc8JEAL2b2q2oLIbNTGjSkuw==
X-Received: by 2002:a05:6a20:d705:b0:1ea:ddd1:2fb6 with SMTP id adf61e73a8af0-1ede88ab39emr1548573637.30.1738717039415;
        Tue, 04 Feb 2025 16:57:19 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ad4fdb4bb86sm1985949a12.43.2025.02.04.16.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:57:18 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTjA-0000000Ejj7-0Ism;
	Wed, 05 Feb 2025 11:57:16 +1100
Date: Wed, 5 Feb 2025 11:57:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/34] fsx: fix leaked log file pointer
Message-ID: <Z6K3bAOEcyRHgAWA@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406564.546134.12817088521328536453.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406564.546134.12817088521328536453.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:30:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix a resource leaks in fsx, where we fail to close the fsx logfile,
> because the C library could have some buffered contents that aren't
> flushed when the program terminates.  glibc seems to do this for us, but
> I wouldn't be so sure about the others.
> 
> Fixes: 3f742550dfed84 ("fsx: add support for recording operations to a file")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  ltp/fsx.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index d1b0f245582b31..163b9453b5418b 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -3489,6 +3489,7 @@ main(int argc, char **argv)
>  	if (recordops)
>  		logdump();
>  
> +	fclose(fsxlogf);
>  	exit(0);
>  	return 0;
>  }

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
