Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57168 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752110AbdEJLFC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 07:05:02 -0400
Date: Wed, 10 May 2017 13:04:57 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 01/27] fs: remove unneeded forward definition of
 mm_struct from fs.h
Message-ID: <20170510110457.GA25137@quack2.suse.cz>
References: <20170509154930.29524-1-jlayton@redhat.com>
 <20170509154930.29524-2-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170509154930.29524-2-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

On Tue 09-05-17 11:49:04, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/fs.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7251f7bb45e8..38adefd8e2a0 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1252,8 +1252,6 @@ extern void f_delown(struct file *filp);
>  extern pid_t f_getown(struct file *filp);
>  extern int send_sigurg(struct fown_struct *fown);
>  
> -struct mm_struct;
> -
>  /*
>   *	Umount options
>   */
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
