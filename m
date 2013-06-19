Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4FDF67CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 14:55:10 -0500 (CDT)
Date: Wed, 19 Jun 2013 14:55:06 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v3 1/2] xfs: Remove XFS_MOUNT_RETERR
Message-ID: <20130619195506.GS20932@sgi.com>
References: <51824DB3.9050904@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51824DB3.9050904@oracle.com>
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
Cc: Mark Tinguely <tinguely@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, May 02, 2013 at 07:27:47PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
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
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Mark Tinguely <tinguely@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
