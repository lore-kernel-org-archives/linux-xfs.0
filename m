Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 21:18:23 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J4IFj8019654
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 21:18:15 -0700
Message-ID: <48D3285F.2010600@sgi.com>
Date: Fri, 19 Sep 2008 14:19:43 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xail idbg command doesn't increment count in each loop
References: <48D31095.908@sgi.com>
In-Reply-To: <48D31095.908@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Lachlan McIlroy wrote:
> count is never incremented on each log item because it is unreachable code.
> 
> --- a/fs/xfs/xfsidbg.c    2008-09-19 12:27:05.000000000 +1000
> +++ b/fs/xfs/xfsidbg.c    2008-09-16 12:34:12.000000000 +1000
> @@ -6249,8 +6249,8 @@ xfsidbg_xaildump(xfs_mount_t *mp)
>         default:
>             kdb_printf("Unknown item type %d\n", lip->li_type);
>             break;
> -        count++;
>         }
> +        count++;
>     }
> }
Oops - count++ after break.

Looks good.

--Tim
