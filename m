Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38796 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750786AbdIFGzc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2017 02:55:32 -0400
From: Richard Wareing <rwareing@fb.com>
Subject: Re: [PATCH v2 0/3] XFS real-time device tweaks
Date: Wed, 6 Sep 2017 06:54:41 +0000
Message-ID: <9729DF06-8F96-4F93-BF50-133F9BA2770F@fb.com>
References: <20170902224145.1291030-1-rwareing@fb.com>
 <20170903085602.GF32385@infradead.org>
 <30E1D468-6E15-469E-8026-8EE542201422@fb.com>
 <20170906034443.GQ17782@dastard>
In-Reply-To: <20170906034443.GQ17782@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <6D596FDA0C937B45BDCA2D572D7B789E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>


On 9/5/17, 8:45 PM, "Dave Chinner" <david@fromorbit.com> wrote:

    On Sun, Sep 03, 2017 at 10:02:41PM +0000, Richard Wareing wrote:
    >=20
    > > On Sep 3, 2017, at 1:56 AM, Christoph Hellwig
    > > <hch@infradead.org> wrote:
    > >=20
    > > On Sat, Sep 02, 2017 at 03:41:42PM -0700, Richard Wareing
    > > wrote:
    > >> - Replaced rtdefault with rtdisable, this yields similar
    > >> operational benefits when combined with the existing mkfs time
    > >> setting of the inheritance flag on the root directory.  Allows
    > >> temporary disabling of real-time allocation without having to
    > >> walk entire FS to remove flags (which could be time consuming).
    > >> I still don't think it's super obvious to an admin the
    > >> real-time flag was put there at mkfs time (vs. rtdefault being
    > >> in mount flags), but this gets me half of what I'm after.
    > >=20
    > > I still don't understand this option.  What is the use case of
    > > dynamically switching on/off these default to the rt device?
    > >=20
    >=20
    > Say you are in a bit of an emergency, and you need IOPs *now*
    > (incident recovery), w/ rtdisable you could funnel the IO to the
    > SSD
   =20
    But it /doesn't do that/. It only disables new files from writing to
    the rt device. All reads for data in the RT device and writes to
    existing files still go to the RT device.
   =20
   =20
    > without having to strip the inheritance bits from all the
    > directories (which would require two walks....one to remove and
    > one to add them all back).    I think this is about having some
    > options during incidents, and a "kill-switch" should the need
    > arise.
   =20
    And soon after the kill switch is triggered, your tiny data device
    will go ENOSPC because changing that mount option effective removed
    TBs of free space from the filesystem. Then things will really start
    going bad.
   =20
    So maybe you didn't think this through properly - the last thing a
    typical user would expect is a filesystem reporting TBs of free
    space to go ENOSPC and not being able to recover, regardless of what
    mount options are present. iAnd they'll be especially confused when
    they start looking at inodes and seeing RT bits set all over the
    place...
   =20
    It's just a recipe for confusion, unexpected behaviour and all I
    see here is a support and triage nightmare. Not to mention FB will
    move on to something else in a couple of years, and we get stuck
    having to maintain it forever more (*cough* filestreams *cough*).
   =20
Fair enough, what are your thoughts on rtdefault, if I changed it to *not* =
set the inheritance bits, but take over this responsibility in their place?=
  My thinking here is this integrates better than inheritance bits w/ polic=
y management systems such as Chef/Puppet.  Inheritance bits, on the other h=
and don=B9t really lend themselves to machine level policies; they can be s=
prinkled about all over the FS, and a walk would be required to enforce a m=
achine wide policy.

Or instead of a mount option, would a sysfs option be acceptable?

My hope is we don=B9t move on, but collaborate a bit more with the open-sou=
rce world on these sorts of problems instead of re-inventing the proverbial=
 FS wheel (and re-learning old lessons solved many moons ago by FS develope=
rs).  Trying to do my part now, show it can be done and should be done.

    > The other problem I see is accessibility and usability.  By making
    > these decisions buried in more generic XFS allocation mechanisms
    > or fnctl's, few developers are going to really understand how to
    > safely use them (e.g. without blowing up their SSD's WAF or
    > endurance).=20
   =20
    The whole point of putting them into the XFS allocator as admin
    policies is that *applications developers don't need to know they
    exist*.
   =20
I get you now: *admins* need to know, but application developers not so muc=
h.

    > Fallocation is a better understood notion, easier to
    > use and has wider support amongst existing utilities.
   =20
    Almost every application I've seen that uses fallocate does
    something wrong and/or breaks a longevity or performance
    optimisation that filesystems have been making for years.=20
   =20
    fallocate is "easy to understand" but *difficult to use optimally*
    because it's behaviour is tightly bound to the filesystem allocator
    algorithms. i.e. it's easy to defeat hidden filesystem optimisations
    with fallocate, but it's difficult to understand a sub-optimal
    corner case in the filesystem allocator that fallocate could be used
    to avoid.
   =20
    In reality, we don't want people using fallocate - the filesystem
    algorithms should do the right thing so people don't need to modify
    their applications. In cases like this, having the filesystem decide
    automatically at first allocation what device to use is the right
    way to integrate the functionality, not require users to use
    fallocate to trigger such a decision and, as a side effect, prevent
    the filesystem from making all the other optimisations they still
    want it to make.

You make a good point here, on preventing the FS from making other optimiza=
tions.  I=B9m re-working this as you and others have suggested (new version=
 tomorrow).

And xfs_fsr would be the home for code migrating the file to the real-time =
device once it grows beyond some tunable size. =20

    > Keep in
    > mind, we need our SSDs to last >3 years (w/ only a mere 70-80 TBW;
    > 300TBW if we are lucky), so we want to design things such that
    > application developers are less likely to step on land mines
    > causing pre-mature SSD failure.
   =20
    Hmmm. I don't think they way you are using fallocate is doing what
    you think it is doing.
   =20
    That is, using fallocate to preallocate all files so you can direct
    allocation to a different device means that delayed allocation is
    turned off. Hence XFS cannot optimise allocation across multiple
    files at writeback time. This means that writeback across multiple
    files will be sprayed around disjointed preallocated regions. When
    using delayed allocation, the filesystem will allocate the blocks
    for all the files sequentially and so the block layer merge will
    them all into one big contiguous IO.
   =20
    IOWs, fallocate sprays write IO around because they decouple
    allocation locality from temporal writeback locality and this causes
    non-contiguous write patterns which are a significant contributin
    factor to write amplification in SSDs.  In comparison, delayed
    allocation results in large sequential IOs that minimise write
    amplification in the SSD...
   =20
    Hence the method you describe that "maximises SSD life" won't help
    - if anything it's going to actively harm the SSD life when
    compared to just letting the filesystem use delayed allocation and
    choose what device to write to at that time....

Wrt to SSDs you are completely correct on this, our fallocate calls were in=
tended to pay up front on the write path for more favorable allocations whi=
ch pay off during reads on HDDs.  For SSDs this clearly makes less sense, a=
nd an optimization we will need to make in our code for the reasons you poi=
nt out.

    Hacking one-off high level controls into APIs like fallocate does
    not work. Allocation policies need to be integrated into the
    filesystem allocators for them to be effective and useful to
    administrators and applications alike. fallocate is no sustitute for
    the black magic that filesystems do to optimise allocation and IO
    patterns....
   =20
    Cheers,
   =20
    Dave.
    --=20
    Dave Chinner
    david@fromorbit.com
   =20

Thanks for the great comments, suggestions & insights.  Learning a lot.

Richard


