Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A28C7CA0
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 10:29:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F068E304048
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 08:29:00 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id q7CHQ2Hp2cBGxQ4n (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2016 08:28:59 -0800 (PST)
Date: Mon, 7 Mar 2016 08:28:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: pad xfs_attr_leaf_name_remote to avoid tripping
	on m68k
Message-ID: <20160307162858.GE19784@infradead.org>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
	<1457300990-18300-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457300990-18300-7-git-send-email-david@fromorbit.com>
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

On Mon, Mar 07, 2016 at 08:49:50AM +1100, Dave Chinner wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> Pad the xfs_attr_leaf_name_remote so that we don't trip the structure
> size checker on m68k.
> 
> [dchinner: add comment, XFS_ATTR_LEAF_NAME_BYTES constant and make sure
> 	   xfs_attr_leaf_entsize_remote() does the right thing. ]

I think using a small fixed size array as a variable sized array
is not a good idea, especially with increasinly "smart" optimizing
compilers.  I'd rather take this structure out the size checking,
and then move it to a C99 VLA instead of the size 1 hack in the long
run.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
