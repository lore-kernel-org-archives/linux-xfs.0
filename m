Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D0BE77F58
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 16:46:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B67098F8035
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 14:46:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PmnclyxWkX8404JB for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 14:46:41 -0700 (PDT)
Date: Wed, 19 Aug 2015 07:45:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
Message-ID: <20150818214557.GC3902@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-6-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439828606-7886-6-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 06:23:20PM +0200, Jan Tulak wrote:
> Add and update various API, macros and types where is some change
> in OS X or xfsprogs. Most changes are in darwin.h.
> 
> Add dummy implementations where native support is nonexistent
> and the tools are not expected to work anyway, so all tools can be
> at least compiled.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Hmmm, looks like I accidentally comitted an earlier version of this
patch yesterday. Jan, can you send delta patches to what I committed
to address more recent review comments? Sorry, my bad.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
