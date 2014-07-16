Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F5537F57
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 02:12:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD701AC007
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 00:12:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id I09EWXGy9iovOoEu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 00:12:51 -0700 (PDT)
Date: Wed, 16 Jul 2014 00:12:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix uflags detection at xfs_fs_rm_xquota
Message-ID: <20140716071250.GA1461@infradead.org>
References: <53C4F5DB.2060108@oracle.com>
	<20140715102520.GH30363@infradead.org>
	<53C62595.6010702@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53C62595.6010702@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jul 16, 2014 at 03:11:17PM +0800, Jeff Liu wrote:
> > This code was introduced by commit
> > 9da93f9b7cdf8ab28da6b364cdc1fafc8670b4dc which attempts to fix the
> > broken quotarm code.  Seems like we need a testcase for this
> > functionality or just remove it.  Physically removing the quota file
> > never seems that useful to me to start with..
> 
> Is there an approach to verify that a particular quota file inode has
> been successfully removed?  It seems we have to do this in a test case
> but am not yet figure out a way, or any thoughts for the test case?

umount the filesystem and check that the field in the superblock
pointing to that kind of quota inode is zeroed out would be my
suggestion.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
