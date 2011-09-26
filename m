Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8QFlWO7179859 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 10:47:33 -0500
Subject: Re: [PATCH] Add test 257: Check proper FITRIM argument handling
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <alpine.LFD.2.00.1109261541500.3806@dhcp-27-109.brq.redhat.com>
References: <1316787311-23428-2-git-send-email-lczerner@redhat.com>
	<1317021244-7556-1-git-send-email-lczerner@redhat.com>
	<1317041252.3030.24.camel@doink>
	<alpine.LFD.2.00.1109261541500.3806@dhcp-27-109.brq.redhat.com>
Date: Mon, 26 Sep 2011 10:47:27 -0500
Message-ID: <1317052047.2925.26.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-09-26 at 15:52 +0200, Lukas Czerner wrote:
> On Mon, 26 Sep 2011, Alex Elder wrote:
> 
> > On Mon, 2011-09-26 at 09:14 +0200, Lukas Czerner wrote:
. . .
> > I think the use of "bc" to do certain math operations
> > has some value, and as such I think the right fix is
> > just to require "bc" in order for xfstests, or at least
> > for any that use the _math() function, and drop the
> > fall-back logic out of the definition of _math().
> > 
> > What do you think?
> 
> Yes I had the same concern, but I guess I was just lazy to look at it
> :). So if we can require "bc" for xfstests we can simply remove the
> fallback. Also maybe adding helper _require_bc, or maybe even better
> adding helper _require <whatever> so we can check for <whatever> tool
> in any test.

Would you mind re-submitting the first patch (which defined
the _math() function), adding the definition of _require_math
which would be used in any script that uses the _math function?
That would fail if "bc" weren't available.  It seems indirect
but I think _require_math makes more sense in the context of
whoever would be using it than _require_bc would.

And having heard nobody voice objection to the idea I think
we should just go with it.

I can take your other patch and insert the _require_math call
for you, and will verify the result works before committing it.

Thanks.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
