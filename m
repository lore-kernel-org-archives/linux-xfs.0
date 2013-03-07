Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 858AF7FA1
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 12:45:39 -0600 (CST)
Date: Thu, 7 Mar 2013 12:45:39 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix xfs_iomap_eof_prealloc_initial_size type
Message-ID: <20130307184539.GQ22182@sgi.com>
References: <20130224190436.906161932@sgi.com>
	<20130224190441.937509860@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130224190441.937509860@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 24, 2013 at 01:04:37PM -0600, Mark Tinguely wrote:
> Fix the return type of xfs_iomap_eof_prealloc_initial_size() to
> xfs_fsblock_t to reflect the fact that the return value may be an
> unsigned 64 bits if XFS_BIG_BLKNOS is defined.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
