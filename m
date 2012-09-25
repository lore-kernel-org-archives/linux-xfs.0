Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8P9Zw0b037905 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 04:35:58 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CnW7odz7ZszzhHYh (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 02:37:15 -0700 (PDT)
Date: Tue, 25 Sep 2012 05:37:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfs: Fix mp->m_maxagi update during inode64 remount
Message-ID: <20120925093715.GF9189@infradead.org>
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
	<1348147961-7520-5-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348147961-7520-5-git-send-email-cmaiolino@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 20, 2012 at 10:32:39AM -0300, Carlos Maiolino wrote:
> With the changes made on xfs_set_inode64(), to make it behave as
> xfs_set_inode32() (now leaving to the caller the responsibility to update
> mp->m_maxagi), we use the return value of xfs_set_inode64() to update
> mp->m_maxagi during remount.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Shouldn;t this be part of the previous patch?

Otherwise looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
