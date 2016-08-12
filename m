Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A2E67CA2
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 15:23:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D702430404E
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 13:23:57 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id SWS6aiK4xMYbcH8n (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Aug 2016 13:23:55 -0700 (PDT)
Date: Fri, 12 Aug 2016 13:23:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfsprogs 01/14] configure: use AC_SYS_LARGEFILE
Message-ID: <20160812202352.GA2085@infradead.org>
References: <cover.1470555003.git.felix.janda@posteo.de>
	<ea8cca9bf1dbeb13a788f85f73d6bafbcc374a89.1470555003.git.felix.janda@posteo.de>
	<20160809073611.GC25647@infradead.org> <20160809174105.GA5907@nyan>
	<20160812025753.GD10701@infradead.org> <20160812165440.GA367@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160812165440.GA367@nyan>
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

On Fri, Aug 12, 2016 at 06:54:40PM +0200, Felix Janda wrote:
> glibc: since version 2.2 (2000)
> uClibc: since version 0.9.11 (2002)
> dietlibc: since version 0.8 (2001)
> klibc: AFAICS since beginning only transparent LFS
> musl: since beginning only transparent LFS
> bionic: In 2015 _FILE_OFFSET_BITS was implemented "mostly"...
> newlib: (except on cygwin) does not seem to have support for transparent LFS
> 
> Note that LFS can be configured out of uClibc. However its headers
> error out when it is configured out and an application sets
> _FILE_OFFSET_BITS. (So in the case of xfsprogs it would have errored
> out in this situation already earlier.)
> 
> 
> So it seems that this patch series breaks newlib support...

I think that's fine, newlib hasn't every really been a supported
config.  The point I tried to make is that we should aim to error
out during ./configure for this case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
