Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 86EB37F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 12:28:50 -0500 (CDT)
Date: Thu, 25 Jul 2013 12:28:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 13/48] xfs: shortform directory offsets change for dir3
	format
Message-ID: <20130725172849.GA3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-14-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:36AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because the header size for the CRC enabled directory blocks is
> larger, the offset of the first entry into a directory block is
> different to the dir2 format. The shortform directory stores the
> dirent's offset so that it doesn't change when moving from shortform
> to block form and back again, and hence it needs to take into
> account the different header sizes to maintain the correct offsets.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

corresponds to commit 6b2647a12a0

xfs_dir2_sf_getdents which is changed in the kernel commit doesn't exist in userspace.

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
