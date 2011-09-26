Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8QDqd6X167380 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 08:52:39 -0500
Date: Mon, 26 Sep 2011 15:52:33 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] Add test 257: Check proper FITRIM argument handling
In-Reply-To: <1317041252.3030.24.camel@doink>
Message-ID: <alpine.LFD.2.00.1109261541500.3806@dhcp-27-109.brq.redhat.com>
References: <1316787311-23428-2-git-send-email-lczerner@redhat.com>
	<1317021244-7556-1-git-send-email-lczerner@redhat.com>
	<1317041252.3030.24.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Mon, 26 Sep 2011, Alex Elder wrote:

> On Mon, 2011-09-26 at 09:14 +0200, Lukas Czerner wrote:
> > This test suppose to validate that file systems are using the fitrim
> > arguments right. It checks that the fstrim returns EINVAl in case that
> > the start of the range is beyond the end of the file system, and also
> > that the fstrim works without an error if the length of the range is
> > bigger than the file system (it should be truncated to the file system
> > length automatically within the fitrim implementation).
> > 
> > This test should also catch common problem with overflow of start+len.
> > Some file systems (ext4,xfs) had overflow problems in the past so there
> > is a specific test for it (for ext4 and xfs) as well as generic test for
> > other file systems, but it would be nice if other fs can add their
> > specific checks if this problem does apply to them as well.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> OK, I know I suggested it, and I do like the result, but
> there could be a problem with the use of things like
> "2^32 - 1" being passed to the _math() function.
> 
> The problem lies in the way _math() backs off to try
> to use shell built-in arithmetic, which interprets the
> '^' as a bitwise XOR operator.  (Note, _math() was
> defined in an earlier patch.)
> 
> I think the use of "bc" to do certain math operations
> has some value, and as such I think the right fix is
> just to require "bc" in order for xfstests, or at least
> for any that use the _math() function, and drop the
> fall-back logic out of the definition of _math().
> 
> What do you think?

Yes I had the same concern, but I guess I was just lazy to look at it
:). So if we can require "bc" for xfstests we can simply remove the
fallback. Also maybe adding helper _require_bc, or maybe even better
adding helper _require <whatever> so we can check for <whatever> tool
in any test.

Thanks!
-Lukas


> 
> Assuming we resolve that, this test now looks fine to me.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
