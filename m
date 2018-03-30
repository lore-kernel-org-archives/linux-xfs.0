Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-bl2nam02on0099.outbound.protection.outlook.com ([104.47.38.99]:44480
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752072AbeC3CrJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 22:47:09 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Date: Fri, 30 Mar 2018 02:47:05 +0000
Message-ID: <20180330024704.GE7561@sasha-vm>
References: <20180323013037.GA9190@wotan.suse.de>
 <20180323034145.GH4818@magnolia> <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia> <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180328033228.GA18129@dastard> <20180328193004.GB7561@sasha-vm>
 <20180328230535.GE18129@dastard>
In-Reply-To: <20180328230535.GE18129@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CA5B43971A20994B9DD4C50736DDFE53@namprd21.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>

On Thu, Mar 29, 2018 at 10:05:35AM +1100, Dave Chinner wrote:
>On Wed, Mar 28, 2018 at 07:30:06PM +0000, Sasha Levin wrote:
>> This is actually something I want maintainers to dictate. What sort of
>> testing would make the XFS folks happy here? Right now I'm doing
>> "./check 'xfs/*'" with xfstests. Is it sufficient? Anything else you'd l=
ike to see?
>
>... and you're doing it wrong. This is precisely why being able
>to discover /exactly/ what you are testing and being able to browse
>the test results so we can find out if tests passed when a user
>reports a bug on a stable kernel.
>
>The way you are running fstests skips more than half the test suite
>It also runs tests that are considered dangerous because they are
>likely to cause the test run to fail in some way (i.e. trigger an
>oops, hang the machine, leave a filesystem in an unmountable state,
>etc) and hence not complete a full pass.
>
>"./check -g auto" runs the full "expected to pass" regression test
>suite for all configured test configurations. (i.e. all config
>sections listed in the configs/<host>.config file)

Great! With information from Darrick and yourself I've modified tests to
be more relevant. Right now I run 4 configs for each stable kernel, but
can add more or remove any - depends on what helps people analyse the
results.

The complete VM serial logs as well as results/ from xfstests are also
available and are linked from the email.

Here's an example of such email:

> From: Sasha Levin <alexander.levin@microsoft.com>
> To: Sasha Levin <alexander.levin@microsoft.com>
> To: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.co=
m>
> Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] xfs: Correctly invert xfs_buftarg LRU isolation logi=
c
> In-Reply-To: <20180306102638.25322-1-vbendel@redhat.com>
> References: <20180306102638.25322-1-vbendel@redhat.com>
>
> Hi Vratislav Bendel,
>
> [This is an automated email]
>
> This commit has been processed by the -stable helper bot and determined
> to be a high probability candidate for -stable trees. (score: 6.4845)
>
> The bot has tested the following trees: v4.15.12, v4.14.29, v4.9.89, v4.4=
.123, v4.1.50, v3.18.101.
>
> v4.15.12: Build OK!
> v4.14.29: Build OK!
> v4.9.89: Build OK!
> v4.4.123: Build OK!
> v4.1.50: Build OK!
> v3.18.101: Build OK!
>
> XFS Specific tests:
>
> v4.15.12 (http://stable-bot.westus2.cloudapp.azure.com/test/v4.15.12/test=
s/):
>     No tests completed!
> v4.14.29 (http://stable-bot.westus2.cloudapp.azure.com/test/v4.14.29/test=
s/):
>     No tests completed!
> v4.9.89 (http://stable-bot.westus2.cloudapp.azure.com/test/v4.9.89/tests/=
):
>     No tests completed!
> v4.4.123 (http://stable-bot.westus2.cloudapp.azure.com/test/v4.4.123/test=
s/):
>     v4:
>         Thu Mar 29 21:23:57 UTC 2018
>         Interrupted!
>         Passed all 0 tests
>     v4_reflink:
>         Thu Mar 29 21:24:37 UTC 2018
>         Interrupted!
>         Passed all 0 tests
> v4.1.50 (http://stable-bot.westus2.cloudapp.azure.com/test/v4.1.50/tests/=
):
>     No tests completed!
> v3.18.101 (http://stable-bot.westus2.cloudapp.azure.com/test/v3.18.101/te=
sts/):
>     v4:
>         Thu Mar 29 21:30:40 UTC 2018
>         Interrupted!
>         Passed all 0 tests
>     v4_reflink:
>         Thu Mar 29 21:25:14 UTC 2018
>         Interrupted!
>         Passed all 0 tests
>
> Please let us know if you'd like to have this patch included in a stable =
tree.
>
> --
> Thanks,
> Sasha

Let me know if this would be good enough for now, and if there's
anything else to add that'll be useful.

This brings me to the sad part of this mail: not a single stable kernel
survived a run. Most are paniced, some are hanging, and some were killed
because of KASan.

All have hit various warnings in fs/iomap.c, and kernels accross several
versions hit the BUG at fs/xfs/xfs_message.c:113 (+-1 line)

4.15.12 is hitting a use-after-free in xfs_efi_release().
4.14.29 and 4.9.89 seems to end up with corrupted memory (KASAN
warnings) at or before generic/027.
And finally, 3.18.101 is pretty unhappy with sleeping functions called
from atomic context.

--
Thanks,
Sasha=
