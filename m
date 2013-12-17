Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 790F47F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 10:02:33 -0600 (CST)
Date: Tue, 17 Dec 2013 10:02:29 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/6] xfs: fixes for 3.13-rc4
Message-ID: <20131217160229.GT1935@sgi.com>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386826478-13846-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 04:34:32PM +1100, Dave Chinner wrote:
> Theses are all the kernel fixes I've accumulated over the past
> few weeks. There are a couple of IO error handling fixes, log grant
> head accounting fixes to avod spurious warnings, a swalloc alignment
> fix, and a patch to fix all the leaks in
> xlog_recover_process_data().

Applied Christoph's version of patch 1, as well as 4, and 6.  Cherry-picked
some stuff that I feel is appropriate for -rc5 and pushed into
xfs-for-linus-v3.13-rc5.

I'm not certain about the the two 'spurious messages' patches just yet.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
