Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13FJvMT138221 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 09:19:57 -0600
Date: Fri, 3 Feb 2012 09:19:58 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC PATCH 1/4] Define a new function xfs_this_quota_on()
Message-ID: <20120203151958.GH13095@sgi.com>
References: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173125.31546.2342.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120124174712.GD9853@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120124174712.GD9853@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Tue, Jan 24, 2012 at 12:47:12PM -0500, Christoph Hellwig wrote:
> On Mon, Jan 23, 2012 at 11:31:25AM -0600, Chandra Seetharaman wrote:
> > Create a new function xfs_this_quota_on() that takes a xfs_mount
> > data srtucture and a disk quota type and returns true if the specified
> > type of quota is ON in the xfs_mount data structure.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> Looks good except for a tiny style nitpick.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > +	switch(type) {
> 
> This should have a whitespace after the opening brace.

I've added the space.

This patch looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
