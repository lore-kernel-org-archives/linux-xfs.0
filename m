Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E212C29E05
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:01:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6FA9BAC020
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:01:51 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id dUxR4ldNfCLBjRG8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 10:01:50 -0800 (PST)
Date: Thu, 12 Dec 2013 10:01:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/10] xfstests: fix generic/225 to check fiemap support
Message-ID: <20131212180144.GB19422@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-7-git-send-email-jayr@google.com>
	<20131211074657.GF19248@infradead.org>
	<20131211224229.GK10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211224229.GK10988@dastard>
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
Cc: tytso@mit.edu, Junho Ryu <jayr@google.com>, hughd@google.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, branto@redhat.com

On Thu, Dec 12, 2013 at 09:42:29AM +1100, Dave Chinner wrote:
> I'd just rename if _require_fiemap, because we need both xfs_io and
> kernel support for it, and we need xfs_io support to check for
> kernel support....

Fine with me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
