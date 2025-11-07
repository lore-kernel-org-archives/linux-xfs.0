Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B202BE658
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 17:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762537133; cv=none; b=qiRe2Cwzs/c109gJ3i36933C2Lv/BkX3LdKRjGa7STmbT2YcoyZgA+0NiCHyU3uCAzf+r1AM8DeL7cqWyd2/wDWXBVN8+jNPVB1ygSWSAJtLzTJqsk+kfSf5y49SrJUEYbJXo2bZZ8+H0EYcxXLy5qUaOWnL5iyBB9Zl6RWntA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762537133; c=relaxed/simple;
	bh=nqPRiF1UVLb08/ED3mgdXEin7kZb8kZvaa1uTBeIoe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSbyFxH/hK3Ww5zqfDeYrfzzMa6tJ40AvMedohPjyKxxMyQyjcB2LoNnoaCBX7vqonB1GPaBHWXwpjnqOyH+hZENPKbwNe9DSpW8LtjWgSm8v65QLNOqeUT4hmEbOi7C4FBdYf4DbECUBl2UgB0slgoD+Rd2lRNvF7wZojW6tVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P6S9xBjt; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P6S9xBjt"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4711b95226dso10137845e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 07 Nov 2025 09:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762537130; x=1763141930; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FkGrb5FIfYGjvwq3xqqJa/an5bkzJawmSPcfz37UvHg=;
        b=P6S9xBjt0OqNL+osLhLSKbSDGjdbPOKKnYgsjhF39nNTlDZLaShaLpB/JXogALcdy5
         6BoVBqihCfZZDT02hsw4Wf+ikYOt2sovLhxcR8ObqewfhIJlVmO2Q0Y9CkfpYx2Waf3J
         lh+cMVJ38zhO+5mwshEyb8dpVBlwmZTE1B0iMtStGOF3hB42Pj8hPWYmbBwBBDBMv3u+
         4gXNKH5cT+X/of53XOsiWS0qFjla+UN/RcWkBTRTeUbJ+42RtmarODm6pn2KRW2w0M3A
         ndjsH+cSryzDlc4i9rMjthAxQSAEnoC304STTNViGbrq6wGcxBEHX3E4JnGDp6N1cpJR
         4HNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762537130; x=1763141930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FkGrb5FIfYGjvwq3xqqJa/an5bkzJawmSPcfz37UvHg=;
        b=YlbzFtLDJq7LkHeIsO/MY4DBTYiJeOdKBEBjYRVaMIlfSIthvZebOuc8NhCzACD1ga
         oqQU5dkQbf0l0WQg/LBLgNfWT4YhmHamwoP2mWoEbEMr/R8u9M7NWNhQ4vW6fnmPe13a
         7+/rpKL+vG36mKOX0l0w2gG4+8k/sILvgAFL/YDmlETC/34+rZwgKshMq3gWj3r7ZiUY
         I5iETugZ1R185j4KKqekOkouoLouWd+9tqdgdiJdy7r9WFXZ/KK+zwa5ysimKIPDNEpC
         f576a0LdVRUP812JD4k36o3GrQthPyIDbtH/m98thmv+VibVZDqzEJa55EK2Je3gjbZW
         Uc3g==
X-Gm-Message-State: AOJu0YyZ4IancXYfI5QgJNykAF31rlVthl5tNjKmYXMV5QXqbZzPPcjT
	P5GPzIo4AITckx6s3KBUE41fbhM8EyGh9Fgq9eKn+JX8EL3sCbhdcyzg
