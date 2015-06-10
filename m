Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0BBF27F86
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 03:24:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F1ECA304053
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 01:24:17 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JZ5nQu92icwgRfOb (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jun 2015 01:24:16 -0700 (PDT)
Date: Wed, 10 Jun 2015 01:24:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs for-next build error on Debian Wheezy / amd64
Message-ID: <20150610082415.GA23860@infradead.org>
References: <20150610070604.GA9855@infradead.org>
	<20150610081914.GV9143@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150610081914.GV9143@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 10, 2015 at 06:19:14PM +1000, Dave Chinner wrote:
> Does the problem go away after a 'make distclean'?

No. Neither a distclean nor a fresh clone fixes the issue.

Also disabling the crc32ctest target I get similar error in other
code.

Note that the master branch is doing fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
