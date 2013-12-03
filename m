Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D8FEF7F58
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 03:54:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2A1C304062
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 01:54:01 -0800 (PST)
Received: from volubilis.easter-eggs.com (volubilis.easter-eggs.com
	[37.9.136.135]) by cuda.sgi.com with ESMTP id zZguypvgQxMDbBm3
	for <xfs@oss.sgi.com>; Tue, 03 Dec 2013 01:53:59 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by volubilis.easter-eggs.com (Postfix) with ESMTP id 8B67F15E18
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 10:53:58 +0100 (CET)
Received: from datura.easter-eggs.fr (coquelicot-s.easter-eggs.com
	[109.190.110.196])
	by volubilis.easter-eggs.com (Postfix) with ESMTPSA id 6543215DD4
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 10:53:58 +0100 (CET)
Date: Tue, 3 Dec 2013 10:53:58 +0100
From: Emmanuel Lacour <elacour@easter-eggs.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
	(mode:0x250)
Message-ID: <20131203095357.GC5405@easter-eggs.com>
References: <20131128091322.GC5337@easter-eggs.com>
	<20131128100521.GO10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131128100521.GO10988@dastard>
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
To: xfs@oss.sgi.com

On Thu, Nov 28, 2013 at 09:05:21PM +1100, Dave Chinner wrote:
> On Thu, Nov 28, 2013 at 10:13:22AM +0100, Emmanuel Lacour wrote:
> > 
> > Dear XFS users,
> > 
> > 
> > I run a Ceph cluster using XFS on Debian wheezy servers and Linux 3.10
> > (debian backports). I see the following line in our logs:
> > 
> > XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> > 
> > does this reveal a problem in my setup or may I ignore it? If it's a
> > problem, can someone give me any hint on solving this?
> 
> It might be, but you need to provide more information for us to be
> able to make any intelligent comment on the message. Start here:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 


The problem continue and crashed my ceph cluster again, so here is all
the informations said in the FAQ:

http://people.easter-eggs.org/~manu/xfs.log

This may be related to a friend problem here:

http://tracker.ceph.com/issues/6386


thanks for any help on solving this!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
