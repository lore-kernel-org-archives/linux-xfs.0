Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 00C607F55
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 16:49:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EECB5304048
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 14:49:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	C5RJRBSLwj9shojk for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 14:49:27 -0700 (PDT)
Date: Mon, 5 May 2014 07:49:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] common: use a relative path to fsstress
Message-ID: <20140504214913.GP26353@dastard>
References: <20140504104510.GA9510@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140504104510.GA9510@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, May 04, 2014 at 03:45:10AM -0700, Christoph Hellwig wrote:
> All commands run as $qa_user should use a relative path so that
> missing access permissions on $HOME for root don't prevent running
> it.  This fixes common/233 for me.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> --- a/common/config
> +++ b/common/config
> @@ -134,7 +134,7 @@ export MOUNT_PROG="`set_prog_path mount`"
>  export UMOUNT_PROG="`set_prog_path umount`"
>  [ "$UMOUNT_PROG" = "" ] && _fatal "umount not found"
>  
> -export FSSTRESS_PROG="`set_prog_path fsstress $PWD/ltp/fsstress`"
> +export FSSTRESS_PROG="./ltp/fsstress"

Why remove the set_prog_path call? i.e. this should work:

+export FSSTRESS_PROG="`set_prog_path fsstress ./ltp/fsstress`"

Otherwise, a comment explaining why set_prog_path is not used just
for this binary would be appropriate....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
