Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 658F77F3F
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 17:17:26 -0500 (CDT)
Date: Fri, 19 Jul 2013 17:17:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: generic/315, verify preallocated disk space
	is released per truncate
Message-ID: <20130719221722.GA3111@sgi.com>
References: <51D159FF.401@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51D159FF.401@oracle.com>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jul 01, 2013 at 06:29:19PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Introduce generic test 315 to verify if the disk space is
> released after truncating a preallocated file back to the
> old smaller size.  Before Linux-3.10, Btrfs/OCFS2 test
> failed in this case.
> 
> The test file is fallocated with FALLOC_FL_KEEP_SIZE option.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
