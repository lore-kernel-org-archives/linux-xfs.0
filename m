Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953FC246BC5
	for <linux-xfs@vger.kernel.org>; Thu, 11 Dec 2025 21:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765487570; cv=none; b=igdH/MVJYXhlzhpNXqogs4L6IATi3yyn6TDFEwIEliOrQKUXxB7dy2EP4Rwk+n85vx2dNj8W3J6e2t58qR0y5ah3ThvIzZk9mGAFTwScXZHkyktZIA0Ww+tf7YSDVs+BxPeak5Aglc/vIlttoZBb1rQnGgMhdVFYqoWLakFt+XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765487570; c=relaxed/simple;
	bh=2StT5fey7xO/gGkRoOza1EpEfTzayi0kGne6NOjJklE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJXNDft3AUo/O31UqwsQwO0UGuFRC8cdTqnjj1zf42gS0HfY6QTSxD70DXnAx6L65K+Datd/nFBSICSCmkS1OIUphjz0R9L1UKmtbo+xvpP8LNRaDmX61EHyeQ+evg9sTSrSf9M/bq0+/MS2O7OYD6DwRBSJ3vcH/KAAjlvODCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=PEswLXfr; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="PEswLXfr"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7c7613db390so317141a34.2
        for <linux-xfs@vger.kernel.org>; Thu, 11 Dec 2025 13:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1765487568; x=1766092368; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3XheekkRDFybc7x85IgNduTzuOzvtB/yxFRw2uL5q9I=;
        b=PEswLXfrSpSYFs+imbUCO7CZiwM8N13f6CVVXN7NKXyA37AYWVaUPlg5ZDF/hEmTbl
         5bs/kv4TBHUovzZAhevOfmzUo3e3GWBnN1pqyN9wVtcX7WkW1+cKvw6GdpZMZecIwu84
         KsihdwxIjQu1Fl165OMI9z/HaN3ZvECHHe7J0BjdS6CPHubrZ/Id6gg+JLpgI3kNekWx
         4lC3EOYpLGz6vlxWsSlrXYe9PwUip7NLm35cUO/9oL2G0IJJKp42z13Vh2cSGfEW4eWs
         Za+er2+TDji0GuMFx5dFJv6uhplRBO8cvAgqYW3mGwq9EUh+4XdwjGjGIsNxPUF2u7wC
         5heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765487568; x=1766092368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3XheekkRDFybc7x85IgNduTzuOzvtB/yxFRw2uL5q9I=;
        b=BT6B2P6wHyVRtgMlD5z0I9J5WDWLdrRs6vJ8YYmllCNFCIAfVR7oKaKVOJHk1RD5c2
         Yz0rVC0hTKjVOuz2iuiQfmB0fRlQu/ajzLXdPRhfi3zouX/pxUvtipG9Shk0R0ZLEp5c
         vE1LbNrEzVZ9iAOsrjTcEBKiGJtcHvTZSvHJAZz+jNRMqOGMw8XSx78ayN6FKvOvMs/3
         mdRu9jnAhHBG+3DMo6ZoqHcUGk8peZ+hQuyUDu5VNgZ1MT6KC0KhgTqV2UEw9ykQDpRD
         tSzVzt354q486+jVEjoga2xDvyTjs7PHX6klvRRYzQ8NQaI+7gnxmbMqUUMewGG0umBH
         X7Nw==
X-Forwarded-Encrypted: i=1; AJvYcCUnjEs8XZXI88mA0Ca6F33RVsSJbTD9dN2K08/Ulm9lBX5IAZGO/NjQHji7N/QtRe/XR7C9TB7jdO8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9ZiHiN/HiVNMgwZSQag76PiPyxb+8zzt5XdEp1hKJBG9/tijI
	D4jt3D0yX4aR+AzCbA0/bbBLj3PUfO2Un8oafapUNezV2SKy4GMH42njkjhZjI3YRp4=
