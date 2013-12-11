Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 808177FCB
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 20:10:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 595348F804C
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 18:10:46 -0800 (PST)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	aKwq4vzUG0TyyIxf for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 18:10:45 -0800 (PST)
Date: Tue, 10 Dec 2013 18:12:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131211021213.GA18168@kroah.com>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
	<20131209121534.GE4278@hercules>
	<CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
	<20131209235523.GW31386@dastard>
	<CA+5PVA5rUmWYQiPwkN15CnfqckmEjVukXz3mU75CiUBVzfERqA@mail.gmail.com>
	<20131211010326.GF10988@dastard>
	<CA+5PVA7wso5fo11xX9kCUdbrqBQMzUnYwTOB_Qe3K7LDY4z_Cw@mail.gmail.com>
	<20131211020007.GH10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211020007.GH10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Luis Henriques <luis.henriques@canonical.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Dwight Engen <dwight.engen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Gao feng <gaofeng@cn.fujitsu.com>, Kees Cook <keescook@google.com>

On Wed, Dec 11, 2013 at 01:00:07PM +1100, Dave Chinner wrote:
> On Tue, Dec 10, 2013 at 08:10:51PM -0500, Josh Boyer wrote:
> > On Tue, Dec 10, 2013 at 8:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > Security processes are not something that should be hidden away in
> > > it's own private corner - if there's a problem upstream needs to
> > > take action on, then direct contact with upstream is necessary. We
> > > need to know about security issues - even ones that are classified
> > > post-commit as security issues - so we are operating with full
> > > knowledge of the issues in our code and the impact of our fixes....
> > 
> > Agreed.  I'm going to interpret your comments at being directed to the
> > general audience because otherwise you're just shooting the messenger
> > :).
> 
> Right, they are not aimed at you - they are aimed at those on the
> security side of the fence. I'm tired of learning about CVEs in XFS
> code through chinese whispers and/or luck.

CVEs for the kernel are almost always "assigned" after the problem is
fixed, or when people "notice" something was changed upstream.  At that
point, there's no need for the original committer to be notified, as
there's nothing to do.

Anyway, I understand your frustration about CVEs, I don't like them much
either, but some people do, so let them deal with them, and don't give
them a second thought.

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
