Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0E847CA1
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 16:59:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28ED7AC001
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 14:59:10 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nTaGxHBSHnNR1Y1a for <xfs@oss.sgi.com>;
	Sun, 20 Mar 2016 14:58:59 -0700 (PDT)
Date: Mon, 21 Mar 2016 08:58:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs causing "Metadata corruption detected at
	xfs_agf_read_verify"
Message-ID: <20160320215856.GO30721@dastard>
References: <20160317224803.GA8856@redhat.com> <56EB35F8.1030601@sandeen.net>
	<20160318123107.GB8856@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160318123107.GB8856@redhat.com>
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
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Mar 18, 2016 at 12:31:07PM +0000, Richard W.M. Jones wrote:
> On Thu, Mar 17, 2016 at 05:55:52PM -0500, Eric Sandeen wrote:
> > On 3/17/16 5:48 PM, Richard W.M. Jones wrote:
> > > 
> > > With recent kernels (or maybe xfsprogs?) we've noticed strange
> > > filesystem corruption after using xfs_growfs.
> > > 
> > > Examples:
> > > 
> > > https://bugzilla.redhat.com/show_bug.cgi?id=1315895 (on aarch64)
> > > https://www.redhat.com/archives/libguestfs/2016-March/msg00113.html (x86_64)
> > > https://rwmj.wordpress.com/2015/11/04/virt-builder-fedora-23-image/#comment-15668 (x86_64)
> > > 
> > > Do these errors look familiar?  I don't yet have a simple test case,
> > > still working on that.
> > 
> > try:
> > http://oss.sgi.com/pipermail/xfs/2016-March/047683.html
> 
> I've tried this patch now, but I still can't get a solid reproducer
> (one that doesn't involve using aarch64).
> 
> I just tried to create a filesystem on kernel 4.6.0, grow it on 4.6.0,
> then copy it to another machine with 4.4.4.  However that didn't
> reproduce the bug, so I couldn't verify if the patch fixes the bug.
> (Maybe 4.4.4 is too new?)

4.4.4 has the fix already in it, through the stable kernel backport
process. i.e. the original kernel commit had this in it:

	 cc: <stable@vger.kernel.org> # 3.10 - 4.4

And so the fix is automatically appearing in stable kernels as they
are released. Hence the number of current supported kernels you can
reproduce this on is shrinking....

> Can you help me to understand under what circumstances this bug would
> appear, as far as you understand what's happening?

Take a stock 4.5.0 kernel, mkfs, mount, growfs, unmount go back to a
stock 4.4.0 kernel, mount (fails), xfs_repair v4.3.0 (warns, fixes),
xfs_repair v4.5.0 (clean, fixes).

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
