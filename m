Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 07:14:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8FEE4es030326
	for <linux-xfs@oss.sgi.com>; Mon, 15 Sep 2008 07:14:07 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDD20442076
	for <linux-xfs@oss.sgi.com>; Mon, 15 Sep 2008 07:15:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id D216EwHyr0QthMuD for <linux-xfs@oss.sgi.com>; Mon, 15 Sep 2008 07:15:34 -0700 (PDT)
Date: Mon, 15 Sep 2008 10:15:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS does not recognise mount options in 2.6.27-rc6
Message-ID: <20080915141533.GA12590@infradead.org>
References: <pan.2008.09.14.18.53.20@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2008.09.14.18.53.20@telenet.be>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 06:53:21PM +0000, Frederik Himpe wrote:
> In 2.6.27-rc6, XFS still does not recognise mount options like logbufs and 
> others. Because of this, at boot time it fails to mount the partitions rw, 
> making the system unusable.
> 
> Some time ago, it seems a patch was about to be committed, but apparently 
> this has not been done yet:
> http://lkml.org/lkml/2008/8/14/340

The fix is in:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=62a877e35d5085c65936ed3194d1bbaf84f419e1

if you still see problems please give me the exact mount / remount
commands that cause you problems.
