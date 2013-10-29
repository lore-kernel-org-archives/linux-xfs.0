Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E1EB97F4E
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 14:22:12 -0500 (CDT)
Date: Tue, 29 Oct 2013 14:22:09 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 11/15] xfs: convert directory vector functions to constants
Message-ID: <20131029192209.GE1935@sgi.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
	<1383045118-31107-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383045118-31107-12-git-send-email-david@fromorbit.com>
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

On Tue, Oct 29, 2013 at 10:11:54PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Many of the vectorised function calls now take no parameters and
> return a constant value. There is no reason for these to be vectored
> functions, so convert them to constants
> 
> Binary sizes:
> 
>    text    data     bss     dec     hex filename
>  794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
>  792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
>  792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
>  789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
>  789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
>  789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
>  789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
>  791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7
>  791701   96802    1096  889599   d92ff fs/xfs/xfs.o.p8
>  791205   96802    1096  889103   d91cf fs/xfs/xfs.o.p9
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
