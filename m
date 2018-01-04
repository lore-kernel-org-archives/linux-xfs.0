Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56758 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751014AbeADAGB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 19:06:01 -0500
From: Richard Wareing <rwareing@fb.com>
Subject: Re: [ZOMG RFCRAP PATCH 0/2] xfs: horrifying eBPF hacks
Date: Thu, 4 Jan 2018 00:05:21 +0000
Message-ID: <F1508AF4-D241-47AA-B690-6AF6073D0E25@fb.com>
References: <20171213061825.GO19219@magnolia>
 <20171221133338.GD1567@infradead.org> <20171221164535.GS12613@magnolia>
In-Reply-To: <20171221164535.GS12613@magnolia>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FE7336C570F8EF479B5F07FE23936420@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>

Hey Darrick,

I'll try to get to testing this out early next week, I was out on vacation=
=20
the last couple weeks so I kinda fell off the earth for a bit.

I will test for functionality & performance as best I can, but we'll probab=
ly
want to explore everyone's concerns on leveraging eBPF in this way as
well.  I have pretty limited experience with BPF, so I'm probably not going
to be super useful in such a discussion, though I'll certainly try to get r=
ead
up on it.

Is there any precedence for doing this sort of thing with BPF anywhere
else in the kernel?

Richard


> On Dec 21, 2017, at 8:45 AM, Darrick J. Wong <darrick.wong@oracle.com> wr=
ote:
>=20
> On Thu, Dec 21, 2017 at 05:33:38AM -0800, Christoph Hellwig wrote:
>> Eek.  Whie eBPF is a really nice debug tool we should never use
>> it for actual required kernel I/O functionality.
>=20
> Certainly not in its current hacky form.  I'm curious if Richard has had
> a chance to try out these patches to see if it affects performance in a
> noticeable way?
>=20
> I /think/ bpf has enough safety mechanisms (no loops, no direct writing
> to kernel memory, bytecode verifiers, opcode count limits) that such a
> beast could be hidden behind a kconfig option that isn't turned for the
> general public.  For people who have these particularly specific use
> cases I think it better to have a general mechanism to accomodate them
> vs. scattering code all over xfs vs. "no sorry go away", though this
> ebpf thing isn't necessarily the final answer.  We do validate that the
> proposed iflags are allowed for the fs geometry, though I acknowledge
> that the prospect of running ebpf with ilock_excl does give me pause.
>=20
> I'm curious, though, what are your (and everyone else's) concerns about
> this?
>=20
> --D
>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

