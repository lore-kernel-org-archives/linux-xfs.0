Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 043EB7FA9
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 01:30:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E24298F804B
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 23:30:28 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id WrPkScWsHkYAL2uk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 23:30:27 -0800 (PST)
Date: Mon, 2 Feb 2015 08:30:24 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/20] xfs: pass a 64-bit count argument to
	xfs_iomap_write_unwritten
Message-ID: <20150202073024.GA9399@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-17-git-send-email-hch@lst.de>
	<20150129205232.GB11064@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150129205232.GB11064@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Thu, Jan 29, 2015 at 03:52:32PM -0500, J. Bruce Fields wrote:
> Who can give us ACKs on these last five fs/xfs patches?  (And is it
> going to cause trouble if they go in through the nfsd tree?)


We'd need ACKs from Dave.  He already has pulled in two patches so
we might run into some conflicts.  Maybe the best idea is to add the
exportfs patch to both the XFS and nfsd trees, so each of them can
pull in the rest?  Or we could commit the two XFS preparation patches
to both tree and get something that compiles and works in the nfsd
tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
