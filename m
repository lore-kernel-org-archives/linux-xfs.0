Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9O3bAkM088218 for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 22:37:10 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4081219739F6
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 20:38:25 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id jezvQ22Yc09dBHFF
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 20:38:25 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id A46266C102
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 22:38:25 -0500 (CDT)
Message-ID: <4CC3AA31.2000101@hardwarefreak.com>
Date: Sat, 23 Oct 2010 22:38:25 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS Test Results Interpretation
References: <3C5E029826A0704DB5998577FCFF46F0095A278CBF@dagobah>
In-Reply-To: <3C5E029826A0704DB5998577FCFF46F0095A278CBF@dagobah>
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
To: xfs@oss.sgi.com

Andrew Debenham put forth on 10/23/2010 9:59 PM:
> I am in the process of trying to determine the best parameters to use when creating and mounting an XFS file system on some new hardware we are going to be using.  My company has two separate applications that will be running on the same hardware (but on separate systems).  One application is the PostgreSQL database and the other is a custom application that does writes to many (~1,000) relatively small (~672MB) files concurrently.

Post the detailed hardware specs (server, local RAID or SAN, number of
disks in stripe set, RAID level, etc), and if both applications are
running on the same physical machine or different machines.  Are both
apps writing to the same XFS filesystem or two different filesystems?
Your description of "what is where" was very confusing.

Oh, and Bonnie++ test results are usually useless, as well as IOZone,
etc.  Next time ask before taking the time to run benchmarks and jump
through hoops to get the data onto the list. :)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
