Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 22:16:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m785FkjU017046
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 22:15:46 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F196A375CA0
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2008 22:16:57 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.172]) by cuda.sgi.com with ESMTP id SwtYChjJ6ijNjAY3 for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 22:16:57 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 26so696615wfd.32
        for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 22:16:57 -0700 (PDT)
Message-ID: <cc7060690808072216q29efacf4tdf363fe3ed8a2c44@mail.gmail.com>
Date: Fri, 8 Aug 2008 10:46:56 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 981498 - Use KM_NOFS for debug trace buffers
In-Reply-To: <cc7060690808071043r659aea9fn4e28959b3a62081e@mail.gmail.com>
MIME-Version: 1.0
References: <20080806061553.A8D8958C52A4@chook.melbourne.sgi.com>
	 <cc7060690808061012x43511581m15c794e72129becc@mail.gmail.com>
	 <20080806201957.GQ21635@disturbed>
	 <cc7060690808071043r659aea9fn4e28959b3a62081e@mail.gmail.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>, Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

On Thu, Aug 7, 2008 at 11:13 PM, Bhagi rathi <jahnu77@gmail.com> wrote:

>
>
> On Thu, Aug 7, 2008 at 1:49 AM, Dave Chinner <david@fromorbit.com> wrote:
>
>> On Wed, Aug 06, 2008 at 10:42:15PM +0530, Bhagi rathi wrote:
>> > I couldn't get a chance to read the diff's completely. If I click on
>> > Lachlan's url for diff's, I couldn't access them. It looks to me that
>> > the issue is not just with trace buffers. It can extend to xfs_iformat
>> > as well. The same dead-lock can spring via
>> >
>> > xfs_iread -> xfs_iformat -> xfs_iformat_extents -> xfs_iext_add ->
>> > xfs_iext_inline_to_direct -> which can do kmem_alloc with
>> > KM_SLEEP flag.
>>
>> Fixed already:
>>
>>
>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=8c6266658cb76e282c14cb92f8ba5a1c674f4928
>>
>
>  Thanks Dave. However, My concern is just not one allocation. We
>  need to clean all allocations that can re-enter to file-system.
>  I see that this issue exists in attributes format for i_afp allocations.
>  It may exist with local format of data and attributes too.
>
>  xfs_iread->xfs_iformat->xfs_iformat_local.
>

  Is the above issue fixed already? I see this existing in latest linux
  kernel.


>
>  Are we safe that we fixed all these real problems by looking
>  into possible allocations that will enter into file-system? The
>  problem with trace buffers is telling us to clean this code path.
>
>  By the way, I browse the source code from lxr.linux.no.
>  If I have to browse the latest xfs source code with linux
>  kernel that is used at SGI, how can I do that?
>

 Any pointers on this? I wish to setup my own xfs development enviroment
 and details on this will be helpful.

Cheers,
Bhagi.

>
>
>  Cheers,
>  Bhagi.
>
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>
>


[[HTML alternate version deleted]]
