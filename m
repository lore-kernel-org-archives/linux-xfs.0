Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF9527CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 03:11:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD9F48F8033
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 01:11:06 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id pxqlPh11iKBU3syO (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 01:11:04 -0800 (PST)
Date: Tue, 9 Feb 2016 01:11:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: Introduce writeback context for writepages
Message-ID: <20160209091103.GA23349@infradead.org>
References: <1440479153-1584-1-git-send-email-david@fromorbit.com>
	<1440479153-1584-3-git-send-email-david@fromorbit.com>
	<20160208073631.GA1789@infradead.org>
	<20160208075403.GA29242@infradead.org>
	<20160208202123.GL27429@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208202123.GL27429@dastard>
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
Cc: xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 07:21:23AM +1100, Dave Chinner wrote:
> What is your test config? The only failures I've had recently of
> generic/311 were caused by a bug in the fsync-tester application.
> This was fixed by commit 9165a84 ("fsync-tester: reopen files with
> correct flags") that was pushed out in the fstests update I did
> yesterday.

Yeah, that seems to fix it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
