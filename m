Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MJg4Dr254638 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 14:42:04 -0500
Subject: Re: [PATCH] xfstests: test timestamps before the epoch
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4E778C51.7040100@redhat.com>
References: <4E778C51.7040100@redhat.com>
Date: Thu, 22 Sep 2011 14:41:59 -0500
Message-ID: <1316720519.2009.53.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, 2011-09-19 at 13:39 -0500, Eric Sandeen wrote:
> ext2/3/4 was sign-extending times before the timestamp when read
> from disk on 64-bit systems.  This was fixed by:
> 
> 4d7bf11d649c72621ca31b8ea12b9c94af380e63
> ext2/3/4: fix file date underflow on ext2 3 filesystems on 64 bit systems
> 
> Here's a generic regression test.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
