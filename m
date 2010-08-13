Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DCSfao056745 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 07:28:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B42964B3D2E
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 05:29:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id G8mKzuHFcEdEhThr for
	<xfs@oss.sgi.com>; Fri, 13 Aug 2010 05:29:08 -0700 (PDT)
Date: Fri, 13 Aug 2010 08:29:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: observed significant performance improvement using "delaylog" in
Message-ID: <20100813122907.GA14650@infradead.org>
References: <201008121346.30760.eye.of.the.8eholder@gmail.com>
	<i41q43$6td$1@dough.gmane.org> <4C6516CA.2010602@hardwarefreak.com>
	<201008131235.45050@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201008131235.45050@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Fri, Aug 13, 2010 at 12:35:44PM +0200, Michael Monnerie wrote:
> On Freitag, 13. August 2010 Stan Hoeppner wrote:
> > Some benchmark results maybe worth a look:
> > http://btrfs.boxacle.net/repository/raid/2.6.35-rc5/2.6.35-rc5/
>  
> Thanks - it would have been great to see xfs with delaylog in that 
> comparison, but the graphs are very very nice.
> 
> XFS seems performing better the more threads there are, just in "large 
> file random reads" it's the slowest - why this?

Any idea who is doing these runs?  Once we figure out what that large
file random reads loads is I'm sure we could fix it soon.  And asking
him/her to add -o delaylog would also be good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
