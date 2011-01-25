Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P8YOSr221541 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 02:34:25 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F5188AA020
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 00:36:46 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9QHD63HP1CiejvB1 for <xfs@oss.sgi.com>;
	Tue, 25 Jan 2011 00:36:46 -0800 (PST)
Date: Tue, 25 Jan 2011 19:36:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Optimize RAID0 for max IOPS?
Message-ID: <20110125083643.GE28803@dastard>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
	<alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
	<20110124215713.82D75B187@gemini.denx.de>
	<20110124230314.GA11040@dastard>
	<20110125083900.4dd65bf2@galadriel2.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110125083900.4dd65bf2@galadriel2.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Wolfgang Denk <wd@denx.de>, Justin Piszcz <jpiszcz@lucidpixels.com>

[ As a small note - if you are going to comment on the results table
from a previous message, please don't cut it from your response.
Context is important. I pasted the relevant part back in so i can
refer back to it in my response. ]

On Tue, Jan 25, 2011 at 08:39:00AM +0100, Emmanuel Florac wrote:
> Le Tue, 25 Jan 2011 10:03:14 +1100 vous =E9criviez:
> > > Version  1.96       ------Sequential Create------ --------Random Crea=
te--------
> > > A1                  -Create-- --Read--- -Delete-- -Create-- --Read---=
 -Delete--
> > >               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP=
  /sec %CP
> > >                  16   104   0 +++++ +++   115   0    89   0 +++++ +++=
   111   0
> > =

> > Only 16 files?
> =

> IIRC this is 16 thousands of files. Though this is not enough, I
> generally use 80 to 160 for tests.

Yes, you're right, the bonnie++ man page states that it is in units
of 1024 files. Be nice if there was a "k" to signify that so people
who aren't intimately familiar with it's output format can see
exactly what was tested....

As it is, a create rate of 104 files/s (note the consistency of
units between 2 adjacent numbers!) indicates something else is
screwed, because my local test VM on RAID0 gets numbers like this:

Version  1.96       ------Sequential Create------ --------Random Create----=
----
test-4              -Create-- --Read--- -Delete-- -Create-- --Read--- -Dele=
te--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec=
 %CP
                 16 25507  90 +++++ +++ 30472  97 25281  93 +++++ +++ 29077=
  97
Latency             23864us     204us   21092us   18855us      82us     121=
us

IOWs, create rates of 25k/s and unlink of 30k/s and it is clearly
CPU bound.

Therein lies the difference: the original numbers have 0% CPU usage,
which indicates that the test is blocking.  Something is causing the
reported test system to be blocked almost all the time.

/me looks closer.

Oh, despite $subject being "RAID0" the filesystems being tested are
on RAID5 and RAID6 with very small chunk sizes on slow SATA drives.
This is smelling like a case of barrier IOs on software raid on
cheap storage....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
