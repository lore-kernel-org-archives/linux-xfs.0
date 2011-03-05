Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p250o3vu199951 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 18:50:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1EC441AFA6A7
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 16:52:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id v3xm2p7p3GdBxtMr for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 16:52:54 -0800 (PST)
Date: Fri, 4 Mar 2011 19:52:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: git xfsprogs don't build
Message-ID: <20110305005253.GA11865@infradead.org>
References: <20110304163608.GB2030@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110304163608.GB2030@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On Fri, Mar 04, 2011 at 05:36:08PM +0100, Marc Lehmann wrote:
> That almost certainly means somebody tried to build a shared object or
> library with some object file compiled without -fPIC.

That function indeed doesn't exist in non-debug builds.  But by default
we do not build xfsprogs that way.  For now make sure to not have
-DNDEBUG in your CFLAGS, I'll make sure we get a proper fix commited.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
