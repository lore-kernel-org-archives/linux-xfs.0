Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6631E1DA303
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 07:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720509666; cv=none; b=VIz+PycDE4XrUGlaRlQ4CwX41ccdQWG+JDWRiDEHDxNBAC0o6JUd90kUPMJRiIUlfut8ylBXGvLlqVF5nu16FrENJozwny7E/l0KJdlMTD15qHxYvtxMObrSqxKJGkHkaRV1QrQ40z9+oVRqgbD9SaChFO8QlTNSf4iWuPLu+Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720509666; c=relaxed/simple;
	bh=UOvD88VR5yimrlzLqHAwBefcUVXA2BnB1wxZK2RN1Fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnNe04aTTSdOzx1RlVtFLKT5+4Y4aV1YmNo5D5/eEtzZ8Fd8PSXuozymiDCj2lTugbk6TTfuvhzGmzr3/7QvD/t5YI9NkFkOVR9W5eJkTQpYgiZ+JOebjOpHrz6s0TgEWGteeopz+AmG2w7RdmrkYVS09W3qmdU+4i+fRbesy7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=b4YfHqlw; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="b4YfHqlw"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3cabac56b38so3113051b6e.3
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 00:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720509662; x=1721114462; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=16+5KkAcmyyYiIqIlKkzho/7Sa2vbg2kF7UVlzopShI=;
        b=b4YfHqlwEY8IbUKg9mWKz0zmB2S30hFcQwKmaU4PEvPEGQTJ4RllXCOhutEGXSW5hp
         vGn0TM2LXFWGMAzJ/aCokxgIBvFhwQtGSgzBRYkTZbk688aOMbEhImDaA4+Xb816Y+qf
         HhqIkjYYkZTgBIQAQ2XkDNvNp7YFh3dTbFDPJc1igjHu/WXpvVagP5KUufO5oYFhDoJg
         egTgQufMCk3NEkB/g1cSK39RvxZ5IFdJatDqDnk24szm+giI0YKFN7+8UMD9XTxvJeny
         /ahSLbBXVpkt5s2cLw8UZ4NmLcLsiBp7IPPOqhuojCAPA8ZA5m0+F0ecit/NAyfqOZA3
         QEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720509662; x=1721114462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=16+5KkAcmyyYiIqIlKkzho/7Sa2vbg2kF7UVlzopShI=;
        b=G2pkHYmvettlbEw1PXTVhM4A2p3mHyWKbhIYyTQnOqTCJocqWsfhWne7FQZa+x+Em6
         btwY4/g9y9xhAeQpnJ9i1Iw7ICCCQAZE8J58Kh5u3GRXsL5Fvl48p9aGGZ0xEpOBRfyM
         qvZEN18fohmK98DfB59hkQuIleIzaeI+5VEdVxzkkrdwhZLn2z+imbV//bryixx0Zqg8
         LOQnH1eetgsrg4JclmFCtVm5ZtT1j/ECh3hziKEcpda+/sgl6FT0hT7WYm8+QQcPOz+s
         CCQpW6zZfdGsW2eM3SgHlIO5984MBa57bbzRrKAvY/1+UGByOXo4ohwafMlPVVwktuHT
         OlgQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2OzcUeVypAOmvtoUeP0NeIumGXu9Syu52HmMppy4GSg3CCnLtEDUnrlg03aOBCtoTay6ehEWs0Gjm3J5yE/8B26dN4LxqcFwI
X-Gm-Message-State: AOJu0YxqvM1vplOeB1K6O6I5k0EuFskzeo1UI0DFbyYh64Y1DqeLsQFA
	tdQzfUKcTP1noHjFcjwXEmKNgG4ShUPCeMiZeh1BmL7v1FGlpAka8ihSx1WDzIhGWyPVp9EV1Oa
	Z
X-Google-Smtp-Source: AGHT+IGxho6HzSTwZ00E/Od1WJiNvx4PrWZZXzDxNa7aH2wDIFKYeUQ2MgtOuIoyNUACs37c2ZdsSQ==
X-Received: by 2002:a05:6808:120c:b0:3d9:2cec:9b10 with SMTP id 5614622812f47-3d93c105f70mr1422011b6e.56.1720509662345;
        Tue, 09 Jul 2024 00:21:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b4398959csm1079705b3a.163.2024.07.09.00.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 00:21:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sR59n-009RAJ-23;
	Tue, 09 Jul 2024 17:20:59 +1000
Date: Tue, 9 Jul 2024 17:20:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: remove duplicate rtalloc declarations in libxfs.h
Message-ID: <Zozk26g3EoJTamEA@dread.disaster.area>
References: <20240709064401.2998863-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709064401.2998863-1-hch@lst.de>

On Tue, Jul 09, 2024 at 08:44:01AM +0200, Christoph Hellwig wrote:
> These already come from xfs_rtbitmap.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/libxfs.h         |  5 -----
>  man/man8/xfs_scrub_all.8 | 42 ----------------------------------------
>  2 files changed, 47 deletions(-)
>  delete mode 100644 man/man8/xfs_scrub_all.8
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index fb8efb696..40e41ea77 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -220,11 +220,6 @@ libxfs_bmbt_disk_get_all(
>  		irec->br_state = XFS_EXT_NORM;
>  }
>  
> -/* XXX: this is clearly a bug - a shared header needs to export this */
> -/* xfs_rtalloc.c */
> -int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
> -bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
> -
>  #include "xfs_attr.h"
>  #include "topology.h"
>  
> diff --git a/man/man8/xfs_scrub_all.8 b/man/man8/xfs_scrub_all.8
> deleted file mode 100644
> index 74548802e..000000000
> --- a/man/man8/xfs_scrub_all.8
> +++ /dev/null
> @@ -1,42 +0,0 @@
> -.TH xfs_scrub_all 8
> -.SH NAME
> -xfs_scrub_all \- scrub all mounted XFS filesystems
> -.SH SYNOPSIS
> -.B xfs_scrub_all
> -[
> -.B \-hV
> -]
> -.SH DESCRIPTION
> -.B xfs_scrub_all
> -attempts to read and check all the metadata on all mounted XFS filesystems.
> -The online scrub is performed via the
> -.B xfs_scrub
> -tool, either by running it directly or by using systemd to start it
> -in a restricted fashion.
> -Mounted filesystems are mapped to physical storage devices so that scrub
> -operations can be run in parallel so long as no two scrubbers access
> -the same device simultaneously.
> -.SH OPTIONS
> -.TP
> -.B \-h
> -Display help.
> -.TP
> -.B \-V
> -Prints the version number and exits.
> -.SH EXIT CODE
> -The exit code returned by
> -.B xfs_scrub_all
> -is the sum of the following conditions:
> -.br
> -\	0\	\-\ No errors
> -.br
> -\	4\	\-\ File system errors left uncorrected
> -.br
> -\	8\	\-\ Operational error
> -.br
> -\	16\	\-\ Usage or syntax error
> -.TP
> -These are the same error codes returned by xfs_scrub.
> -.br
> -.SH SEE ALSO
> -.BR xfs_scrub (8).

Not sure that you meant to remove this man page when cleaning up 
libxfs.h...

-Dave.

-- 
Dave Chinner
david@fromorbit.com
