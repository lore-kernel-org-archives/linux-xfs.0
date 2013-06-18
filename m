Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 021F77CBF
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 13:59:02 -0500 (CDT)
Date: Tue, 18 Jun 2013 13:59:02 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v4] xfs: fix the symbolic link assert in xfs_ifree
Message-ID: <20130618185902.GM20932@sgi.com>
References: <20130617203503.472644581@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130617203503.472644581@sgi.com>
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
Cc: xfs@oss.sgi.com

On Mon, Jun 17, 2013 at 03:35:57PM -0500, Mark Tinguely wrote:
> Adding an extended attribute to a symbolic link can force that
> link to an remote extent. xfs_inactive() incorrectly assumes
> that any symbolic link small enough to be in the inode core
> is incore, resulting in the remote extent to not be removed.
> xfs_ifree() will assert on presence of this leaked remote extent.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
