Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-bn3nam01on0090.outbound.protection.outlook.com ([104.47.33.90]:21483
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752936AbeC1TaK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 15:30:10 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Date: Wed, 28 Mar 2018 19:30:06 +0000
Message-ID: <20180328193004.GB7561@sasha-vm>
References: <20171123060137.GL2135@magnolia>
 <20180323013037.GA9190@wotan.suse.de> <20180323034145.GH4818@magnolia>
 <20180323170813.GD30543@wotan.suse.de> <20180323172620.GK4818@magnolia>
 <20180323182302.GB9190@wotan.suse.de> <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180328033228.GA18129@dastard>
In-Reply-To: <20180328033228.GA18129@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12005E4348B1064B9395E20EC95B03D6@namprd21.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>

On Wed, Mar 28, 2018 at 02:32:28PM +1100, Dave Chinner wrote:
>How much time are your test rigs going to be able to spend running
>xfstests? A single pass on a single filesysetm config on spinning
>disks will take 3-4 hours of run time. And we have at least 4 common
>configs that need validation (v4, v4 w/ 512b block size, v5
>(defaults), and v5 w/ reflink+rmap) and so you're looking at a
>minimum 12-24 hours of machine test time per kernel you'd need to
>test.

No reason they can't run in parallel, right?

>> > From: Sasha Levin <alexander.levin@microsoft.com>
>> > To: Sasha Levin <alexander.levin@microsoft.com>
>> > To: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle=
.com>
>> > Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org
>> > Subject: Re: [PATCH] xfs: Correctly invert xfs_buftarg LRU isolation l=
ogic
>> > In-Reply-To: <20180306102638.25322-1-vbendel@redhat.com>
>> > References: <20180306102638.25322-1-vbendel@redhat.com>
>> >
>> > Hi Vratislav Bendel,
>> >
>> > [This is an automated email]
>> >
>> > This commit has been processed by the -stable helper bot and determine=
d
>> > to be a high probability candidate for -stable trees. (score: 6.4845)
>> >
>> > The bot has tested the following trees: v4.15.12, v4.14.29, v4.9.89, v=
4.4.123, v4.1.50, v3.18.101.
>> >
>> > v4.15.12: OK!
>> > v4.14.29: OK!
>> > v4.9.89: OK!
>> > v4.4.123: OK!
>> > v4.1.50: OK!
>> > v3.18.101: OK!
>> >
>> > Please reply with "ack" to have this patch included in the appropriate=
 stable trees.
>
>That might help, but the testing and validation is completely
>opaque. If I wanted to know what that "OK!" actually meant, where
>do I go to find that out?

This is actually something I want maintainers to dictate. What sort of
testing would make the XFS folks happy here? Right now I'm doing
"./check 'xfs/*'" with xfstests. Is it sufficient? Anything else you'd like=
 to see?

--
Thanks,
Sasha=
