Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9127B7F47
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 13:09:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83944304053
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 11:09:19 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id 3FFc2fmFPEGqeTA5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 11:09:15 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id DDA3920B88
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 20:09:12 +0100 (CET)
Date: Thu, 14 Jan 2016 20:06:34 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 6/6] Add configure check for members of dirent for use in
	io/readdir.c
Message-ID: <20160114190634.GA627@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112200022.GG568@nyan> <20160113075855.GG21939@infradead.org>
	<20160113170938.GA10942@nyan>
	<20160114101729.GC27644@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160114101729.GC27644@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Jan 13, 2016 at 06:09:38PM +0100, Felix Janda wrote:
> > Christoph Hellwig wrote:
> > > I think we're having a deeper issue here.  For an LFS build we
> > > absolutely should have these values as the kernel dirent64 has them.
> > > 
> > > Either we manage to not pull in the LFS version of readdir/getdents
> > > or musl is doing something inredibly stupid.  Can you investigate if
> > > and why we're not using the LFS getdents64 here?
> > 
> > With musl you always have LFS. However still musl does not define the
> > _DIRENT_HAVE_*. You can see the full dirent.h at:
> > 
> > http://git.musl-libc.org/cgit/musl/tree/include/dirent.h
> > 
> > I will ask on the musl list whether these constants can be added. So
> > you can disregard this patch.
> 
> Oh, ok.  That's a little weird, but I guess working around that
> with a new autoconf test is fine.

Actually, it should also be useful for other systems. For example, on
FreeBSD dirent has d_type (but does not declare _DIRENT_HAVE_D_TYPE),
but currently dump_dirent() does not print it.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
