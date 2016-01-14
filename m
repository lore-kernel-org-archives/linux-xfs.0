Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14E437F50
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 04:17:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D85C58F8059
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 02:17:35 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id VdpzQ6dy4LRycVlM (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 02:17:31 -0800 (PST)
Date: Thu, 14 Jan 2016 02:17:29 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] Add configure check for members of dirent for use in
	io/readdir.c
Message-ID: <20160114101729.GC27644@infradead.org>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112200022.GG568@nyan> <20160113075855.GG21939@infradead.org>
	<20160113170938.GA10942@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160113170938.GA10942@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jan 13, 2016 at 06:09:38PM +0100, Felix Janda wrote:
> Christoph Hellwig wrote:
> > I think we're having a deeper issue here.  For an LFS build we
> > absolutely should have these values as the kernel dirent64 has them.
> > 
> > Either we manage to not pull in the LFS version of readdir/getdents
> > or musl is doing something inredibly stupid.  Can you investigate if
> > and why we're not using the LFS getdents64 here?
> 
> With musl you always have LFS. However still musl does not define the
> _DIRENT_HAVE_*. You can see the full dirent.h at:
> 
> http://git.musl-libc.org/cgit/musl/tree/include/dirent.h
> 
> I will ask on the musl list whether these constants can be added. So
> you can disregard this patch.

Oh, ok.  That's a little weird, but I guess working around that
with a new autoconf test is fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
