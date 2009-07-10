Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6A7BiTa083200 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 02:11:45 -0500
Received: from fgwmail5.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94B78355BF4
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 00:12:19 -0700 (PDT)
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id Il6eomRkAY0MUCkP for
	<xfs@oss.sgi.com>; Fri, 10 Jul 2009 00:12:19 -0700 (PDT)
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id
	n6A7CHWa006342
	for <xfs@oss.sgi.com> (envelope-from kosaki.motohiro@jp.fujitsu.com);
	Fri, 10 Jul 2009 16:12:17 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 22FB045DE55
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 16:12:17 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id CABCC45DE57
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 16:12:16 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 307171DB8042
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 16:12:16 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.249.87.107])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id C68D11DB803B
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 16:12:15 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
In-Reply-To: <20090709130134.GH18008@think>
References: <20090709110342.2386.A69D9226@jp.fujitsu.com>
	<20090709130134.GH18008@think>
Message-Id: <20090710153349.17EC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Date: Fri, 10 Jul 2009 16:12:15 +0900 (JST)
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
To: Chris Mason <chris.mason@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, kosaki.motohiro@jp.fujitsu.com, xfs mailing list <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Olaf Weber <olaf@sgi.com>

> On Thu, Jul 09, 2009 at 11:04:32AM +0900, KOSAKI Motohiro wrote:
> > > On Tue, Jul 07, 2009 at 07:33:04PM +0900, KOSAKI Motohiro wrote:
> > > > At least, I agree with Olaf. if you got someone's NAK in past thread,
> > > > Could you please tell me its url?
> > > 
> > > The previous thread was simply dead-ended and nothing happened.
> > > 
> > 
> > Can you remember this thread subject? sorry, I haven't remember it.
> 
> This is the original thread, it did lead to a few different patches
> going in, but the nr_to_write change wasn't one of them.
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2008/10/1/3472704/thread

Thanks good pointer. This thread have multiple interesting discussion.

1. making ext4_write_cache_pages() or modifying write_cache_pages()

I think this is Christoph's homework. he said

> I agree.  But I'm still not quite sure if that requirement is unique to
> ext4 anyway.  Give me some time to dive into the writeback code again,
> haven't been there for quite a while.

if he says modifying write_cache_pages() is necessary, I'd like to review it.


2. Current mapping->writeback_index updating is not proper?

I'm not sure which solution is better. but I think your first proposal is
enough acceptable.


3. Current wbc->nr_to_write value is not proper?

Current writeback_set_ratelimit() doesn't permit that ratelimit_pages exceed
4M byte. but it is too low restriction for nowadays.
(that's my understand. right?)

=======================================================
void writeback_set_ratelimit(void)
{
        ratelimit_pages = vm_total_pages / (num_online_cpus() * 32);
        if (ratelimit_pages < 16)
                ratelimit_pages = 16;
        if (ratelimit_pages * PAGE_CACHE_SIZE > 4096 * 1024)
                ratelimit_pages = (4096 * 1024) / PAGE_CACHE_SIZE;
}
=======================================================

Yes, 4M bytes are pretty magical constant. We have three choice
  A. Remove magical 4M constant simple (a bit danger)
  B. Decide high border from IO capability
  C. Introduce new /proc knob (as Olaf proposed)


In my personal prefer, B & C are better.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
