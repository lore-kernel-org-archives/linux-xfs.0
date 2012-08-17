Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7HIFjpN074655 for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 13:15:45 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 61d5NdRTgIeprSoE for <xfs@oss.sgi.com>;
	Fri, 17 Aug 2012 11:15:44 -0700 (PDT)
Received: from macmini.sandeen.net (macmini.sandeen.net [10.0.0.61])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: sandeen)
	by mail.sandeen.net (Postfix) with ESMTP id 39EB14F32D84
	for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 13:15:44 -0500 (CDT)
Message-ID: <502E8A4F.9050105@sandeen.net>
Date: Fri, 17 Aug 2012 13:15:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS regression: Oops in xfs_buf_do_callbacks on xfstest 137
References: <501ABC84.6030708@sandeen.net>
	<20120817180254.GA15382@infradead.org>
In-Reply-To: <20120817180254.GA15382@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 8/17/12 1:02 PM, Christoph Hellwig wrote:
> I'd be this is my new code added to xfs_buf_item_unpin, but I don't
> quite understand why.  It's been a long time since I wrote that code,
> but I had to add that code to make sure we clear all buffers during
> a forced shutdown.  Can you test if things go away if you just remove it
> (even if causes other hangs?)

It does go away AFAIK, since the bisect found it.

Sadly it's been on the back burner for me, under other deadline pressure.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
