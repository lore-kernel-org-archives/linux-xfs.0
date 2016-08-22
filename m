Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8213F7CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 08:17:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8001AC006
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 06:16:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uWwwh6sqHGxo26L7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2016 06:16:53 -0700 (PDT)
Date: Mon, 22 Aug 2016 08:16:49 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH v2 2/3] xfs_quota: changes to accomodate hoisted ioctl defs
Message-ID: <20160822131649.GA2736@redhat.com>
References: <1471356998-2876-1-git-send-email-billodo@redhat.com>
	<1471356998-2876-3-git-send-email-billodo@redhat.com>
	<20160822011812.GP19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160822011812.GP19025@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 22, 2016 at 11:18:12AM +1000, Dave Chinner wrote:
> On Tue, Aug 16, 2016 at 09:16:37AM -0500, Bill O'Donnell wrote:
> > The kernel commit to make the ioctl promotion (334e580a6f) moved
> > the definitions for the XFS ioctl to uapi/linux/fs.h for the
> > following reason:
> > 
> >     Hoist the ioctl definitions for the XFS_IOC_FS[SG]SETXATTR API
> >     from fs/xfs/libxfs/xfs_fs.h to include/uapi/linux/fs.h so that
> >     the ioctls can be used by all filesystems, not just XFS. This
> >     enables (initially) ext4 to use the ioctl to set project IDs on
> >     inodes.
> > 
> > This means we now need to handle this change in userspace as the
> > uapi/linux/fs.h file may not contain the definitions (i.e. new
> > xfsprogs/ old linux uapi files) xfsprogs needs to build. Hence we
> > need to massage the definition in xfs_fs.h to take the values from
> > the system header if it exists, otherwise keep the old definitions
> > for compatibility and platforms other than linux..
> > 
> > This patch was originally submitted by Dave Chinner
> > (http://oss.sgi.com/archives/xfs/2016-02/msg00108.html)
> > 
> > Resubmitting with changes to accomodate upstream changes since
> > initial submission.
> 
> This is unnecessary - the "include local version" changes were made
> to the platform headers (e.g. include/linux.h) in commit 83f4b5a
> ("xfs_fs.h: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR
> promotion").

Sorry, I missed that. I'll remove this patch on v3.
Thanks-
Bill

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
