Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D474B7FAA
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 18:39:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ACADB304048
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 16:39:22 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	cCCmnuxUsJdWAqQk for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 16:39:21 -0700 (PDT)
Date: Fri, 15 Mar 2013 10:39:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9-rc2 xfs panic
Message-ID: <20130314233919.GC21651@dastard>
References: <5913647.851698.1363248364959.JavaMail.root@redhat.com>
	<5141CDCD.6070801@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5141CDCD.6070801@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 08:17:01AM -0500, Mark Tinguely wrote:
> On 03/14/13 03:06, CAI Qian wrote:
> >This is easy to reproduce here,
> >
> ># ./check 111
> >
> >Bisecting is under way...
> >
> 
> 
> Right now, xfstests 111 will cause a panic. See thread:
> 
> 	http://oss.sgi.com/archives/xfs/2013-03/msg00322.html

On a debug kernel, yes. On a production kernel, no.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
