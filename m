Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51708 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933745AbcKMMMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Nov 2016 07:12:15 -0500
Date: Sun, 13 Nov 2016 04:12:14 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: new xfs/103 failure
Message-ID: <20161113121214.GB8362@infradead.org>
References: <20161112163248.GA24737@infradead.org>
 <20161112183129.GJ27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161112183129.GJ27776@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Nov 13, 2016 at 02:31:29AM +0800, Eryu Guan wrote:
> On Sat, Nov 12, 2016 at 08:32:48AM -0800, Christoph Hellwig wrote:
> > After recently upgrading the xfs and xfsprogs trees I get reproducible
> > xfs/103 failures because the n flags is not reported.  Does anyone else
> > see this?
> 
> I see xfs/103 hang with latest xfsprogs & xfstests, and after applying
> this xfstests patch xfs/103 passed for me without problem. kernel is
> for-next branch from xfs tree.
> 
> http://www.spinics.net/lists/fstests/msg04308.html
> 
> Not sure if this is related to your problem.

With that patch applies the test passes for me.
