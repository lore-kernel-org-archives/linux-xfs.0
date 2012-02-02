Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12Mr0I7078530 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 16:53:00 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	e8P2LKpWFNlzE8s7 for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 14:52:58 -0800 (PST)
Date: Fri, 3 Feb 2012 09:52:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfsprogs: extend fiemap configure check
Message-ID: <20120202225256.GA9090@dastard>
References: <519369070.69746.1328051417713.JavaMail.root@acxmail-au2.aconex.com>
	<1247398017.69749.1328051476851.JavaMail.root@acxmail-au2.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1247398017.69749.1328051476851.JavaMail.root@acxmail-au2.aconex.com>
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
To: Nathan Scott <nathans@debian.org>
Cc: xfs@oss.sgi.com

On Wed, Feb 01, 2012 at 10:11:16AM +1100, Nathan Scott wrote:
> Make the fiemap configure check consistent with the other
> libc interface checks - perform a compile and link with a
> complete set of symbols, macros and interfaces needed, as
> opposed to a build with just the headers.
> 
> Signed-off-by: Nathan Scott <nathans@debian.org>

Definitely a good idea. 

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