X-Gm-Gg: ASbGnct79bRlSLTvN+9Lc1SvTz6s5NaLeFVT4Kw0nM77AxmOoqmi33BzwJu1izb7nAH
	e+9ynI1U+TfRuCs9Ho2vj1RLHnrkAs28ap37Gv32NyXy2mEyDWUTYAotrzj0pdeXBSaO1eyjB7m
	SHLQ/k8kfJAUrnnebFyncK9Fiurmj/IFPm2aEkZygApH3G5FW0GxE3NVHYEPwOFGeZamqRN7RRg
	1TSV4DCHxxQuyFBo7kYF7KnMBBc9ZeQwVl14mdSlmWRq01YihbTSnAGlKZuZIpAuqJ435Hi1IID
	NK9oekwaf+T4pITtzQRVRNQdkSeFS9oEPQ1n2TYG4Utssl4iK94zApEwr+7Peki8WdCtcerOcjv
	3mVivk15ifLoWTq+dnlVL60BMwO0X8f+pbA/G/jdt2gOz/klNsst46LHoWIdsRjhpeM2Q0dnW4B
	soGe4L+WAAVWgHx4gpBOMDx1BdaN0Td+qPT4Qsa6BlSURK+/kYIxLinc1wswo=
X-Google-Smtp-Source: AGHT+IFcAjngPn3GKJMVqlX5Xw5rpaehjrzKKTy6v194wpLN84n9XvR3Yh+mnOmnddDKNo4Mk9lGQw==
X-Received: by 2002:a05:600c:4ba2:b0:477:4345:7c59 with SMTP id 5b1f17b1804b1-4776bcc9886mr25279955e9.40.1762537129593;
        Fri, 07 Nov 2025 09:38:49 -0800 (PST)
Received: from f13 ([2a01:e11:3:1ff0:dd42:7144:9aa4:2bfc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4776bcfd2e5sm60335755e9.13.2025.11.07.09.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 09:38:49 -0800 (PST)
Date: Fri, 7 Nov 2025 18:38:47 +0100
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev
Subject: Re: [PATCH v1] libxfs: support reproducible filesystems using
 deterministic time/seed
Message-ID: <ozzqqsmphjqdjll56bntpsgfextta7wvv4x7rq7p3vsewaj4za@nigafa5dhfqk>
References: <20251107161242.3659615-1-luca.dimaio1@gmail.com>
 <20251107163741.GJ196391@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107163741.GJ196391@frogsfrogsfrogs>

Thanks Darrick for the review

On Fri, Nov 07, 2025 at 08:37:41AM -0800, Darrick J. Wong wrote:
> > +	if (!read_env) {
> > +		read_env = true;
> > +		source_date_epoch = getenv("SOURCE_DATE_EPOCH");
> > +		if (source_date_epoch && source_date_epoch[0] != '\0') {
> > +			errno = 0;
> > +			epoch = strtoul(source_date_epoch, NULL, 10);
> 
> time64_t is an alias for long long int, I think you want strtoll here.
> 
> Also you ought to provide an endptr so that you can check that strtoll
> consumed the entire $SOURCE_DATE_EPOCH string.  The
> reproducible-builds.org spec you reference above says:
> 
> "The value MUST be an ASCII representation of an integer with no
> fractional component, identical to the output format of date +%s."
> 
> which I interpret to mean that
> 
> # SOURCE_DATE_EPOCH=35hotdogs mkfs.xfs -f /dev/sda ...
> 
> shouldn't be allowed.
>

Alright, makes things easier I guess

> > +			if (errno != 0) {
> > +				epoch = -1;
> > +				return false;
> > +			}
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * This will happen only if we successfully read a valid
> > +	 * SOURCE_DATE_EPOCH and properly initiated the epoch value.
> > +	 */
> > +	if (read_env && epoch >= 0) {
> 
> Why disallow negative timestamps?  Suppose I want all the new files to
> have a timestamp of November 5th, 1955?
>

Wanted to reuse the epoch also as a way to track initialization of the
value, but I guess using another variable unblocks this

> > +		tv->tv_sec = (time_t)epoch;
> 
> time_t can be 32-bit; don't needlessly truncate epoch.
> 

Ack

> Why not return a fixed "random" value?  Wouldn't that be more obviously
> deterministic?
> 
> 	if (getenv("DETERMINISTIC_SEED"))
> 		return 0x53414d45;		/* "SAME" */
> 
> --D
>

I wanted to make sure other stuff that could rely on having different
numbers from random, didn't break, but I guess it makes things even
simpler this way

L.

