Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 54BEE29E0A
	for <linux-xfs@oss.sgi.com>; Wed,  8 May 2013 19:41:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 408228F8049
	for <linux-xfs@oss.sgi.com>; Wed,  8 May 2013 17:41:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PpDE3n05iTjyuNLk for <linux-xfs@oss.sgi.com>;
	Wed, 08 May 2013 17:41:19 -0700 (PDT)
Date: Thu, 9 May 2013 10:41:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.0: general protection fault
Message-ID: <20130509004115.GM24635@dastard>
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard> <5187A663.707@itwm.fraunhofer.de>
	<20130507011254.GP19978@dastard>
	<5188E2F5.1090304@itwm.fraunhofer.de>
	<20130507220742.GC24635@dastard>
	<518A8FD4.40700@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518A8FD4.40700@itwm.fraunhofer.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-xfs@oss.sgi.com

On Wed, May 08, 2013 at 07:48:04PM +0200, Bernd Schubert wrote:
> On 05/08/2013 12:07 AM, Dave Chinner wrote:
> >On Tue, May 07, 2013 at 01:18:13PM +0200, Bernd Schubert wrote:
> >>On 05/07/2013 03:12 AM, Dave Chinner wrote:
> >>>On Mon, May 06, 2013 at 02:47:31PM +0200, Bernd Schubert wrote:
> >>>>On 05/06/2013 02:28 PM, Dave Chinner wrote:
> >>>>>On Mon, May 06, 2013 at 10:14:22AM +0200, Bernd Schubert wrote:
> >>>>>>And anpther protection fault, this time with 3.9.0. Always happens
> >>>>>>on one of the servers. Its ECC memory, so I don't suspect a faulty
> >>>>>>memory bank. Going to fsck now-
> >>>>>
> >>>>>http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >>>>
> >>>>Isn't that a bit overhead? And I can't provide /proc/meminfo and
> >>>>others, as this issue causes a kernel panic a few traces later.
> >>>
> >>>Provide what information you can.  Without knowing a single thing
> >>>about your hardware, storage config and workload, I can't help you
> >>>at all. You're asking me to find a needle in a haystack blindfolded
> >>>and with both hands tied behind my back....
> >>
> >>I see that xfs_info, meminfo, etc are useful, but /proc/mounts?
> >>Maybe you want "cat /proc/mounts | grep xfs"?. Attached is the
> >>output of /proc/mounts, please let me know if you were really
> >>interested in all of that non-xfs output?
> >
> >Yes. You never know what is relevant to a problem that is reported,
> >especially if there are multiple filesystems sharing the same
> >device...
> 
> Hmm, I see. But you need to extend your questions to multipathing
> and shared storage.

why would we? Anyone using such a configuration reporting a bug
usually is clueful enough to mention it in their bug report when
describing their RAID/LVM setup.  The FAQ entry covers the basic
information needed to start meaingful triage, not *all* the
infomration we might ask for. It's the baseline we start from.

Indeed, the FAQ exists because I got sick of asking people for the
same information several times a week, every week in response to
poor bug reports like yours. it's far more efficient to paste a link
several times a week.  i.e. The FAQ entry is there for my benefit,
not yours.

I don't really care if you don't understand why we are asking for
that information, I simply expect you to provide it as best you can
if you want your problem solved.

> Both time you can easily get double mounts... I
> probably should try to find some time to add ext4s MMP to XFS.

Doesn't solve the problem. It doesn't prevent multiple write access
to the lun:

	Ah, a free lun. I'll just put LVM on it and mkfs it and....
	Oh, sorry, were you using that lun?

So, naive hacks like MMP don't belong in filesystems....

> >>And I just wonder what you are going to do with the information
> >>about the hardware. So it is an Areca hw-raid5 device with 9 disks.
> >>But does this help? It doesn't tell if one of the disks reads/writes
> >>with hickups or provides any performance characteristics at all.
> >
> >Yes, it does, because Areca cards are by far the most unreliable HW
> >RAID you can buy, which is not surprising because they are also the
> 
> Ahem. Compared to other hardware raids Areca is very stable.

Maybe in your experience. We get a report every 3-4 months about
Areca hardware causing catastrophic data loss. It outnumbers every
other type of hardware RAID by at least 10:1 when it comes to such
problem reports.

> You might want to add to your FAQ something like:
> 
> Q: Are you sure there is not disk / controller / memory data
> corruption? If so please state why!

No, the FAQ entry is for gathering facts and data, not what
the bug reporter *thinks* might be the problem. If there's
corruption we'll see it in the information that is gathered, and
then we can start to look for the source.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
