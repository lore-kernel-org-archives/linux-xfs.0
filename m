Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0098.outbound.protection.outlook.com ([104.47.42.98]:24704
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751874AbeDBAf2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 1 Apr 2018 20:35:28 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Date: Mon, 2 Apr 2018 00:35:25 +0000
Message-ID: <20180402003523.GG7561@sasha-vm>
References: <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia> <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180328033228.GA18129@dastard> <20180328193004.GB7561@sasha-vm>
 <20180328230535.GE18129@dastard> <20180330024704.GE7561@sasha-vm>
 <20180330194946.GF9190@wotan.suse.de>
In-Reply-To: <20180330194946.GF9190@wotan.suse.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F232D384E580E34D8703968E0238C317@namprd21.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Sasha Levin <levinsasha928@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>

On Fri, Mar 30, 2018 at 07:49:46PM +0000, Luis R. Rodriguez wrote:
>On Fri, Mar 30, 2018 at 02:47:05AM +0000, Sasha Levin wrote:
>> On Thu, Mar 29, 2018 at 10:05:35AM +1100, Dave Chinner wrote:
>> >On Wed, Mar 28, 2018 at 07:30:06PM +0000, Sasha Levin wrote:
>> >"./check -g auto" runs the full "expected to pass" regression test
>> >suite for all configured test configurations. (i.e. all config
>> >sections listed in the configs/<host>.config file)
>>
>> Great! With information from Darrick and yourself I've modified tests to
>> be more relevant. Right now I run 4 configs for each stable kernel, but
>> can add more or remove any - depends on what helps people analyse the
>> results.
>>
>> This brings me to the sad part of this mail: not a single stable kernel
>> survived a run. Most are paniced, some are hanging,
>
>I expected this. The semantics over -g auto yielding "expected to pass"
>are relative. Perhaps its better described as "should pass"?
>
>> and some were killed
>> because of KASan.
>>
>> All have hit various warnings in fs/iomap.c, and kernels accross several
>> versions hit the BUG at fs/xfs/xfs_message.c:113 (+-1 line)
>>
>> 4.15.12 is hitting a use-after-free in xfs_efi_release().
>> 4.14.29 and 4.9.89 seems to end up with corrupted memory (KASAN
>> warnings) at or before generic/027.
>> And finally, 3.18.101 is pretty unhappy with sleeping functions called
>> from atomic context.
>
>From my limited experience you have no option but to create an expunge lis=
t for
>each failure for now, and then pass the expunge lists -- that in essence w=
ould
>define the stable baseline and you should expect this to be different per
>kernel release. If you upgrade tooling, it can also change the results, an=
d
>likewise if you upgrade fstests.
>
>If you define an expunge list you can then pass the list with the -E param=
eter,
>you can for instance categorize then failures by type and use a file for e=
ach
>type of failure, whether that's a triage list or a type of common failure.
>Format can be:
>
>test # comments are ignored
>
>Since you may want to database this somehow, perhaps a format that lists
>some tracking for it or other heuristics:
>
>generic/388 # bug#12345 - 1/300 run fails
>
>I'd recommend to just add all failures to one large expunge list for now,
>and later you can split / sort them them as needed.
>
>The idea later is that any failure later would be a regression. What would
>be good is to test a stable kernel prior to the auto-selection and use tha=
t
>as baseline, then bump the kernel and ensure no regressions were created.
>
>A dicey corner issue is that of tests which are supposed to "pass" but yet
>can fail every blue moon. For instance I've been running into one-off fail=
ures
>with generic/388 -- but only if I run it over 300 times.
>
>As such the baseline IMHO should also track these as just failures, howeve=
r it
>will be often picked up as a regression first. The only way to rule this o=
ut
>is to loop test the same test prior to a kernel update and ensure it wasn'=
t
>a regression -- ie, that it *was* still failing before.

Thanks for the pointers!

>This is why all this work is rather full time'ish. There is no way around =
it,
>it will take time to establish a baseline from fstests for a filesystem. T=
here
>will also be a lot of odd ins and outs of each filesystem.

Right, but the way I see it, no one actually uses upstream. If anything,
it's a development branch, and the "real" users pick up one of the
stable trees to work with. So while there seems to be a lot of effort
dedicated to new features or fixing upstream bugs, not enough people
care that no one won't see those fixes for a few years.


--
Thanks,
Sasha=
