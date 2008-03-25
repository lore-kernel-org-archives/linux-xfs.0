Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 21:55:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P4t7ir031429
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:55:13 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA01916; Tue, 25 Mar 2008 15:55:36 +1100
Message-ID: <47E885C8.4030902@sgi.com>
Date: Tue, 25 Mar 2008 15:55:36 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: make 054 _require_quota
References: <47E71A3D.9040707@sandeen.net>
In-Reply-To: <47E71A3D.9040707@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> 054 needs quota support to run, but doesn't make that explicit.

Looks good Eric

> Index: xfstests/054
> ===================================================================
> --- xfstests.orig/054
> +++ xfstests/054
> @@ -38,6 +38,7 @@ cp /dev/null $seq.full
>  chmod ugo+rwx $seq.full
>  
>  _require_scratch
> +_require_quota
>  
>  _filter_stat()
>  {
> 
> 
