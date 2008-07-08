Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jul 2008 19:54:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m682sSbr019949
	for <xfs@oss.sgi.com>; Mon, 7 Jul 2008 19:54:28 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C6832C6677
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 19:55:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id bjH1qFW1L9za1c7O for <xfs@oss.sgi.com>; Mon, 07 Jul 2008 19:55:32 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id BDDC9AC3593
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 21:55:31 -0500 (CDT)
Message-ID: <4872D725.5070306@sandeen.net>
Date: Mon, 07 Jul 2008 21:55:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] convert xfs to use ERR_CAST
References: <480FA737.5030001@sandeen.net>
In-Reply-To: <480FA737.5030001@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Looks like somehow xfs got missed in the conversion that
> took place in e231c2ee64eb1c5cd3c63c31da9dac7d888dcf7f,
> "Convert ERR_PTR(PTR_ERR(p)) instances to ERR_CAST(p) <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e231c2ee64eb1c5cd3c63c31da9dac7d888dcf7f>"
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

ping.

This one's really, really, really easy :)

-Eric

> ndex: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
> @@ -167,7 +167,7 @@ xfs_fs_fh_to_dentry(struct super_block *
>  	if (!inode)
>  		return NULL;
>  	if (IS_ERR(inode))
> -		return ERR_PTR(PTR_ERR(inode));
> +		return ERR_CAST(inode);
>  	result = d_alloc_anon(inode);
>  	if (!result) {
>  		iput(inode);
> @@ -198,7 +198,7 @@ xfs_fs_fh_to_parent(struct super_block *
>  	if (!inode)
>  		return NULL;
>  	if (IS_ERR(inode))
> -		return ERR_PTR(PTR_ERR(inode));
> +		return ERR_CAST(inode);
>  	result = d_alloc_anon(inode);
>  	if (!result) {
>  		iput(inode);
> 
> 
> 
