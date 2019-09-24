Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F25DC432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 10:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70C9120872
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 10:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409516AbfIXKpj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 06:45:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409506AbfIXKpi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 06:45:38 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5DE507E423;
        Tue, 24 Sep 2019 10:45:38 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 742FC5D713;
        Tue, 24 Sep 2019 10:45:25 +0000 (UTC)
Date:   Tue, 24 Sep 2019 06:45:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 02/16] xfs: remove very old mount option
Message-ID: <20190924104523.GD13820@bfoster>
References: <156897321789.20210.339237101446767141.stgit@fedora-28>
 <156897334377.20210.1896184598481042341.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156897334377.20210.1896184598481042341.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 24 Sep 2019 10:45:38 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 05:55:43PM +0800, Ian Kent wrote:
> It appears the biosize mount option hasn't been documented as
> a vilid option since 2005.
> 
> So remove it.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

Works for me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f9450235533c..1010097354a6 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -51,7 +51,7 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>   * Table driven mount option parser.
>   */
>  enum {
> -	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
> +	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
>  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
>  	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
>  	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep,
> @@ -67,7 +67,6 @@ static const match_table_t tokens = {
>  	{Opt_logbsize,	"logbsize=%s"},	/* size of XFS log buffers */
>  	{Opt_logdev,	"logdev=%s"},	/* log device */
>  	{Opt_rtdev,	"rtdev=%s"},	/* realtime I/O device */
> -	{Opt_biosize,	"biosize=%u"},	/* log2 of preferred buffered io size */
>  	{Opt_wsync,	"wsync"},	/* safe-mode nfs compatible mount */
>  	{Opt_noalign,	"noalign"},	/* turn off stripe alignment */
>  	{Opt_swalloc,	"swalloc"},	/* turn on stripe width allocation */
> @@ -229,7 +228,6 @@ xfs_parseargs(
>  				return -ENOMEM;
>  			break;
>  		case Opt_allocsize:
> -		case Opt_biosize:
>  			if (suffix_kstrtoint(args, 10, &iosize))
>  				return -EINVAL;
>  			iosizelog = ffs(iosize) - 1;
> 
