Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BBjmgq162433 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 05:45:48 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	us0YkOahE8IbcZVP for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 03:45:47 -0800 (PST)
Date: Wed, 11 Jan 2012 06:45:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix 251's cp -axT problem
Message-ID: <20120111114544.GE14423@infradead.org>
References: <1326195560-4434-1-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326195560-4434-1-git-send-email-liubo2009@cn.fujitsu.com>
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
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jan 10, 2012 at 07:39:20PM +0800, Liu Bo wrote:
> When I ran xfstests, 251 got failed cause "cp -axT" did not work as wish:
> cp: cannot overwrite directory `/mnt/scratch/1' with non-directory
> 
> With this patch, 251 has passed.

Why would cp give that message with a missing /?

I'm not against putting this in, but I'd like to understand what's going
on.

Lukas, any idea?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
