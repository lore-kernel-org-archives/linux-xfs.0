Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBF1QHgn194365 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 19:26:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5132F19783A6
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 17:26:54 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	kV7LhIvl42q3X27F for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 17:26:54 -0800 (PST)
Date: Tue, 15 Dec 2009 12:26:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG report]xfs_btree_make_block_unfull generated an OOPS
Message-ID: <20091215012640.GA4850@discord.disaster>
References: <4B1F1211.90607@sandeen.net>
	<389deec70912081918v24ccc5abi90c8fc7546c741d7@mail.gmail.com>
	<4B1F18C4.3060704@sandeen.net>
	<389deec70912082053v4310057dg479f6d4b6c4b46f7@mail.gmail.com>
	<4B1F31FD.3020705@sandeen.net>
	<389deec70912082220pcb3b5d1q516ac197d31502c5@mail.gmail.com>
	<389deec70912082230g38987576pc48d7699f23844c5@mail.gmail.com>
	<389deec70912140119q40ed91cao62fe9c9ebdf13601@mail.gmail.com>
	<4B26604B.3060901@sandeen.net>
	<389deec70912141649g767a1540hdeae66707c4c68fd@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <389deec70912141649g767a1540hdeae66707c4c68fd@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 15, 2009 at 08:49:37AM +0800, hank peng wrote:
> Hi, Eric:
> I add some code like this:
> if (*stat) {
>                 printk("*stat = 0x%08x, oindex = %p, index = %p\n",
>                                 *stat, oindex, index);
>                 if (oindex == NULL || index == NULL) {

This won't catch bad non-NULL pointers like you are seeing.

>                         printk("BUG occured!\n");
>                         printk("oindex = %p, index = %p\n", oindex, index);
>                         BUG();
>                 }
>                 *oindex = *index = cur->bc_ptrs[level];
>                 return 0;
>         }
> 
> And the same OOPS happened again but a little different, kernel messages are:
> 
> <snip>
> *stat = 0x00000001, oindex = e87d7bf8, index = e87d7bfc
> *stat = 0x00000001, oindex = e87d7bf8, index = e87d7bfc
> *stat = 0x00000001, oindex = e87d7bf8, index = e87d7bfc
> *stat = 0x00000001, oindex = e87d7bf8, index = e87d7bfc
> *stat = 0x00000001, oindex = 00000501, index = 22008424
> Unable to handle kernel paging request for data at address 0x22008424

Given that oindex and index are stack varibles, this indicates some
thing is probably smashing the stack. Possibly a buffer overrun. To
narrow down the possible cause, can you add the debug:

	printk("%s:%s: oindex = %p, index = %p\n",
			__func__, __LINE__, oindex, index);

throughout the xfs_btree_make_block_unfull() function? i.e. at
first entry, before the xfs_btree_rshift() call, before the
xfs_btree_lshift() call, etc, to see if any of the parameters
are being modified during execution of the function?

If the variables being passed into xfs_btree_make_block_unfull() are
already bad, then do the same thing for the caller
xfs_btree_insert(). This may help narrow down where the problem
is coming from....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
