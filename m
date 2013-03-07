Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1E1C07FA1
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 12:43:09 -0600 (CST)
Date: Thu, 7 Mar 2013 12:43:08 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix potential infinite loop in
	xfs_iomap_prealloc_size()
Message-ID: <20130307184308.GN22182@sgi.com>
References: <1361557976-54981-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361557976-54981-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 22, 2013 at 01:32:56PM -0500, Brian Foster wrote:
> If freesp == 0, we could end up in an infinite loop while squashing
> the preallocation. Break the loop when we've killed the prealloc
> entirely.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Applied.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
