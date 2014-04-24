Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB1817F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 00:47:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 61A1FAC00E
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 22:47:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kNzNAfb2T6kZ4Erl for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 22:47:52 -0700 (PDT)
Date: Thu, 24 Apr 2014 15:47:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 08/11] xfs: update the finobt on inode free
Message-ID: <20140424054750.GC15995@dastard>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
	<1397146116-42546-9-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397146116-42546-9-git-send-email-bfoster@redhat.com>
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

On Thu, Apr 10, 2014 at 12:08:33PM -0400, Brian Foster wrote:
> An inode free operation can have several effects on the finobt. If
> all inodes have been freed and the chunk deallocated, we remove the
> finobt record. If the inode chunk was previously full, we must
> insert a new record based on the existing inobt record. Otherwise,
> we modify the record in place.
> 
> Create the xfs_difree_finobt() function to identify the potential
> scenarios and update the finobt appropriately.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

No problems there that I can see.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
