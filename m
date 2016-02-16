Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7CDAB7CA3
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 13:20:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6FCC78F8049
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 11:20:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zUlOQd2c2a1VyiFu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2016 11:19:58 -0800 (PST)
Date: Tue, 16 Feb 2016 14:19:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/14] xfsprogs: kernel libxfs sync up to 4.5-rc2
Message-ID: <20160216191955.GE39655@bfoster.bfoster>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

On Mon, Feb 15, 2016 at 05:18:11PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This patchset pulls xfsprogs lixfs up to the same base code as the
> v4.5-rc2 kernel. I've simply pulled the commits across and in each
> patch made the external xfsprogs changes necessary to make them
> compile and work correctly. This applies on top of the xfs_io dax
> patchset I posted a short while ago. I've left all the kernel
> sign-offs on the commits - it's really only the patches that change
> stuff outside libxfs that need any sort of review...
> 
> This is pretty much all of the remaining changes needed before I can
> cut a 4.5.0-rc1 release of xfsprogs - it's really only bug fixes and
> minor changes from here, as I really need this base tree mostly
> stable from here on.
> 
> The reason for that I'm now going to be build a for-next branch off
> this that has all the changes in the current kernel for-next branch.
> This will enable Darrick to have a sane code base that he can rebase
> all his xfsprogs changes for rmap/reflink on top of. That will make
> review, testing and eventual merge much easier for everyone.
> 

A couple nits to follow that don't warrant a resend. So, for the series:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
