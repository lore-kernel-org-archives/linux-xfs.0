Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3T8lbqp052615 for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 03:47:38 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D19FD11BB330
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 01:51:10 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id S6E1NPV2D9CC2Qyk
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 01:51:10 -0700 (PDT)
Message-ID: <4DBA7BF8.7030002@dermichi.com>
Date: Fri, 29 Apr 2011 10:51:04 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: vmap allocation for size 1048576 failed
References: <4CD924A6.6040200@dermichi.com>
	<20101109120701.GN2715@dastard>	<4CDA54E3.308@dermichi.com>
	<20101110123052.GW2715@dastard>
In-Reply-To: <20101110123052.GW2715@dastard>
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
To: xfs@oss.sgi.com

Hi Dave!
On Wed Nov 10 2010 13:30:52 GMT+0100 (CET), Dave Chinner
<david@fromorbit.com> wrote:
> Ok, thanks for the info. I'm struggling to work out what is actually
> consuming vmap space given what you are doing and the storage
> config. None of the operations you are doing should be triggering
> mapping of multipage metadata buffers given the filesystem
> configuration....
Coming back to this, i can confirm that your patch "[PATCH 2/6] vmap:
flush vmap aliases when mapping fails" posted on March 23 2011 did cure
my problems.

with kind regards,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
