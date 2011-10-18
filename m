Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9IHkfJK115437 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 12:46:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A46F0153188B
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 10:54:33 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ohrXjHrwpnWAFMQG for <xfs@oss.sgi.com>;
	Tue, 18 Oct 2011 10:54:33 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RGDkK-0003Hc-D7
	for xfs@oss.sgi.com; Tue, 18 Oct 2011 17:46:36 +0000
Date: Tue, 18 Oct 2011 13:46:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/14] RFC: quota updates
Message-ID: <20111018174636.GA12575@infradead.org>
References: <20110831203647.455809764@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110831203647.455809764@bombadil.infradead.org>
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
To: xfs@oss.sgi.com

On Wed, Aug 31, 2011 at 04:36:47PM -0400, Christoph Hellwig wrote:
> This is my current batch of quota updates.  Most important is the removal
> of runtime explicit quota flusing, and a new lock order for the quota
> manager locks.  In addition to that there are various cleanups.
> 
> This survices xfstests (with or without quotas enabled on the test device)
> for quite a few runs, but I haven't done any performance testing.

Any comments on these?  At least the first five should be low risk
enough to go in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
