Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37926 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbeKOUUG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 15:20:06 -0500
Date: Thu, 15 Nov 2018 02:12:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Remove noinline from #define STATIC
Message-ID: <20181115101245.GA13913@infradead.org>
References: <7302f4a13c1cbf62b07f636878ce25fcca84b6c4.camel@perches.com>
 <6420cf91-89c8-a876-7a0d-25ab8ba428b8@sandeen.net>
 <20181112214515.GN19305@dastard>
 <bd3806ccc911989c7ef1fed9e8d26a4a5ad347a9.camel@perches.com>
 <20181113011804.GP19305@dastard>
 <20181113015410.GB30750@thunk.org>
 <20181113030926.GQ19305@dastard>
 <b03fda08ee4ca4b488c6f67e64bfc94f49be4e83.camel@perches.com>
 <20181113052651.GR19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113052651.GR19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Joe Perches <joe@perches.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Tue, Nov 13, 2018 at 04:26:51PM +1100, Dave Chinner wrote:
> That's just as bad as removing them all, if not worse.
> 
> If you are writing new code or reworking existing code, then we'll
> consider the usage of STATIC/static in the context of that work.
> Otherwise, we leave it alone.
> 
> It if ain't broke, don't fix it. And it sure as hell isn't broken
> right now. We've got more than enough bugs to fix without having to
> deal with drive-by bikeshed painting...

Agreed.  That being said I think we should aim to add manual
noline annotations to those functions where we really care while we
go through the code instead of the weird STATIC that just seems to
cause this kind of confusion.

And if Joe or somone else can come up with a few patches where removing
the noinline (aka STATIC) makes a huge difference for a small number
of functions we should consider it as well.
