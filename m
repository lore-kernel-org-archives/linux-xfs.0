Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 319E97F37
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 15:51:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E43E88F8033
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 13:51:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	r2YoWTLAJUTWXZDq for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 13:51:33 -0700 (PDT)
Date: Wed, 7 May 2014 06:51:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: attr cleanups
Message-ID: <20140506205131.GO5421@dastard>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
	<53651375.9080305@sgi.com> <20140504101623.GA4947@lst.de>
	<53679113.8000209@sgi.com> <20140505205552.GX26353@dastard>
	<53693AC8.8020605@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53693AC8.8020605@sgi.com>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, May 06, 2014 at 02:40:56PM -0500, Mark Tinguely wrote:
> On 05/05/14 15:55, Dave Chinner wrote:
> >On Mon, May 05, 2014 at 08:24:35AM -0500, Mark Tinguely wrote:
> >>On 05/04/14 05:16, Christoph Hellwig wrote:
> >>>On Sat, May 03, 2014 at 11:04:05AM -0500, Mark Tinguely wrote:
> >>>>Depends on how parent inode pointers are implemented, this folding the
> >>>>internal version of get and set attributes could be undone.
> >>>
> >>>We might have to introduce _locked version at that point.  But I'd like
> >>>to keep the xfs_name removal and other assorted cleanups.
> >>>
> >>
> >>locking is only one issue, xfs_attr_(get/set/remove) are asciii only
> >>whereas the xfs_attr_(get/set/remove)_int versions are more generic.
> >>I am thinking of not just parent inode pointers but a non-ascii
> >>character set.
> >
> >I fail to see how they are different. The attribute name is just an
> >opaque binary blob - only when it is compared externally does it
> >have any meaning at all.
> >
> >Character sets are meaningless unless you are doing case
> >manipulation, in which case we would need to apply the same
> >treatment as the directory code deep in the internal attribute cod.
> >i.e It needs case aware compare and hash algorithms. However, the
> >outer layers are completely unchanged - they just pass through the
> >blob that was passed to them...
> >
> >Cheers,
> >
> >Dave.
> 
> Right now xfs_attr_get(), xfs_attr_set, xfs_attr_remove() expect the
> name to be a NULL terminate character array.

Sure. The obvious solution is simply moving xfs_attr_name_to_xname()
to the callers and passing an xfs_name rather than a char *, as you
have pointed out:

> The internal versions of these functions have a more useful
> interface, they use a blob for the name (the array/length xfs_name
> structure).

... there is nothing that inherently makes those functions only
support character strings.

Like I said, it needs to become more like the directory code - we do
this "convert to opaque xfs_name" via xfs_dentry_to_name() at the
VFS entry layer for directory operations (see xfs_iops.c), and all
the code that uses xattrs should do the same...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
