Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC9067CA1
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 14:20:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BC61AC004
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 12:19:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FfYlQyewwqybNqFb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 12:19:56 -0700 (PDT)
Date: Tue, 28 Jun 2016 12:19:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 001/119] vfs: fix return type of ioctl_file_dedupe_range
Message-ID: <20160628191929.GC4917@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612627940.12839.15145788608361492501.stgit@birch.djwong.org>
	<20160617113223.GA19042@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160617113223.GA19042@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Fri, Jun 17, 2016 at 04:32:23AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 16, 2016 at 06:17:59PM -0700, Darrick J. Wong wrote:
> > All the VFS functions in the dedupe ioctl path return int status, so
> > the ioctl handler ought to as well.
> > 
> > Found by Coverity, CID 1350952.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This should go out to Al as a separate patch.

I sent it to him back in February, though he hasn't responded.

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
