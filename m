Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5BE3929DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 11:17:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 011E6AC001
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 09:17:35 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id tn8sr7Y6uZyDSlpy (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 09:17:35 -0800 (PST)
Date: Mon, 2 Dec 2013 09:17:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/15] mkfs: table based parsing for converted parameters
Message-ID: <20131202171734.GC28630@infradead.org>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385689430-10103-12-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 12:43:46PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> All the parameters that can be passed as block or sector sizes need
> to be passed the block and sector sizes that they should be using
> for conversion. For parameter parsing, it is always the same two
> variables, so to make things easy just declare them as global
> variables so we can avoid needing to pass them to getnum_checked().
> 
> We also need to mark these parameters are requiring conversion so
> that we don't need to pass this information manually to
> getnum_checked(). Further, some of these options are required to
> have a power of 2 value, so add optional checking for that as well.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>


Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
