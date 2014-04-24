Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B01E7F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 00:44:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33CBEAC00E
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 22:44:31 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cueQEQ6CGQ3MZCJ8 for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 22:44:30 -0700 (PDT)
Date: Thu, 24 Apr 2014 15:44:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 06/11] xfs: use and update the finobt on inode
	allocation
Message-ID: <20140424054428.GB15995@dastard>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
	<1397146116-42546-7-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397146116-42546-7-git-send-email-bfoster@redhat.com>
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

On Thu, Apr 10, 2014 at 12:08:31PM -0400, Brian Foster wrote:
> Replace xfs_dialloc_ag() with an implementation that looks for a
> record in the finobt. The finobt only tracks records with at least
> one free inode. This eliminates the need for the intra-ag scan in
> the original algorithm. Once the inode is allocated, update the
> finobt appropriately (possibly removing the record) as well as the
> inobt.
> 
> Move the original xfs_dialloc_ag() algorithm to
> xfs_dialloc_ag_inobt() and fall back as such if finobt support is
> not enabled.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
