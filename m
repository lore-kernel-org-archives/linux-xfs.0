Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EIfIPt025655 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 12:41:18 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 0/10] Perag lookup rework
Date: Thu, 14 Jan 2010 12:42:12 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A696E@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1263210469-22171-1-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> This is the previous set of patches all put together in the one series
> for the current xfs-dev tree.
> 
> Patch 10 is a new patch - it embeds the busy extent list into the perag
> structure rather than leaving as a separate allocation.

All 10 patches look good.  I am adding the following descriptions
to these patches which lacked them:

http://patchwork.xfs.org/patch/429/
[03/10] XFS: Convert filestreams code to use per-ag get/put routines

Description:
Use xfs_perag_get() and xfs_perag_put() in the filestreams code.


http://patchwork.xfs.org/patch/417/
[09/10] xfs: handle ENOMEM correctly during initialisation of perag structures

Description:
Add proper error handling in case an error occurs while initializing
new perag structures for a mount point.  The mount structure is
restored to its previous state by deleting and freeing any perag
structures added during the call.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
