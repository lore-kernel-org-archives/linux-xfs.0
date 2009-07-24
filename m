Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6O5WNIn108903 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 00:32:24 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5345F13D9A32
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 22:33:06 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id oqyJgDkDW0i5uHBj for
	<xfs@oss.sgi.com>; Thu, 23 Jul 2009 22:33:06 -0700 (PDT)
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id
	n6O5X4iI019103
	for <xfs@oss.sgi.com> (envelope-from kosaki.motohiro@jp.fujitsu.com);
	Fri, 24 Jul 2009 14:33:04 +0900
Received: from smail (m5 [127.0.0.1])
	by outgoing.m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 4563945DE4F
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 14:33:04 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (s5.gw.fujitsu.co.jp [10.0.50.95])
	by m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 1624745DE4E
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 14:33:04 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 018B0E1800B
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 14:33:04 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 9DA33E1800C
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 14:33:03 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
In-Reply-To: <7149D747-2769-4559-BAF6-AAD2B6C6C941@sgi.com>
References: <20090710153349.17EC.A69D9226@jp.fujitsu.com>
	<7149D747-2769-4559-BAF6-AAD2B6C6C941@sgi.com>
Message-Id: <20090724143159.67B6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Date: Fri, 24 Jul 2009 14:33:02 +0900 (JST)
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Olaf Weber <olaf@sgi.com>, xfs mailing list <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com, Chris Mason <chris.mason@oracle.com>

> 
> On Jul 10, 2009, at 2:12 AM, KOSAKI Motohiro wrote:
> 
> >> On Thu, Jul 09, 2009 at 11:04:32AM +0900, KOSAKI Motohiro wrote:
> >>>> On Tue, Jul 07, 2009 at 07:33:04PM +0900, KOSAKI Motohiro wrote:
> >>>>> At least, I agree with Olaf. if you got someone's NAK in past  
> >>>>> thread,
> >>>>> Could you please tell me its url?
> >>>>
> >>>> The previous thread was simply dead-ended and nothing happened.
> >>>>
> >>>
> >>> Can you remember this thread subject? sorry, I haven't remember it.
> >>
> >> This is the original thread, it did lead to a few different patches
> >> going in, but the nr_to_write change wasn't one of them.
> >>
> >> http://kerneltrap.org/mailarchive/linux-kernel/2008/10/1/3472704/thread
> >
> > Thanks good pointer. This thread have multiple interesting discussion.
> >
> > 1. making ext4_write_cache_pages() or modifying write_cache_pages()
> >
> > I think this is Christoph's homework. he said
> >
> >> I agree.  But I'm still not quite sure if that requirement is  
> >> unique to
> >> ext4 anyway.  Give me some time to dive into the writeback code  
> >> again,
> >> haven't been there for quite a while.
> >
> > if he says modifying write_cache_pages() is necessary, I'd like to  
> > review it.
> >
> >
> > 2. Current mapping->writeback_index updating is not proper?
> >
> > I'm not sure which solution is better. but I think your first  
> > proposal is
> > enough acceptable.
> >
> >
> > 3. Current wbc->nr_to_write value is not proper?
> >
> > Current writeback_set_ratelimit() doesn't permit that  
> > ratelimit_pages exceed
> > 4M byte. but it is too low restriction for nowadays.
> > (that's my understand. right?)
> >
> > =======================================================
> > void writeback_set_ratelimit(void)
> > {
> >        ratelimit_pages = vm_total_pages / (num_online_cpus() * 32);
> >        if (ratelimit_pages < 16)
> >                ratelimit_pages = 16;
> >        if (ratelimit_pages * PAGE_CACHE_SIZE > 4096 * 1024)
> >                ratelimit_pages = (4096 * 1024) / PAGE_CACHE_SIZE;
> > }
> > =======================================================
> >
> > Yes, 4M bytes are pretty magical constant. We have three choice
> >  A. Remove magical 4M constant simple (a bit danger)
> 
> That's will be outside the xfs, and seems like there is no much interest
> from mm people.

That's ok. you can join mm people :)



> >  B. Decide high border from IO capability
> 
> It's not clear to me how to calculate that high border, but again
> it's outside of the xfs scope, and we don't have much control here.
> 
> >  C. Introduce new /proc knob (as Olaf proposed)
> 
> We need at least to play with different numbers, and putting the
> knob (xfs tunable) would be one way to do it. Also, different
> configurations may need different nr_to_write value.
> 
> In either way it seems hackish, but with the knob at least there is
> some control of it.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
