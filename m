Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH9b9bK220673 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:37:09 -0600
Date: Wed, 17 Nov 2010 04:38:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 9/9] xfsrestore: check for compatible xfsrestore
Message-ID: <20101117093842.GI17317@infradead.org>
References: <20101116150502.179825893@sgi.com>
	<20101116150705.423217632@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101116150705.423217632@sgi.com>
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Tue, Nov 16, 2010 at 09:05:11AM -0600, wkendall@sgi.com wrote:
> When resuming a restore or doing a cumulative restore, xfsrestore
> reads state information left around by the previous invocation.
> This patch adds logic to determine whether or not restore is
> able to make sense of the sense information.
> 
> The xfsrestore man page has also been updated to make the user
> aware of the requirement to use a compatible restore and
> system when resuming restores.

Shouldn't you use the opportunity to switch everything in the on-disk
layout to explicitly sized types?  Seeing things like the bool types
in the persistant structures really scares me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
