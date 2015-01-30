Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A5F7B7FF4
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2015 02:25:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 744688F804C
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2015 00:25:32 -0800 (PST)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
	[209.85.220.41]) by cuda.sgi.com with ESMTP id 4RWezZqEqg2kWWeM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Jan 2015 00:25:31 -0800 (PST)
Received: by mail-pa0-f41.google.com with SMTP id kq14so49766474pab.0
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2015 00:25:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150130013456.GA4251@dastard>
References: <54c1c12e.230a460a.4729.11fc@mx.google.com>
	<20150128015757.GT16552@dastard>
	<CALJmpHP=vjz_ZY9sFpW8k2Y7TL+sz-WyjPeMoy4sM6XDTt8MTQ@mail.gmail.com>
	<20150128205956.GA6282@dastard>
	<CALJmpHOFVZer7YL8Kek6jk2U8f7JyBrJknYzVhyowht_EGm7DQ@mail.gmail.com>
	<20150130013456.GA4251@dastard>
Date: Fri, 30 Jan 2015 13:55:30 +0530
Message-ID: <CALJmpHO1MiPRFvE9P2mU0rtRgcftfNc3XXnxb=nPVYWt-=fU9g@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs_spaceman: Accounting for AGFL blocks
From: Dhruvesh Rathore <adrscube@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On Fri, Jan 30, 2015 at 7:04 AM, Dave Chinner <david@fromorbit.com> wrote:
> [ please reply to the list! ]

We apologize it was an honest mistake.
We had hit reply instead of typing in the 'to field'.

>
> On Thu, Jan 29, 2015 at 09:18:03AM +0530, Dhruvesh Rathore wrote:
>> On Thu, Jan 29, 2015 at 2:29 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Wed, Jan 28, 2015 at 06:35:22PM +0530, ADRS PICT wrote:
>> >> On Wed, Jan 28, 2015 at 7:27 AM, Dave Chinner <david@fromorbit.com> wrote:
>> >> > Hmmm - I think something is still missing - what are the sagbno and
>> >> > eagbno parameters supposed to do?
>> >>
>> >> Actually the parameters sagbno and eagbno are not needed in this
>> >> function and can be excluded.
>> >
>> > Why? Don't we still have to check the blocks found on the AGFL fll
>> > within the range requested by the user, like we do for every extent
>> > found in the btree?
>>
>> We had felt that the range check is not needed as we are fetching block numbers
>> from the allocation group free block array by the function
>> xfs_alloc_read_agfl().
>> And in xfs_alloc_read_agfl(), the error checking is done implicitly.
>>
>> However, after you have raised this point, it is clear to us that performing a
>> range check will be a good way to catch and display a warning if the blocks are
>> out of range.

> The range checking is not for validity of the blocks themselves -
> the ranges passed in come from the user. i.e. the user is asking for
> free space blocks within a certain range on disk. The blocks in the
> AGFL may or may not lie within that the user specified range, and so
> need to be checked against the range (similar to btree extents) to
> determine if they shoul dbe added to the FIEMAPFS output...
>

We have incorporated the above changes, and sent the updated patches on
the mailing list. Here are the links:

http://oss.sgi.com/archives/xfs/2015-01/msg00484.html
http://oss.sgi.com/archives/xfs/2015-01/msg00486.html
http://oss.sgi.com/archives/xfs/2015-01/msg00487.html
http://oss.sgi.com/archives/xfs/2015-01/msg00488.html
http://oss.sgi.com/archives/xfs/2015-01/msg00489.html

Regards,
A-DRS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
