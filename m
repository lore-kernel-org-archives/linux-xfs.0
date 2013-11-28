Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 845B37F59
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 04:05:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5CD3B304048
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 02:05:54 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lXe4hKT3L5PEumR4 for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 02:05:49 -0800 (PST)
Date: Thu, 28 Nov 2013 21:05:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
	(mode:0x250)
Message-ID: <20131128100521.GO10988@dastard>
References: <20131128091322.GC5337@easter-eggs.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131128091322.GC5337@easter-eggs.com>
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
To: Emmanuel Lacour <elacour@easter-eggs.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 28, 2013 at 10:13:22AM +0100, Emmanuel Lacour wrote:
> 
> Dear XFS users,
> 
> 
> I run a Ceph cluster using XFS on Debian wheezy servers and Linux 3.10
> (debian backports). I see the following line in our logs:
> 
> XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> 
> does this reveal a problem in my setup or may I ignore it? If it's a
> problem, can someone give me any hint on solving this?

It might be, but you need to provide more information for us to be
able to make any intelligent comment on the message. Start here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
