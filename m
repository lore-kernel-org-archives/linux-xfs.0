Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-sn1nam02on0117.outbound.protection.outlook.com ([104.47.36.117]:52401
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752826AbeC2SgG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 14:36:06 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Date: Thu, 29 Mar 2018 18:36:04 +0000
Message-ID: <20180329183601.GD7561@sasha-vm>
References: <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia> <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180328033228.GA18129@dastard> <20180328193004.GB7561@sasha-vm>
 <20180328230535.GE18129@dastard> <20180329181223.GK30543@wotan.suse.de>
 <20180329181712.ijbruc7rl2i3nh35@destiny>
In-Reply-To: <20180329181712.ijbruc7rl2i3nh35@destiny>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3C34FFD362AE0C43A41685263EB61DDC@namprd21.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>, Sasha Levin <levinsasha928@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, Tso Ted <tytso@mit.edu>

On Thu, Mar 29, 2018 at 02:17:13PM -0400, Josef Bacik wrote:
>On Thu, Mar 29, 2018 at 06:12:23PM +0000, Luis R. Rodriguez wrote:
>> On Thu, Mar 29, 2018 at 10:05:35AM +1100, Dave Chinner wrote:
>> > On Wed, Mar 28, 2018 at 07:30:06PM +0000, Sasha Levin wrote:
>> > >
>> > > This is actually something I want maintainers to dictate. What sort =
of
>> > > testing would make the XFS folks happy here? Right now I'm doing
>> > > "./check 'xfs/*'" with xfstests. Is it sufficient? Anything else you=
'd like to see?
>> >
>> > ... and you're doing it wrong. This is precisely why being able
>> > to discover /exactly/ what you are testing and being able to browse
>> > the test results so we can find out if tests passed when a user
>> > reports a bug on a stable kernel.
>> >
>> > The way you are running fstests skips more than half the test suite
>> > It also runs tests that are considered dangerous because they are
>> > likely to cause the test run to fail in some way (i.e. trigger an
>> > oops, hang the machine, leave a filesystem in an unmountable state,
>> > etc) and hence not complete a full pass.
>> >
>> > "./check -g auto" runs the full "expected to pass" regression test
>> > suite for all configured test configurations. (i.e. all config
>> > sections listed in the configs/<host>.config file)
>>
>> ie, it would be safer to expect that an algorithmic auto-selection proce=
ss for
>> fixes for stable kernels should have direct input and involvement from
>> subsystems for run-time testing and simply guessing or assuming won't su=
ffice.
>>
>> The days of just compile testing should be way over by now, and we shoul=
d
>> expect no less for stable kernels, *specially* if we start involving
>> automation.
>>
>> Would a way to *start* to address this long term for XFS or other filesy=
stems
>> for auto-selection long-term be a topic worth covering / addressing at L=
SF/MM?

If this is something the FS/MM folks would like to discuss I'd be happy
to attend. I do plan on pushing this to other subsystems (and given that
I'd support xfstests, fs/ is a good candidate) once the infrastructure +
XFS specific stuff is done (hopefully later today).

>It would be cool to tie tests to commit numbers for things where we're mak=
ing
>sure a oops/hang doesn't happen again, but honestly I'm not sure it's wort=
h the
>effort.  Maybe this is my upstream bias showing, but I only ever run xfste=
sts
>against something relatively close to linus, so I'm not super worried abou=
t
>./check -g auto eating my box.  I expect that if I run auto that everythin=
g
>minus the few flakey tests are going to pass.
>
>Also TIL about configs/<host>.config, that's pretty fucking cool.  Thanks,

On the other hand, from all the customers I've seen, none run anything
"close" (<3 months delta?) from Linus. The "good" ones run 4.15.y, the
worst are probably 4.1.y for upstream and the 2.6.32 RHEL ones.

So while making upstream bug-free is important, no one is actually using
that code :)

By the time those customers end up using a 4.16 kernel, for example,
they'll get all the fixes you're pushing in now, but they'll also be
stuck with the new bugs that slipped in.

Either way, I've integrated xfstests to run the way Derrick and Dave
recommended for every stable tree that I'm considering a backport of a
patch to, I'll send another mail later today once I wrap it up.

--
Thanks,
Sasha=
