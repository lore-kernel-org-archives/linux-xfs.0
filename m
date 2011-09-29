Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8T0PJrH147536 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 19:25:19 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45532142DB71
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 17:31:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	auS9Xg5Ai6seYx4t for <xfs@oss.sgi.com>;
	Wed, 28 Sep 2011 17:31:21 -0700 (PDT)
Date: Thu, 29 Sep 2011 10:25:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 64-bit inodes and back again
Message-ID: <20110929002511.GI3159@dastard>
References: <4E825C25.6050804@cchtml.com> <20110928011020.GE3159@dastard>
	<4E8278D8.9060309@cchtml.com> <4E828BE1.8030003@cchtml.com>
	<20110928053539.GF3159@dastard> <4E82C5AF.8040203@cchtml.com>
	<20110928110726.GG3159@dastard> <4E831D81.6070102@cchtml.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E831D81.6070102@cchtml.com>
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
To: Michael Cronenworth <mike@cchtml.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 28, 2011 at 08:13:37AM -0500, Michael Cronenworth wrote:
> Dave Chinner on 09/28/2011 06:07 AM wrote:
> >It's failing trying to copy the attributes on a directory. What are
> >the attributes on the specific directory?
> 
> That particular directory was
> 
> drwxrwsr-x  root:mock

I was asking about stuff like selinux attributes, not modes and
owners. i.e:

$ lsattr /usr/sbin/xfs_db
-------------e- /usr/sbin/xfs_db
$ attr -l /usr/sbin/xfs_db
Attribute "selinux" has a 27 byte value for /usr/sbin/xfs_db
$

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
