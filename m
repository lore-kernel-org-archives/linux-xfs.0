Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9533429DFD
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 23:07:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 742318F8037
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 21:07:50 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id JDPNOXwYyz7RY42H
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 21:07:50 -0700 (PDT)
Message-ID: <52183194.2060008@hardwarefreak.com>
Date: Fri, 23 Aug 2013 23:07:48 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: does having ~Ncore+1? kworkers flushing XFS to 1 disk improve
	throughput?
References: <52181B69.6060707@tlinx.org>
In-Reply-To: <52181B69.6060707@tlinx.org>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/23/2013 9:33 PM, Linda Walsh wrote:

> So what are all the kworkers doing and does having 6 of them
> do things at the same time really help disk-throughput?
> 
> Seems like they would conflict w/each other, cause
> disk contention, and extra fragmentation as they
> do things?  If they were all writing to separate
> disks, that would make sense, but do that many kworker
> threads need to be finishing out disk I/O on 1 disk?

https://raw.github.com/torvalds/linux/master/Documentation/workqueue.txt

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
