Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E0FD47F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 01:43:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6606304043
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 23:43:35 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id LHCgDseDO9XL9Q1X (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 23:43:33 -0700 (PDT)
Date: Thu, 24 Apr 2014 23:43:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 04/10] xfs: introduce per allocation group inumbers
Message-ID: <20140425064333.GA20871@infradead.org>
References: <535078B5.4010700@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535078B5.4010700@oracle.com>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Apr 18, 2014 at 08:58:29AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Introduce xfs_perag_inumbers(), it could be used to fetch the inode number
> tables per allocation group via a new ioctl(2) in the future.  Also, that
> would be a net win considering the scalability for a file system with huge
> number of inodes as multiple allocation groups can be scanned in parallel,
> refactor xfs_inumbers() with it.

Given that you don't actually introduce a per-ag inumbers interface in
this series I'd prefer if you just refactor the inumbers code to
add a helper that operates on an AG with xfs_inumbers moving on to
the next one, but not adding the xfs_aginumbers structure that just
makes the move less obvious for now. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
