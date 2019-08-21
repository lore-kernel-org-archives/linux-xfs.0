Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E947BC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 14:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA98822D6D
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 14:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfHUOwI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:52:08 -0400
Received: from sandeen.net ([63.231.237.45]:55654 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbfHUOwH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Aug 2019 10:52:07 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5F84717DFF;
        Wed, 21 Aug 2019 09:52:06 -0500 (CDT)
Subject: Re: [PATCH 01/10] xfs: mount-api - add fs parameter description
To:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <a895b8c9-5a1c-b642-a7f3-2adc004351e6@sandeen.net>
Date:   Wed, 21 Aug 2019 09:52:05 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156134510205.2519.16185588460828778620.stgit@fedora-28>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/23/19 9:58 PM, Ian Kent wrote:
> The new mount-api uses an array of struct fs_parameter_spec for
> parameter parsing, create this table populated with the xfs mount
> parameters.
> 
> The new mount-api table definition is wider than the token based
> parameter table and interleaving the option description comments
> between each table line is much less readable than adding them to
> the end of each table entry. So add the option description comment
> to each entry line even though it causes quite a few of the entries
> to be longer than 80 characters.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Ian, I saw hints about a V2 in replies, is that still in the works?

Thanks,
-Eric

> ---
>  fs/xfs/xfs_super.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a14d11d78bd8..ab8145bf6fff 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -51,6 +51,8 @@
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
>  #include <linux/parser.h>
> +#include <linux/fs_context.h>
> +#include <linux/fs_parser.h>
>  
>  static const struct super_operations xfs_super_operations;
>  struct bio_set xfs_ioend_bioset;
> @@ -60,9 +62,6 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
>  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>  #endif
>  
> -/*
> - * Table driven mount option parser.
> - */
>  enum {
>  	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
>  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
> @@ -122,6 +121,49 @@ static const match_table_t tokens = {
>  	{Opt_err,	NULL},
>  };
>  
> +static const struct fs_parameter_spec xfs_param_specs[] = {
> + fsparam_u32	("logbufs",    Opt_logbufs),   /* number of XFS log buffers */
> + fsparam_string ("logbsize",   Opt_logbsize),  /* size of XFS log buffers */
> + fsparam_string ("logdev",     Opt_logdev),    /* log device */
> + fsparam_string ("rtdev",      Opt_rtdev),     /* realtime I/O device */
> + fsparam_u32	("biosize",    Opt_biosize),   /* log2 of preferred buffered io size */
> + fsparam_flag	("wsync",      Opt_wsync),     /* safe-mode nfs compatible mount */
> + fsparam_flag	("noalign",    Opt_noalign),   /* turn off stripe alignment */
> + fsparam_flag	("swalloc",    Opt_swalloc),   /* turn on stripe width allocation */
> + fsparam_u32	("sunit",      Opt_sunit),     /* data volume stripe unit */
> + fsparam_u32	("swidth",     Opt_swidth),    /* data volume stripe width */
> + fsparam_flag	("nouuid",     Opt_nouuid),    /* ignore filesystem UUID */
> + fsparam_flag_no("grpid",      Opt_grpid),     /* group-ID from parent directory (or not) */
> + fsparam_flag	("bsdgroups",  Opt_bsdgroups), /* group-ID from parent directory */
> + fsparam_flag	("sysvgroups", Opt_sysvgroups),/* group-ID from current process */
> + fsparam_string ("allocsize",  Opt_allocsize), /* preferred allocation size */
> + fsparam_flag	("norecovery", Opt_norecovery),/* don't run XFS recovery */
> + fsparam_flag	("inode64",    Opt_inode64),   /* inodes can be allocated anywhere */
> + fsparam_flag	("inode32",    Opt_inode32),   /* inode allocation limited to XFS_MAXINUMBER_32 */
> + fsparam_flag_no("ikeep",      Opt_ikeep),     /* do not free (or keep) empty inode clusters */
> + fsparam_flag_no("largeio",    Opt_largeio),   /* report (or do not report) large I/O sizes in stat() */
> + fsparam_flag_no("attr2",      Opt_attr2),     /* do (or do not) use attr2 attribute format */
> + fsparam_flag	("filestreams",Opt_filestreams), /* use filestreams allocator */
> + fsparam_flag_no("quota",      Opt_quota),     /* disk quotas (user) */
> + fsparam_flag	("usrquota",   Opt_usrquota),  /* user quota enabled */
> + fsparam_flag	("grpquota",   Opt_grpquota),  /* group quota enabled */
> + fsparam_flag	("prjquota",   Opt_prjquota),  /* project quota enabled */
> + fsparam_flag	("uquota",     Opt_uquota),    /* user quota (IRIX variant) */
> + fsparam_flag	("gquota",     Opt_gquota),    /* group quota (IRIX variant) */
> + fsparam_flag	("pquota",     Opt_pquota),    /* project quota (IRIX variant) */
> + fsparam_flag	("uqnoenforce",Opt_uqnoenforce), /* user quota limit enforcement */
> + fsparam_flag	("gqnoenforce",Opt_gqnoenforce), /* group quota limit enforcement */
> + fsparam_flag	("pqnoenforce",Opt_pqnoenforce), /* project quota limit enforcement */
> + fsparam_flag	("qnoenforce", Opt_qnoenforce),  /* same as uqnoenforce */
> + fsparam_flag_no("discard",    Opt_discard),   /* Do (or do not) not discard unused blocks */
> + fsparam_flag	("dax",	       Opt_dax),       /* Enable direct access to bdev pages */
> + {}
> +};
> +
> +static const struct fs_parameter_description xfs_fs_parameters = {
> +	.name		= "xfs",
> +	.specs		= xfs_param_specs,
> +};
>  
>  STATIC int
>  suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
> 
