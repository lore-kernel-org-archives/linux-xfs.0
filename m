Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1EJh8XA119727 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 13:43:08 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	h5jKYHOwYZPZJitE (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Feb 2012 11:43:07 -0800 (PST)
Date: Tue, 14 Feb 2012 14:43:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
Message-ID: <20120214194306.GA7399@infradead.org>
References: <20120213171556.GA13449@infradead.org>
	<4F3947D6.5060402@cape-horn-eng.com>
	<20120213172937.GA25248@infradead.org>
	<4F394E10.9000804@cape-horn-eng.com>
	<20120213180220.GA24163@infradead.org>
	<4F395134.8030202@cape-horn-eng.com>
	<20120213181012.GA27962@infradead.org>
	<4F395B1A.7010709@cape-horn-eng.com>
	<20120213211654.GA20192@infradead.org>
	<4F3A2DE9.5050901@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F3A2DE9.5050901@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 14, 2012 at 10:48:25AM +0100, Richard Ems wrote:
> It didn't improve, 100 min again.
> 
> 
> 
> >> Or will only unlink run time improve ?
> > 
> > Yes.
> 
> rm took about 110 min.

In that case you're pretty much bound by the time the directory
traversals help.

Using larger inodes will help you as we won't have to seek for the
external attribute block.  Not filling a fs 100% will probably help by
reducing the fragmentaion, as will using larger directory blocks
as suggested by Dave.

A patch to improve the unlink path won't help the traversal speed
ever, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