X-Gm-Gg: AY/fxX5DEDa1kD62DnEJh5aDidRfj0L2JWj0oI+Mcr/bL76b+Oz9V8jQqariac6V6g9
	ups7bIVxET8mczFj7UlIAnCP4/tTh3256V4gY0xhDIR10aYC4nM7AiJJznERUXbdGOiIt0B3RJi
	dJEwuwZ4Cz3yzuSvDIaH8fB8l4lIstUlA4oh80H5GoU+YiAAvnUxSkKUyo5DeiKnXXfG/LaT9Gv
	0rKJQo3oiY80cNn9LKOO1ytqWZdC1wY3/2nnUwI2plyQcBZSi3TtOnwoMiEj/+pvuIkfGkAoEqs
	MPDNxcmz58Pn6OJIXGvawQ5GrS8YQign5DZt1ga3zBH8um46JcBF3qiwqk8GPy0JyOpASmSMDRn
	ppa7HFdJYk74Qo//CU/lTyEF/djNIbiP7KYO+UY3u08z8pxhsJ6/QnLdI89LK/zbeVCk=
X-Google-Smtp-Source: AGHT+IFSOsvPqHBXCLwDMa/o2UaxQjPew98a3AmxZA3+OsFsZN55l1zZO8FFLZh/lYirNNidSm4pnQ==
X-Received: by 2002:a05:6830:4c08:b0:7c7:6da2:6d67 with SMTP id 46e09a7af769-7caceba996emr3989412a34.3.1765487567654;
        Thu, 11 Dec 2025 13:12:47 -0800 (PST)
Received: from CMGLRV3 ([2a09:bac5:947d:1b37::2b6:8])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cadb1d0facsm2218090a34.3.2025.12.11.13.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 13:12:47 -0800 (PST)
Date: Thu, 11 Dec 2025 15:12:45 -0600
From: Frederick Lawler <fred@cloudflare.com>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	Roberto Sassu <roberto.sassu@huawei.com>,
	kernel-team@cloudflare.com
Subject: Re: xfs/ima: Regression caching i_version
Message-ID: <aTszzVJkIqBpYLst@CMGLRV3>
References: <aTspr4_h9IU4EyrR@CMGLRV3>
 <2b193b5ccd696420196ae9059f83dcc8b3f06473.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b193b5ccd696420196ae9059f83dcc8b3f06473.camel@kernel.org>

On Fri, Dec 12, 2025 at 05:55:45AM +0900, Jeff Layton wrote:
> On Thu, 2025-12-11 at 14:29 -0600, Frederick Lawler wrote:
> > Hi Jeff,
> > 
> > While testing 6.18, I think I found a regression with
> > commit 1cf7e834a6fb ("xfs: switch to multigrain timestamps") since 6.13
> > where IMA is no longer able to properly cache i_version when we overlay
> > tmpfs on top of XFS. Each measurement diff check in function
> > process_measurement() reports that the i_version is
> > always set to zero for iint->real_inode.version.
> > 
> > The function ima_collect_measurement() is looking to extract the version
> > from the cookie on next measurement to cache i_version.
> > 
> > I'm unclear from the commit description what the right approach here is:
> > update in IMA land by checking for time changes, or do
> > something else such as adding the cookie back.
> > 
> > 
> 
> What we probably want to do is switch to using the ctime to manufacture
> a change attribute when STATX_CHANGE_ATTRIBUTE is not set in the statx
> reply.
> 
> IIRC, IMA doesn't need to persist these values across reboot, so
> something like this (completely untested) might work, but it may be
> better to lift nfsd4_change_attribute() into a common header and use
> the same mechanism for both:

I agree lifting nfsd4_change_attribute(), if anything else, a consistent
place to fetch the i_version from. Am I correct in my understanding that
the XOR on the times will cancel out and result in just the i_version?
IMA is calling into inode_eq_iversion() to perform the comparison
between the cached value and inode.i_version.
> 
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index c35ea613c9f8..5a71845f579e 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -272,10 +272,14 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
>          * to an initial measurement/appraisal/audit, but was modified to
>          * assume the file changed.
>          */
> -       result = vfs_getattr_nosec(&file->f_path, &stat, STATX_CHANGE_COOKIE,
> +       result = vfs_getattr_nosec(&file->f_path, &stat, STATX_CHANGE_COOKIE | STATX_CTIME,
>                                    AT_STATX_SYNC_AS_STAT);
> -       if (!result && (stat.result_mask & STATX_CHANGE_COOKIE))
> -               i_version = stat.change_cookie;
> +       if (!result) {
> +               if (stat.result_mask & STATX_CHANGE_COOKIE)
> +                       i_version = stat.change_cookie;
> +               else if (stat.result_mask & STATX_CTIME)
> +                       i_version = stat.ctime.tv_sec ^ stat.ctime.tv_nsec;
> +       }
>         hash.hdr.algo = algo;
>         hash.hdr.length = hash_digest_size[algo];
>  
