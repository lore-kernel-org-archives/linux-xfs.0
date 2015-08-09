Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 003397F54
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 02:37:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2DE6304059
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 00:37:21 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id mglt8LzbdmyFPwzq (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2015 00:37:20 -0700 (PDT)
Date: Sun, 9 Aug 2015 00:37:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/11] xfs: return committed status from xfs_trans_roll()
Message-ID: <20150809073720.GB3163@infradead.org>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438883072-28706-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 06, 2015 at 01:44:23PM -0400, Brian Foster wrote:
> Some callers need to make error handling decisions based on whether the
> current transaction successfully committed or not. Rename
> xfs_trans_roll(), add a new parameter and provide a wrapper to preserve
> existing callers.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
