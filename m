Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBA59DeA013435 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 23:09:13 -0600
Message-ID: <493F4EF2.1020300@sgi.com>
Date: Wed, 10 Dec 2008 16:09:06 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 5/5] use inode_change_ok for setattr permission checking
References: <20081209094729.939583000@bombadil.infradead.org>
	<20081209094801.643772000@bombadil.infradead.org>
In-Reply-To: <20081209094801.643772000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Instead of implementing our own checks use inode_change_ok to check for
> necessary permission in setattr.  There is a slight change in behaviour
> as inode_change_ok doesn't allow i_mode updates to add the suid or sgid
> without superuser privilegues while the old XFS code just stripped away
> those bits from the file mode.
> 
> (First sent on Semptember 29th)
(No reply from Question on Nov 12th:)

I just wanted to run this thru an amended xfstests/193 first.

Thanks,
--Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
