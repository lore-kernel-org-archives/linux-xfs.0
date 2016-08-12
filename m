Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 46A0F7CA1
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 11:55:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEA68AC003
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 09:55:42 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id 1StLj8WFtREndgMV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Aug 2016 09:55:36 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 211DC20850
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 18:55:34 +0200 (CEST)
Date: Fri, 12 Aug 2016 18:54:40 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH xfsprogs 01/14] configure: use AC_SYS_LARGEFILE
Message-ID: <20160812165440.GA367@nyan>
References: <cover.1470555003.git.felix.janda@posteo.de>
	<ea8cca9bf1dbeb13a788f85f73d6bafbcc374a89.1470555003.git.felix.janda@posteo.de>
	<20160809073611.GC25647@infradead.org> <20160809174105.GA5907@nyan>
	<20160812025753.GD10701@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160812025753.GD10701@infradead.org>
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
> On Tue, Aug 09, 2016 at 07:41:05PM +0200, Felix Janda wrote:
> > Thanks for reviewing the patch series!
> > 
> > > Does this also error out for libraries that don't support large
> > > off_t at all?  I think that would be helpful to add if not there yet.
> > 
> > I do not quite understand. Do you refer to libraries using libxfs or
> > the external libraries used by xfsprogs?
> 
> I meant C libraries, sorry.  E.g. uclibc used to not support LFS
> many years ago, although they probably fixed it up by now.

Thaks for clarifying.

If a libc does not support LFS, with this patch series the build will
fail soon, because of the off_t size check in xfs.h.

The support of transparent LFS in different c libraries on linux seems
to be the following:

glibc: since version 2.2 (2000)
uClibc: since version 0.9.11 (2002)
dietlibc: since version 0.8 (2001)
klibc: AFAICS since beginning only transparent LFS
musl: since beginning only transparent LFS
bionic: In 2015 _FILE_OFFSET_BITS was implemented "mostly"...
newlib: (except on cygwin) does not seem to have support for transparent LFS

Note that LFS can be configured out of uClibc. However its headers
error out when it is configured out and an application sets
_FILE_OFFSET_BITS. (So in the case of xfsprogs it would have errored
out in this situation already earlier.)


So it seems that this patch series breaks newlib support...

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
