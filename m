Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9O96oJ6061346 for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 04:06:51 -0500
Date: Mon, 24 Oct 2011 05:06:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfstests: fsstress should kill children tasks before
	exit
Message-ID: <20111024090645.GA31887@infradead.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
	<1319020189-13584-2-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1319020189-13584-2-git-send-email-dmonakhov@openvz.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: jack@suse.cz, xfs@oss.sgi.com, hch@infradead.org, aelder@sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

> +int 		should_stop = 0;

this should use sig_atomic_t, or at least volatile.
>  
>  void	add_to_flist(int, int, int);
>  void	append_pathname(pathname_t *, char *);
> @@ -253,6 +256,10 @@ void	usage(void);
>  void	write_freq(void);
>  void	zero_freq(void);
>  
> +void sg_handler(int signum) {
> +	should_stop = 1;
> +}

please use normal K&R / Linux style brace placement.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
