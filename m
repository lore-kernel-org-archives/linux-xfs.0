Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4BEjg4n094959 for <xfs@oss.sgi.com>; Tue, 11 May 2010 09:45:42 -0500
Subject: Re: [77/98] xfs: add a shrinker to background inode reclaim
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100510223541.333994587@kvm.kroah.org>
References: <20100510223541.333994587@kvm.kroah.org>
Date: Tue, 11 May 2010 09:47:20 -0500
Message-ID: <1273589240.2674.15.camel@doink>
Mime-Version: 1.0
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
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, stable-review@kernel.org, Dave Chinner <dchinner@redhat.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable@kernel.org, alan@lxorguk.ukuu.org.uk

On Mon, 2010-05-10 at 15:35 -0700, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.

Acked-by: Alex Elder <aelder@sgi.com>

> ------------------
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> commit 9bf729c0af67897ea8498ce17c29b0683f7f2028 upstream
> 
> On low memory boxes or those with highmem, kernel can OOM before the
> background reclaims inodes via xfssyncd. Add a shrinker to run inode
> reclaim so that it inode reclaim is expedited when memory is low.
> 
...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
