Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Jul 2008 05:07:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m64C7iKP026200
	for <xfs@oss.sgi.com>; Fri, 4 Jul 2008 05:07:44 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAC0BDA407E
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2008 05:08:47 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id SeAPJYjmHsfYpsN7 for <xfs@oss.sgi.com>; Fri, 04 Jul 2008 05:08:47 -0700 (PDT)
Message-Id: <B7BFE816D02640B8A5EFDD83E9C23FB9@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080701105251.GC22522@agk.fab.redhat.com> <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp> <20080703124709.GI22522@agk.fab.redhat.com> <20080703221133.GA29319@disturbed>
In-Reply-To: <20080703221133.GA29319@disturbed>
Subject: Re: [dm-devel] Re: [PATCH 3/3] Add timeout feature
Date: Fri, 4 Jul 2008 21:08:09 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

Hi Alasdair, Eric and Dave,

> On Thu, Jul 03, 2008 at 01:47:10PM +0100, Alasdair G Kergon wrote:
>> On Thu, Jul 03, 2008 at 09:11:05PM +0900, Takashi Sato wrote:
>> > If the freezer accesses the frozen filesystem and causes a deadlock,
>> > the above ideas can't solve it
>>
>> But you could also say that if the 'freezer' process accesses the frozen
>> filesystem and deadlocks then that's just a bug and that userspace code
>> should be fixed and there's no need to introduce the complexity of a
>> timeout parameter.
>
> Seconded - that was also my primary objection to the timeout code.

I will consider removing the timeout.

>> The point I'm trying to make here is:
>>   Under what real-world circumstances might multiple concurrent freezing
>>   attempts occur, and which of A, B or C (or other variations) would be
>>   the most appropriate way of handling such situations?
>>
>> A common example is people running xfs_freeze followed by an lvm command
>> which also attempts to freeze the filesystem.
>
> Yes, I've seen that reported a number of times.
>
>> I can see a case for B or C, but personally I prefer A:
>>
>> > > 1 succeeds, freezes
>> > > 2 succeeds, remains frozen
>> > > 3 succeeds, remains frozen
>> > > 4 succeeds, thaws
>
> Agreed, though I'd modify the definition of that case to be "remain
> frozen until the last thaw occurs". That has the advantage that
> it's relatively simple to implement with just a counter...

I agree this idea.
But I have one concern. When device-mapper's freeze follows FIFREEZE,
can device-mapper freeze only device-mapper's part correctly?
And when device-mapper's thaw follows FITHAW,
can device-mapper thaw only device-mapper's part?

Cheers, Takashi 
