Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 31E6329E12
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 16:02:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 10A898F8035
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 14:02:12 -0800 (PST)
MIME-Version: 1.0
From: Chris Mason <clm@fb.com>
In-Reply-To: <20131204212504.GX1935@sgi.com>
References: <20131119151707.GA13412@infradead.org>
	<20131204212504.GX1935@sgi.com>
Message-ID: <20131204220144.1501.13481@ret>
Subject: Re: [PATCH] fs: fix iversion handling
Date: Wed, 4 Dec 2013 17:01:44 -0500
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
To: Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Quoting Ben Myers (2013-12-04 16:25:04)
> Hey Christoph,
> 
> On Tue, Nov 19, 2013 at 07:17:07AM -0800, Christoph Hellwig wrote:
> > Currently notify_change directly updates i_version for size updates,
> > which not only is counter to how all other fields are updated through
> > struct iattr, but also breaks XFS, which need inode updates to happen
> > under its own lock, and synchronized to the structure that gets written
> > to the log.
> > 
> > Remove the update in the common code, and it to btrfs and ext4,
> > XFS already does a proper updaste internally and currently gets a
> > double update with the existing code.
> > 
> > IMHO this is 3.13 and -stable material and should go in through the XFS
> > tree.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Does this still need a btrfs ack, or is it ready to go?

The btrfs parts look good to me.

Signed-off-by: Chris Mason <clm@fb.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
