Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-cys01nam02on0126.outbound.protection.outlook.com ([104.47.37.126]:56288
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752594AbeC1BL6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Mar 2018 21:11:58 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Date: Wed, 28 Mar 2018 01:11:55 +0000
Message-ID: <20180328011152.GA7561@sasha-vm>
References: <20171123060137.GL2135@magnolia>
 <20180323013037.GA9190@wotan.suse.de> <20180323034145.GH4818@magnolia>
 <20180323170813.GD30543@wotan.suse.de> <20180323172620.GK4818@magnolia>
 <20180323182302.GB9190@wotan.suse.de> <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180327070637.GX5652@dhcp22.suse.cz>
In-Reply-To: <20180327070637.GX5652@dhcp22.suse.cz>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7B03628C6FB3BF4084DBE7795852B767@namprd21.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Chinner <david@fromorbit.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Joerg Roedel <joro@8bytes.org>

On Tue, Mar 27, 2018 at 09:06:37AM +0200, Michal Hocko wrote:
>On Mon 26-03-18 19:54:31, Sasha Levin wrote:
>[...]
>> About half a year ago. I'm not sure about the no visibility part -
>> maintainers and authors would receive at least 3 mails for each patch
>> that got in this way, and would have at least a week (usually a lot
>> more) to object to the inclusion. Did you not receive any mails from
>> me?
>
>Well, I was aware of your emails yet my free time didn't really allow me
>to follow those patch bombs. I responded only when some email subject
>hit my eyes as being non-stable candidate. So by no means the MM
>backports were reviewed by me. And considering how hard it is to get any
>review for MM patches in general I strongly suspect that others didn't
>review either.

Being aware is different than saying it was snuck in without anyone
knowing.

>In general I am quite skeptical about the automagic backports
>selections, to be honest. MM patches should be reasonably good at
>selecting stable backports and adding more patches on top just risks
>regressions.

Okay, let's take mm/ as a subsystem that is doing a good job with
submitting stuff to -stable.

There were 40 patches in total going into the 4.14 LTS tree that touched
mm/. Out of those, 5 were selected via the "automagic" process:

> 647a37ec1a17 mm/frame_vector.c: release a semaphore in 'get_vaddr_frames(=
)'
> d91c3f2e540f mm/early_ioremap: Fix boot hang with earlyprintk=3Defi,keep
> b2ba0bd34695 kmemleak: add scheduling point to kmemleak_scan()
> 5ca94e03675a slub: fix sysfs duplicate filename creation when slub_debug=
=3DO
> 342ee8775800 mm, x86/mm: Fix performance regression in get_user_pages_fas=
t()

The only "questionable" one here I see is the performance regression
one, which I decided to keep in because it's a rather severe one in a
common code path.

Even good subsystems might sometimes miss a patch or two.

But yes, I've received less response from maintainers than I expected,
so I'll switch it to an opt-in model for new patches that go upstream.


--
Thanks,
Sasha=
