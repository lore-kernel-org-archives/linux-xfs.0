Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 502DC7FC6
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 07:52:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3583F304048
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 05:52:33 -0800 (PST)
Received: from mail-out1.booking.com (mail-out1.booking.com [62.190.24.20]) by
	cuda.sgi.com with ESMTP id IUwhqqOlMtJqEnI3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 05:52:32 -0800 (PST)
Message-ID: <1362664376.16657.26.camel@seahawk>
Subject: Re: XFS IO multiplication problem on centos/rhel 6 using hp p420i
	raid controllers
From: Dennis Kaarsemaker <dennis.kaarsemaker@booking.com>
Date: Thu, 07 Mar 2013 14:52:56 +0100
In-Reply-To: <513899D3.80907@hardwarefreak.com>
References: <1362060736.1247.30.camel@seahawk>
	<20130228194023.GQ5551@dastard> <1362577992.1247.84.camel@seahawk>
	<20130307035737.GC6369@dastard> <1362651128.16657.13.camel@seahawk>
	<513891D7.4060801@hardwarefreak.com>
	<1362663188.16657.20.camel@seahawk>
	<513899D3.80907@hardwarefreak.com>
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

On Thu, 2013-03-07 at 07:44 -0600, Stan Hoeppner wrote:
> On 3/7/2013 7:33 AM, Dennis Kaarsemaker wrote:
> 
> > The "ten times as many bytes" is constant, so it is constantly writing
> > ten times as much data.
> 
> Where in the IO stack are you counting the bytes?  Are 10x as many bytes
> actually hitting the AGs?  I.e. are you consuming 10x more (real--not
> counting preallocation) space in the filesystem?  Or are you simply
> seeing larger IOs in flight per unit time, but the same total amount of
> IO bytes?

I'm counting them with vmstat, iostat and collectl as can be seen in the
various outputs I've sent. I hope that answers your question as I have
no idea how to see what's hitting the AG's.

I am not using ten times as much space, as that wouldn't fit on the
volume.
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
