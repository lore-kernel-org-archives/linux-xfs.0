Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A596129DFD
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2014 16:42:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45E63AC009
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2014 14:42:06 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id R6gFMMtY1M9CC24T (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 19 Apr 2014 14:42:04 -0700 (PDT)
Date: Sat, 19 Apr 2014 17:42:03 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix check for zero range support in ext4/001
Message-ID: <20140419214203.GB11494@thunk.org>
References: <20140419190815.GB2116@wallace>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140419190815.GB2116@wallace>
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
To: Eric Whitney <enwlinux@gmail.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Sat, Apr 19, 2014 at 03:08:15PM -0400, Eric Whitney wrote:
> Ext4/001 fails when run on a file system that does not support byte range
> zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
> on a pre-3.15 extent-mapped file system.  The code in the test intended
> to prevent this contains an apparent typo that results in a check for
> fallocate() rather than zero range support.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

LGTM

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
