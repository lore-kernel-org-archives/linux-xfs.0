Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5CD717F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 11:23:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE68AAC005
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 09:23:13 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id VWyYAPAHMsRFdyx5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 09:23:10 -0700 (PDT)
Date: Fri, 20 Mar 2015 09:23:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
Message-ID: <20150320162303.GA18786@infradead.org>
References: <5509C0FD.70309@Netapp.com> <20150318185545.GF8818@fieldses.org>
	<5509E27C.3080004@Netapp.com> <20150318205554.GA10716@fieldses.org>
	<5509E824.6070006@Netapp.com> <20150318211144.GB10716@fieldses.org>
	<OFB111A6D8.016B8BD5-ON88257E0D.001D174D-88257E0D.005268D6@us.ibm.com>
	<20150319153627.GA20852@fieldses.org>
	<OF38D4D18B.19055EC2-ON88257E0D.0059BA03-88257E0D.005A781F@us.ibm.com>
	<20150320151718.GD2036@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150320151718.GD2036@fieldses.org>
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
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Marc Eshel <eshel@us.ibm.com>, Anna Schumaker <Anna.Schumaker@netapp.com>, linux-nfs-owner@vger.kernel.org

On Fri, Mar 20, 2015 at 11:17:18AM -0400, J. Bruce Fields wrote:
> Maybe this is a question for xfs developers.
> 
> So, we have a new READ_PLUS call that's basically just a version of READ
> optimized for sparse files:
> 
> 	http://tools.ietf.org/html/draft-ietf-nfsv4-minorversion2-33#section-15.10
> 
> It allows an NFS server to return either file data (like a normal READ
> call) or, at the server's discretion, records saying "this range of the
> data is all zeroes".
> 
> Anna tried implementing READ_PLUS for knfsd using
> vfs_llseek(.,.,SEEK_HOLE) followed by an ordinary read if that
> determines we're not at a hole.
> 
> (Very) preliminary results suggest that's slower than a plain READ for
> an xfs file with no holes.  (And *much* slower in the ext4 case for some
> reason.)

It should be a fairly cheap operastion, and does extent tree operations
that are pretty similar to an (uncached) read.  Do you have profiles?

> Is that expected, and should we be doing this some other way instead?

Are the read cached or uncached?  If they are from pagecache just
copying the zeroes is pretty much unbeatable compared to extent
tree lookups, so we'd need a new page flag (difficult..) to see
that a page is a hole (and then it would only work for the whole page),
but for uncached reads an optimization would be to tell a read that it's
an NFS READ_PLUS so that it could just read until it reach a hole,
and then we'd need some way to communicate the hole size (or just fall
back to SEEK_HOLE for that case).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
