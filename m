Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E124F7FB6
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 07:44:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA16B8F8066
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 05:44:41 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id mHGlM9g0WKyAC1G0
	for <xfs@oss.sgi.com>; Thu, 07 Mar 2013 05:44:41 -0800 (PST)
Message-ID: <513899D3.80907@hardwarefreak.com>
Date: Thu, 07 Mar 2013 07:44:51 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS IO multiplication problem on centos/rhel 6 using hp p420i
	raid controllers
References: <1362060736.1247.30.camel@seahawk> <20130228194023.GQ5551@dastard>
	<1362577992.1247.84.camel@seahawk> <20130307035737.GC6369@dastard>
	<1362651128.16657.13.camel@seahawk>
	<513891D7.4060801@hardwarefreak.com>
	<1362663188.16657.20.camel@seahawk>
In-Reply-To: <1362663188.16657.20.camel@seahawk>
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

On 3/7/2013 7:33 AM, Dennis Kaarsemaker wrote:

> The "ten times as many bytes" is constant, so it is constantly writing
> ten times as much data.

Where in the IO stack are you counting the bytes?  Are 10x as many bytes
actually hitting the AGs?  I.e. are you consuming 10x more (real--not
counting preallocation) space in the filesystem?  Or are you simply
seeing larger IOs in flight per unit time, but the same total amount of
IO bytes?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
