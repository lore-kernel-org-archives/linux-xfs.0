Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27784 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752638AbcLLCps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Dec 2016 21:45:48 -0500
Date: Mon, 12 Dec 2016 13:45:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Preparing for XFS reflink D-day
Message-ID: <20161212024544.GU4326@dastard>
References: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
 <20161210194214.GL8436@birch.djwong.org>
 <CAOQ4uxhkfUY8HHkMkJxmAZ8TJexOqACSQjqWJc0pUvgTEN2CcQ@mail.gmail.com>
 <20161211182744.GM8436@birch.djwong.org>
 <CAOQ4uxiCTrTsBSzUp9wOs-1FmBiF4kkDCzzeaonciA-NJHWR0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiCTrTsBSzUp9wOs-1FmBiF4kkDCzzeaonciA-NJHWR0A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Sun, Dec 11, 2016 at 09:23:38PM +0200, Amir Goldstein wrote:
> > Un-sharing an fs full of reflinked files requires us to build code to
> > iterate every bmbt of every file (or to cross-reference every refcountbt
> > record against the rmapbt to find the sharers) and then relocate the
> > data, which is quite a bit more complex... and unnecessary since we can
> > rebuild all the broken refcount metadata anyway.
> 
> You are right, of course, from technical POV, but psychologically, if people
> know they have a safe way back to what they know and trust, it is easier
> for them make the leap...

/me shakes his head.

If people don't feel safe running experimental code that might go
wrong, they're going to be absolutely thrilled to hear that when it
does go wrong, there's even more experimental code that will try to
fix it up again.

No.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
