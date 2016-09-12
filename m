Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D23C7CA0
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 14:13:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9461304059
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 12:13:21 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id xnSkXncArVIhA73t (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Sep 2016 12:13:20 -0700 (PDT)
Date: Mon, 12 Sep 2016 12:12:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/6] vfs: support FS_XFLAG_REFLINK and FS_XFLAG_COWEXTSIZE
Message-ID: <20160912191251.GB23422@birch.djwong.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
	<147216786073.525.16014208838990530622.stgit@birch.djwong.org>
	<20160905145622.GB7662@infradead.org>
	<20160906191515.GA26927@birch.djwong.org>
	<20160911125808.GD1399@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160911125808.GD1399@infradead.org>
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
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, linux-xfs@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

On Sun, Sep 11, 2016 at 05:58:08AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 06, 2016 at 12:15:15PM -0700, Darrick J. Wong wrote:
> > So far I've put the reflink flag to use in xfs_scrub to look for
> > obvious signs of brokenness such as extents that overlap or have the
> > shared flag set but the inode flag is off; and to skip various kinds
> > of checks that don't have to happen when blocks don't overlap.
> > 
> > I doubt there's much of a use for the flag outside of the XFS utilities.
> > For a while I pondered only exposing the fsxattr flag if the caller had
> > CAP_SYS_ADMIN (the level of priviledge required to run scrub) but
> > decided that I wouldn't change the existing interface like that unless
> > I had a really good reason.
> 
> I don't think CAP_SYS_ADMIN is nessecarily the right thing, but it's
> still an XFS implementation detail which I don't think we should
> pollute a flags API for normal user space applications with.

I can work around it in xfs_scrub, so I'll give back the xflag bit for
reflink.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
