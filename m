Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 49ACF7F81
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 07:20:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE550AC002
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 05:20:09 -0800 (PST)
Received: from mail-oa0-f44.google.com (mail-oa0-f44.google.com
	[209.85.219.44]) by cuda.sgi.com with ESMTP id dBsCdeNgpysnxQxB
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Dec 2013 05:20:07 -0800 (PST)
Received: by mail-oa0-f44.google.com with SMTP id m1so5496023oag.3
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 05:20:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131209235523.GW31386@dastard>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
	<20131209121534.GE4278@hercules>
	<CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
	<20131209235523.GW31386@dastard>
Date: Tue, 10 Dec 2013 08:20:07 -0500
Message-ID: <CA+5PVA5rUmWYQiPwkN15CnfqckmEjVukXz3mU75CiUBVzfERqA@mail.gmail.com>
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

On Mon, Dec 9, 2013 at 6:55 PM, Dave Chinner <david@fromorbit.com> wrote:
> [cc xfs list, cc stable@vger.kernel.org]
>
> On Mon, Dec 09, 2013 at 08:17:09AM -0500, Josh Boyer wrote:
>> On Mon, Dec 9, 2013 at 7:15 AM, Luis Henriques
>> <luis.henriques@canonical.com> wrote:
>> > On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
>> >> Hi,
>> >>
>> >> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
>> >> capability check to free eofblocks ioctl") is a security fix that was
>> >> never sent to -stable? From what I can see, it was introduced in 3.8
>> >> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
>> >> XFS_IOC_FREE_EOFBLOCKS ioctl").
>> >>
>> >> I don't see this in the 3.8.y tree. Should it be added there and newer?
>> >
>> > Thanks Kees, I'm queuing it for the 3.11 kernel.
>>
>> There's also this one:
>>
>> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/57654
>>
>> It fixes CVE-2013-6382
>
> First I've heard about it there being a CVE for that bug. Since when
> has it been considered best practice to publish CVEs without first
> (or ever) directly contacting the relevant upstream developers?

We got a Fedora bug for it, and there are similar RHEL bugs open.  I
had assumed you would be informed either via upstream or through
those.  The CVE request was submitted by Kees here:
http://seclists.org/oss-sec/2013/q4/330

josh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
