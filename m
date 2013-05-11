Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A402029DF8
	for <linux-xfs@oss.sgi.com>; Fri, 10 May 2013 19:12:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3297FAC004
	for <linux-xfs@oss.sgi.com>; Fri, 10 May 2013 17:12:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JV0gj7N2lTkjiBAI for <linux-xfs@oss.sgi.com>;
	Fri, 10 May 2013 17:12:17 -0700 (PDT)
Date: Sat, 11 May 2013 10:12:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.0: general protection fault
Message-ID: <20130511001213.GA32675@dastard>
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard> <5187A663.707@itwm.fraunhofer.de>
	<20130507011254.GP19978@dastard>
	<5188E2F5.1090304@itwm.fraunhofer.de>
	<20130507220742.GC24635@dastard>
	<518A8FD4.40700@itwm.fraunhofer.de>
	<20130509004115.GM24635@dastard>
	<518CC9A9.9060500@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518CC9A9.9060500@itwm.fraunhofer.de>
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

On Fri, May 10, 2013 at 12:19:21PM +0200, Bernd Schubert wrote:
> On 05/09/2013 02:41 AM, Dave Chinner wrote:
> >On Wed, May 08, 2013 at 07:48:04PM +0200, Bernd Schubert wrote:
> >>On 05/08/2013 12:07 AM, Dave Chinner wrote:
> >>>On Tue, May 07, 2013 at 01:18:13PM +0200, Bernd Schubert wrote:
> >>>>On 05/07/2013 03:12 AM, Dave Chinner wrote:
> >>>>>On Mon, May 06, 2013 at 02:47:31PM +0200, Bernd Schubert wrote:
> >>>>>>On 05/06/2013 02:28 PM, Dave Chinner wrote:
> >>>>>>>On Mon, May 06, 2013 at 10:14:22AM +0200, Bernd Schubert wrote:
> >>>>>>>>And anpther protection fault, this time with 3.9.0. Always happens
> >>>>>>>>on one of the servers. Its ECC memory, so I don't suspect a faulty
> >>>>>>>>memory bank. Going to fsck now-
> >>>>>>>
> >>>>>>>http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >>>>>>
> >>>>>>Isn't that a bit overhead? And I can't provide /proc/meminfo and
> >>>>>>others, as this issue causes a kernel panic a few traces later.
> >>>>>
> >>>>>Provide what information you can.  Without knowing a single thing
> >>>>>about your hardware, storage config and workload, I can't help you
> >>>>>at all. You're asking me to find a needle in a haystack blindfolded
> >>>>>and with both hands tied behind my back....
> >>>>
> >>>>I see that xfs_info, meminfo, etc are useful, but /proc/mounts?
> >>>>Maybe you want "cat /proc/mounts | grep xfs"?. Attached is the
> >>>>output of /proc/mounts, please let me know if you were really
> >>>>interested in all of that non-xfs output?
> >>>
> >>>Yes. You never know what is relevant to a problem that is reported,
> >>>especially if there are multiple filesystems sharing the same
> >>>device...
> >>
> >>Hmm, I see. But you need to extend your questions to multipathing
> >>and shared storage.
> >
> >why would we? Anyone using such a configuration reporting a bug
> >usually is clueful enough to mention it in their bug report when
> >describing their RAID/LVM setup.  The FAQ entry covers the basic
> >information needed to start meaingful triage, not *all* the
> >infomration we might ask for. It's the baseline we start from.
> >
> >Indeed, the FAQ exists because I got sick of asking people for the
> >same information several times a week, every week in response to
> >poor bug reports like yours. it's far more efficient to paste a link
> >several times a week.  i.e. The FAQ entry is there for my benefit,
> >not yours.
> 
> Poor bug report or not, most information you ask about in the FAQ
> are entirely irrelevant for this issue.

<sigh>

You're complaining that I've asked for irrelevant information in
reponse to your bug report. I know nothing about your system, so I
need to know some basic information before I start. So while you
might think it's irrelevant, it is critical information for me

> >I don't really care if you don't understand why we are asking for
> >that information, I simply expect you to provide it as best you can
> >if you want your problem solved.
> 
> And here we go, the bug I reported is not my problem. I simply
> reported a bug in XFS. You can use it or not, I do not care at all.

No, that's not what I said. You're hearing what you want to hear,
not what I'm saying.  I care about fixing the bug - I'd be ignoring
you if I didn't care.

However: don't confuse the fact that I don't care who you are, what
you do, how important you think you are or what you think know with
that. Who you are simply not important - you are a Random Joe from
the interwebs that has reported a bug, and I've given the same
response to you that I gave to the last hundred Random Joes that
have reported problems.

So, Random Joe, it's now your responsibility to jump through the
hoops we ask you to so that _we_ can find the cause of your problem.

> Of course I don't like bugs and I'm going to help to fix it, but I
> have a long daily todo list and I'm not going to spend my time
> filling in irrelevent items.

Oh, cry me a river. The majority of what is asked for in the FAQ can
be gathered in less than 5 minutes. You've wasted far more time than
that arguing that what I asked for is irrelevant, unnecessary and
too hard to gather and lecturing about irrelevant stuff like MMP and
HA.  Then having the gall to accuse me of not caring about fixing
your bug.  You need to pull your head in and take a long, hard look
at yourself.

I can't fix a bug without the bug reporter's help, and you seem to
be unwilling to help. Ergo, I can't fix the bug. Co-operation is
needed. If you want your problem fixed, please drop the attitude, go
back up the thread to where I asked for information from you, and
fresh start again.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
