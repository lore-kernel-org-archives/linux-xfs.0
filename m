Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o95A87vI192303 for <xfs@oss.sgi.com>; Tue, 5 Oct 2010 05:08:07 -0500
Received: from mail-yw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 002804C812C
	for <xfs@oss.sgi.com>; Tue,  5 Oct 2010 03:09:10 -0700 (PDT)
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id Y4w9d6pnghX5G0YR
	for <xfs@oss.sgi.com>; Tue, 05 Oct 2010 03:09:10 -0700 (PDT)
Received: by ywo7 with SMTP id 7so297652ywo.26
	for <xfs@oss.sgi.com>; Tue, 05 Oct 2010 03:09:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101004092107.GJ4681@dastard>
References: <201009161546.16909.ruirui.r.yang@tieto.com>
	<20100917005227.GJ24409@dastard>
	<20100920191355.GA28443@infradead.org>
	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
	<4CA997DF.5030008@kernel.org> <20101004092107.GJ4681@dastard>
Date: Tue, 5 Oct 2010 12:09:10 +0200
Message-ID: <AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>
Subject: Re: -mm: xfs lockdep warning
From: Torsten Kaiser <just.for.lkml@googlemail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Yang Ruirui <ruirui.r.yang@tieto.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Oct 4, 2010 at 11:21 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Oct 04, 2010 at 11:01:19AM +0200, Tejun Heo wrote:
>> Hello,
>>
>> On 09/25/2010 03:08 PM, Torsten Kaiser wrote:
>> > [adding Tejun Heo, because I'm partly blaming his workqueues]
>>
>> :-) Sorry about the delay. =A0I was away the last week.
>>
>> > After that I enabled lockdep and retried the same update: This time no
>> > hang, only the same lockdep report that Yang Ruirui had.
>> >
>> > So I'm currently at a loss how I should continue from here. The XFS
>> > false positive drowns any other lockdep problems, but XFS had some
>> > hang problems with the new workqueues. (Personally I had no other hang
>> > with earlier 2.6.36-rcs)
>
> What XFS hang problem? I've seen temporary livelocks from the new
> workqueue code, but thay have been fixed. I haven't come across any
> deadlocks or hangs. Do you have a pointer to a bug report in case my
> memory is failing me?

I was referring to the hang that prompted to increase of the priority
of the xfslogd thread. Its commit
51749e47e191db8e588ad5cebea731caf7b705d7 in Linus' tree. But it seems
I have misremembered that one as a hang.

The hang I have seen is describe here:
http://marc.info/?l=3Dlinux-kernel&m=3D128542018414916&w=3D2

As 2.6.36-rc5 already includes this priority fix, I believe this hang
is something different and wrote that mail.

>> If workqueue lockdep annotations are triggering spuriously, just nuke
>> all lockdep annotations in workqueue.c. =A0Currently the annotations are
>> the same as before and trigger even when an actual deadlock won't
>> happen anymore around flushes (but then again all the current users
>> should be operating under the same constraints as before). =A0I'm
>> looking into how to improve the lockdep annotations but in the end it
>> might be best to leave it as it is. =A0I'll try to analyze the warnings.
>
> It looks like there's been some discussion that has been private so
> I'm clueless as to the context being discussed here. =A0Can someone
> fill me in on whatever is going on?

I only send the above message both to the lkml and the XFS mailing list.

But it could have been wrong to make it a reply in this thread,
because now there are three different things mixed up.

1) the old livelock, that I was referring too -> That is already fixed
in mainline, I just wanted to note, that this is unrelated to the hang
I have seen.
2) the hang with 2.6.35-rc5 I have seen twice (triggered probably by
high load while building KOffice on an tmpfs)
3) the lockdep issue that started this thread and that I am seeing in
mainline 2.6.36-rc5 and -rc6 and that seems to be rather easy to
trigger for me.

Because 3) is regarded as a false positive, it should not be the cause
of 2). But because 3) triggers on my system I can't see if lockdep
might give better pointers to what might be the real cause of 2).

So, I would like to test the patch Christoph was testing in
http://marc.info/?l=3Dlinux-kernel&m=3D128501006509743&w=3D2 to see, if that
helps to debug my hang. (And because I did not see that patch on the
lkml, I replied to Christophs mail.)

I CC'ed Tejun, because I believe the primary suspect for my hang was
the stuck kworker/u:8:845 and I was hoping he might see something
obvious wrong in that stacktrace.

Torsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
