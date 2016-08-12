Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 012757CA2
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 21:57:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C5511304048
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 19:57:05 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id hBygfjwloKDpL3G8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 19:57:04 -0700 (PDT)
Date: Thu, 11 Aug 2016 19:57:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfsprogs 11/14] replace statvfs64 by equivalent statvfs
Message-ID: <20160812025703.GC10701@infradead.org>
References: <cover.1470555003.git.felix.janda@posteo.de>
	<f4fc0b97ae8cdb30f1e0b0d55521f136877b33f5.1470555003.git.felix.janda@posteo.de>
	<20160809074010.GM25647@infradead.org> <20160809174158.GA4476@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809174158.GA4476@nyan>
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

On Tue, Aug 09, 2016 at 07:41:58PM +0200, Felix Janda wrote:
> This patch removes the usage of statvfs64 and thus one of the problems
> for Mac OS X. The other problem is solved by giving a suitable
> definition of f_brsize. Note that this might collide with other uses
> of f_brsize (if they exist). It might be cleaner to just check for Mac
> OS X in xfs_fsr.c.

Yes, that's probably better.  Or simply not build fsr on MacOS given
that there is no kernel XFS support anyway..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
