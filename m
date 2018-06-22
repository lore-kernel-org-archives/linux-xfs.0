Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:38591 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753944AbeFVPR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 11:17:58 -0400
Received: by mail-lf0-f66.google.com with SMTP id i83-v6so9256017lfh.5
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 08:17:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180622035424.GD13748@dastard>
References: <20180618174433.3069-1-mbenatto@redhat.com> <20180618174433.3069-2-mbenatto@redhat.com>
 <20180622023735.GN2780@desktop> <9b44c744-6abd-35d2-e3ec-1f8a1a8ea710@redhat.com>
 <20180622035424.GD13748@dastard>
From: Marco Benatto <mbenatto@redhat.com>
Date: Fri, 22 Jun 2018 12:17:56 -0300
Message-ID: <CAOGQQ2-_pgiPKPRoxHudZaoyAngd8+NW17oJDG+5N-e2R51m2g@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfstests: Test root inode parent pointer repairing
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

Hi Eryuy et al,

firstly thanks for the reviews.

OK, I'll resend just the test itself (without the one which hoist the
helper function for sfdir format).


Given Eric's and Dave's updates, should I re-include the common
definitions even those being unused within
this test scope?

If those are used by helpers or any other flow on xfstest I do agree
with Eric and Dave about hoist it.

Thanks,


On Fri, Jun 22, 2018 at 12:54 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jun 21, 2018 at 09:58:25PM -0500, Eric Sandeen wrote:
>> On 6/21/18 9:37 PM, Eryu Guan wrote:
>> > On Mon, Jun 18, 2018 at 02:44:33PM -0300, Marco Benatto wrote:
>> >> Recently we found out xfs_repair were not repairing
>> >> root inode parent pointer when root inode is on short-form
>> >> and parent points to an invalid inode number (refer to:
>> >> "xfs_repair: Fix root inode's parent when it's bogus for sf
>> >> directory" on xfs-devel list).
>> >>
>> >> This test checks if xfs_repair successfully repair the
>> >> filesystem in the scenario mentioned before.
>> >>
>> >> Signed-off-by: Marco Benatto <mbenatto@redhat.com>
>> >> ---
>> >>  tests/xfs/450     | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>> >>  tests/xfs/450.out |  1 +
>> >>  tests/xfs/group   |  1 +
>> >>  3 files changed, 55 insertions(+)
>> >>  create mode 100755 tests/xfs/450
>> >>  create mode 100644 tests/xfs/450.out
>> >>
>> >> diff --git a/tests/xfs/450 b/tests/xfs/450
>> >> new file mode 100755
>> >> index 0000000..dc7f244
>> >> --- /dev/null
>> >> +++ b/tests/xfs/450
>> >> @@ -0,0 +1,53 @@
>> >> +#! /bin/bash
>> >> +# SPDX-License-Identifier: GPL-2.0
>> >> +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
>> >> +#
>> >> +# FS QA Test 450
>> >> +#
>> >> +# Make sure xfs_repair can repair root inode parent's pointer
>> >> +# when it contains a bogus ino when it's using shot form directory
>> >> +#
>> >> +seq=`basename $0`
>> >> +seqres=$RESULT_DIR/$seq
>> >> +
>> >> +status=1  # failure is the default!
>> >
>> > Apart from Dave's comments, there're some common definitions missing
>> > too, e.g. 'tmp' and 'here', please use './new xfs' to generate new test
>> > template.
>>
>> Eryu, I think I suggested that Marco could remove the "tmp" definition
>> because it's not used in the script.  Is there some reason to keep it?
>> The script did start out with a "./new xfs" generation template.
>>
>> Oh, I bet some helpers depend on it... sorry, my mistake.  Oops.
>>
>> (though maybe tmp should just get hoisted to the harness and
>> not be required in every script, but I digress ...)
>
> You mean like I proposed a couple of weeks ago along with the
> spdx license tag updates?
>
> https://www.spinics.net/lists/fstests/msg09849.html
>
> that's next on my list of "Big cleanups for fstests To Do" list.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Marco Benatto
Senior Software Maintenance Engineer | Red Hat Brasil
T: +55 11 35246161 | M: +55 41 9 88504051
Av. Brigadeiro Faria Lima 3900, 8° Andar. São Paulo, Brasil. RED HAT |
TRIED. TESTED. TRUSTED. Saiba porque em redhat.com
