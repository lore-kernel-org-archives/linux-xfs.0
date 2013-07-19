Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0204B7F4E
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 15:38:41 -0500 (CDT)
Date: Fri, 19 Jul 2013 15:38:37 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: exit out if _scratch_mount fails
Message-ID: <20130719203837.GJ3572@sgi.com>
References: <1373396847-7975-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373396847-7975-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linxu-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 09, 2013 at 03:07:27PM -0400, Josef Bacik wrote:
> I test some of the different mkfs options for btrfs, one set doesn't work
> properly with small file systems, so the fs won't mount.  This is fine from a
> btrfs point of view, but tests that fail to mount the scratch fs will run
> anyway, so if it's a "fill the fs" sort of test this will wreak havoc.  To fix
> this just error out of _scratch_mount fails.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
