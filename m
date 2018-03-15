Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:42525 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbeCOQ1e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 12:27:34 -0400
Received: by mail-ot0-f195.google.com with SMTP id l5-v6so7461850otf.9
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 09:27:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180315154604.GX4865@magnolia>
References: <20180314171724.41951-1-bfoster@redhat.com> <20180314181218.GR4865@magnolia>
 <CAC=E7cUme5-0z9GjVOynD==nK5aG2athrHmm=WKA8HBFWX-hRQ@mail.gmail.com>
 <20180315103839.GA44732@bfoster.bfoster> <20180315154604.GX4865@magnolia>
From: Dave Chiluk <chiluk+linuxxfs@indeed.com>
Date: Thu, 15 Mar 2018 11:27:02 -0500
Message-ID: <CAC=E7cW7eae8Un++GQNchmPi2QA3sZFPF1BiVHW9bw7c8vj2tg@mail.gmail.com>
Subject: Re: [PATCH] xfs: detect agfl count corruption and reset agfl
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Mar 15, 2018 at 10:46 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Mar 15, 2018 at 06:38:39AM -0400, Brian Foster wrote:
>> On Wed, Mar 14, 2018 at 03:42:50PM -0500, Dave Chiluk wrote:
>> > On Wed, Mar 14, 2018 at 1:12 PM, Darrick J. Wong
>> > <darrick.wong@oracle.com> wrote:
>> > > On Wed, Mar 14, 2018 at 01:17:24PM -0400, Brian Foster wrote:
>> ...
>> >
>> > Reviewed-by Dave Chiluk <chiluk+linuxxfs@indeed.com>
>> >
>> > I'm also assuming this will get submitted back to the linux-stable
>> > trees as the agfl packing change is already causing issues in the
>> > stable trees.  If you do not intend to push it into the linux-stable
>> > trees let me know and I'll take care of at least the major ones.
>> >
>>
>> Yeah, I can cc stable in the next post along with the other minor fixes.
>> My question is how far back should this fix go? Was the plan to only go
>> back to v4.5 because that is where the packing fix first went in? Or
>> should this go back further because it looks like the packing fix was
>> backported to v3.10:
>>
>> $ git show 96f859d52bcb1
>> commit 96f859d52bcb1c6ea6f3388d39862bf7143e2f30
>> Author: Darrick J. Wong <darrick.wong@oracle.com>
>> Date:   Mon Jan 4 16:13:21 2016 +1100
>>
>>     libxfs: pack the agfl header structure so XFS_AGFL_SIZE is correct
>>
>>     ...
>>
>>     cc: <stable@vger.kernel.org> # 3.10 - 4.4
>>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>     Reviewed-by: Dave Chinner <dchinner@redhat.com>
>>     Signed-off-by: Dave Chinner <david@fromorbit.com>
>
> Hmmm, I'm assuming that you'd want 3.10 at least for RHEL, but I'll let
> you all figure that one out.
>
> As far as the upstream kernels, 4.14.27, 4.9.87, 4.4.121, and 4.1.50
> have that packing patch so I guess they'll all need some version of this.
>
> --D
>
>>
>> Brian
>>
>> > Thanks,
>> > Dave
>> > --

RHEL is actually fine for now, since they explicitly remove the
packing patch in their kernel, and xfsprogs.  Once you submit the
patches to linux-stable the ubuntu-kernel team monitors and includes
patches for the releases that they are stable maintainers of *(they
are downstream for 4.4 of gregkh, but currently maintain a 3.13, 4.13,
and 4.15 tree).

Also please add a Fixes line to your commit so it's obvious what patch
it helps remediate.  Fixes is actually not a great word here, but that
looks to be what the submitting-patches.txt doc calls for.

Fixes: 96f859d52bcb libxfs: pack the agfl header structure so
XFS_AGFL_SIZE is correct

This way stable maintainers understand that the fix resolves an issue
that was introduced by that patch, and can apply/not apply
appropriately.  Although in all honesty the patch really applies to
all stable kernels regardless of if the packing patch has been applied
or not.

Dave.
