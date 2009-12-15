Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBF3EOv5199557 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 21:14:24 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A9A3E23AFB
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 19:15:00 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id lr1jWnoLpb3qfFvU for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2009 19:15:00 -0800 (PST)
Message-ID: <4B26FF3D.2020500@sandeen.net>
Date: Mon, 14 Dec 2009 21:15:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [BUG report]xfs_btree_make_block_unfull generated an OOPS
References: <4B1F1211.90607@sandeen.net> <4B1F18C4.3060704@sandeen.net>	
	<389deec70912082053v4310057dg479f6d4b6c4b46f7@mail.gmail.com>	
	<4B1F31FD.3020705@sandeen.net>	
	<389deec70912082220pcb3b5d1q516ac197d31502c5@mail.gmail.com>	
	<389deec70912082230g38987576pc48d7699f23844c5@mail.gmail.com>	
	<389deec70912140119q40ed91cao62fe9c9ebdf13601@mail.gmail.com>	
	<4B26604B.3060901@sandeen.net>	
	<389deec70912141649g767a1540hdeae66707c4c68fd@mail.gmail.com>	
	<20091215012640.GA4850@discord.disaster>
	<389deec70912141756k23776aajbc90c6d7e3fc8d4b@mail.gmail.com>
In-Reply-To: <389deec70912141756k23776aajbc90c6d7e3fc8d4b@mail.gmail.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

hank peng wrote:
> 2009/12/15 Dave Chinner <david@fromorbit.com>:
>> On Tue, Dec 15, 2009 at 08:49:37AM +0800, hank peng wrote:
>>> Hi, Eric:
>>> I add some code like this:
>>> if (*stat) {
>>>                 printk("*stat = 0x%08x, oindex = %p, index = %p\n",
>>>                                 *stat, oindex, index);
>>>                 if (oindex == NULL || index == NULL) {
>> This won't catch bad non-NULL pointers like you are seeing.
>>
>>>                         printk("BUG occured!\n");
>>>                         printk("oindex = %p, index = %p\n", oindex, index);
>>>                         BUG();
>>>                 }
>>>                 *oindex = *index = cur->bc_ptrs[level];
>>>                 return 0;
>>>         }
>>>
>>> And the same OOPS happened again but a little different, kernel messages are:
>>>
>>> <snip>
>>> *stat = 0x00000001, oindex = e87d7bf8, index = e87d7bfc
>>> *stat = 0x00000001, oindex = e87d7bf8, index = e87d7bfc
>>> *stat = 0x00000001, oindex = e87d7bf8, index = e87d7bfc
>>> *stat = 0x00000001, oindex = e87d7bf8, index = e87d7bfc
>>> *stat = 0x00000001, oindex = 00000501, index = 22008424
>>> Unable to handle kernel paging request for data at address 0x22008424

Are you using any of the xfs userspace prior to this error, or is it a
fresh boot and just normal IO?

I ask because libxfs calls sys_ustat() which at one point was corrupting
userspace, at least, with 32-bit userspace on a 64-bit kernel:
https://bugzilla.redhat.com/show_bug.cgi?id=472795

Even with that fixed there were still some reports of odd behavior
on ppc... I don't know if things might be going wrong in kernelspace
as well...

https://bugzilla.redhat.com/show_bug.cgi?id=517994
and I haven't gotten to the bottom of that yet ...

Very few things actually use sys_ustat, but xfs userspace does...
just a random thought.

-eric

>> Given that oindex and index are stack varibles, this indicates some
>> thing is probably smashing the stack. Possibly a buffer overrun. To
>> narrow down the possible cause, can you add the debug:
>>
>>        printk("%s:%s: oindex = %p, index = %p\n",
>>                        __func__, __LINE__, oindex, index);
>>
>> throughout the xfs_btree_make_block_unfull() function? i.e. at
>> first entry, before the xfs_btree_rshift() call, before the
>> xfs_btree_lshift() call, etc, to see if any of the parameters
>> are being modified during execution of the function?
>>
>> If the variables being passed into xfs_btree_make_block_unfull() are
>> already bad, then do the same thing for the caller
>> xfs_btree_insert(). This may help narrow down where the problem
>> is coming from....
>>
> Thanks for your reply!
> As you said, I added some code like this:
> /* First, try shifting an entry to the right neighbor. */
>         printk("%s: before xfs_btree_rshift, oindex = %p, index = %p\n",
>                         __func__, oindex, index);
>         error = xfs_btree_rshift(cur, level, stat);
>         if (error || *stat)
>                 return error;
> 
>         /* Next, try shifting an entry to the left neighbor. */
>         printk("%s: before xfs_btree_lshift, oindex = %p, index = %p\n",
>                         __func__, oindex, index);
>         error = xfs_btree_lshift(cur, level, stat);
>         if (error)
>                 return error;
> 
>         if (*stat) {
>                 printk("*stat = 0x%08x, oindex = %p, index = %p\n",
>                                 *stat, oindex, index);
>                 if (oindex == NULL || index == NULL) {
>                         printk("BUG occured!\n");
>                         printk("oindex = %p, index = %p\n", oindex, index);
>                         BUG();
>                 }
>                 *oindex = *index = cur->bc_ptrs[level];
>                 return 0;
>         }
> 
> 
> xfs_btree_set_ptr_null(cur, &nptr);
>         if (numrecs == cur->bc_ops->get_maxrecs(cur, level)) {
>                 printk("%s: before calling
> xfs_btree_make_block_unfull, &optr = %p, &ptr = %p\n",
>                                 __func__, &optr, &ptr);
>                 error = xfs_btree_make_block_unfull(cur, level, numrecs,
>                                         &optr, &ptr, &nptr, &ncur, &nrec, stat);
>                 if (error || *stat == 0)
>                         goto error0;
>         }
> 
> 
> We are waiting for OOPS to happen.
> 
> I hope it will nerver be memory corrupt problem which is nightmare for
> me to debug.
> 
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
