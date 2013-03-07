Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB2B47FBE
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 07:32:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9271E8F8068
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 05:32:46 -0800 (PST)
Received: from mail-out1.booking.com (mail-out1.booking.com [62.190.24.20]) by
	cuda.sgi.com with ESMTP id fiCXwnRGcaFHUx8j (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 05:32:45 -0800 (PST)
Message-ID: <1362663188.16657.20.camel@seahawk>
Subject: Re: XFS IO multiplication problem on centos/rhel 6 using hp p420i
	raid controllers
From: Dennis Kaarsemaker <dennis.kaarsemaker@booking.com>
Date: Thu, 07 Mar 2013 14:33:08 +0100
In-Reply-To: <513891D7.4060801@hardwarefreak.com>
References: <1362060736.1247.30.camel@seahawk>
	<20130228194023.GQ5551@dastard> <1362577992.1247.84.camel@seahawk>
	<20130307035737.GC6369@dastard> <1362651128.16657.13.camel@seahawk>
	<513891D7.4060801@hardwarefreak.com>
Mime-Version: 1.0
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

On Thu, 2013-03-07 at 07:10 -0600, Stan Hoeppner wrote:
> On 3/7/2013 4:12 AM, Dennis Kaarsemaker wrote:
> 
> > I see, so now I need to find out what's causing the larger average
> > request size. Would you happen to know a list of common causes?
> 
> Given that mysql is doing the writes, that's the first place to look.

That is indeed where we started, but MySQL is configured exactly the
same on both thanks to puppet.

> Is the mysql version the same on all machines?  

Yes.

> How about the config?

All that's different is server_id and prompt.

> How about the sql code driving the IO, is it the same?

They're replicating the same set of data.

> Is this host using a different mysql log or db file format?  Is the logging method the same?  

All the same

> Is it writing the same
> total amount of data to the filesystem, but just in larger chunks?  Etc,

The "ten times as many bytes" is constant, so it is constantly writing
ten times as much data.
-- 
Dennis Kaarsemaker, Systems Architect
Booking.com
Herengracht 597, 1017 CE Amsterdam
Tel external +31 (0) 20 715 3409
Tel internal (7207) 3409

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
