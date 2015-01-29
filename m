Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D4E07F78
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 21:48:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8CA69304064
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 19:48:43 -0800 (PST)
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id ccbN3AdxEpIZyYLw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2015 19:48:42 -0800 (PST)
Received: by mail-pa0-f53.google.com with SMTP id kx10so33529423pab.12
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 19:48:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALJmpHOFVZer7YL8Kek6jk2U8f7JyBrJknYzVhyowht_EGm7DQ@mail.gmail.com>
References: <54c1c12e.230a460a.4729.11fc@mx.google.com>
	<20150128015757.GT16552@dastard>
	<CALJmpHP=vjz_ZY9sFpW8k2Y7TL+sz-WyjPeMoy4sM6XDTt8MTQ@mail.gmail.com>
	<20150128205956.GA6282@dastard>
	<CALJmpHOFVZer7YL8Kek6jk2U8f7JyBrJknYzVhyowht_EGm7DQ@mail.gmail.com>
Date: Thu, 29 Jan 2015 09:18:41 +0530
Message-ID: <CALJmpHNVSsdYp1pwfBjmhJHCnaXwrp071mwp20GfxaQynsYrNA@mail.gmail.com>
Subject: Fwd: [PATCH 2/2] xfs_spaceman: Accounting for AGFL blocks
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
To: xfs@oss.sgi.com

On Thu, Jan 29, 2015 at 2:29 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jan 28, 2015 at 06:35:22PM +0530, ADRS PICT wrote:
>> On Wed, Jan 28, 2015 at 7:27 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > Hmmm - I think something is still missing - what are the sagbno and
>> > eagbno parameters supposed to do?
>>
>> Actually the parameters sagbno and eagbno are not needed in this
>> function and can be excluded.
>
> Why? Don't we still have to check the blocks found on the AGFL fll
> within the range requested by the user, like we do for every extent
> found in the btree?

We had felt that the range check is not needed as we are fetching block numbers
from the allocation group free block array by the function
xfs_alloc_read_agfl().
And in xfs_alloc_read_agfl(), the error checking is done implicitly.

However, after you have raised this point, it is clear to us that performing a
range check will be a good way to catch and display a warning if the blocks are
out of range.

Regards,
A-DRS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
