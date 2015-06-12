Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D21287F61
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 17:52:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9079304043
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 15:52:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0jCkIFfpasl9KcRj for <xfs@oss.sgi.com>;
	Fri, 12 Jun 2015 15:52:24 -0700 (PDT)
Date: Sat, 13 Jun 2015 08:52:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
Message-ID: <20150612225209.GA20262@dastard>
References: <5579296A.8010208@skylable.com>
	<20150611151620.GB59168@bfoster.bfoster>
	<5579A904.3020204@skylable.com> <5579AE85.5080203@sandeen.net>
	<5579B034.4070503@sandeen.net> <5579B804.9050707@skylable.com>
	<20150612122108.GB60661@bfoster.bfoster>
	<557AD4D4.3010901@skylable.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <557AD4D4.3010901@skylable.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@skylable.com>
Cc: Karanvir Singh <karanvir.singh@hgst.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Luca Gibelli <luca@skylable.com>, xfs@oss.sgi.com, Christopher Squires <christopher.squires@hgst.com>, Wayne Burri <wayne.burri@hgst.com>

On Fri, Jun 12, 2015 at 03:47:16PM +0300, T=F6r=F6k Edwin wrote:
> On 06/12/2015 03:21 PM, Brian Foster wrote:
> > I echo Dave's suggestion down thread with regard to toolchain. This
> > kernel was compiled with the following cross-gcc (installed via Fedora
> > package):
> > =

> > 	gcc version 4.9.2 20150212 (Red Hat Cross 4.9.2-5) (GCC) =

> > =

> > Are you using something different?
> =

> /proc/version says:
> =

> Linux version 3.14.3-00088-g7651c68 (jenkins@boulder-jenkins) (gcc versio=
n 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #24 Thu Apr 9 16:13:46 MDT 2015
> =

> I'll get back to you when I have a new kernel running.

Yup, that's looking like a toolchain bug. Thread about arm directory
read corruption:

http://oss.sgi.com/archives/xfs/2013-02/msg00505.html

cross-gcc version results:

http://oss.sgi.com/archives/xfs/2013-02/msg00563.html

"A quick rundown:
  -cross-gcc4.4:  OK
  -cross-gcc4.5:  OK
  -cross-gcc4.6:  BAD
  -cross-gcc4.7:  BAD
  -cross-gcc4.8:  OK"

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
