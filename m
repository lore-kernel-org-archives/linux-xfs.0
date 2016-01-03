Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 687967F37
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 14:48:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01C60AC002
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 12:48:04 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Gl29kEOnwgNIhorr for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2016 12:48:00 -0800 (PST)
Date: Mon, 4 Jan 2016 07:47:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: KASAN: use-after-free in xfs_iflush_cluster+0x9d7/0xaf0
Message-ID: <20160103204758.GW19802@dastard>
References: <20151214180048.GA15690@glen> <20151214195422.GM26718@dastard>
	<20151214201526.GA25152@glen> <20151214212220.GO26718@dastard>
	<20151215091145.GA19282@glen>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151215091145.GA19282@glen>
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
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Dec 15, 2015 at 10:11:45AM +0100, Andrea Gelmini wrote:
> On Tue, Dec 15, 2015 at 08:22:20AM +1100, Dave Chinner wrote:
> > $ gdb vmlinux
> > ....
> > (gdb) l *(xfs_iflush_cluster+0x9d7)
> 
> It's not working. Shame on me, I forgot to set "Compile the kernel with debug info".
> 
> I'm recompiling, to try it again.
> Maybe, in the meanwhile, you can do something with my files. You can find 'em here:
> http://mail.gelma.net/xfs_kasan

Any update on this problem, Andrea?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
