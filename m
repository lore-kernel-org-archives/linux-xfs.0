Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 334197F78
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 15:04:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 103268F804B
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 13:04:41 -0800 (PST)
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	pI8ajD6IDvjX8nHx for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 13:04:40 -0800 (PST)
Received: from ty.sabi.co.UK (78.86.80.54) by honeysuckle.london.02.net
	(8.5.140)
	id 50D1042B04BC0EAA for xfs@oss.sgi.com; Thu, 7 Mar 2013 21:04:39 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1UDhzK-0007NZ-Gq
	for <xfs@oss.sgi.com>; Thu, 07 Mar 2013 21:04:30 +0000
Resent-Message-ID: <20793.222.376461.229641@tree.ty.sabi.co.uk>
Resent-To: xfs@oss.sgi.com
Subject: Re: Pathological allocation pattern with direct IO
Date: Wed, 6 Mar 2013 22:31:42 +0000
MIME-Version: 1.0
From: pg_xf2@xf2.for.sabi.co.uk (Peter Grandi)
Message-ID: <20791.50126.796065.137158@tree.ty.sabi.co.uk>
References: <20130306202210.GA1318@quack.suse.cz>
In-Reply-To: <20130306202210.GA1318@quack.suse.cz>
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
To: Linux fs XFS <xfs@OSS.SGI.com>

> [ ... ] application that write large (tens of GB) files using
> direct IO done in 16 MB chunks. They keep the fs around 80%
> full deleting oldest files when they need to store new ones.
> Usually the file can be stored in under 10 extents but from
> time to time a pathological case is triggered and the file has
> few thousands extents (which naturally has impact on
> performance). [ ... ]

They just want *guaranteed* (not just nearly-always) contiguity,
without preallocating, with incremental writes with direct IO,
while keeping the filesystem full at 80%.

And a pony! :-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
