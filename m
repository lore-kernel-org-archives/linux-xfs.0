Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F5A27F37
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 15:26:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7101F304059
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 13:26:08 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id FLEmMqzQGNNfVElq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 Nov 2015 13:26:05 -0800 (PST)
Date: Mon, 23 Nov 2015 13:25:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] generic/15[78]: fix error messages in the golden
	output
Message-ID: <20151123212533.GC10589@birch.djwong.org>
References: <20151121005001.20398.92856.stgit@birch.djwong.org>
	<20151121005014.20398.22316.stgit@birch.djwong.org>
	<20151121180644.GA23916@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151121180644.GA23916@infradead.org>
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

On Sat, Nov 21, 2015 at 10:06:44AM -0800, Christoph Hellwig wrote:
> > --- a/tests/generic/158.out
> > +++ b/tests/generic/158.out
> >  Try to dedupe a device
> > -XFS_IOC_FILE_EXTENT_SAME: Permission denied
> > +XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> >  Try to dedupe to a dir
> > -/mnt/test-158/dir1: Is a directory
> > +TEST_DIR/test-158/dir1: Is a directory
> >  Try to dedupe to a device
> > -dedupe: Permission denied
> > +dedupe: Operation not supported
> >  Try to dedupe to a fifo
> > -dedupe: Permission denied
> > +dedupe: Operation not supported
> 
> Shouldn't these be Invalid argument just like the
> to a device case above or the clone case?

I was trying to mirror the behavior of reflink, which spits out EOPNOTSUPP when
the destination isn't a regular file and EINVAL when the source isn't a regular
file.

--D

> 
> Otherwise looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
