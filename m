Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7AAJlwo175806 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 05:19:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37E0F18A0FA6
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 03:19:22 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1NRwvJ1UnypUYujG for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2011 03:19:22 -0700 (PDT)
Date: Wed, 10 Aug 2011 06:19:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] splice: i_mutex vs splice write deadlock V2
Message-ID: <20110810101921.GD27114@infradead.org>
References: <1312785927-10662-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312785927-10662-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xfs@oss.sgi.com

On Mon, Aug 08, 2011 at 04:45:25PM +1000, Dave Chinner wrote:
> generic_file_splice_write() takes the inode->i_mutex after the
> filesystem has taken whatever locks it needs to ensure sanity.
> however, this typically violates the locking order of filesystems
> with their own locks in that the order is usually i_mutex ->
> filesystem lock.
> 
> XFS is such a case, and generic_file_splice_write() is generating
> lockdep warnings because of lock inversions between the
> inode->i_mutex and the XFS_I(inode)->i_iolock. There is also a
> reported case of fio causing a deadlock when it mixes IO types
> (e.g. splice vs direct IO).

Another case is ocfs2, which looks like a perfect candidate to be
converted over to your infrastructure.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
