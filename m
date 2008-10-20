Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 07:56:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KEuO80016896
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 07:56:25 -0700
Received: from yx-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 095BB1441A6A
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 07:58:09 -0700 (PDT)
Received: from yx-out-1718.google.com (yx-out-1718.google.com [74.125.44.155]) by cuda.sgi.com with ESMTP id lf6JoIjYnLMeVAj5 for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 07:58:09 -0700 (PDT)
Received: by yx-out-1718.google.com with SMTP id 36so302416yxh.32
        for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 07:58:09 -0700 (PDT)
Message-ID: <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com>
Date: Mon, 20 Oct 2008 18:58:09 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
In-Reply-To: <20081017135510.7127c4e7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
	 <20081017164116.GA17375@infradead.org>
	 <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
	 <20081017165738.GA20818@infradead.org>
	 <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
	 <20081017203710.GA27187@infradead.org>
	 <20081017135510.7127c4e7@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

2008/10/18 Arjan van de Ven <arjan@infradead.org>:
> On Fri, 17 Oct 2008 16:37:10 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
>
>> I just ran the xfs testsuite over linux-next on qemu (i386), and I
>> can't find anything at all.  Really strange.  Let's see if this still
>> there with mondays linux-next, and if yes can you just try the xfs
>> patch from the splitout linux-next patches and see if that alone
>> causes it?

Hi Christoph

I have the same result with next-1020 and today's xfs-2.6.git/master
(
commit bfd2bd10da76378dc4afd87d7d204a1d3d70b347
Author: David Chinner <david@fromorbit.com>
Date:   Fri Oct 17 15:36:23 2008 +1000
    Inode: Allow external list initialisation
)

Should I start bisecting?
>>
>> In fact that might be useful for todays linux-next, too.
>> --
>
> also if you enable lockdep, it tracks where irq's got turned off (with
> a stacktrace I think) so it would provide some good clues.

Yes, lockdep was enabled, but there is no more information than I
already posted.
