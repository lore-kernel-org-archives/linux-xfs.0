Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0349bxs028615 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 22:09:37 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90D23175A868
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 20:09:34 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 9A26RJwCzaH73DZP for
	<xfs@oss.sgi.com>; Fri, 02 Jan 2009 20:09:34 -0800 (PST)
Message-ID: <495EE4FC.9080808@sandeen.net>
Date: Fri, 02 Jan 2009 22:09:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: oopses in xfs_attr_shortform_* on kerneloops.org
References: <495D91A0.4050304@sandeen.net>
	<20090102175911.GA29506@infradead.org>
In-Reply-To: <20090102175911.GA29506@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Jan 01, 2009 at 10:01:36PM -0600, Eric Sandeen wrote:
>> I noticed this on kerneloops.org and pinged Christoph about it but I'll
>> go ahead & point it out here & file a bug so it doesn't get lost:
>>
>> http://www.kerneloops.org/search.php?search=xfs_attr_shortform&btnG=Function+Search
>>
>> would seem to indicate a problem, though not a (recent) regression anyway.
> 
> Yeah, I've been looking into and the disassemly looks like we have
> a NULL attribut fork pointer for some reason.  I did some poking
> around in the code and couldn't a cause for it.  So if anyone of
> the kerneloops submitters actually is on the list and can reproduce
> it that would be extremly helpful.

This *might* be a clue:

http://article.gmane.org/gmane.comp.file-systems.xfs.general/22156

one of those oopses, and associated xfs_repair output for the fs in
question... doesn't make anything clearer to me, though, offhand.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
