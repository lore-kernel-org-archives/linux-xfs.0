Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 239407F7C
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 15:37:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9A3AAC008
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 13:37:15 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ruCEvB80QNGSQJpb for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 13:37:13 -0800 (PST)
Date: Mon, 3 Feb 2014 08:37:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Extended attributes limit in Linux
Message-ID: <20140202213711.GR2212@dastard>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>
	<52EB64DC.4020603@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52EB64DC.4020603@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Sun_Blood <sblood@gmail.com>, xfs@oss.sgi.com

On Fri, Jan 31, 2014 at 04:54:52PM +0800, Jeff Liu wrote:
> Hello,
> 
> On 01/31 2014 15:40 PM, Sun_Blood wrote:
> > Hello,
> > 
> > If I understands it correctly XFS don't have a limit to the size of
> > extended attributes(EA) but Linux impose a limit at 64k.
> > What I am trying to do is build a backup server that our Apple computers
> > will use together with rsync to backup files to. The problem I face is
> > that Apple HFS+ don't have a limit to EA so it has files with more then
> > 64k of EA in it.
> > 
> > The Linux Kernel has a limit imposed to it in include/linux/limits.h
> > 
> >     #defineXATTR_SIZE_MAX 65536   /* size of an extended attribute value
> >     (64k) */
> > 
> >     #defineXATTR_LIST_MAX 65536   /* size of extended attribute namelist
> >     (64k) */
> > 
> 
> Yes, 64k is the VFS limit per EA value size.

XFS has a limit of 64k as well. I suspect that we could handle
larger EAs without too much problem as we already have the concept
of a "remote EA" that is allocated outside of the attribute btree
(but still inside the attribute address space). The problem with
them is that they are written synchronously, and so large attributes
written this way are slow operations.

Still, until the VFS limit is lifted and we do a bunch more work to
avoid XATTR_SIZE_MAX allocations everywhere there's no point looking
at raising the XFS limit....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
