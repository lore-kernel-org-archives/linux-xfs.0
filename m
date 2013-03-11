Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D06A7F3F
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 04:29:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B2C28F8049
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 02:29:49 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id hOsbt94zxc7ZWrg8
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 02:29:45 -0700 (PDT)
Message-ID: <513DA40B.6050903@hardwarefreak.com>
Date: Mon, 11 Mar 2013 04:29:47 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption
References: <CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com> <5139A3B6.3040805@hardwarefreak.com>
	<5139D792.4090304@redhat.com> <513A350A.508@hardwarefreak.com>
	<20130309091152.GH23616@dastard>
	<513B84AD.2000603@hardwarefreak.com>
	<20130310224536.GK23616@dastard>
	<513D1D51.7010905@hardwarefreak.com>
	<20130311005024.GC20565@dastard>
In-Reply-To: <20130311005024.GC20565@dastard>
Reply-To: stan@hardwarefreak.com
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
Cc: Julien FERRERO <jferrero06@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

On 3/10/2013 7:50 PM, Dave Chinner wrote:
> On Sun, Mar 10, 2013 at 06:54:57PM -0500, Stan Hoeppner wrote:
>> On 3/10/2013 5:45 PM, Dave Chinner wrote:
>>>>  Does everyone remember the transitive property of equality from math
>>>> class decades ago?  It states "If A=B and B=C then A=C".  Thus if
>>>> barrier writes to the journal protect the journal, and the journal
>>>> protects metadata, then barrier writes to the journal protect metadata.
>>>
>>> Yup, but the devil is in the detail - we don't protect individual
>>> metadata writes at all and that difference is significant enough to
>>> comment on.... :P
>>
>> Elaborate on this a bit, if you have time.  I was under the impression
>> that all directory updates were journaled first.
> 
> That's correct - they are all journalled.
> 
> But journalling is done at the transactional level, not that of
> individual metadata changes. IOWs, journalled changes do not
> contain the same information as a metadata buffer write - they
> contain both more and less information than a metadata buffer write.
> 
> They contain more information in that there is change atomicity
> information in the journal information for recovery purposes. i.e.
> how the individual change relates to changes in other related
> metadata objects. This information is needed in the journal so that
> log recovery knows to either apply all the changes in a checkpoint
> or none of them if this journal checkpoint (or a previous one) is
> incomplete.
> 
> They contain less information in that the changes to a metadata
> object is stored as a diff in the journal rather than as a complete
> copy of the object. This is done to reduce the amount of journal
> space and memory required to track and store all of the changes in
> the checkpoint.

Forget the power loss issue for a moment.  If I'm digesting this
correctly, it's seems quite an accomplishment that you got delaylog
working, at all, let alone extremely well as it does.  Given what you
state above, it would seem there is quite a bit of complexity involved
in tracking these metadata change relationships and modifying the
checkpoint information accordingly.  I would think as you merge multiple
traditional XFS log writes into a single write that the relationship
information would also need to be modified as well.  Or do I lack
sufficient understanding at this point to digest this?

> Hence what is written to the journal is quite different to what is
> written during metadata writeback in both contents ad method. It is
> the atomicity information in the journal that we know got
> synchronised to disk (via the FUA/cache flush) that enables us to
> get away with being lazy writing back metadata buffers in any order
> we please without needing FUA/cache flushes...

This makes me wonder... for a given metadata write into an AG, is the
amount of data in the corresponding journal write typically greater or
less?  You stated above it is both more and less but I don't know if you
meant that qualitatively or quantitatively, or both.  I'm wondering that
if log write bytes is typically significantly lower, and we know we can
recreate a lost metadata write from the journal data during a
recovery.... Given that CPU is so much faster than disk, would it be
plausible to do all metadata writes in a lazy fashion through the
relevant sections of the recovery code, or something along these lines?
 Make 'recovery' the standard method for metadata writes?  I'm not
talking about replacing the log journal, but replacing the metadata
write method with something akin to a portion of the the journal
recovery routine.

In other words, could we make use of the delaylog concept of doing more
work with fewer IOs to achieve a similar performance gain for metadata
writeback?  Or is XFS metadata writeback already fully optimized WRT IOs
and bandwidth, latency, etc?  Or is this simply a crazy idea from a
member of the peanut gallery who has just enough knowledge to be a
nuisance, but lacks enough to make real contributions?  Probably the
latter. ;)

> So, yes you are correct in that the journalling protects metadata.
> However, the distinction I'm making is that the journal writes
> contain different information and have different constraints
> compared to individual metadata object writeback, and therefore are
> not the "same thing" and do not require the same protection from
> power loss/crash events...

Thanks Dave for continuing to take time to teach.  I've passed on much
of what I've learned from you to many others outside of this list.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
