Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 20:32:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G3Vsbm004440
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 20:31:56 -0700
Date: Mon, 16 Jul 2007 13:31:48 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] fix format string warnings in xfsidbg
Message-ID: <20070716033148.GL12413810@sgi.com>
References: <20070715171948.GA6894@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070715171948.GA6894@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Jul 15, 2007 at 07:19:48PM +0200, Christoph Hellwig wrote:
> @@ -6818,7 +6818,7 @@ xfsidbg_xihash(xfs_mount_t *mp)
>  
>  	kdb_printf("\n");
>  
> -	kdb_printf("total inodes = %d, average length = %ld, adjusted average = %ld \n",
> +	kdb_printf("total inodes = %zu, average length = %zu, adjusted average = %zu\n",
>  		total, total / mp->m_ihsize,
>  		total / (mp->m_ihsize - numzeros));

ia64 build gives:

fs/xfs/xfsidbg.c:6826: warning: format â%zuâ expects type âsize_tâ, but
argument 2 has type âintâ

total is declared as an int - I'll change it back to %d....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
