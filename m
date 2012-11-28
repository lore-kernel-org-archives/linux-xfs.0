Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qASDSh7P181933 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 07:28:43 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hf8GGxAZPQEWpXPz (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 05:31:00 -0800 (PST)
Date: Wed, 28 Nov 2012 08:30:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: fix sparse reported log CRC endian issue
Message-ID: <20121128133059.GC2765@infradead.org>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1354068063-1692-5-git-send-email-david@fromorbit.com>
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

On Wed, Nov 28, 2012 at 01:01:03PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Not a bug as such, just warning noise from the xlog_cksum()
> returning a __be32 type when it shoul dbe returning a __le32 type.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

The patch look okay.

But why are we storing the crc field little endian while all other on
disk formats are big endian? (And yes I realize it might as well have
been me who did that back in the idea, but I still have no idea why)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
