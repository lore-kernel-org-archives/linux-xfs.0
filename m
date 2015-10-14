Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B3EB77F37
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 02:31:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86D4E304039
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 00:31:36 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ziQZcvk2rtwTR0IO (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Oct 2015 00:31:34 -0700 (PDT)
Date: Wed, 14 Oct 2015 00:31:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 01/51] libxcmd: provide a common function to report
	command runtimes
Message-ID: <20151014073133.GA26706@infradead.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050520.1504.59073.stgit@birch.djwong.org>
	<20151014053557.GI10397@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151014053557.GI10397@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

On Tue, Oct 13, 2015 at 10:35:57PM -0700, Darrick J. Wong wrote:
> Refactor the open-coded runtime stats reporting into a library
> command, then update xfs_io commands to use it.
> 
> v2: Pass the verb name along so that we can report it accurately
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good - and useful even without the actual reflink support.

Signed-off-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
