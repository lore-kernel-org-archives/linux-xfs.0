Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 931E97F3F
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 18:59:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7FEA58F8065
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 16:59:22 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	W7vPdYQN6EQd6w3W for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 16:59:19 -0700 (PDT)
Date: Wed, 27 May 2015 09:58:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs_repair: better checking of v5 metadata fields
Message-ID: <20150526235830.GA4316@dastard>
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
	<20150526225139.26434.37575.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150526225139.26434.37575.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, May 26, 2015 at 03:51:39PM -0700, Darrick J. Wong wrote:
> Check the UUID, owner, and block number fields during repair, looking for
> blocks that fail either the checksum or the data structure verifiers.  For
> directories we can simply rebuild corrupt/broken index data, though for
> anything else we have to toss out the broken object.

helper function needed here for owner/uuid/blkno info checks. i.e
the header info being checked is a common structure
(xfs_da3_blkinfo) embedded into the different dir header structures,
so no need to repeat the same checks just with different dir3 header
structures....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
