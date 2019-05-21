Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41182 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfEUTTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 15:19:48 -0400
Date: Tue, 21 May 2019 12:19:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] libfrog: fix bitmap return values
Message-ID: <20190521191946.GA5657@infradead.org>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839424514.68606.14562327454853103352.stgit@magnolia>
 <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
 <20190521170103.GD5141@magnolia>
 <c281d3c3-5385-90a3-125a-8a620944c971@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c281d3c3-5385-90a3-125a-8a620944c971@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 01:59:58PM -0500, Eric Sandeen wrote:
> So yeah I'm of the opinion that unless it's kernel(-ish?) code it should be
> positive, and I can send a patch to clean up stuff that's not.
> 
> I can be swayed by counterarguments if you have them.  :)

What speaks against everything is negative?  It isn't like returning
positive errors really is a traditional userspace convention, as that
is return -1 (negative!) and look at errno..
