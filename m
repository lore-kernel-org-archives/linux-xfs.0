Return-Path: <SRS0=DzrB=EM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF21C2D0A3
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Nov 2020 07:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5EE6208B3
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Nov 2020 07:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgKFHsc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Nov 2020 02:48:32 -0500
Received: from verein.lst.de ([213.95.11.211]:50401 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgKFHsc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Nov 2020 02:48:32 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id CF70C68B02; Fri,  6 Nov 2020 08:48:29 +0100 (CET)
Date:   Fri, 6 Nov 2020 08:48:29 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        fdmanana@kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfs: separate __sb_start_write into blocking and
 non-blocking helpers
Message-ID: <20201106074829.GB31133@lst.de>
References: <160463582157.1669281.13010940328517200152.stgit@magnolia> <160463583438.1669281.14783057013328963357.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160463583438.1669281.14783057013328963357.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 05, 2020 at 08:10:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Break this function into two helpers so that it's obvious that the
> trylock versions return a value that must be checked, and the blocking
> versions don't require that.  While we're at it, clean up the return
> type mismatch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/aio.c           |    2 +-
>  fs/io_uring.c      |    3 +--
>  fs/super.c         |   18 ++++++++++++------
>  include/linux/fs.h |   21 +++++++++++----------
>  4 files changed, 25 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index c45c20d87538..04bb4bac327f 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1572,7 +1572,7 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
>  		 * we return to userspace.
>  		 */
>  		if (S_ISREG(file_inode(file)->i_mode)) {
> -			__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);
> +			__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE);

This should use sb_start_write()

>  	if (req->flags & REQ_F_ISREG) {
> -		__sb_start_write(file_inode(req->file)->i_sb,
> -					SB_FREEZE_WRITE, true);
> +		__sb_start_write(file_inode(req->file)->i_sb, SB_FREEZE_WRITE);

Same.

> +void __sb_start_write(struct super_block *sb, int level)
>  {
> +	percpu_down_read(sb->s_writers.rw_sem + level - 1);
>  }
>  EXPORT_SYMBOL(__sb_start_write);
>  
> +/*
> + * This is an internal function, please use sb_start_{write,pagefault,intwrite}
> + * instead.
> + */
> +bool __sb_start_write_trylock(struct super_block *sb, int level)
> +{
> +	return percpu_down_read_trylock(sb->s_writers.rw_sem + level - 1);
> +}
> +EXPORT_SYMBOL_GPL(__sb_start_write_trylock);

I think these can be inline in the headers, or even be merged into
the few callers.

> @@ -2756,14 +2757,14 @@ static inline void file_start_write(struct file *file)
>  {
>  	if (!S_ISREG(file_inode(file)->i_mode))
>  		return;
> -	__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);
> +	__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE);

This should use sb_start_write.

>  }
>  
>  static inline bool file_start_write_trylock(struct file *file)
>  {
>  	if (!S_ISREG(file_inode(file)->i_mode))
>  		return true;
> -	return __sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, false);
> +	return __sb_start_write_trylock(file_inode(file)->i_sb, SB_FREEZE_WRITE);

And this one sb_start_write_trylock.
