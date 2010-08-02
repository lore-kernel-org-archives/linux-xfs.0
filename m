Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o72Ip5FN202770 for <xfs@oss.sgi.com>; Mon, 2 Aug 2010 13:51:05 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2888215D1249
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 11:59:17 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id p66knIPt0OsD0iyS for <xfs@oss.sgi.com>;
	Mon, 02 Aug 2010 11:59:17 -0700 (PDT)
Date: Mon, 2 Aug 2010 20:50:53 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] dio: track and serialise unaligned direct IO
Message-ID: <20100802185052.GK3278@quack.suse.cz>
References: <1280733945-16231-1-git-send-email-david@fromorbit.com>
	<1280733945-16231-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280733945-16231-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, sandeen@sandeen.net, xfs@oss.sgi.com

On Mon 02-08-10 17:25:44, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we get two unaligned direct IO's to the same filesystem block
> that is marked as a new allocation (i.e. buffer_new), then both IOs
> will zero the portion of the block they are not writing data to. As
> a result, when the IOs complete there will be a portion of the block
> that contains zeros from the last IO to complete rather than the
> data that should be there.
> 
> This is easily manifested by qemu using aio+dio with an unaligned
> guest filesystem - every IO is unaligned and fileystem corruption is
> encountered in the guest filesystem. xfstest 240 (from Eric Sandeen)
> is also a simple reproducer.
> 
> To avoid this problem, track unaligned IO that triggers sub-block
> zeroing and check new incoming unaligned IO that require sub-block
> zeroing against that list. If we get an overlap where the start and
> end of unaligned IOs hit the same filesystem block, then we need to
> block the incoming IOs until the IO that is zeroing the block
> completes. The blocked IO can then continue without needing to do
> any zeroing and hence won't overwrite valid data with zeros.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
...
> +/*
> + * Add a filesystem block to the list of blocks we are tracking.
> + */
> +static void
> +dio_start_zero_block(struct dio *dio, sector_t zero_block)
> +{
> +	struct dio_zero_block *zb;
> +
> +	zb = kmalloc(sizeof(*zb), GFP_NOIO);
> +	if (!zb)
> +		return;
  Ho hum, so if the allocation fails, we will just silently corrupt the
data anyway? Not good I think.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
