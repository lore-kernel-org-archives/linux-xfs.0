Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3JdhFQ048695 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 14:39:43 -0500
Date: Thu, 3 Nov 2011 15:39:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/9] xfstests: add a new quota test that runs fsstress
	under ENOSPC conditions
Message-ID: <20111103193935.GA23014@infradead.org>
References: <1320342953-7973-1-git-send-email-dmonakhov@openvz.org>
	<1320342953-7973-7-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320342953-7973-7-git-send-email-dmonakhov@openvz.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, hch@lst.de, aelder@sgi.com

On Thu, Nov 03, 2011 at 09:55:51PM +0400, Dmitry Monakhov wrote:
> - Same as 264 but with quota enabled.

269 is the new 270

> - IO performed from $qa_user user
> - fsstress granted with CAP_CHOWN capability.

This fails in my test VM because it doesn't have setcap.  If you
want to use additional non-standard tools please do a _notrun if
they aren't present.

I don't quite understand why it would need CAP_CHOWN - chowns
from owned files do not require it, and the test runs fine with
the setcap line commented out.

I'll commit it as-is for now, but unless I get some feedback on
why the setcap is require I'll add another commit to remove it ASAP.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
