Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 899EE7F7C
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 12:11:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32CA0AC003
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 10:11:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id v2F9A8FHkV4mIz2X (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 10:11:28 -0700 (PDT)
Date: Thu, 30 Jul 2015 10:11:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfsprogs: avoid use of si_tid in struct
	xlog_split_item
Message-ID: <20150730171128.GF25395@infradead.org>
References: <1437913255-7524-1-git-send-email-tytso@mit.edu>
	<1437913255-7524-5-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1437913255-7524-5-git-send-email-tytso@mit.edu>
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

On Sun, Jul 26, 2015 at 08:20:53AM -0400, Theodore Ts'o wrote:
> In Android's bionic libc (as well as the Linux kernel's
> include/uapi/asm-generic/siginfo.h), si_tid is a #define to provide
> backwards compatibility for the timerid in the siginfo structure.
> This breaks the compile of logprint/log_misc.c.  Change this to be
> si_xtid in order to avoid a namespace collision

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
