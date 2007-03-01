Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Mar 2007 15:27:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l21NQx6p014519
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2007 15:27:00 -0800
Message-ID: <45E76138.2020202@sgi.com>
Date: Fri, 02 Mar 2007 10:26:48 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] repquota does't report correct space usage
References: <200702280733.AA05017@TNESG9305.tnes.nec.co.jp>
In-Reply-To: <200702280733.AA05017@TNESG9305.tnes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <utako@tnes.nec.co.jp>
Cc: xfs@oss.sgi.com

Utako Kusaka wrote:
> Hi,
> 
> repquota may report incorrect space usage when the filesystem is mounted
> repeatedly with different quota options.
> The cause of the problem is that xfs_qm_quotacheck() is not called because
> the `CHKD' flag in mp->m_qflags is not cleared until it is mounted with 
> no quota option. This patch fixes it.

Good find, I've heard of some problems with quota 'corruption' that may
actually be caused by this.

> --- linux-2.6.20-orgn/fs/xfs/quota/xfs_qm.c.orgn        2007-02-22 17:30:07.000000000 +0900
> +++ linux-2.6.20/fs/xfs/xfs_qm.c        2007-02-22 17:30:58.000000000 +0900
> @@ -1175,8 +1175,6 @@ xfs_qm_init_quotainfo(
>         qinf->qi_dqperchunk = BBTOB(qinf->qi_dqchunklen);
>         do_div(qinf->qi_dqperchunk, sizeof(xfs_dqblk_t));
> 
> -       mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
> -
>         /*
>          * We try to get the limits from the superuser's limits fields.
>          * This is quite hacky, but it is standard quota practice.

This disables the optimization that skips the quota check for the normal case where mount
options have not been changed.

I don't have any quota check performance figures handy but I don't think we can loose this
optimization for people with large filesystems/machines.

I think instead we need to clear the individual quota bit when a filesystem is mounted
without a particular quota type. This will force a quota check but only when the filesystem
is again mounted with that quota type.

Donald
