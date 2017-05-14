Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36235 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757606AbdENBlg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 May 2017 21:41:36 -0400
Received: by mail-io0-f196.google.com with SMTP id f102so8865731ioi.3
        for <linux-xfs@vger.kernel.org>; Sat, 13 May 2017 18:41:36 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <38F56772-7836-4902-929C-80908BFBEA7B@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C16D2EC1-0DAE-4DEB-9C8D-0B16C5B5B762";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ioctl_getfsmap.2: document the GETFSMAP ioctl
Date: Sat, 13 May 2017 19:41:24 -0600
In-Reply-To: <20170511051051.GA7533@zzz>
References: <CAG48ez1AWewJRg8gySgihn0y15jRhC6C+5DNwGsDpAhtokB=Lw@mail.gmail.com>
 <20170508184112.GJ5973@birch.djwong.org>
 <CAG48ez3e+2VuvjtEfJuMujEo6PWBO3z8oM-otN2juq96jKdjCw@mail.gmail.com>
 <20170508204738.GL5973@birch.djwong.org>
 <CAG48ez0iLRazKvXty9CG8ENXvkG6b1xjO0Q75p+16HKNptFnow@mail.gmail.com>
 <20170509015324.GM5973@birch.djwong.org> <20170509211746.GA87747@gmail.com>
 <20170510163818.7bleiykxgnx3pkds@thunk.org> <87mvakpl5m.fsf@xmission.com>
 <20170510201437.GA9854@birch.djwong.org> <20170511051051.GA7533@zzz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Theodore Ts'o <tytso@mit.edu>, Jann Horn <jannh@google.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>


