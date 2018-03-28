Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-dm3nam03on0130.outbound.protection.outlook.com ([104.47.41.130]:63206
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752654AbeC1TdJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 15:33:09 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Date: Wed, 28 Mar 2018 19:33:06 +0000
Message-ID: <20180328193304.GC7561@sasha-vm>
References: <20180323013037.GA9190@wotan.suse.de>
 <20180323034145.GH4818@magnolia> <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia> <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180327070637.GX5652@dhcp22.suse.cz> <20180327195435.GE9190@wotan.suse.de>
 <20180328132148.GN9275@dhcp22.suse.cz>
In-Reply-To: <20180328132148.GN9275@dhcp22.suse.cz>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9B5140F3BB2D1E4CB24230C00239FFE4@namprd21.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Sasha Levin <levinsasha928@gmail.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Joerg Roedel <joro@8bytes.org>

On Wed, Mar 28, 2018 at 03:21:48PM +0200, Michal Hocko wrote:
>On Tue 27-03-18 19:54:35, Luis R. Rodriguez wrote:
>> On Tue, Mar 27, 2018 at 09:06:37AM +0200, Michal Hocko wrote:
>> > So by no means the MM backports were reviewed by me. And considering h=
ow hard
>> > it is to get any review for MM patches in general I strongly suspect t=
hat
>> > others didn't review either.
>> >
>> > In general I am quite skeptical about the automagic backports
>> > selections, to be honest. MM patches should be reasonably good at
>> > selecting stable backports and adding more patches on top just risks
>> > regressions.
>>
>> BTW other than suggesting we needing *actual review* of the MM patches, =
are
>> there known unit tests which could be run as well? Thinking long term.
>
>There are some in selftests but most fixes are quite hard to get a
>specialized testcase for. Rememeber the MM is a pile of heuristics to
>handle large scale of workloads.

Would running mmtests for each patch help here at all?

--
Thanks,
Sasha=
