Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A0C57F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 15:32:58 -0600 (CST)
From: Shaun Gosse <sgosse@sgi.com>
Subject: RE: [PATCH] xfs: check all buffers in xfs_check_page_type()
Date: Fri, 28 Feb 2014 21:32:53 +0000
Message-ID: <8D3FA7645C1CFC4E9E783D22B4C708647305CBB3@P-EXMB2-DC21.corp.sgi.com>
References: <1393615369-41882-1-git-send-email-bfoster@redhat.com>
	<5310EB67.5050404@sgi.com>
In-Reply-To: <5310EB67.5050404@sgi.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Mark Tinguely <tinguely@sgi.com>, Brian Foster <bfoster@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> Is there any reason to scan all the buffers when we all we want is an indication that at least one is acceptable?
> Maybe there are generally not may buffers to a page to make it worthwhile.
>

The problem is the else doesn't check if acceptable is set before breaking. So it can quit early, not having found what it was looking for even though it was in one of the later buffers. Pre-mature optimization...

So the patch is good as is. It improves correctness.

If the optimization were desired, though, it could be:

+ else if (acceptable)
+   break 

In addition to the remove already posted, and with proper whitespace.

Fair warning: this is without looking at the code, just inferring from what's been written in those two emails. I'm hearing my CS101 professor in my head and thinking may not be worth a couple cycles at the risk of correctness or clarity (and suggesting code blind seems risky).

Actually, this could be the first condition. If the whole point of that loop is just to make sure to set acceptable if it can be set according to the rules on the basis of at least one of the buffers, then a starting:

+ if (acceptable)
+    break

With an annotation something like "/** Optimization: Quit when acceptable has been set. Loop has no other side-effects to worry about.*/" seems reasonable (and hopefully is true). And then it's clear from the code that's the point of the loop and how it works.

Cheers,
-Shaun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
