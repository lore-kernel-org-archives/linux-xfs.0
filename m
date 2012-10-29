Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9TCJPWp163540 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 07:19:25 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VBKGP1yN0CqfHNOs for <xfs@oss.sgi.com>;
	Mon, 29 Oct 2012 05:21:13 -0700 (PDT)
Date: Mon, 29 Oct 2012 23:21:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
Message-ID: <20121029122111.GR29378@dastard>
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr> <20121025211047.GD29378@dastard>
	<508A600C.1020109@univ-nantes.fr> <508B092E.6070209@univ-nantes.fr>
	<20121028234802.GE4353@dastard> <20121029012540.GO29378@dastard>
	<508E3A2E.20901@univ-nantes.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <508E3A2E.20901@univ-nantes.fr>
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

On Mon, Oct 29, 2012 at 09:11:26AM +0100, Yann Dupont wrote:
> Le 29/10/2012 02:25, Dave Chinner a =E9crit :
> >I can't reproduce this with a similar setup but using KVM (i.e.
> >killing the VM instead of power cycling) or forcing a shutdown of
> >the filesystem without flushing the log. The second case is very
> >much the same as power cycling, but without the potential "power
> >failure caused partial IOs to be written" problem. The only thing
> >I can see in the logprint that I haven't seen so far in my testing
> >is that your log print indicates a checkpoint that wraps the end
> >of the log. I haven't yet hit that situation by chance, so I'll
> >keep trying to see if that's the case that is causing the
> >problem.... Cheers, Dave.
> =

> Ok, is your kvm guest was lvm enabled ?

No. The idea being that if it is an XFS problem, then it will show
up without needing LVM. And it did.

> I'll try to recrash the FS, this time I'll make an image of it on
> another machine for further testings. And I'll supply a usefull
> logprint

No need, I have a simple local reproducer now based on your example.
I should be able to find the problem from here....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
