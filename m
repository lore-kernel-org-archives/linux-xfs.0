Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C523F7CA1
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 12:40:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 843E230405F
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 10:40:34 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JgNq4RMrfTlOBKrb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 10:40:32 -0700 (PDT)
Date: Wed, 30 Mar 2016 10:40:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't hand out pNFS layouts for reflink inodes
Message-ID: <20160330174026.GB2236@birch.djwong.org>
References: <1456936485-21940-1-git-send-email-hch@lst.de>
	<20160328195140.GB5360@birch.djwong.org>
	<20160329072128.GA14940@lst.de>
	<20160330000842.GD5822@birch.djwong.org>
	<20160330172634.GA22951@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160330172634.GA22951@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Mar 30, 2016 at 07:26:34PM +0200, Christoph Hellwig wrote:
> On Tue, Mar 29, 2016 at 05:08:42PM -0700, Darrick J. Wong wrote:
> > > Btw, we'll need something similar to prevent swapfiles which just use
> > > ->bmap, but unfortunately swap just checks for the existences of method,
> > > so I'll probably have to do some VFS changes to properly support that.
> > 
> > Yes, please.  ocfs2 will gladly let you call swapon on a reflinked file,
> > and totally fails to CoW it properly. :)
> 
> Ouch.  Time to add a test for that to xfstests..

Swap/reflink tests will appear as generic/92[34] the next time I post xfstests
patches.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
