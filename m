Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98BDE7FBA
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 07:10:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44F5AAC001
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 05:10:38 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 9j56iuP4aM2huRap
	for <xfs@oss.sgi.com>; Thu, 07 Mar 2013 05:10:37 -0800 (PST)
Message-ID: <513891D7.4060801@hardwarefreak.com>
Date: Thu, 07 Mar 2013 07:10:47 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS IO multiplication problem on centos/rhel 6 using hp p420i
	raid controllers
References: <1362060736.1247.30.camel@seahawk> <20130228194023.GQ5551@dastard>
	<1362577992.1247.84.camel@seahawk> <20130307035737.GC6369@dastard>
	<1362651128.16657.13.camel@seahawk>
In-Reply-To: <1362651128.16657.13.camel@seahawk>
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
To: Dennis Kaarsemaker <dennis.kaarsemaker@booking.com>
Cc: xfs@oss.sgi.com

On 3/7/2013 4:12 AM, Dennis Kaarsemaker wrote:

> I see, so now I need to find out what's causing the larger average
> request size. Would you happen to know a list of common causes?

Given that mysql is doing the writes, that's the first place to look.
Is the mysql version the same on all machines?  If not, what changed
between versions?  How about the config?  How about the sql code driving
the IO, is it the same?  Is this host using a different mysql log or db
file format?  Is the logging method the same?  Is it writing the same
total amount of data to the filesystem, but just in larger chunks?  Etc,
etc.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
