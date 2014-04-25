Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E5507F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 00:40:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6C39304048
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 22:40:22 -0700 (PDT)
Date: Thu, 24 Apr 2014 22:40:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] libxfs: adding attribute fork frees xfs_inode ptr
Message-ID: <20140425054021.GA16132@infradead.org>
References: <20140423210034.892939354@sgi.com>
	<20140423210445.700477624@sgi.com> <20140423222215.GT18672@dastard>
	<535945DC.6010108@sgi.com> <53597B34.9050407@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53597B34.9050407@sgi.com>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Thu, Apr 24, 2014 at 03:59:32PM -0500, Mark Tinguely wrote:
> PS. I may not have been very clear, the libxfs_trans_roll() and
>     inode_item_done() also cause a premature libxfs_iput().
>     Let me do more testing making any changes and target this for
>     xfsprogs-3.2.1.

You mean you've fixed the way we handle the attachement of inodes to
transaction in userspace to mirror what we do in kernelspace?  I'd love
to review this if you have patches as it's a somewhat of a pain point
to have these work so different in kernel and userspace.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
