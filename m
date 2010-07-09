Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o69G9e6h122030 for <xfs@oss.sgi.com>; Fri, 9 Jul 2010 11:09:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67FA2BA1B4F
	for <xfs@oss.sgi.com>; Fri,  9 Jul 2010 09:18:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id t2uwC1pkZM4UXdi2 for
	<xfs@oss.sgi.com>; Fri, 09 Jul 2010 09:18:16 -0700 (PDT)
Date: Fri, 9 Jul 2010 12:12:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfstests] _qmount: mount w/o selinux xattrs
Message-ID: <20100709161232.GA26302@infradead.org>
References: <4C2CF34F.7070008@redhat.com>
	<20100702071006.GB30776@infradead.org>
	<4C2E2687.3080700@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C2E2687.3080700@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs mailing list <xfs@oss.sgi.com>

On Fri, Jul 02, 2010 at 12:48:55PM -0500, Eric Sandeen wrote:
> > What about just disabling selinux for all filesystems instead of just
> > XFS for the general case.
> 
> Well it seems like if we -can- test with it on, that's good.
> Certain distros ship with it on by default, so exercising lots
> of scenarios with it on seems beneficial...

It seems, but I'd rather do it consistently for all filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
