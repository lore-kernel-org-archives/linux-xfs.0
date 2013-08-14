Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B16B329E14
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 23:12:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3ADB7AC003
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 21:12:39 -0700 (PDT)
Received: from mail-qa0-f48.google.com (mail-qa0-f48.google.com
	[209.85.216.48]) by cuda.sgi.com with ESMTP id X7FytiZTPfDFEyA9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Aug 2013 21:12:36 -0700 (PDT)
Received: by mail-qa0-f48.google.com with SMTP id o19so791862qap.0
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 21:12:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130814035738.GD6023@dastard>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<1376304611-22994-51-git-send-email-david@fromorbit.com>
	<520A4AB7.1080207@sgi.com> <20130813214648.GC6023@dastard>
	<520AAC79.1030608@sgi.com> <20130814035738.GD6023@dastard>
Date: Wed, 14 Aug 2013 12:12:36 +0800
Message-ID: <CAEH94Lir_YKgCLntOWrmhVsntR_wdJ4QcvtYYO+xPiNzxPKHFg@mail.gmail.com>
Subject: Re: [PATCH 50/50] xfs: use reference counts to free clean buffer items
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfstests <xfs@oss.sgi.com>

On Wed, Aug 14, 2013 at 11:57 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Aug 13, 2013 at 05:00:25PM -0500, Mark Tinguely wrote:
>> On 08/13/13 16:46, Dave Chinner wrote:
>> >On Tue, Aug 13, 2013 at 10:03:19AM -0500, Mark Tinguely wrote:
>> >>On 08/12/13 05:50, Dave Chinner wrote:
>> >>>From: Dave Chinner<dchinner@redhat.com>
>> >>>
>> >>>When a transaction is cancelled and the buffer log item is clean in
>>
>> ...
>>
>> >>
>> >>why is a clean buffer on the AIL? Racing with a completion handler?
>> >
>> >"clean" means that it wasn't dirtied in the transaction - it can be
>> >in the AIL and holding a reference count that way.
>>
>> I am wondering because it should not have made it into the CIL if it
>> was not dirtied in a transaction - at least according to the the log
>> item descriptor flag at least.
>
> CIL != AIL. IOWs, the bli_refcount going to zero doesn't always
By the way, can you explain what the difference is between CIL and AIL?

> mean the bli should be freed. All a zero value means is that it is
> not tracked by any transaction. If the item is not going to be
> placed in the AIL (or not already in the AIL) then it can be
> released (freed). Clean or aborted items are not going into the AIL,
> so they can be freed immeidately. Everything else needs to avoid
> freeing the item until the correct state is reached, even if the ref
> count goes to zero.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
