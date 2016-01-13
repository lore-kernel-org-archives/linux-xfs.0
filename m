Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D32767F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 11:12:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B335C30405F
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 09:12:35 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id m3E1W6b5CSssElcA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2016 09:12:29 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 5B1D320BBC
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 18:12:23 +0100 (CET)
Date: Wed, 13 Jan 2016 18:09:38 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 6/6] Add configure check for members of dirent for use in
	io/readdir.c
Message-ID: <20160113170938.GA10942@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112200022.GG568@nyan> <20160113075855.GG21939@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160113075855.GG21939@infradead.org>
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
> I think we're having a deeper issue here.  For an LFS build we
> absolutely should have these values as the kernel dirent64 has them.
> 
> Either we manage to not pull in the LFS version of readdir/getdents
> or musl is doing something inredibly stupid.  Can you investigate if
> and why we're not using the LFS getdents64 here?

With musl you always have LFS. However still musl does not define the
_DIRENT_HAVE_*. You can see the full dirent.h at:

http://git.musl-libc.org/cgit/musl/tree/include/dirent.h

I will ask on the musl list whether these constants can be added. So
you can disregard this patch.


However notice that these constants are not defined when not on linux
or with glibc, e.g. freebsd (without k). On these systems the code in
io/readdir.c just happens to have worked because either
dirent.d_namelen exists or nobody has tested it on these systems.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
