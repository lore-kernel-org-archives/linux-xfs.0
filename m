Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C2C37FD5
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:16:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FE158F8033
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:16:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Yah8TAgcdQBUmi5P (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:16:52 -0700 (PDT)
Date: Tue, 6 May 2014 01:16:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: don't need dirv2 checks anymore
Message-ID: <20140506081652.GC24143@infradead.org>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
	<1399348559-19889-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399348559-19889-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> -	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
> +	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);

How is this going to work for v5 filesystems?  Probably better to just
kill the assert..

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
