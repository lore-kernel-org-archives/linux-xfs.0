Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Oct 2006 07:03:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9FE3QaG020951
	for <xfs@oss.sgi.com>; Sun, 15 Oct 2006 07:03:29 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC117D1343F7
	for <xfs@oss.sgi.com>; Sun, 15 Oct 2006 07:02:43 -0700 (PDT)
Message-ID: <45323F7F.80807@sandeen.net>
Date: Sun, 15 Oct 2006 09:02:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: corrupted log causes infinite loop at mount
References: <452FECFE.5050902@sandeen.net> <4531CC5D.5010705@melbourne.sgi.com>
In-Reply-To: <4531CC5D.5010705@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: chatz@melbourne.sgi.com
Cc: xfs@oss.sgi.com

David Chatterton wrote:
> I assume the loop is further up the chain since kmem_alloc should return NULL
> when asked to alloc 0. So then the problem also lies further up the chain in
> checking for a 0 length before calling down, and/or not assuming we are out of
> memory when xfs_buf_get_noaddr fails.

Well, I set kdb breakpoints, and we only entered xfs_buf_get_noaddr once, so I 
assume it's looping inside.  But I was looking for bugs on, um, another 
filesystem at the time, so didn't investigate much.

I can put it on my list of spare-time bugs to look at, or just thought you guys 
may be interested as well.

-Eric

p.s. ok can't help but look just a bit further...

a test module which does:

int __init test_init(void)
{
         void *data;
         int size = 0;

         data = kmalloc(size, GFP_KERNEL);
         if (data == NULL) {
                 printk("got NULL for alloc return\n");
                 return -1;
         } else {
                 printk("allocated %d bytes at %p\n", size, data);
                 return 0;
         }

}

yields:

allocated 0 bytes at ffff810029d88480

not NULL... nifty eh!

-Eric
