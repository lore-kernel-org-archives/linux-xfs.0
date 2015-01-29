Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA74129DF7
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 09:38:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA5E7304064
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:38:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jjug16tOYnVTR3EF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 07:38:46 -0800 (PST)
Date: Thu, 29 Jan 2015 10:38:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/9] xfs: xfs_ioctl_setxattr rework
Message-ID: <20150129153834.GJ17652@laptop.bfoster>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422328486-24661-1-git-send-email-david@fromorbit.com>
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
Cc: iustin@k1024.org, xfs@oss.sgi.com

On Tue, Jan 27, 2015 at 02:14:37PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This is a series I started a few months ago when we first started
> talking about the issues with extent size hints on directories and
> the project ID inherit flags being set on regular files. The code
> is particularly nice and has no clear definition of what sort
> of changes we allow in the XFS_IOC_FSSETXATTR ioctl.
> 
> The first thing the series does is kill the FSX_* flags and separate
> out the two different use cases for the xfs_ioctl_setattr()
> function. The first is just changing a constrained set of flags via
> the xfs_ioc_setxflags(), and the second is supporting
> xfs_ioc_fssetxattr(). Factoring out the part of the code that sets
> just the inode flags appropriately allows us to kill the FSX_* flags
> completely.
> 
> The next patch then relaxes the overly defensive approach to
> restricting XFS_IOC_FSSETXATTR to only the init namespace. We really
> only need to restrict project ID changes - allowing changes to other
> parts of the inode are managed by user/group permissions which are
> already user namespace aware.
> 
> The next part of the patch set factors out the validity checking
> of extent size changes and project ID changes from the setattr
> functions, making it much clearer the separation between checks and
> actions performed by xfs_ioctl_setattr() function.
> 
> Finally, with all these changes, Iustin Pop's extent size change
> validity checking patch is ported on top. That now becomes a simple,
> obvious set of changes to an isolated function, and i've added
> comments to explain the rules allowing extent size hints to be
> changed.
> 
> Comments, thoughts, flames, etc all welcome.
> 

All in all this looks like a nice cleanup to me. By the way, you've got
"xfs; ..." in some of the patch/mail headers instead of "xfs: ..."

Brian

> - Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
