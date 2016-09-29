Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4163E7CA1
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 15:18:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 136E08F8033
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 13:18:38 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id HeT3acmb326Uz1eU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Sep 2016 13:18:36 -0700 (PDT)
Date: Thu, 29 Sep 2016 22:18:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: aio completions vs file_accessed race, was: Re: [PATCH 7/8]
	xfs: split direct I/O and DAX path
Message-ID: <20160929201834.GA5872@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<1466609236-23801-8-git-send-email-hch@lst.de>
	<20160929025351.GB4901@birch.djwong.org>
	<20160929083824.GA12799@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160929083824.GA12799@lst.de>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Can you try the patch below?  That just moves the file_accessed call
before the I/O, similar to how we handle timestamp updates on the write
side.  generic_file_read_iter will also need a similar update.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
