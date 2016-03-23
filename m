Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D1F37CB8
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 18:26:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B2D38F8040
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 16:26:35 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id Rnprakud2fzXkBAu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2016 16:26:32 -0700 (PDT)
Date: Thu, 24 Mar 2016 00:26:30 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] xfs: set up inode operation vectors later
Message-ID: <20160323232630.GA5646@lst.de>
References: <1458740935-31260-1-git-send-email-hch@lst.de>
	<1458740935-31260-3-git-send-email-hch@lst.de>
	<20160323230500.GZ30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323230500.GZ30721@dastard>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Mar 24, 2016 at 10:05:00AM +1100, Dave Chinner wrote:
> >  	d_instantiate(dentry, inode);
> >  	xfs_finish_inode_setup(cip);
> 
> I think there are more places than this that need xfs_setup_iops()
> calls - a quick look around makes me think they need to be paired
> with every path that calls xfs_finish_inode_setup().

Most calls to xfs_finish_inode_setup are for error cases that
just drop the inode instantly and don't need it.  The other
cases are:

 - xfs_generic_create, xfs_vn_symlink and xfs_setup_existing_inode,
   which are handled in this patch
 - xfs_qm_qino_alloc, which is for the quota inode that doesn't have
   inode operations
 - xfs_rename_alloc_whiteout which probably needs it.  This seems
   to be recent and has no apparent test coverage, so I'm not sure
   how to verify it, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
