Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C42FC7F61
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2014 16:41:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66F47AC005
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2014 14:41:54 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 7HdQHWawX6EbUDVr (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 19 Apr 2014 14:41:52 -0700 (PDT)
Date: Sat, 19 Apr 2014 17:41:49 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] generic: fix check for zero range support in generic/009
Message-ID: <20140419214149.GA11494@thunk.org>
References: <20140419190524.GA2116@wallace>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140419190524.GA2116@wallace>
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

On Sat, Apr 19, 2014 at 03:05:24PM -0400, Eric Whitney wrote:
> Generic/001 fails when run on a file system that does not support byte range
> zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
> on a pre-3.15 extent-mapped file system.  The code in the test intended
> to prevent this contains an apparent typo that results in a check for
> fallocate() rather than zero range support.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

LGTM.

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
