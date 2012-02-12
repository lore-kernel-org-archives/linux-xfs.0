Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1CNiU15216446 for <xfs@oss.sgi.com>; Sun, 12 Feb 2012 17:44:31 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dPSFWIAuFn5Ospgn (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Feb 2012 15:44:27 -0800 (PST)
Date: Sun, 12 Feb 2012 18:44:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: quotacheck speed
Message-ID: <20120212234425.GA23625@infradead.org>
References: <201202122201.07649.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201202122201.07649.arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Sun, Feb 12, 2012 at 10:01:07PM +0100, Arkadiusz Mi??kiewicz wrote:
> 
> Hi,
> 
> When mounting 800GB filesystem (after repair for example) here quotacheck 
> takes 10 minutes. Quite long time that adds to whole time of filesystem 
> downtime (repair + quotacheck).
> 
> I wonder if quotacheck can be somehow improved or done differently like doing 
> it in parallel with normal fs usage (so there will be no downtime) ?

I think the best idea to improve the performance in case you did a
repair is to integrate the quotacheck code into repair.  It's fairly
simple given that quotacheck simply walks all inodes and adds their
space usage to the correct user/group/project, and given that repair
already walks all inodes, and checks their block maps it does most of
that work already.  The only downside would be that the memory usage
of repair increases a bit by keeping the dquots in memoryb, but even
for your 130000 dquot setup that would add about 100 bytes * 130000
please a bit of in-memory metadata (less than 20MB total) of memory
usage, so it probably is a good tradeoff.

In what cases do you regularly run quotacheck when you did not do
a repair first?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
