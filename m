Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o95HrVe8243589 for <xfs@oss.sgi.com>; Tue, 5 Oct 2010 12:53:37 -0500
Received: from mail-yw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CED3111EE79D
	for <xfs@oss.sgi.com>; Tue,  5 Oct 2010 11:08:13 -0700 (PDT)
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id B5Arb9kRUOGvvYuL
	for <xfs@oss.sgi.com>; Tue, 05 Oct 2010 11:08:13 -0700 (PDT)
Received: by ywo7 with SMTP id 7so475258ywo.26
	for <xfs@oss.sgi.com>; Tue, 05 Oct 2010 10:54:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CAB5779.5020901@kernel.org>
References: <201009161546.16909.ruirui.r.yang@tieto.com>
	<20100917005227.GJ24409@dastard>
	<20100920191355.GA28443@infradead.org>
	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
	<4CA997DF.5030008@kernel.org> <20101004092107.GJ4681@dastard>
	<AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>
	<4CAB5779.5020901@kernel.org>
Date: Tue, 5 Oct 2010 19:54:32 +0200
Message-ID: <AANLkTinwFix7br+p+U2X_mNLTbb0umxQEL5+bhp5N0jW@mail.gmail.com>
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
To: Tejun Heo <tj@kernel.org>
Cc: Yang Ruirui <ruirui.r.yang@tieto.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>, Andrew Morton <akpm@linux-foundation.org>

On Tue, Oct 5, 2010 at 6:51 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> This is getting confusing.
>
> On 10/05/2010 12:09 PM, Torsten Kaiser wrote:
>> 2) the hang with 2.6.35-rc5 I have seen twice (triggered probably by
>> high load while building KOffice on an tmpfs)
>
> The trace doesn't seem to firmly point at xfs locking up. =A0There are
> md and dm crypt involved. =A0Are you sure this is locking up inside xfs?

Not 100%, but apart from the md/dm-worker the other prcesses got stuck
in sync_page() and do_lockup() and these function look filesystem
related. And the only filesystem I'm using on that system is XFS.

And having just read about some problems (that were fixed in
2.6.36-rc5) regarding XFS vs the new workqueues, I "feared" that I
somehow triggered some funny interaction between the workqueues of
XFS, md-raid1 and dm-crypt.

> Also, can you please enable frame pointers so that we can get more
> reliable backtrace?

I will do that and see if -rc6 gets stuck the same way.
But it might take until tomorrow to test this.

>> 3) the lockdep issue that started this thread and that I am seeing in
>> mainline 2.6.36-rc5 and -rc6 and that seems to be rather easy to
>> trigger for me.
>>
>> Because 3) is regarded as a false positive, it should not be the cause
>> of 2)
>
> For now, let's not draw any conclusion or mix the issues. =A0I'll look
> up the original thread and look into what the lockdep warning means.
>
> Thanks.
>
> --
> tejun
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
