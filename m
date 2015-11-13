Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3C8B7F53
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 12:33:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4805CAC006
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 10:33:14 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id uKBYMWqCohGgMZgL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 10:33:08 -0800 (PST)
Date: Fri, 13 Nov 2015 10:32:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
Message-ID: <20151113183234.GD2224@birch.djwong.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
	<20151112090756.GA25685@infradead.org>
	<20151112125115.GA28822@infradead.org>
	<20151112173427.GC2217@birch.djwong.org>
	<20151112173635.GA9247@infradead.org>
	<20151113090822.GB2214@birch.djwong.org>
	<20151113141228.GA7218@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151113141228.GA7218@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Fri, Nov 13, 2015 at 06:12:28AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 13, 2015 at 01:08:22AM -0800, Darrick J. Wong wrote:
> > I think I got all the tests renumbered correctly and fixed all the other bugs.
> > I'd like to send the updated patchpile to Dave tomorrow, but if you have a few
> > spare cycles would you mind giving this a quick test to make sure I fixed
> > everything?
> > 
> > https://github.com/djwong/xfstests/tree/for-dave
> 
> Looks good enough to go in
> 
> Acked-by: Christoph Hellwig <hch@lst.de>
> 
> I have for failing tests on NFS currently.  Two of them probably are
> NFS issues (free block count), but and two others fail because NFS
> doesn't support chattr/lsattr.  I will send an incremental check to adda
> feature test for those.

I separated the chattr +i tests into a separate test that doesn't run if lsattr
doesn't make sense; will post patches shortly.

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
