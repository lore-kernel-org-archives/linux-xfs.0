Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Mar 2007 18:09:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2K19n6p025943
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 18:09:51 -0700
Message-ID: <45FF344C.2070000@sgi.com>
Date: Tue, 20 Mar 2007 12:09:32 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] Fix a bug which is in user or group quota enforcement
 disabled
References: <20070223132318k-ooizumi@rifu.bsd.tnes.nec.co.jp>
In-Reply-To: <20070223132318k-ooizumi@rifu.bsd.tnes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>
Cc: xfs@oss.sgi.com

Kouta Ooizumi wrote:
> Hi!
> 
> I found a bug in the following conditions.
> 
> Conditions:
>  - Both XFS_UQUOTA_ACCT and XFS_GQUOTA_ACCT are enabled.
>  - Either XFS_UQUOTA_ENFD or XFS_OQUOTA_ENFD is enabled.
>  - The usage without enforce is reached at the soft limit.
> 
> Problems:
>  1. "repquota" shows all grace time even if no enforcement. 
>  2. we cannot make a file over a hard limits even if no enforcement.

Hi Kouta,

Thanks for the patches, they're both in now.

Sorry for the delay picking them up.
Donald
