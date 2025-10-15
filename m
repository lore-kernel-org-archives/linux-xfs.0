Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEB530648C
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 09:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760520208; cv=none; b=RyoJGI/DWKizUM4e/0VUgvGj+7A2xBqPtHzs/5hbenoBspOPFBjnjXxHLaWxDUpma4/OgEMt6HA5dJNQ7E3fctfFjy1qr0CBesXSZ6VjFmsny0q4Fg99a+h0SnNF0NwgF7pZJT3qf09UKqYh4aL6x/FCABe5xTDlrxPhhswi/z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760520208; c=relaxed/simple;
	bh=E9mpLsKPkCHC04KA8uliEqAwT6K2uu6XdMY4O7nzGy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXTp62HewOKWiJDUc9uBqvKFEP8JE873sjHK3vjiULcQ4EF/A5BF+RJpQQnEj4nhMZVcrj5+6eA+K9DaB5vLT2aGmpI09jJo9gk11B478W+8F3g8goyh6dtGomfZhhMvv5gRpps3kl+kljb9TQRhCeDZT9UJCtp/dp7Mhn/84vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hn4v8Zwe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hn4v8Zwe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760520202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=88GBGQzfIph4xnxrzgsJBHr0+JpWKkaGoeYMZcyTe1c=;
	b=hn4v8ZweyYDbkGvIbQyXYXnzQEvoZEZrfzh8h9a9RotBJoyieic8fa09T7i4Qm2Ts0xsdZ
	vImigYHKdQvgh6C3lw/hgKDggC0dBx50qUgdHu2BZvR2PsqpkRv1+eUYP+/kfVJak/oFhx
	uTwDivKAucJlqs07aYLc2qvOK/v/bD4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-PCNTOgi8OpKQJS_wqum5fg-1; Wed, 15 Oct 2025 05:23:20 -0400
X-MC-Unique: PCNTOgi8OpKQJS_wqum5fg-1
X-Mimecast-MFC-AGG-ID: PCNTOgi8OpKQJS_wqum5fg_1760520196
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4256fae4b46so4562731f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 02:23:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760520196; x=1761124996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88GBGQzfIph4xnxrzgsJBHr0+JpWKkaGoeYMZcyTe1c=;
        b=CuIDt0TnRRiFEFMFcLqFDyr/DC9y3CJdkRUAaf+l0hSqPBJ3OyH/yPouSiv5vJ9c81
         JNAWV/ar1DM1PaNkrU8P5uhBsoR91EYK+kGGZWLHfg+YMJHKIuzq5diau/sdvi+cOOF6
         Y38wIoQQ2fIWXRs1m2VG7csl7AbViDRZzF7twlO8hO4afhuAoCE1k+RF1klgG4hPWeOV
         e5LLlsy1V1fl5K0WGCVKGudiJ0op9yWQj33tSb0MAdgSzVNv8jHQvIl5U5Cjjn1hpe8u
         noMstrLu4PbwrbqyIifS4daG52e03DCEU83ivY5y32onTNxVxo2cCxZQ7E1XBGB7O+9D
         x5jA==
X-Forwarded-Encrypted: i=1; AJvYcCVrCm85InrfkZnjlUgLxv1tO4vL4yLEW38OneDbmOi6BOAxmO5O7EdTWsH5HA77iSSQxRE2WIzLGyE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ8lex1HexhS/a6a8TbAU0qK2nuWz3mtGmWhlY3hKHbfot5/+R
	m+L8YHeEy5ADh8LXY+/fy8Y5CQJ3cH9UvDJNA75lJo8Bj9YIz2Nfzv7UZQ/RrSXfHrChyO/VhVk
	4m5OBlsXLi3MncPvHepijcIYoxyb/lkehm7f+l7bBSXEAeASq7FD6X0fuPBEh
X-Gm-Gg: ASbGncuzy0P1dBRoKuflemrvnWVSqPYb52Ut4vzMBbSsoHkrcwbXop5A7rUrHC72+JR
	M35+X4y0ixUKMQ+EtgmEgWGaxnCc1h7Eyo6SQSoXvuxgame/11QMJcOO1L9imKUf4xAvN171tiT
	AdawQzy8ooBSIPnfWzRMrxCR0ClSugycboO6oT3GsfqlGAZiK1vdr1NGyhiz8SDR89ILDMdc2nu
	JPcc3xnqenfyKpDycdNfzz/rMAqp1Nfr7la2B5VNmyoeQIOcDU3EzPf5FHdSvIO2rny+rRvZQNi
	udOHDu++H8XjIiboU3Io+259zCccff2D1TRsKXgNpvFyBdWfQB4jFd5QjND6
