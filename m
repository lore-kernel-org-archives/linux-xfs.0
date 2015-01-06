Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 11D737F8D
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:40:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2C5C304059
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 09:40:02 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id CEY8h0z4B8b4GJsV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 09:40:00 -0800 (PST)
Date: Tue, 6 Jan 2015 18:39:57 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/18] nfsd: pNFS block layout driver
Message-ID: <20150106173957.GA16200@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-15-git-send-email-hch@lst.de>
	<20150106171658.GD12067@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150106171658.GD12067@fieldses.org>
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

On Tue, Jan 06, 2015 at 12:16:58PM -0500, J. Bruce Fields wrote:
> > +file system must sit on shared storage (typically iSCSI) that is accessible
> > +to the clients as well as the server.  The file system needs to either sit
> > +directly on the exported volume, or on a RAID 0 using the MD software RAID
> > +driver with the version 1 superblock format.  If the filesystem uses sits
> > +on a RAID 0 device the clients will automatically stripe their I/O over
> > +multiple LUNs.
> > +
> > +On the server pNFS block volume support is automatically if the file system
> 
> s/automatically/automatically enabled/.
> 
> So there's no server-side configuration required at all?

The only required configuration is the fencing helper script if you
want to be able to fence a non-responding client.  For simple test setups
everything will just work out of the box.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
