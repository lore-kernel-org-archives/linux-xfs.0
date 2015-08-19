Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FCC97F73
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 03:09:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 21EC58F8037
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 01:09:43 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id osgqI9vCTTVSXFs2 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 01:09:42 -0700 (PDT)
Date: Wed, 19 Aug 2015 01:09:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
Message-ID: <20150819080940.GA13130@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-6-git-send-email-jtulak@redhat.com>
	<20150818214557.GC3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150818214557.GC3902@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: hch@infradead.org, xfs@oss.sgi.com, Jan Tulak <jtulak@redhat.com>

On Wed, Aug 19, 2015 at 07:45:57AM +1000, Dave Chinner wrote:
> Hmmm, looks like I accidentally comitted an earlier version of this
> patch yesterday. Jan, can you send delta patches to what I committed
> to address more recent review comments? Sorry, my bad.

Can you revert it for now? I think most of these changes are incorrect
and should either be dropped for now by disabling fsx or will need
a major rework.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
