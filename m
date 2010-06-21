Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L7IuaC110194 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 02:18:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B21BF14AAB67
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 00:25:41 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id hda3txC2yEf7RXXm for <xfs@oss.sgi.com>;
	Mon, 21 Jun 2010 00:25:41 -0700 (PDT)
Date: Mon, 21 Jun 2010 03:21:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsqa: test 214 leaves files around that cause 236 to fail
Message-ID: <20100621072133.GB1361@infradead.org>
References: <1277077378-17927-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1277077378-17927-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Mon, Jun 21, 2010 at 09:42:58AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Test 214 and 236 use the same file names for test files in the TEST
> filesystem and don't check/create clean initial test state. Hence if
> you run 214 then 236, 236 will fail with:
> 
> +link: cannot create link `/mnt/test/ouch2' to `/mnt/test/ouch': File exists
> +ctime: 1277076527 -> 1277076527
> +Fatal error: ctime not updated after link
> 
> Ensure that both tests clean up after themselves properly and also
> ensure a clean state before they start.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
