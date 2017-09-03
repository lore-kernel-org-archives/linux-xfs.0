Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41847 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752952AbdICWDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 18:03:35 -0400
From: Richard Wareing <rwareing@fb.com>
Subject: Re: [PATCH v2 0/3] XFS real-time device tweaks
Date: Sun, 3 Sep 2017 22:02:41 +0000
Message-ID: <30E1D468-6E15-469E-8026-8EE542201422@fb.com>
References: <20170902224145.1291030-1-rwareing@fb.com>
 <20170903085602.GF32385@infradead.org>
In-Reply-To: <20170903085602.GF32385@infradead.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7DBAEBF697D9CA44802DA32405044710@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>


> On Sep 3, 2017, at 1:56 AM, Christoph Hellwig <hch@infradead.org> wrote:
>=20
> On Sat, Sep 02, 2017 at 03:41:42PM -0700, Richard Wareing wrote:
>> - Replaced rtdefault with rtdisable, this yields similar operational
>> benefits when combined with the existing mkfs time setting of the inheri=
tance
>> flag on the root directory.  Allows temporary disabling of real-time all=
ocation
>> without having to walk entire FS to remove flags (which could be time co=
nsuming).
>> I still don't think it's super obvious to an admin the real-time flag wa=
s put
>> there at mkfs time (vs. rtdefault being in mount flags), but this gets m=
e
>> half of what I'm after.
>=20
> I still don't understand this option.  What is the use case of
> dynamically switching on/off these default to the rt device?
>=20

Say you are in a bit of an emergency, and you need IOPs *now* (incident rec=
overy), w/ rtdisable you could funnel the IO to the SSD without having to s=
trip the inheritance bits from all the directories (which would require two=
 walks....one to remove and one to add them all back).    I think this is a=
bout having some options during incidents, and a "kill-switch" should the n=
eed arise.

>> - rtfallocmin no changes, need to think more about this.  Still a pretty=
 big
>> fan of this option for reasons already stated; at least until a more ele=
gant
>> solution such as preferred AGs (we'd need a tunable size for the "prefer=
red"
>> AG, since our SSD partitions are a fraction of the size of a normal AG) =
can=20
>> be implemented.  The only other idea I have is to make a new ioctl e.g.=
=20
>> "norealtime", which causes the RT bits to stay cleared regardless of=20
>> inheritance bits on the containing directory.  This would allowing the=20
>> "steering" of files to the data device (e.g. SSD); this is probably a sa=
fer=20
>> design than defaulting to SSD and steering to the HDD via the realtime i=
octl. =20
>=20
> Jens just added a nice new fcntl to declare the life time of write
> streams (and in theory can add other I/O hints).
>=20
> How about a a mount option that moves all I/O with a given hint
> to the RT device?  E.g. rt=3Dlonglife would direct I/O on a file
> with an rw hint of RWH_WRITE_LIFE_LONG or RWH_WRITE_LIFE_EXTREME to the
> RT subvolume as long as there aren't any previous extents.

You seem to trust application developers more than I :).  The problem I see=
 with the lifetime, or allocation size as a hint is that a user could later=
 append to the file and fill up the SSD.  A "norealtime" or fallocation req=
uest is a bit more explicit and high signal about the intent vs. the lifeti=
me or allocation size alone.  It's possible, I happen to trickle writes int=
o a file which may ultimately become very very large (e.g. logging), or per=
haps introduce a performance or buffering bug which triggers smaller writes=
 (allocations) and altered write lifetimes.  With fallocmin, this won't hap=
pen as the assumption/relationship here is clear, you are clearly declaring=
 your intent to write a file of N bytes, and based on that we promote or de=
mote you to the appropriate tier of storage.

The other problem I see is accessibility and usability.  By making these de=
cisions buried in more generic XFS allocation mechanisms or fnctl's, few de=
velopers are going to really understand how to safely use them (e.g. withou=
t blowing up their SSD's WAF or endurance).  Fallocation is a better unders=
tood notion, easier to use and has wider support amongst existing utilities=
.  Keep in mind, we need our SSDs to last >3 years (w/ only a mere 70-80 TB=
W; 300TBW if we are lucky), so we want to design things such that applicati=
on developers are less likely to step on land mines causing pre-mature SSD =
failure.

Whatever the ultimate solution here, it should be designed such that it's r=
elatively difficult to accidentally write data to the non-RT device (e.g. S=
SD in our case); intent must be clear and high signal.  Thus my similar "hi=
gh-signal" bias in my first patchset w/ rtdefault; sure inheritance bits sh=
ould be there if somebody mkfs'd, but if somehow they were removed, it coul=
d wind up costing 10's of millions of dollars in reduced SSD write lifetime=
 at our scale.  An explicit mount option makes me sleep better at night, th=
ings like chef/cfengine can enforce this through traditional policy mechani=
sms, and removing the behavior has a higher bar (remount + change chef/cfen=
gine) than a trivial call to xfs_io.  From a production engineering/reliabi=
lity stand-point the design decision is pretty clear; inheritance bits are =
nearly unenforcible with policy engines such as cfengine or chef (somebody/=
something could remove a bit buried in the FS and you'd find it only by wal=
king the entire FS), and as result they are bombs waiting to go off compare=
d to the rtdefault flag.

I'd ideally like to take things even further with fallocmin, and revert to =
the RT device should the non-RT device fill up (subtracting some % of space=
 for metadata); this brings the behavior more along the lines of a "preferr=
ed" device vs. a must-have.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

