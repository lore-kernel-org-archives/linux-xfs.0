Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B6B17F7C
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 12:10:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 69A278F8033
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 10:10:01 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 0aPWiklUUZCNZt8H (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 10:09:59 -0700 (PDT)
Date: Thu, 30 Jul 2015 10:09:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfsprogs: use "unsigned short" instead of ushort
Message-ID: <20150730170958.GB25395@infradead.org>
References: <1437913255-7524-1-git-send-email-tytso@mit.edu>
	<1437913255-7524-6-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1437913255-7524-6-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jul 26, 2015 at 08:20:54AM -0400, Theodore Ts'o wrote:
> Android's bionic libc doesn't define ushort.  There isn't a real
> benefit (other than perhaps conciseness) to use ushort over "unsigned
> short", and it's only used in a handful of files in xfsprogs.  So
> change over to using unsigned short everywhere.

For the files shared with the kernel this should go into the kernel
first or at least at the same time.  Can you also send
a kernel patch to remove all uses of ushort under fs/xfs?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
