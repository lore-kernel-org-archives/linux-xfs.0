Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 083CD7FCD
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 22:18:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C2CDF8F8039
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 20:18:05 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZUZdveaK53GHIf6N for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 20:18:03 -0800 (PST)
Date: Wed, 11 Dec 2013 15:17:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131211041758.GI10988@dastard>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
	<20131209121534.GE4278@hercules>
	<CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
	<20131209235523.GW31386@dastard>
	<CA+5PVA5rUmWYQiPwkN15CnfqckmEjVukXz3mU75CiUBVzfERqA@mail.gmail.com>
	<20131211010326.GF10988@dastard>
	<CA+5PVA7wso5fo11xX9kCUdbrqBQMzUnYwTOB_Qe3K7LDY4z_Cw@mail.gmail.com>
	<20131211020007.GH10988@dastard>
	<CAGXu5jKUShtztTK-PtY7w0WSg=F3KUGL-iCM3=6H61qy3u6aZg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGXu5jKUShtztTK-PtY7w0WSg=F3KUGL-iCM3=6H61qy3u6aZg@mail.gmail.com>
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
To: Kees Cook <keescook@google.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Luis Henriques <luis.henriques@canonical.com>, Greg KH <gregkh@linuxfoundation.org>, Brian Foster <bfoster@redhat.com>, Dwight Engen <dwight.engen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Gao feng <gaofeng@cn.fujitsu.com>, Dave Chinner <dchinner@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>

On Tue, Dec 10, 2013 at 06:45:54PM -0800, Kees Cook wrote:
> On Tue, Dec 10, 2013 at 6:00 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Dec 10, 2013 at 08:10:51PM -0500, Josh Boyer wrote:
> >> On Tue, Dec 10, 2013 at 8:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > Security processes are not something that should be hidden away in
> >> > it's own private corner - if there's a problem upstream needs to
> >> > take action on, then direct contact with upstream is necessary. We
> >> > need to know about security issues - even ones that are classified
> >> > post-commit as security issues - so we are operating with full
> >> > knowledge of the issues in our code and the impact of our fixes....
> >>
> >> Agreed.  I'm going to interpret your comments at being directed to the
> >> general audience because otherwise you're just shooting the messenger
> >> :).
> >
> > Right, they are not aimed at you - they are aimed at those on the
> > security side of the fence. I'm tired of learning about CVEs in XFS
> > code through chinese whispers and/or luck.
> 
> Mostly I try to shield anyone not interested in CVEs from the boring
> process, and try to focus on just getting things marked as needing to
> go into stable. I don't think anyone needs to read the oss-security
> list if they don't want to.

Which is how is should be. ;) All I want is some kind of
notification when a CVE raised for an XFS issue. It may be telling
us something we already known, but if:

	a) it has not yet been pushed upstream; or
	b) it was not marked for stable kernels at commit time; or
	c) don't have a fix for it yet

then it's an indication that we need to pay a little more attention
to this class of problem when we review similar fixes.

> In this case, the fix Dan sent was part of a larger collection of
> security issues reported by Nico. I think the communication error here
> was Dan accidentally forgetting to add the Cc: stable tag. But beyond
> that, it was sent to the xfs list and Cc: to security, so I'm not sure
> it's fair to say it was hidden away. :)

Right - this falls into the above category a) because of that. There
didn't appear to be any urgency because of the level of exposure of
the problem (i.e. need CAP_SYS_ADMIN to trip over it) and the fact
it's been like this for the past 10 years....

> Besides the missing Cc: stable tag, what should future patch senders
> do to call attention to an issue being a security problem at the time
> it is being reported?

Well, it may not be known at the time it's considered a security
issue, so I think that the best thing to do is make sure that when
a CVE is actually raise a note is sent to the relevant list just to
indicate 'CVE 1024-3267 has been raised for commit abcd1234
("xfs: knabgraddle the frobnozzle")'.

At least that way everyone - including XFS users - that there is an
issue that they might want to look out for and plan to upgrade their
stable kernels in the not-to-distant future...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
