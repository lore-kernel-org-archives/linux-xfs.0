Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 346217F55
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 21:16:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3C24AC005
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 19:16:51 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pTH3IdPyEcE1b0Nc for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 19:16:49 -0700 (PDT)
Date: Fri, 25 Jul 2014 12:16:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fwd: XFS
Message-ID: <20140725021636.GC26465@dastard>
References: <CAJAKVEHDrKxi27uxfiApcn0VKsRZOWRiKAZAVBigGmN=smFNOQ@mail.gmail.com>
	<CAJAKVEGHNSMy-kZqhjHq+2_Bi6_Yu6hBW=bB102-Yt4OW-uCaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJAKVEGHNSMy-kZqhjHq+2_Bi6_Yu6hBW=bB102-Yt4OW-uCaQ@mail.gmail.com>
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
To: Somdeep Dey <somdeepdey10@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2014 at 11:53:26PM +0530, Somdeep Dey wrote:
> Hello,
>   We are a group of students that are currently pursuing our undergraduate
> degrees in Computer Science from Pune Institute of Computer Technology
> (PICT), Maharashtra, India. We will be graduating in June 2015 and are
> currently in our final year. For our final year B.E project we have
> selected the domain as Systems and would be very interested in working in
> the field of journalling file systems, which is where we stumbled upon XFS.
>      Over the past few weeks we have been extensively studying the various
> features and working principles which has allowed this filesystem to
> prosper. It will be a great learning opportunity for us to work with XFS
> and in turn work with you. As per given on the *http://xfs.org/
> <http://xfs.org/>* website for contributions, we would appreciate if you
> could steer us towards the direction of choosing the right topic and
> working towards culminating a project in the same, which would be helpful
> for the community.

My first concern is this: Do you have permission from PICT to
publish your work under the GPL or LGPL (depending on whether it is
kernel or userspace code you write)? If not, then we can't use the
work you do and so you can guess how much interest we'd have in
that case...

> 4) Development time ( 6 to 7 months from August to February )

So nothing too complex then...

> We would love to hear from about any ideas that you see fit for us to
> pursue and which are feasible in the specified time frame. Hoping to hear
> from you soon, and thanking you in anticipation.

Well, given the timeframe and your capabilities, I'd suggest that
developing new core infrastructure features might be a bit of a
stretch. However, I think that taking one of the userspace utilities
and enhancing/modernising them would be a great way to learn.

For example, we've had plans for a long time to make xfs_fsr (the
online defragmenter) more intelligent and able to solve issues we
know exist but never had the time to fix. For example:

	- explicit control of locality for groups of files
	- ability to defragment only portions of files rather than
	  just whole files
	- defragmenting free space
	- enhanced/faster filesystem scanning

In just those four things, there are new kernel interfaces that are
required, interaction with other community members that are adding
code whose functionality you'd need to build upon, code
modernisation/factoring/enhancement, partial and full filesystem
structural analysis to determine optimal data movement to solve
multiple goals, test code for the new interfaces and each new
defragmentation goal, etc.

A project like this allows you to start by classifying and
understanding the current high level behaviour of both the fileystm
and the utility, then it's limitations and it's problems, then
determine the best solutions to the problems, and then implement the
solutions. The work can also be broken up into multiple independent
parts, which is useful for a team that is doing the work.

The main thing is that you are not going to be able to do this in
isolation. Each step of the process needs review and feedback from
the community, otherwise we'll can end up with code that nobody wants
or can use. You're going to need to pick the brains of community
people to understand the algorithms and their deficiencies,
and for us to pick holes in your solutions to those deficiencies
to improve the solutions we end up implementing.

To illustrate this with an example, I'll again point you to Brian's
sparse inode allocation patchset from this morning. The idea behind
that patchset was originally documented back in 2008 here:

http://xfs.org/index.php/Improving_inode_Caching#Single_Block_Inode_Allocation

and it's taken us a long time to:

	a) understand exactly what is required to implement such
	functionality; and
	b) get the pre-requisite infrastructure in place to be able
	to start implementing the solution.

IOWs, we've talked about the design for some time and the code Brian
posted is an early prototype of the solution we've iterated over.
There are lots of open discussion points that the prototype has
uncovered, and so we'll continue to iterate the
design/prototype/review cycle on the mailing list until we have code
of production quality. That is likely to still take a couple months
to get the functionality to the point where it can be merged.

I'm mentioning this because it will give you some insight into the
processes we use for solving problems and getting those changes into
the upstream code base. Keep in mind, though, that the bar isn't
quite as high for userspace code as it is for kernel code - that's
one of the reasons why I'm suggesting that improving userspace
utilities is a good place to start.

If defragmetnation and layout optimisation doesn't really interest
you, I can suggest other features we would like to have that require
similar levels of development work for both kernel and userspace
like filesystem shrinking or reverse block mapping for error
recovery purposes, or ....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
