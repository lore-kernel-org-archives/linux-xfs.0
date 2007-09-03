Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Sep 2007 01:49:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l838nJ4p004199
	for <xfs@oss.sgi.com>; Mon, 3 Sep 2007 01:49:22 -0700
Date: Mon, 3 Sep 2007 18:49:16 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
Message-ID: <20070903084916.GG995458@sgi.com>
References: <46D6279F.40601@sgi.com> <46D6480F.4040307@sgi.com> <46D64CAD.6050705@sgi.com> <46D67FE6.20205@sgi.com> <46D68510.1020404@sgi.com> <46D77B79.3040104@sgi.com> <46D792A1.7030308@sgi.com> <20070831154822.GD734179@sgi.com> <46DB3E4B.3030106@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DB3E4B.3030106@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Mark Goodwin <markgw@sgi.com>, Lachlan McIlroy <lachlan@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 03, 2007 at 08:50:51AM +1000, Vlad Apostolov wrote:
> David Chinner wrote:
> >An unlinked inode is only detectable by the mode parameter being zero.
> >The rest of the inode will look valid.
> What about the nlink count? Can't we detect unlinked inode by nlink == 0?

A file that is open but unlinked must still remain valid on disk
until the last reference goes away. This inode will have a link
count of zero, but it is still a valid, referenced inode. Hence
detection of an inode with a link count of zero does not mean it
has been fully removed yet - a zero link count and a non-zero
mode indicates the inode should be onthe unlinked inode list.

See xfs_ifree() - the mode is zeroed only after the inode has been
pulled from the AGI unlinked list and marked free in the AGI btree.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
