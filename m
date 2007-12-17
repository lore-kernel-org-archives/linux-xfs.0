Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 20:12:34 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBH4COYB020427
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 20:12:30 -0800
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA00426; Mon, 17 Dec 2007 15:12:33 +1100
Message-ID: <4765F730.7000307@sgi.com>
Date: Mon, 17 Dec 2007 15:12:32 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [review] Remove the xfs refcache
References: <4765EC66.5020202@sgi.com> <4765F444.8010705@sgi.com>
In-Reply-To: <4765F444.8010705@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> Hey hold on there buddy!  We may need to reactivate this code to fix some
> performance issues.  I've acttually got this code working and proven that
> it is one way to fix some of the NAS/NFS issues we have.
> 
> The little comment that reads "reference cache not needed for NFS in 2.6"
> is wrong - we do need it or something like it.

Cool :)

I'm just trying to clean up any 2.4 build leftovers before things go
upstream for .25. Bear in mind that xfs_refcache.c is only present in
ptools/CVS, it was excluded for mainline when it wasn't needed for the
2.6 builds.

Don
