Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 468257FE0
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 00:55:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 210CB304032
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 22:55:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id mYevxRB6T2fGoeFt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 22:55:27 -0800 (PST)
Date: Tue, 10 Dec 2013 22:55:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] generic: require filesize to be greater than fs block
	size in generic/240
Message-ID: <20131211065525.GA11124@infradead.org>
References: <1386321845-9221-1-git-send-email-stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386321845-9221-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: vasily.isaenko@oracle.com, xfs@oss.sgi.com

> -# 2 threads, fs block sized writes, 64k filesize, stride through file by
> +if [ $file_size -lt $fs_block_size ]; then
> +	file_size=$fs_block_size
> +fi

We'd need the file size to be a multiple of the block size to make this
useful, I'd take 4 or 8 times as a useful default.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