--Apple-Mail=_C16D2EC1-0DAE-4DEB-9C8D-0B16C5B5B762
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 10, 2017, at 11:10 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
>=20
> On Wed, May 10, 2017 at 01:14:37PM -0700, Darrick J. Wong wrote:
>> [cc btrfs, since afaict that's where most of the dedupe tool authors =
hang out]
>>=20
>> On Wed, May 10, 2017 at 02:27:33PM -0500, Eric W. Biederman wrote:
>>> Theodore Ts'o <tytso@mit.edu> writes:
>>>=20
>>>> On Tue, May 09, 2017 at 02:17:46PM -0700, Eric Biggers wrote:
>>>>> 1.) Privacy implications.  Say the filesystem is being shared =
between multiple
>>>>>    users, and one user unpacks foo.tar.gz into their home =
directory, which
>>>>>    they've set to mode 700 to hide from other users.  Because of =
this new
>>>>>    ioctl, all users will be able to see every (inode number, size =
in blocks)
>>>>>    pair that was added to the filesystem, as well as the exact =
layout of the
>>>>>    physical block allocations which might hint at how the files =
were created.
>>>>>    If there is a known "fingerprint" for the unpacked foo.tar.gz =
in this
>>>>>    regard, its presence on the filesystem will be revealed to all =
users.  And
>>>>>    if any filesystems happen to prefer allocating blocks near the =
containing
>>>>>    directory, the directory the files are in would likely be =
revealed too.
>>=20
>> Frankly, why are container users even allowed to make unrestricted =
ioctl
>> calls?  I thought we had a bunch of security infrastructure to =
constrain
>> what userspace can do to a system, so why don't ioctls fall under =
these
>> same protections?  If your containers are really that adversarial, =
you
>> ought to be blacklisting as much as you can.
>>=20
>=20
> Personally I don't find the presence of sandboxing features to be a =
very good
> excuse for introducing random insecure ioctls.  Not everyone has =
everything
> perfectly "sandboxed" all the time, for obvious reasons.  It's easy to =
forget
> about the filesystem ioctls, too, since they can be executed on any =
regular
> file, without having to open some device node in /dev.
>=20
> (And this actually does happen; the SELinux policy in Android, for =
example,
> still allows apps to call any ioctl on their data files, despite all =
the effort
> that has gone into whitelisting other types of ioctls.  Which should =
be fixed,
> of course, but it shows that this kind of mistake is very easy to =
make.)
>=20
>>>> Unix/Linux has historically not been terribly concerned about =
trying
>>>> to protect this kind of privacy between users.  So for example, in
>>>> order to do this, you would have to call GETFSMAP continously to =
track
>>>> this sort of thing.  Someone who wanted to do this could probably =
get
>>>> this information (and much, much more) by continuously running "ps" =
to
>>>> see what processes are running.
>>>>=20
>>>> (I will note. wryly, that in the bad old days, when dozens of users
>>>> were sharing a one MIPS Vax/780, it was considered a *good* thing
>>>> that social pressure could be applied when it was found that =
someone
>>>> was running a CPU or memory hogger on a time sharing system.  The
>>>> privacy right of someone running "xtrek" to be able to hide this =
from
>>>> other users on the system was never considered important at all.  =
:-)
>>=20
>> Not to mention someone running GETFSMAP in a loop will be pretty =
obvious
>> both from the high kernel cpu usage and the huge number of metadata
>> operations.
>=20
> Well, only if that someone running GETFSMAP actually wants to watch =
things in
> real-time (it's not necessary for all scenarios that have been =
mentioned), *and*
> there is monitoring in place which actually detects it and can do =
something
> about it.
>=20
> Yes, PIDs have traditionally been global, but today we have PID =
namespaces, and
> many other isolation features such as mount namespaces.  Nothing is =
perfect, of
> course, and containers are a lot worse than VMs, but it seems weird to =
use that
> as an excuse to knowingly make things worse...
>=20
>>=20
>>>> Fortunately, the days of timesharing seem to well behind us.  For
>>>> those people who think that containers are as secure as VM's (hah,
>>>> hah, hah), it might be that best way to handle this is to have a =
mount
>>>> option that requires root access to this functionality.  For those
>>>> people who really care about this, they can disable access.
>>=20
>> Or use separate filesystems for each container so that exploitable =
bugs
>> that shut down the filesystem can't be used to kill the other
>> containers.  You could use a torrent of metadata-heavy operations
>> (fallocate a huge file, punch every block, truncate file, repeat) to =
DoS
>> the other containers.
>>=20
>>> What would be the reason for not putting this behind
>>> capable(CAP_SYS_ADMIN)?
>>>=20
>>> What possible legitimate function could this functionality serve to
>>> users who don't own your filesystem?
>>=20
>> As I've said before, it's to enable dedupe tools to decide, given a =
set
>> of files with shareable blocks, roughly how many other times each of
>> those shareable blocks are shared so that they can make better =
decisions
>> about which file keeps its shareable blocks, and which file gets
>> remapped.  Dedupe is not a privileged operation, nor are any of the
>> tools.
>>=20
>=20
> So why does the ioctl need to return all extent mappings for the =
entire
> filesystem, instead of just the share count of each block in the file =
that the
> ioctl is called on?

One possibility is that the ioctl() can return the mapping for all =
inodes
owned by the calling PID (or others if CAP_SYS_ADMIN, CAP_DAC_OVERRIDE,
or CAP_FOWNER is set), and return an "filesystem aggregate inode" (or =
more
than one if there is a reason to do so) with all the other allocated =
blocks
for inodes the user doesn't have permission to access?

IMHO, this would allow a non-root user the main benefit of GETFSMAP,  =
which
is trying to determine how fragmented their files are and/or how =
fragmented
the free space is, without leaking any information about file sizes, =
location,
or other information the user can't already get today in a less =
efficient
manner.

I don't know how hard this is to implement, but seems not impossible.

Cheers, Andreas






--Apple-Mail=_C16D2EC1-0DAE-4DEB-9C8D-0B16C5B5B762
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZF7XEpIg59Q01vtYRAiNSAJ9ZT3jqJ8hRUm9aDdLQ+XWEYkAbWQCg56Dp
1u64LMA/lrDzEXBM9Nj+rD0=
=uZ10
-----END PGP SIGNATURE-----

--Apple-Mail=_C16D2EC1-0DAE-4DEB-9C8D-0B16C5B5B762--
