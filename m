Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDB517F8E
	for <linux-xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:34:15 -0500 (CDT)
Date: Tue, 13 Aug 2013 16:34:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: avoid double-free in xfs_attr_node_addname
Message-ID: <20130813213412.GE12719@sgi.com>
References: <51F9B77E.2030005@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F9B77E.2030005@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On Wed, Jul 31, 2013 at 08:18:54PM -0500, Eric Sandeen wrote:
> xfs_attr_node_addname()'s error handling tests whether it
> should free "state" in the out: error handling label:
> 
> out:
>         if (state)
>                 xfs_da_state_free(state);
> 
> but an earlier free doesn't set state to NULL afterwards; this
> could lead to a double free.  Fix it by setting state to NULL
> after it's freed.
> 
> This was found by Coverity.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
