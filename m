Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA2277F51
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 15:18:23 -0500 (CDT)
Date: Fri, 25 Oct 2013 15:18:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 18/19] xfs: vectorise directory leaf operations
Message-ID: <20131025201819.GZ1935@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381789085-21923-19-git-send-email-david@fromorbit.com>
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

On Tue, Oct 15, 2013 at 09:18:04AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Next step in the vectorisation process is the directory free block
> encode/decode operations. There are relatively few of these, though
> there are quite a numberof calls to them.
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
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good except for the two lines that snuck in from the previous patch.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
