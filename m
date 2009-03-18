Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2IE0WI4242613 for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 09:00:52 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6CCB1A7048
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 07:00:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id IUOwDu1iJezxbYzP for <xfs@oss.sgi.com>;
	Wed, 18 Mar 2009 07:00:09 -0700 (PDT)
Message-ID: <49C0FE64.3040203@sandeen.net>
Date: Wed, 18 Mar 2009 09:00:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Lost files + indentical Foldernames on XFS Partition
References: <49BFDC6E.6050607@liga01.de> <49BFDDC5.9060500@sandeen.net>
	<49C029AF.5070205@liga01.de>
	<5948362D99F6F145B37A7D45B5DDA4481042DDA609@VMBX103.ihostexchange.net>
	<49C0B41C.2060506@liga01.de>
In-Reply-To: <49C0B41C.2060506@liga01.de>
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
To: Steffen.Knauf@liga01.de
Cc: Sebastian Brings <sbrings@silexmedia.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Steffen Knauf wrote:
>>
>> Does this happen on the filesystem you mounted in parallel on two machines?
>> I remember your question from early this week, so I ask 
>>
>> Sebastian
>>   
> Yes, but i mounted the partition only a short time parallel (we only 
> read from this partition). At the moment, the mounted Filesystem is only 
> mounted on one machine.
> 
> Steffen
> 

oh... well in that case, do an xfs_repair before anything else.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
