Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7F917F37
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 23:42:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44EE5AC005
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 21:42:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	G7koUm4a9SBvtPvu for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 21:42:22 -0700 (PDT)
Date: Tue, 13 Oct 2015 15:42:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/14] xfsprogs: Make mremap conditional
Message-ID: <20151013044221.GF31326@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-14-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1442311164-12921-14-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 15, 2015 at 11:59:23AM +0200, Jan Tulak wrote:
> Don't build mremap (in xfs_io) on platforms where it has no support.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

This doesn't define HAVE_REMAP as a build define in io/Makefile,
so always fails to build in mremap support. this leads to:

generic/030 2s ... [not run] xfs_io mremap support is missing

I've fixed this on commit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
