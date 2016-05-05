Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 022647CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 12:33:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 692BDAC005
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 10:33:36 -0700 (PDT)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id jnsZOfZWMkCN8zeP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 10:33:34 -0700 (PDT)
Date: Thu, 5 May 2016 13:33:31 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <1752444498.1998887.1462469611479.JavaMail.zimbra@redhat.com>
In-Reply-To: <1462310947-16132-4-git-send-email-hch@lst.de>
References: <1462310947-16132-1-git-send-email-hch@lst.de>
	<1462310947-16132-4-git-send-email-hch@lst.de>
Subject: Re: [PATCH 03/14] xfs: make xfs_bmbt_to_iomap available outside of
	xfs_pnfs.c
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

----- Original Message -----
> And ensure it works for RT subvolume files an set the block device,
> both of which will be needed to be able to use the function in the
> buffered write path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c | 27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_iomap.h |  4 ++++
>  fs/xfs/xfs_pnfs.c  | 26 --------------------------
>  3 files changed, 31 insertions(+), 26 deletions(-)

Reviewed-by: Bob Peterson <rpeterso@redhat.com>

Ugh. Just noticed my previous ones said "Reviewed-off-by". Please
change accordingly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
