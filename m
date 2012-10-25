Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PL9EUG163948 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 16:09:14 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8emDfAG4QwxU4sGk for <xfs@oss.sgi.com>;
	Thu, 25 Oct 2012 14:10:58 -0700 (PDT)
Date: Fri, 26 Oct 2012 08:10:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
Message-ID: <20121025211047.GD29378@dastard>
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <508958FF.4000007@univ-nantes.fr>
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

On Thu, Oct 25, 2012 at 05:21:35PM +0200, Yann Dupont wrote:
> Le 23/10/2012 10:24, Yann Dupont a =E9crit :
> >Le 22/10/2012 16:14, Yann Dupont a =E9crit :
> >
> >Hello. This mail is a follow up of a message on XFS mailing list.
> >I had hang with 3.6.1, and then , damage on XFS filesystem.
> >
> >3.6.1 is not alone. Tried 3.6.2, and had another hang with quite a
> >different trace this time , so not really sure the 2 problems are
> >related .
> >Anyway the problem is maybe not XFS, but is just a consequence of
> >what seems more like kernel problems.
> >
> >cc: to linux-kernel
> Hello.
> There is definitively something wrong in 3.6.xx with XFS, in
> particular after an abrupt stop of the machine :
> =

> I now have corruption on a 3rd machine (not involved with ceph).
> The machine was just rebooting from 3.6.2 kernel to 3.6.3 kernel.
> =

> This machine isn't under heavy load, but it's a machine we use for
> tests & compilations. We often crash it. For 2 years, we didn't have
> problems. XFS always was reliable, even in hard conditions (hard
> reset, loss of power, etc)
> =

> This time, after 3.6.3 boot, one of my xfs volume refuse to mount :
> =

> mount: /dev/mapper/LocalDisk-debug--git: can't read superblock
> =

> 276596.189363] XFS (dm-1): Mounting Filesystem
> [276596.270614] XFS (dm-1): Starting recovery (logdev: internal)
> [276596.711295] XFS (dm-1): xlog_recover_process_data: bad clientid 0x0
> [276596.711329] XFS (dm-1): log mount/recovery failed: error 5
> [276596.711516] XFS (dm-1): log mount failed

That's an indication that zeros are being read from the journal
rather than valid transaction data. It may well be caused by an XFS
bug, but from experience it is equally likely to be a lower layer
storage problem. More information is needed.

Firstly:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_=
reporting_a_problem.3F

Secondly, is the system still in this state? If so, dump the log to
a file using xfs_logprint, zip it up and send it to me so I can have
a look at where the log is intact (i.e. likely xfs bug) or contains
zero (likely storage bug).

If the system is not still in this state, then I'm afraid there's
nothing that can be done to understand the problem.

> I'm not even sure the reboot was after a crash or just a clean
> reboot. (I'm not the only one to use this machine). I have nothing
> suspect on my remote syslog.
> =

> Anyway, it's the 3rd XFS crashed volume in a row with 3.6 kernel.
> Different machines, different contexts. Looks suspicious.

You've had two machines crash with problems in the mm subsystem, and
one filesystem problem that might be hardware realted. Bit early to
be blaming XFS for all your problems, I think....

> xfs_repair -n seems to show volume is quite broken :

Sure, if the log hasn't been replayed then it will be - the
filesystem will only be consistent after log recovery has been run.

> I won't try to repair this volume right now.
> =

> This time, volume is small enough to make an image (it's a 100 GB
> lvm volume). I'll try to image it before making anything else.
> =

> 1st question : I saw there is ext4 corruption reported too with 3.6
> kernel, but as far as I can see, problem seems to be jbd related, so
> it shouldn't affect xfs ?

No relationship at all.

> 2nd question : Am I the only one to see this ?? I saw problems
> reported with 2.6.37, but here, the kernel is 3.6.xx

Yes, you're the only one to report such problems on 3.6. Anything
reported on 2.6.37 is likely to be completely unrelated.

> 3rd question : If you suspect the problem may be lying in XFS , what
> should I supply to help debugging the problem ?

See above.

> Not CC:ing linux kernel list right now, as I'm really not sure where
> the problem is right now.

You should report the mm problems to linux-mm@kvack.org to make sure
the right people see them and they don't get lost in the noise of
lkml....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
