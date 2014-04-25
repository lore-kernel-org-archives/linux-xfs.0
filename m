Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C1AE7F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 01:53:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A4BC7AC006
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 23:53:02 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id MVW701eSw8CmOX18 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 23:53:01 -0700 (PDT)
Date: Thu, 24 Apr 2014 23:53:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 07/10] xfs: introduce xfs_bulkstat_grab_ichunk
Message-ID: <20140425065301.GD20871@infradead.org>
References: <535078C5.5060107@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535078C5.5060107@oracle.com>
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

> -				agino = r.ir_startino + XFS_INODES_PER_CHUNK;

> +				agino += r.ir_startino + XFS_INODES_PER_CHUNK;

why did this turns from a = into a += ?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
