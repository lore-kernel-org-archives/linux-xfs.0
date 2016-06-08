Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A0307CA0
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 23:16:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3DC8E304051
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 21:16:05 -0700 (PDT)
Received: from mail-qt0-f179.google.com (mail-qt0-f179.google.com
	[209.85.216.179]) by cuda.sgi.com with ESMTP id
	tXD2WSjCDFU39FQY (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2016 21:16:03 -0700 (PDT)
Received: by mail-qt0-f179.google.com with SMTP id q45so27164054qtq.1
	for <xfs@oss.sgi.com>; Tue, 07 Jun 2016 21:16:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAA5faFWyPDienm2NbHkafZh-RvbjJp6f_zDq62z6rC1d1Vzyw@mail.gmail.com>
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
	<c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
	<CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
	<48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
	<20160607134442.GA1803@infradead.org>
	<CAAA5faFWyPDienm2NbHkafZh-RvbjJp6f_zDq62z6rC1d1Vzyw@mail.gmail.com>
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Date: Tue, 7 Jun 2016 22:16:01 -0600
Message-ID: <CAAA5faGXHJZPWkkxDM-kvHqh--hPhnD1Y8RuaaSmuzgiz=_LDg@mail.gmail.com>
Subject: Re: crash in xfs in current
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Daniel Wagner <wagi@monom.org>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Tue, Jun 7, 2016 at 5:40 PM, Reinoud Koornstra
<reinoudkoornstra@gmail.com> wrote:
> Hi Christoph,
>
> Now my git log show this:
>
> commit 555b67e4e729ca544bb4028ab12e532c68b70ddb
> Merge: 544ad71 ad438c4
> Author: Dave Chinner <david@fromorbit.com>
> Date:   Fri May 20 10:34:00 2016 +1000
>
>    Merge branch 'xfs-4.7-inode-reclaim' into for-next
>
> commit 544ad71fc8e20fb3a6f50f00d487751492cd8409
> Merge: 2a4ad58 e6b3bb7
> Author: Dave Chinner <david@fromorbit.com>
> Date:   Fri May 20 10:33:38 2016 +1000
>
>    Merge branch 'xfs-4.7-error-cfg' into for-next
>
> commit 2a4ad5894c819978dca5595396d54d51c3aca694
> Merge: a7792aa 6e3e6d5
> Author: Dave Chinner <david@fromorbit.com>
> Date:   Fri May 20 10:33:17 2016 +1000
>
>    Merge branch 'xfs-4.7-misc-fixes' into for-next
>
> commit a7792aad644a259375002db8c9d9e03fd50bf509
> Merge: 5b911354 3ab3ffc
> Author: Dave Chinner <david@fromorbit.com>
> Date:   Fri May 20 10:32:35 2016 +1000
>
> Is this correct?
> If so, let me build and test.
> Building it already as we speak, but it would be nice if you could
> confirm I'm actually testing the right thing.
> Though, wouldn't it be good to repro and get a core file as well?
> Or would the test of this commit narrow down the possibilities as well?
> Thanks,
>
> Reinoud.
>

Ouch, forgive me for not responding inline previously.
For what it's worth, i've compiled the kernel and are running it as we speak.
Will do testing and let you know.
Thanks,

Reinoud.

> On Tue, Jun 7, 2016 at 7:44 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Tue, Jun 07, 2016 at 12:52:39PM +0200, Daniel Wagner wrote:
>>> >> I try to reproduce it on 4.6. My steps do not always trigger the crash.
>>> >> So I can't be really sure if 4.6 doesn't show it, it does not happen.
>>> >
>>> > I have never been able to trigger this in 4.6 and it's my failsafe
>>> > reboot (4.6.0).
>>> > In 4.7-rc1 it's just a matter of time before I hit it.
>>> > I do a lot of transactions, using git, extraction of tar.xz etc normally.
>>>
>>> This rings a bell. I though the lockperf tests triggered it. Before I
>>> compiled a new kernel I did a 'git checkout' step.
>>
>> Thanks for testing this to both of you.  Can you try to build a kernel
>> from git commit 555b67e4e729ca544bb4028ab12e532c68b70ddb - this is the
>> XFS pull request that Dave sent to Linux for Linux 4.7-rc, so it has
>> all the XFS changes relative to 4.6, but none of the others like the VFS
>> changes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
