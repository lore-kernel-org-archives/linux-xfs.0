Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MGUONk243709 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 11:30:24 -0500
Subject: Re: xfstests 258: Test xfs fs creation with fs size close to 4 TB
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316680229.6246.21.camel@dhcp-26-208.brq.redhat.com>
References: <1316613160.781.8.camel@dhcp-26-208.brq.redhat.com>
	<1316624075.2986.22.camel@doink>
	<1316680229.6246.21.camel@dhcp-26-208.brq.redhat.com>
Date: Thu, 22 Sep 2011 11:30:20 -0500
Message-ID: <1316709020.2009.20.camel@doink>
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
To: Boris Ranto <branto@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, 2011-09-22 at 10:30 +0200, Boris Ranto wrote:
> On Wed, 2011-09-21 at 11:54 -0500, Alex Elder wrote:
> > On Wed, 2011-09-21 at 15:52 +0200, Boris Ranto wrote:
> > > mkfs.xfs failed to create xfs filesystems with 4 TB minus few bytes due
> > > to round up error in mkfs.xfs code.
> > > 
> > > This test case is a regression test for the fs creation problem.
> > > 
> > > I've tested the test case with mkfs.xfs patch (in the form posted by
> > > Eric Sandeen) and the test passed (and therefore the patch fixed the
> > > issue for me).
> > > 
> > > Signed-off-by: Boris Ranto <branto@redhat.com>
> > 
> > This looks OK, but I'm a little concerned about the
> > shell's ability to handle > 32-bit values in its
> > arithmetic expressions (within $((...))).
> > 
> > Using ${fourtb} works for me, but I just don't know
> > whether it is written somewhere that bash always
> > supports 64-bit (or even arbitrary) precision values.
> > 
> > Do you know?
> > 
> > Same general concern goes for dd, but I am more inclined
> > to think it can handle large numbers.
> > 
> > Otherwise this looks good to me (though I haven't yet
> > tried it out).
> > 
> > Reviewed-by: Alex Elder <aelder@sgi.com>
> > 
> > . . .
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> I'm not sure whether bash guarantees at least 64-bit precision values in
> its arithmetic operations.
> Therefore I suppose the values can be computed in advance in this case
> and the arithmetic operation can be simply left out:

This at least makes it so we only have to worry about
one program (dd) handling >32-bit values correctly.
Based on that alone I guess I prefer it.  However
there should be a comment that explains where the
numbers come from, i.e.:

# 4398046511103 = 2^42 - 1
# 4398046510592 = 2^42 - 512
# 4398046510080 = 2^42 - 1024
# 4398046510079 = 2^42 - 1025
# 4398046509056 = 2^42 - 2048
# 4398046507008 = 2^42 - 4096

If dd doesn't support numbers that big we aren't working
in an environment suitable for running xfstests.  So
at least from my perspective, this is good enough.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
