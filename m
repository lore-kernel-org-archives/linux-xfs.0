Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E8B87FC4
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 19:10:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2794A8F8064
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 17:10:54 -0800 (PST)
Received: from mail-oa0-f54.google.com (mail-oa0-f54.google.com
	[209.85.219.54]) by cuda.sgi.com with ESMTP id cgTB5fV4IxxDm7tU
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Dec 2013 17:10:52 -0800 (PST)
Received: by mail-oa0-f54.google.com with SMTP id h16so6498584oag.41
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 17:10:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131211010326.GF10988@dastard>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
	<20131209121534.GE4278@hercules>
	<CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
	<20131209235523.GW31386@dastard>
	<CA+5PVA5rUmWYQiPwkN15CnfqckmEjVukXz3mU75CiUBVzfERqA@mail.gmail.com>
	<20131211010326.GF10988@dastard>
Date: Tue, 10 Dec 2013 20:10:51 -0500
Message-ID: <CA+5PVA7wso5fo11xX9kCUdbrqBQMzUnYwTOB_Qe3K7LDY4z_Cw@mail.gmail.com>
Subject: Re: XFS security fix never sent to -stable?
From: Josh Boyer <jwboyer@fedoraproject.org>
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
Cc: Luis Henriques <luis.henriques@canonical.com>, Greg KH <gregkh@linuxfoundation.org>, Brian Foster <bfoster@redhat.com>, Kees Cook <keescook@google.com>, Dwight Engen <dwight.engen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Gao feng <gaofeng@cn.fujitsu.com>, Dave Chinner <dchinner@redhat.com>

On Tue, Dec 10, 2013 at 8:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Dec 10, 2013 at 08:20:07AM -0500, Josh Boyer wrote:
>> On Mon, Dec 9, 2013 at 6:55 PM, Dave Chinner <david@fromorbit.com>
>> wrote:
>> > [cc xfs list, cc stable@vger.kernel.org]
>> >
>> > On Mon, Dec 09, 2013 at 08:17:09AM -0500, Josh Boyer wrote:
>> >> On Mon, Dec 9, 2013 at 7:15 AM, Luis Henriques
>> >> <luis.henriques@canonical.com> wrote:
>> >> > On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
>> >> >> Hi,
>> >> >>
>> >> >> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c
>> >> >> ("xfs: add capability check to free eofblocks ioctl") is a
>> >> >> security fix that was never sent to -stable? From what I can
>> >> >> see, it was introduced in 3.8 by
>> >> >> 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
>> >> >> XFS_IOC_FREE_EOFBLOCKS ioctl").
>> >> >>
>> >> >> I don't see this in the 3.8.y tree. Should it be added there
>> >> >> and newer?
>> >> >
>> >> > Thanks Kees, I'm queuing it for the 3.11 kernel.
>> >>
>> >> There's also this one:
>> >>
>> >> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/57654
>> >>
>> >> It fixes CVE-2013-6382
>> >
>> > First I've heard about it there being a CVE for that bug. Since
>> > when has it been considered best practice to publish CVEs
>> > without first (or ever) directly contacting the relevant
>> > upstream developers?
>>
>> We got a Fedora bug for it, and there are similar RHEL bugs open.
>> I had assumed you would be informed either via upstream or
>> through those.
>
> I've not been cc'd on any of those bugs internally at RH, so I don't
> have visibility of the problems unless someone specifically adds me
> to those bugs.  As it is, raising fedora/RHEL bugs is not informing
> upstream - it is a distro process for tracking the distro issue
> through to closure.

Agreed.  We should probably fix the bug thing anyway though.

>> The CVE request was submitted by Kees here:
>> http://seclists.org/oss-sec/2013/q4/330
>
> Ugh, no, I'm not going to subscribe to a high noise list where the
> only way I might be informed of a CVE being raised is by following
> links to git commit IDs....
>
> Upstream is not magically informed about CVEs, and relying on
> upstream developers to scan or poll *anything* just to find if a
> CVE on their subsystem has been released is not reliable and
> does not scale. If anyone raises a CVE against a kernel subsystem,
> then the relevant list in the MAINTAINERS file for that subsystem
> should be on the cc list of any discussion about the CVE, and on the
> announcement of the CVE.
>
> Security processes are not something that should be hidden away in
> it's own private corner - if there's a problem upstream needs to
> take action on, then direct contact with upstream is necessary. We
> need to know about security issues - even ones that are classified
> post-commit as security issues - so we are operating with full
> knowledge of the issues in our code and the impact of our fixes....

Agreed.  I'm going to interpret your comments at being directed to the
general audience because otherwise you're just shooting the messenger
:).

josh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
