Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54050 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfBBU3W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 15:29:22 -0500
Date: Sat, 2 Feb 2019 12:29:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/8] xfs: refactor inode unlinked pointer update functions
Message-ID: <20190202202913.GS5761@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897670150.26065.2878806054016276963.stgit@magnolia>
 <20190202162737.GC25154@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190202162737.GC25154@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Sat, Feb 02, 2019 at 08:27:37AM -0800, Christoph Hellwig wrote:
> > +	ASSERT(new_agino == NULLAGINO ||
> > +	       xfs_verify_agino(mp, XFS_INO_TO_AGNO(mp, ino), new_agino));
> 
> We have quite a few uses of this pattern.  Shouldn't we just add a
> a xfs_verify_agino_or_null helper?

Yeah, I'll clean that up.

> Also given that the caller has the agno and we use it a few times
> maybe pass it as an argument?
> 
> Also shouldn't new_agino be called something like next_agino or at
> least have a little comment explaining what it stands for?
> 
> > +	xfs_trans_log_buf(tp, ibp, offset, (offset + sizeof(xfs_agino_t) - 1));
> 
> No need for the innter braces.
> 
> Otherwise this looks conceptually fine to me.

Ok, will fix this and the others.

--D
