Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9T1NvHi100224 for <xfs@oss.sgi.com>; Sun, 28 Oct 2012 20:23:57 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HtQNxfUKMBXzXlFF for <xfs@oss.sgi.com>;
	Sun, 28 Oct 2012 18:25:44 -0700 (PDT)
Date: Mon, 29 Oct 2012 12:25:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
Message-ID: <20121029012540.GO29378@dastard>
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr> <20121025211047.GD29378@dastard>
	<508A600C.1020109@univ-nantes.fr> <508B092E.6070209@univ-nantes.fr>
	<20121028234802.GE4353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121028234802.GE4353@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: xfs@oss.sgi.com

On Mon, Oct 29, 2012 at 10:48:02AM +1100, Dave Chinner wrote:
> On Sat, Oct 27, 2012 at 12:05:34AM +0200, Yann Dupont wrote:
> > Le 26/10/2012 12:03, Yann Dupont a =E9crit :
> > >Le 25/10/2012 23:10, Dave Chinner a =E9crit :
> > >
> > >I'll try now to reproduce this kind of behaviour on a verry little
> > >volume (10 GB for exemple) so I can confirm or inform the given
> > >scenario .
> > >
> > =

> > This is reproductible. Here is how to do it :
> > =

> > - Started a 3.6.2 kernel.
> > =

> > - I created a fresh lvm volume on localdisk of 20 GB.
> =

> Can you reproduce the problem without LVM?
> =

> > - mkfs.xfs on it, with default options
> > - mounted with default options
> > - launch something that hammers this volume. I launched compilebench
> > 0.6  on it
> > - wait some time to fill memory,buffers, and be sure your disks are
> > really busy. I waited some minutes after the initial 30 kernel
> > unpacking in compilebench
> > - hard reset the server (I'm using the Idrac of the server to
> > generate a power cycle)
> > - After some try, I finally had the impossibility to mount the xfs
> > volume, with the error reported in previous mails. So far this is
> > normal .
> =

> So it doesn't happen every time, and it may be power cycle related.
> What is your "local disk"?

I can't reproduce this with a similar setup but using KVM (i.e.
killing the VM instead of power cycling) or forcing a shutdown of
the filesystem without flushing the log. The second case is very
much the same as power cycling, but without the potential "power
failure caused partial IOs to be written" problem.

The only thing I can see in the logprint that I haven't seen so far
in my testing is that your log print indicates a checkpoint that
wraps the end of the log. I haven't yet hit that situation by
chance, so I'll keep trying to see if that's the case that is
causing the problem....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
