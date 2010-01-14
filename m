Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EHfS5m020830 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 11:41:28 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3DDF166587
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 09:42:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aTGFwY2YFgwDQZOU for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2010 09:42:24 -0800 (PST)
Message-ID: <4B4F5773.8050409@sandeen.net>
Date: Thu, 14 Jan 2010 11:42:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: allocsize mount option
References: <264613.60659.qm@web76207.mail.sg1.yahoo.com>
In-Reply-To: <264613.60659.qm@web76207.mail.sg1.yahoo.com>
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
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: xfs@oss.sgi.com

Gim Leong Chin wrote:
> Hi Dave,
> 
> 
>> fragmented, it just means that that there are 19% more fragments 
>> than the ideal. In 4TB of data with 1GB sized files, that would
>> mean there are 4800 extents (average length ~800MB, which is 
>> excellent) instead of the perfect 4000 extents (@1GB each). Hence
>> you can see how misleading this "19% fragmentation" number can be
>> on an extent based filesystem...
> 
> There are many files that are 128 GB.
> 
> When I did the tests with dd on this computer, the 20 GB files had up
> to > 50 extents.

which is at least 400mb per extent, which is really not so bad.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
