Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 800BD7F37
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 21:46:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CFBEAC002
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 19:46:06 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	e8Afscpy3B70WaWy for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 19:46:05 -0700 (PDT)
Date: Mon, 29 Jul 2013 12:45:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: introduce object readahead to log recovery
Message-ID: <20130729024546.GD13468@dastard>
References: <1374740619-29797-1-git-send-email-zwu.kernel@gmail.com>
	<20130726025009.GE21982@dastard>
	<CAEH94Lh-UCCEs7hQi_t5v+X+ER1DH9dCtjr6e9GVNX5KJ-f1hQ@mail.gmail.com>
	<20130726113521.GM13468@dastard>
	<CAEH94Ljpih875VOEdCY9Z9CdMF_1DesW7dsz_k7Zm=xt165w5A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEH94Ljpih875VOEdCY9Z9CdMF_1DesW7dsz_k7Zm=xt165w5A@mail.gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>

On Mon, Jul 29, 2013 at 09:38:11AM +0800, Zhi Yong Wu wrote:
> By the way, how do you try the workload which has nothing but dirty
> dquote objects?

Create quota limits for non-existent users. That will allocate the
dquots and dirty them.

Or if you already have a few hundred thousand dquots, just change
the limits on them all to get them logged and dirty...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
