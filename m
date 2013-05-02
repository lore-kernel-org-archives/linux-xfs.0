Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 50C5C29E07
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 10:27:09 -0500 (CDT)
Message-ID: <518285CE.7090703@sgi.com>
Date: Thu, 02 May 2013 10:27:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/2] xfs: Remove XFS_MOUNT_RETERR
References: <51824DB3.9050904@oracle.com>
In-Reply-To: <51824DB3.9050904@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/02/13 06:27, Jeff Liu wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> XFS_MOUNT_RETERR is going to be set at xfs_parseargs() if
> mp->m_dalign is enabled, so any time we enter "if (mp->m_dalign)"
> branch in xfs_update_alignment(), XFS_MOUNT_RETERR is set and so
> we always be emitting a warning and returning an error.
>
> Hence, we can remove it and get rid of a couple of redundant
> check up against it at xfs_upate_alignment().
>
> Thanks Dave Chinner for the suggestions of simplify the code
> in xfs_parseargs().
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>

"alignment check failed: sunit/swidth vs. blocksize(%d)",
				                   ^^^^
"alignment check failed: sunit/swidth vs. agsize(%d)",
                                                 ^^^^
"alignment check failed: sunit(%d) less than bsize(%d)",
                               ^^^^                ^^^^
I know you copied these statements verbatim, but I wonder why all
these statements do not have a space between the type and value?

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
