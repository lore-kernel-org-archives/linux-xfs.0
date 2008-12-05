Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB5IZBfB005182 for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 12:35:12 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11B6816A2B9B
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2008 10:35:10 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id BIH41JYuudEISH03 for
	<xfs@oss.sgi.com>; Fri, 05 Dec 2008 10:35:10 -0800 (PST)
Date: Fri, 5 Dec 2008 19:41:14 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
Message-ID: <20081205184114.GE6703@one.firstfloor.org>
References: <bFquY-2x2-5@gated-at.bofh.it> <bFsnc-51o-37@gated-at.bofh.it>
	<bFuyC-7Zt-11@gated-at.bofh.it> <bFvuI-L8-29@gated-at.bofh.it>
	<bFwTJ-2oc-13@gated-at.bofh.it> <bFxwq-3g7-1@gated-at.bofh.it>
	<bFxGa-3pz-1@gated-at.bofh.it> <bFHvW-7up-5@gated-at.bofh.it>
	<bFHPd-84I-13@gated-at.bofh.it>
	<E1L8fIY-0001ui-DV@be1.7eggert.dyndns.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E1L8fIY-0001ui-DV@be1.7eggert.dyndns.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Bodo Eggert <7eggert@gmx.de>
Cc: Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andi Kleen <andi@firstfloor.org>, Mikulas Patocka <mpatocka@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>

On Fri, Dec 05, 2008 at 07:21:06PM +0100, Bodo Eggert wrote:
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> >> Not when the fundamental design of the code is broken and trashes
> >> performance.
> > 
> > Sorry but that's just not correct. There's nothing in late failing
> > barriers that "trashes performance". The file system writers have 
> > to be careful to handle it, but at least the current ones all do.
> 
> So let's keep requiring the "trashes performance" hacks, because they're

Again there's nothing about the code that handles this that 
"trashes performance". 

Mickulas was just ranting that the current file systems don't use
barriers in the way he thinks they ought to be used, but that
is completely orthogonal to the problem if barriers may fail
late or not.

In Mickulas imaginary barrier world it would be slightly more 
complicated to handle it, but far from impossible. And again
if there it wouldn't affect performance. In the real world
Linux barrier world handling late failing barriers in the fs
is also very easy currently.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
