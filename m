Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 433127CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 08:33:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0887AC003
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 06:33:39 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id TiY9Wu51gdPpd2FT (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2016 06:33:35 -0800 (PST)
Date: Thu, 4 Feb 2016 15:33:44 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: dirty inode only if required
Message-ID: <20160204143344.GA6895@quack.suse.cz>
References: <87k2mkr2ud.fsf@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87k2mkr2ud.fsf@openvz.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Thu 04-02-16 17:02:02, Dmitry Monakhov wrote:
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Makes sense. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/dax.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index e0e9358..fc2e314 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -358,7 +358,8 @@ static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
>  	void *entry;
>  
>  	WARN_ON_ONCE(pmd_entry && !dirty);
> -	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> +	if (dirty)
> +		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>  
>  	spin_lock_irq(&mapping->tree_lock);
>  
> -- 
> 1.8.3.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
