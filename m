Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHlEdO059325 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:47:14 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7DLAlgzvfL7BkYft (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 09:47:13 -0800 (PST)
Date: Tue, 24 Jan 2012 12:47:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/4] Define a new function xfs_this_quota_on()
Message-ID: <20120124174712.GD9853@infradead.org>
References: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173125.31546.2342.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123173125.31546.2342.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 11:31:25AM -0600, Chandra Seetharaman wrote:
> Create a new function xfs_this_quota_on() that takes a xfs_mount
> data srtucture and a disk quota type and returns true if the specified
> type of quota is ON in the xfs_mount data structure.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good except for a tiny style nitpick.

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +	switch(type) {

This should have a whitespace after the opening brace.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
