Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7ULkhkS025576 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 16:46:43 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 573B21E5869E
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 14:47:21 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id NMnnOUSriNaI0ODs for
	<xfs@oss.sgi.com>; Mon, 30 Aug 2010 14:47:21 -0700 (PDT)
Message-ID: <4C7C26E8.9070308@sandeen.net>
Date: Mon, 30 Aug 2010 16:47:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: What should to do with ASSERT failed
References: <AANLkTin-zf0chkk68pGfwDRt03QaKmNdsP3=goDEUS+p@mail.gmail.com>
In-Reply-To: <AANLkTin-zf0chkk68pGfwDRt03QaKmNdsP3=goDEUS+p@mail.gmail.com>
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
To: Mike Gao <ygao.linux@gmail.com>
Cc: xfs@oss.sgi.com

Mike Gao wrote:
> xfs_vm_writepage
> {
>                /*
> * A hole may still be marked uptodate because discard_buffer
> * leaves the flag set.
> */
> if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
> ASSERT(!buffer_dirty(bh));
> imap_valid = 0;
> continue;
> }
> }
> 
> I met this case that buffer is marked as dirty which make assert failed. 
> What does this mean and what I can do with it?

You can report it here, with more information on what load you were running,
and the full backtrace that the ASSERT generated... thanks!

And it means that we think we are in a hole, but the buffer for
that hole is marked dirty, which we did not expect ...

The change went in with this commit:

3d9b02e3c76531687ab5314e0edf266256f13c2d xfs: fix corruption case for block size < page size

which was attempting to fix a very specific file corruption case.

What kernel are you running on?

What block size are you using?  (xfs_info will tell you)

Thanks,
-Eric

> Thanks very much,
> Mike
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
