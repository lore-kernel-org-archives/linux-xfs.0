Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1G1mXVH110495 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 19:48:33 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9499612380F
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 17:47:58 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 7TIU1WswDowwP7hQ for <xfs@oss.sgi.com>;
	Sun, 15 Feb 2009 17:47:58 -0800 (PST)
Message-ID: <4998C5C5.2080003@sandeen.net>
Date: Sun, 15 Feb 2009 19:47:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add "quick" group
References: <20090214164245.GD19813@infradead.org>	<49972260.4000702@sandeen.net>	<20090215182153.GA31179@infradead.org>
	<49986233.6050600@sandeen.net> <4998B90B.1000605@gmail.com>
In-Reply-To: <4998B90B.1000605@gmail.com>
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
To: Mark Goodwin <goodwinos@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Mark Goodwin wrote:
> Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>>> Most are probably close enough, but 178 looks nasty - seems to be
>>>> xfs_repair that's taking so long.  These are running on 100G partitions,
>>>> though :)
>>> 178 only takes 16 seconds for me, running on 10G partitions.
>> interesting that a 10x size growth makes a 22x time growth.
>>
> 
> It would be interesting to see if Barry's "memory optimization"
> patches (that I posted) improve the linearity here.
> 
> Cheers
> -- Mark
> 

I'll have to try it :) (of course it was on totally different hardware,
too... but worth checking out)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
