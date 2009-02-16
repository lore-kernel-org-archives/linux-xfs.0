Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1G0sIOH108052 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 18:54:18 -0600
Received: from ti-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F5D712399D
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 16:53:42 -0800 (PST)
Received: from ti-out-0910.google.com (ti-out-0910.google.com
	[209.85.142.190]) by cuda.sgi.com with ESMTP id
	grNHL6m8s9oFpk6t for <xfs@oss.sgi.com>;
	Sun, 15 Feb 2009 16:53:42 -0800 (PST)
Received: by ti-out-0910.google.com with SMTP id a6so1508908tib.18
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 16:53:40 -0800 (PST)
Message-ID: <4998B90B.1000605@gmail.com>
Date: Mon, 16 Feb 2009 11:53:31 +1100
From: Mark Goodwin <goodwinos@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add "quick" group
References: <20090214164245.GD19813@infradead.org>	<49972260.4000702@sandeen.net>	<20090215182153.GA31179@infradead.org>
	<49986233.6050600@sandeen.net>
In-Reply-To: <49986233.6050600@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>>> Most are probably close enough, but 178 looks nasty - seems to be
>>> xfs_repair that's taking so long.  These are running on 100G partitions,
>>> though :)
>> 178 only takes 16 seconds for me, running on 10G partitions.
> 
> interesting that a 10x size growth makes a 22x time growth.
> 

It would be interesting to see if Barry's "memory optimization"
patches (that I posted) improve the linearity here.

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
