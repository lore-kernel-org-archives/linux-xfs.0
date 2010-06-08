Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o585gJXO193995 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 00:42:19 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E9E9149F33A
	for <xfs@oss.sgi.com>; Mon,  7 Jun 2010 22:44:51 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id 8Rsfvpq6nIsYi1jf for <xfs@oss.sgi.com>;
	Mon, 07 Jun 2010 22:44:51 -0700 (PDT)
Date: Tue, 8 Jun 2010 15:44:46 +1000
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/6] writeback: tracing and fixes V4
Message-ID: <20100608054446.GT26335@laptop>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1275957487-23633-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 08, 2010 at 10:38:01AM +1000, Dave Chinner wrote:
> Hi Linus,
> 
> Can you please consider this patch series for 2.6.35? If you don't
> want the tracing at this stage of the release process, I can redo
> the series with just the bug fixes. However, given the regularity
> with which we break the writeback code in subtle ways, the tracing
> is probably just as important as the bug fixes.

Oh, I don't have a problem with your EOF fix being merged now, as Jan's
patch isn't suitable for 2.6.35.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
