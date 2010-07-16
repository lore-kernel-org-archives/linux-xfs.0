Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6G6RMSV249044 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 01:27:23 -0500
Received: from dmz-mailsec-scanner-5.mit.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27AF315DFECC
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 23:30:19 -0700 (PDT)
Received: from dmz-mailsec-scanner-5.mit.edu (DMZ-MAILSEC-SCANNER-5.MIT.EDU
	[18.7.68.34]) by cuda.sgi.com with ESMTP id Kw0TT5AYiHAfCOMS
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 23:30:19 -0700 (PDT)
Subject: Re: [PATCH 0/2] Fix aio completion vs unwritten extents
Mime-Version: 1.0 (Apple Message framework v1081)
From: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20100716060405.GA32712@infradead.org>
Date: Fri, 16 Jul 2010 02:30:07 -0400
Message-Id: <D4FBB738-1BAF-4100-BA6E-6CAC184BC30B@mit.edu>
References: <20100622122144.302857146@bombadil.infradead.org>
	<20100716060405.GA32712@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com


On Jul 16, 2010, at 2:04 AM, Christoph Hellwig wrote:

> Given that this still hasn't been picked up in any other tree would
> people mind if we push patches 1 and 2 through the XFS tree?
> 
> I some more changes that sit ontop of this, and it would make my
> life a lot easier.


Thanks for bringing this up.  I was going to ask if you had any changes
in patch1 of this series since I was about to put them into the ext4 tree
and I didn't want to have any merge conflicts (or have to force a tree
rewind/rebase) if it turned out if there had been some changes and
some other tree landed in Linus's tree first.

In other words, since we both have patches that depend on your
first patch, one easy way of handling things is that we both put them
into our respective fs trees, and as long as the patch doesn't change
git should do the right thing when Steve or Linus merges them into their
linux-next or linus trees, respectively.

Do you have any objections with this?

									- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
