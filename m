Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q159Y2bo025118 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 03:34:02 -0600
Received: from geotraceuk2.Geotrace.com (ip-87-86-166-5.easynet.co.uk
	[87.86.166.5]) by cuda.sgi.com with ESMTP id SbzFDGsXTDmfEoUa
	for <xfs@oss.sgi.com>; Sun, 05 Feb 2012 01:34:00 -0800 (PST)
From: Ron Yorston <rmy@tigress.co.uk>
Message-Id: <201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
Date: Sun, 05 Feb 2012 09:33:26 +0000
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
References: <4F2D8F30.3090802@redhat.com>
In-Reply-To: <4F2D8F30.3090802@redhat.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, sandeen@redhat.com, linux-ext4@vger.kernel.org

Eric Sandeen wrote:

>Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
>"re-sparsify" a file by punching out ranges of 0s might be in order.
>
>I'll see if util-linux wants it after it gets beat into shape.
>(or did a tool like this already exist and I missed it?)

Way ahead of you.  I wrote my sparsify utility for ext2 in 2004:

   http://intgat.tigress.co.uk/rmy/uml/sparsify.html

It's mostly of historical interest now, I suppose.  The sparsify utility
doesn't work on ext4 and I long since gave up maintaining the kernel
patch.  I still use the zerofree utility, though.

It would be nice to have a modern version of sparsify.  I'll try it out.

Ron

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