X-Received: by 2002:a05:600c:6287:b0:46f:b42e:e38d with SMTP id 5b1f17b1804b1-46fb42ee464mr129131665e9.40.1760520195777;
        Wed, 15 Oct 2025 02:23:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHo4aFhSJSTlALL31iQKgpUlgPdwn2S5YN/PB9wP6hWkWwUl/VD01rI31zi/33P6LICiYPvbA==
X-Received: by 2002:a05:600c:6287:b0:46f:b42e:e38d with SMTP id 5b1f17b1804b1-46fb42ee464mr129131465e9.40.1760520195303;
        Wed, 15 Oct 2025 02:23:15 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47101be0caasm18398985e9.3.2025.10.15.02.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 02:23:15 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:23:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>, 1116595@bugs.debian.org
Cc: Iustin Pop <iustin@debian.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: Bug#1116595: [PATCH] xfs_scrub_fail: reduce security lockdowns
 to avoid postfix problems
Message-ID: <ztwmr6d7wgvhedjdz37zk3fczqwug23kbxpxoau5ut7svjz7hs@jyd6siyqbyrr>
References: <aNmt9M4e9Q6wqwxH@teal.hq.k1024.org>
 <20251013233424.GT6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013233424.GT6188@frogsfrogsfrogs>

On 2025-10-13 16:34:24, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Iustin Pop reports that the xfs_scrub_fail service fails to email
> problem reports on Debian when postfix is installed.  This is apparently
> due to several factors:
> 
> 1. postfix's sendmail wrapper calling postdrop directly,
> 2. postdrop requiring the ability to write to the postdrop group,
> 3. lockdown preventing the xfs_scrub_fail@ service to have postdrop in
>    the supplemental group list or the ability to run setgid programs
> 
> Item (3) could be solved by adding the whole service to the postdrop
> group via SupplementalGroups=, but that will fail if postfix is not
> installed and hence there is no postdrop group.
> 
> It could also be solved by forcing msmtp to be installed, bind mounting
> msmtp into the service container, and injecting a config file that
> instructs msmtp to connect to port 25, but that in turn isn't compatible
> with systems not configured to allow an smtp server to listen on ::1.
> 
> So we'll go with the less restrictive approach that e2scrub_fail@ does,
> which is to say that we just turn off all the sandboxing. :( :(
> 
> Reported-by: iustin@debian.org
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 9042fcc08eed6a ("xfs_scrub_fail: tighten up the security on the background systemd service")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

lgtm
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> ---
>  scrub/xfs_scrub_fail@.service.in |   57 ++------------------------------------
>  1 file changed, 3 insertions(+), 54 deletions(-)
> 
> diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
> index 16077888df3391..1e205768133467 100644
> --- a/scrub/xfs_scrub_fail@.service.in
> +++ b/scrub/xfs_scrub_fail@.service.in
> @@ -19,57 +19,6 @@ SupplementaryGroups=systemd-journal
>  # can control resource usage.
>  Slice=system-xfs_scrub.slice
>  
> -# No realtime scheduling
> -RestrictRealtime=true
> -
> -# Make the entire filesystem readonly and /home inaccessible.
> -ProtectSystem=full
> -ProtectHome=yes
> -PrivateTmp=true
> -RestrictSUIDSGID=true
> -
> -# Emailing reports requires network access, but not the ability to change the
> -# hostname.
> -ProtectHostname=true
> -
> -# Don't let the program mess with the kernel configuration at all
> -ProtectKernelLogs=true
> -ProtectKernelModules=true
> -ProtectKernelTunables=true
> -ProtectControlGroups=true
> -ProtectProc=invisible
> -RestrictNamespaces=true
> -
> -# Can't hide /proc because journalctl needs it to find various pieces of log
> -# information
> -#ProcSubset=pid
> -
> -# Only allow the default personality Linux
> -LockPersonality=true
> -
> -# No writable memory pages
> -MemoryDenyWriteExecute=true
> -
> -# Don't let our mounts leak out to the host
> -PrivateMounts=true
> -
> -# Restrict system calls to the native arch and only enough to get things going
> -SystemCallArchitectures=native
> -SystemCallFilter=@system-service
> -SystemCallFilter=~@privileged
> -SystemCallFilter=~@resources
> -SystemCallFilter=~@mount
> -
> -# xfs_scrub needs these privileges to run, and no others
> -CapabilityBoundingSet=
> -NoNewPrivileges=true
> -
> -# Failure reporting shouldn't create world-readable files
> -UMask=0077
> -
> -# Clean up any IPC objects when this unit stops
> -RemoveIPC=true
> -
> -# No access to hardware device files
> -PrivateDevices=true
> -ProtectClock=true
> +# No further restrictions because some installations may have MTAs such as
> +# postfix, which require the ability to run setgid programs and other
> +# foolishness.
> 

-- 
- Andrey

