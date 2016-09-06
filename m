Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 824C57CA7
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 01:38:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 556C1304043
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 23:38:52 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HXnd235h6IqrlrUU (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2016 23:38:51 -0700 (PDT)
Date: Mon, 5 Sep 2016 23:38:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/71] xfs: introduce tracepoints for AG reservation code
Message-ID: <20160906063848.GB11411@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216795137.867.2930536284130968371.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216795137.867.2930536284130968371.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

> +/* dummy definitions to avoid breaking bisectability; will be removed later */
> +#ifndef XFS_AG_RESV_DUMMY
> +#define XFS_AG_RESV_DUMMY

This seems really odd.  Why would we need this exaxtly?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
