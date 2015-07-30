Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6593D7F7C
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 12:07:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C12DAC002
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 10:07:35 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9yH2B8JGEE3EePGx (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 10:07:34 -0700 (PDT)
Date: Thu, 30 Jul 2015 10:07:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfsprogs: define NBBY if not defined by the system
	header files
Message-ID: <20150730170734.GA25395@infradead.org>
References: <1437913255-7524-1-git-send-email-tytso@mit.edu>
	<1437913255-7524-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1437913255-7524-2-git-send-email-tytso@mit.edu>
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

On Sun, Jul 26, 2015 at 08:20:50AM -0400, Theodore Ts'o wrote:
> Android's bionic libc doesn't define NBBY; this isn't a standard
> define, and since all modern/sane platforms have 8 bits per byte, use
> this as a default.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

This looks fine, but it'll clash with my patch that changes
platform_defs.h so that it's not run through autoconfs m4 anymore.

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
