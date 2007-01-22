Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 05:15:42 -0800 (PST)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0MDFZqw031582
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 05:15:36 -0800
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 6FFAE21270
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 13:55:21 +0100 (CET)
From: Jean Delvare <jdelvare@suse.de>
Subject: Memory allocation in xfs
Date: Mon, 22 Jan 2007 13:58:09 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701221358.09300.jdelvare@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

While investigating a customer-reported issue, I noticed the following code in 
the xfs filesystem (in linux/fs/xfs/linux-2.6/kmem.c):

#define MAX_VMALLOCS    6
#define MAX_SLAB_SIZE   0x20000

void *
kmem_alloc(size_t size, int flags)
{
        int     retries = 0;
        int     lflags = kmem_flags_convert(flags);
        void    *ptr;

        do {
                if (size < MAX_SLAB_SIZE || retries > MAX_VMALLOCS)
                        ptr = kmalloc(size, lflags);
                else
                        ptr = __vmalloc(size, lflags, PAGE_KERNEL);
                if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
                        return ptr;
                if (!(++retries % 100))
                        printk(KERN_ERR "XFS: possible memory allocation "
                                        "deadlock in %s (mode:0x%x)\n",
                                        __FUNCTION__, lflags);
                blk_congestion_wait(WRITE, HZ/50);
        } while (1);
}

If I read it correctly, it first chooses between kmalloc and vmalloc based on 
size, picking kmalloc if the size is less than 128 kB, and vmalloc if it's 
larger. So far, so good, makes sense to me.

Then, if 6 attempts at vmalloc failed, it switches to kmalloc regardless of 
the size. I read in LDD3 that some architectures have a relatively small 
address space reserved for vmalloc, I guess this explains why this fallback 
was implemented. Am I correct? I wonder if it's really a good idea to then 
insist on kmalloc if kmalloc fails too, but at this point it probably no 
longer matters, we're doomed...

What I am curious about is why the fallback in the other direction wasn't 
implemented. If we need an amount of memory less than 128 kB and kmalloc 
keeps failing, isn't it worth trying vmalloc? Disclaimer: I am just trying to 
learn how the memory management works in Linux 2.6, so I might as well be 
totally wrong.

Thanks,
-- 
Jean Delvare
Suse L3
