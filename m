Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6BF157F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 18:58:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE864AC008
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 16:57:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Db6z0VmOvyxsbm25 for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 16:57:57 -0700 (PDT)
Date: Tue, 18 Aug 2015 09:57:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix xfs_attr_leafblock definition
Message-ID: <20150817235755.GE714@dastard>
References: <1439458000-28395-1-git-send-email-jack@suse.com>
	<55CC98DD.6060700@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55CC98DD.6060700@sgi.com>
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
Cc: tdm@sgi.com, xfs@oss.sgi.com, Jan Kara <jack@suse.com>

On Thu, Aug 13, 2015 at 08:17:17AM -0500, Mark Tinguely wrote:
> On 08/13/15 04:26, Jan Kara wrote:
> >struct xfs_attr_leafblock contains 'entries' array which is declared
> >with size 1 altough it can in fact contain much more entries. Since this
> >array is followed by further struct members, gcc (at least in version
> >4.8.3) thinks that the array has the fixed size of 1 element and thus
> >may optimize away all accesses beyond the end of array resulting in
> >non-working code. This problem was only observed with userspace code in
> >xfsprogs, however it's better to be safe in kernel as well and have
> >matching kernel and xfsprogs definitions.
> >
> >Signed-off-by: Jan Kara<jack@suse.com>
> >---
> 
> I hit this bug in SLES12 and RHEL7 XFS kernel code. It is the gcc
> 4.8's new loop optimization routine. A person can bypass it with the
> option:
>     -fno-aggressive-loop-optimizations
> but this fixes the source of the problem.
> 
> Acked-by: Mark Tinguely <tinguely@sgi.com>

Hi Mark - it's great that you had found and identified the exact
compiler optimisation that was causing miscompilation of the XFS
code.

Troy, what's not great about this is that SGI hasn't seen fit to
report this bug upstream or to their distro partners in a prompt
manner. Can you please make sure that any other XFS bug fixes that
SGI are sitting on get communicated to the appropriate venue so
they can be addressed without undue delay?

Thanks,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
