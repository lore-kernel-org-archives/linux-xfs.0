Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 967737F6D
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 16:49:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 30487AC002
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 14:49:53 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NAa64IayjsNHzy8w for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 14:49:44 -0800 (PST)
Date: Mon, 9 Feb 2015 09:49:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 12/18] xfs: filter out sparse regions from individual
	inode allocation
Message-ID: <20150208224942.GG4251@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-13-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423252385-3063-13-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 06, 2015 at 02:52:59PM -0500, Brian Foster wrote:
> Inode allocation from an existing record with free inodes traditionally
> selects the first inode available according to the ir_free mask. With
> sparse inode chunks, the ir_free mask could refer to an unallocated
> region. We must mask the unallocated regions out of ir_free before using
> it to select a free inode in the chunk.
> 
> Create the xfs_inobt_first_free_inode() helper to find the first free
> inode available of the allocated regions of the inode chunk.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Helper can go early on in the patch set, and then when the sparse
inode support is added the bitmap stuff can added to the helepr.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
