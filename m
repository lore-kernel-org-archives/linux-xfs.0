Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OHAjmV180842 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 12:10:45 -0500
Date: Mon, 24 Sep 2012 12:11:59 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
Message-ID: <20120924171159.GG1140@sgi.com>
References: <20120919163133.097340199@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120919163133.097340199@sgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

Hi Mark,

On Wed, Sep 19, 2012 at 11:31:33AM -0500, tinguely@sgi.com wrote:
...
> I traced the callers of xfs_alloc_vextent(), noting transaction creation,
> commits and cancels; I noted loops in the callers and which were marked
> as metadata/userdata. I can send this document to reviewers.

I'd like to see the doc of xfs_alloc_vextent callers and which of them loop.
Can you post your doc to the list?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
