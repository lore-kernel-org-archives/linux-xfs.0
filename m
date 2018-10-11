Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbeJKVGu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 17:06:50 -0400
Date: Thu, 11 Oct 2018 06:39:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/25] xfs: add a per-xfs trace_printk macro
Message-ID: <20181011133934.GA23424@infradead.org>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923114361.5546.11838344265359068530.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923114361.5546.11838344265359068530.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Oct 10, 2018 at 09:12:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a "xfs_tprintk" macro so that developers can use trace_printk to
> print out arbitrary debugging information with the XFS device name
> attached to the trace output.

I can't say I'm a fan of this.  trace_printk is a debugging aid,
and opencoding the file system name really isn't much of a burden.
