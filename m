Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UAPXVs200059 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 04:25:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C28F1C91AF6
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 02:26:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9jBplHsQR6ELt4WC for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 02:26:39 -0800 (PST)
Date: Sat, 30 Jan 2010 05:26:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: make 053 and 077 generic
Message-ID: <20100130102639.GC32695@infradead.org>
References: <4B621E11.4050609@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B621E11.4050609@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jan 28, 2010 at 05:30:25PM -0600, Eric Sandeen wrote:
> 053 and 077 can be generic w/ a little tweaking.
> 
> Also change 077's filler to something more likely
> to be on a random system under test, and add it
> to the enospc group.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> diff --git a/053 b/053
> index 98644a7..5542885 100755
> --- a/053
> +++ b/053
> @@ -38,18 +38,19 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  . ./common.attr
>  
>  # real QA test starts here
> -_supported_fs xfs
> +_supported_fs generic
>  _supported_os Linux
>  
>  [ ! -x /bin/chacl -a ! -x /usr/bin/chacl ] && _notrun "chacl command not found"
>  
>  _require_scratch
> +_acl_requirements

_acl_requirements includes the chacl check, so it can be removed.

Btw, any reason _acl_requirements isn't called _require_acl?

> diff --git a/077 b/077
> index cdee8da..d23305f 100755
> --- a/077
> +++ b/077
> @@ -31,7 +31,8 @@ here=`pwd`
>  tmp=/tmp/$$
>  status=1
>  #filler=$here/../../linux
> -filler=/home/fsgqa/isms/2.4.x-xfs
> +#filler=/home/fsgqa/isms/2.4.x-xfs
> +filler=/lib/modules/`uname -r`/

Oooops.  Maybe just use /lib/modules/ to get as much as possible.
And no need to let the other bits comment out there.  Maybe we need
to generate the data instead to really be safe - at least for my
tests under qemu I don't have any modules installed.  But that should
be left for another patch.

Anyway, patch looks good enough to go in for now, so


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
