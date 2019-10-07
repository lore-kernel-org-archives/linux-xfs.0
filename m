Return-Path: <SRS0=GEoz=YA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91143C47404
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 11:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E79D218AC
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 11:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfJGLwY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 07:52:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727467AbfJGLwY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 07:52:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 674C985362;
        Mon,  7 Oct 2019 11:52:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AE29A60A9D;
        Mon,  7 Oct 2019 11:52:23 +0000 (UTC)
Date:   Mon, 7 Oct 2019 07:52:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 17/17] xfs: mount-api - remove remaining legacy mount
 code
Message-ID: <20191007115221.GE22140@bfoster>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
 <157009840845.13858.14638828094050215119.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157009840845.13858.14638828094050215119.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 07 Oct 2019 11:52:24 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 06:26:48PM +0800, Ian Kent wrote:
> Now that the new mount api is being used the remaining old mount
> code can be removed.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c |   48 +-----------------------------------------------
>  1 file changed, 1 insertion(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 93f42160aa6f..4d65e6c7cfb2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -61,53 +61,7 @@ enum {
>  	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>  	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
> -};
> -
> -static const match_table_t tokens = {
> -	{Opt_logbufs,	"logbufs=%u"},	/* number of XFS log buffers */
> -	{Opt_logbsize,	"logbsize=%s"},	/* size of XFS log buffers */
> -	{Opt_logdev,	"logdev=%s"},	/* log device */
> -	{Opt_rtdev,	"rtdev=%s"},	/* realtime I/O device */
> -	{Opt_wsync,	"wsync"},	/* safe-mode nfs compatible mount */
> -	{Opt_noalign,	"noalign"},	/* turn off stripe alignment */
> -	{Opt_swalloc,	"swalloc"},	/* turn on stripe width allocation */
> -	{Opt_sunit,	"sunit=%u"},	/* data volume stripe unit */
> -	{Opt_swidth,	"swidth=%u"},	/* data volume stripe width */
> -	{Opt_nouuid,	"nouuid"},	/* ignore filesystem UUID */
> -	{Opt_grpid,	"grpid"},	/* group-ID from parent directory */
> -	{Opt_nogrpid,	"nogrpid"},	/* group-ID from current process */
> -	{Opt_bsdgroups,	"bsdgroups"},	/* group-ID from parent directory */
> -	{Opt_sysvgroups,"sysvgroups"},	/* group-ID from current process */
> -	{Opt_allocsize,	"allocsize=%s"},/* preferred allocation size */
> -	{Opt_norecovery,"norecovery"},	/* don't run XFS recovery */
> -	{Opt_inode64,	"inode64"},	/* inodes can be allocated anywhere */
> -	{Opt_inode32,   "inode32"},	/* inode allocation limited to
> -					 * XFS_MAXINUMBER_32 */
> -	{Opt_ikeep,	"ikeep"},	/* do not free empty inode clusters */
> -	{Opt_noikeep,	"noikeep"},	/* free empty inode clusters */
> -	{Opt_largeio,	"largeio"},	/* report large I/O sizes in stat() */
> -	{Opt_nolargeio,	"nolargeio"},	/* do not report large I/O sizes
> -					 * in stat(). */
> -	{Opt_attr2,	"attr2"},	/* do use attr2 attribute format */
> -	{Opt_noattr2,	"noattr2"},	/* do not use attr2 attribute format */
> -	{Opt_filestreams,"filestreams"},/* use filestreams allocator */
> -	{Opt_quota,	"quota"},	/* disk quotas (user) */
> -	{Opt_noquota,	"noquota"},	/* no quotas */
> -	{Opt_usrquota,	"usrquota"},	/* user quota enabled */
> -	{Opt_grpquota,	"grpquota"},	/* group quota enabled */
> -	{Opt_prjquota,	"prjquota"},	/* project quota enabled */
> -	{Opt_uquota,	"uquota"},	/* user quota (IRIX variant) */
> -	{Opt_gquota,	"gquota"},	/* group quota (IRIX variant) */
> -	{Opt_pquota,	"pquota"},	/* project quota (IRIX variant) */
> -	{Opt_uqnoenforce,"uqnoenforce"},/* user quota limit enforcement */
> -	{Opt_gqnoenforce,"gqnoenforce"},/* group quota limit enforcement */
> -	{Opt_pqnoenforce,"pqnoenforce"},/* project quota limit enforcement */
> -	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
> -	{Opt_discard,	"discard"},	/* Discard unused blocks */
> -	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
> -	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
> -	{Opt_err,	NULL},
> +	Opt_discard, Opt_nodiscard, Opt_dax,
>  };
>  
>  static const struct fs_parameter_spec xfs_param_specs[] = {
> 
