Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59IRfNq052432 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 13:27:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84D7C2E2BC1
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 11:28:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id K9EG4XHpHQXWUysS for
	<xfs@oss.sgi.com>; Tue, 09 Jun 2009 11:28:02 -0700 (PDT)
Date: Tue, 9 Jun 2009 14:28:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: enable test 080 for LInux
Message-ID: <20090609182801.GA12057@infradead.org>
References: <4A2EA257.9000702@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A2EA257.9000702@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Tue, Jun 09, 2009 at 12:56:39PM -0500, Eric Sandeen wrote:
> Seems to work here...  Anyone know why it's disabled?
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> diff --git a/080 b/080
> index e9721ad..1794a4c 100755
> --- a/080
> +++ b/080
> @@ -48,13 +48,13 @@ _supported_fs xfs
>  # Apparently should be able to work on IRIX,
>  # but not at the moment.
>  # It does not work on Linux due to some locking issues...

That last line of the comment should be removed I think.

> -_supported_os IRIX
> +_supported_os IRIX Linux
>  
>  [ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"

Given that IRIX doesn't work we should just remove it from _supported_os
above.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
