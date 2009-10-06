Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96D8t6e062822 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 08:08:57 -0500
Date: Tue, 6 Oct 2009 09:10:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage in XFS
Message-ID: <20091006131020.GA12343@infradead.org>
References: <4ACB3AC5.4010603@vlnb.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ACB3AC5.4010603@vlnb.net>
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
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com

On Tue, Oct 06, 2009 at 04:40:37PM +0400, Vladislav Bolkhovitin wrote:
> Hello,
>
> After upgrading to 2.6.31 with SCST testings I started seeing the  
> following lockdep messages. I have not seen them in 2.6.29. Looks like  
> it's something recently introduced.

The lockdep code to track this has been recently introduced.

I've sent some patches to fix it ages ago, but so far no one has
bothered to review them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
