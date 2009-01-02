Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n02HxCv1018581 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 11:59:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 026CD1BFA410
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 09:59:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 84kPTlsjFuVFFKPN for
	<xfs@oss.sgi.com>; Fri, 02 Jan 2009 09:59:11 -0800 (PST)
Date: Fri, 2 Jan 2009 12:59:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: oopses in xfs_attr_shortform_* on kerneloops.org
Message-ID: <20090102175911.GA29506@infradead.org>
References: <495D91A0.4050304@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <495D91A0.4050304@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jan 01, 2009 at 10:01:36PM -0600, Eric Sandeen wrote:
> I noticed this on kerneloops.org and pinged Christoph about it but I'll
> go ahead & point it out here & file a bug so it doesn't get lost:
> 
> http://www.kerneloops.org/search.php?search=xfs_attr_shortform&btnG=Function+Search
> 
> would seem to indicate a problem, though not a (recent) regression anyway.

Yeah, I've been looking into and the disassemly looks like we have
a NULL attribut fork pointer for some reason.  I did some poking
around in the code and couldn't a cause for it.  So if anyone of
the kerneloops submitters actually is on the list and can reproduce
it that would be extremly helpful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
