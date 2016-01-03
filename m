Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6527D7F4E
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 06:13:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5354B8F8035
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 04:13:56 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gRCgcEdkOPJ91XKQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2016 04:13:55 -0800 (PST)
Date: Sun, 3 Jan 2016 04:13:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/76] xfs: fix log ticket type printing
Message-ID: <20160103121353.GA28429@infradead.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219085636.12713.59155.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219085636.12713.59155.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Sat, Dec 19, 2015 at 12:56:36AM -0800, Darrick J. Wong wrote:
> Update the log ticket reservation type printing code to reflect
> all the types of log tickets, to avoid incorrect debug output and
> avoid running off the end of the array.

This looks okay, but I think we should use name array initializers
to make sure it doesn't got out of sync ever.

Also I don't think we'd ever run past the array as the users
does a size check.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
