Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD93C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A449E214AF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732735AbfIPMxZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:53:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732709AbfIPMxZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 08:53:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25EA481DEC;
        Mon, 16 Sep 2019 12:53:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3DB05C22C;
        Mon, 16 Sep 2019 12:53:24 +0000 (UTC)
Date:   Mon, 16 Sep 2019 08:53:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: shortcut xfs_file_release for read-only file
 descriptors
Message-ID: <20190916125323.GC41978@bfoster>
References: <20190916122041.24636-1-hch@lst.de>
 <20190916122041.24636-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916122041.24636-3-hch@lst.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 16 Sep 2019 12:53:25 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 02:20:41PM +0200, Christoph Hellwig wrote:
> xfs_file_release currently performs flushing of truncated blocks and
> freeing of the post-EOF speculative preallocation for all file
> descriptors as long as they are not on a read-only mount.  Switch to
> check for FMODE_WRITE instead as we should only perform these actions
> on writable file descriptors, and no such file descriptors can be
> created on a read-only mount.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 72680edf2ceb..06f0eb25c7cc 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1066,7 +1066,7 @@ xfs_file_release(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +	if (!(file->f_mode & FMODE_WRITE))
>  		return 0;
>  	

Didn't Dave have a variant of this patch for dealing with a
fragmentation issue (IIRC)? Anyways, seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	if (XFS_FORCED_SHUTDOWN(mp))
> -- 
> 2.20.1
> 
