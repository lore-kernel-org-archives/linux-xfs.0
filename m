Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756416AbdDFBMs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 21:12:48 -0400
From: NeilBrown <neil@brown.name>
Date: Thu, 06 Apr 2017 11:12:02 +1000
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
In-Reply-To: <20170405080551.GC8899@quack2.suse.cz>
References: <20170321183006.GD17872@fieldses.org> <1490122013.2593.1.camel@redhat.com> <20170329111507.GA18467@quack2.suse.cz> <1490810071.2678.6.camel@redhat.com> <20170330064724.GA21542@quack2.suse.cz> <1490872308.2694.1.camel@redhat.com> <20170330161231.GA9824@fieldses.org> <1490898932.2667.1.camel@redhat.com> <20170404183138.GC14303@fieldses.org> <878tnfiq7v.fsf@notabene.neil.brown.name> <20170405080551.GC8899@quack2.suse.cz>
Message-ID: <87k26ygx0d.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05 2017, Jan Kara wrote:

> On Wed 05-04-17 11:43:32, NeilBrown wrote:
>> On Tue, Apr 04 2017, J. Bruce Fields wrote:
>>=20
>> > On Thu, Mar 30, 2017 at 02:35:32PM -0400, Jeff Layton wrote:
>> >> On Thu, 2017-03-30 at 12:12 -0400, J. Bruce Fields wrote:
>> >> > On Thu, Mar 30, 2017 at 07:11:48AM -0400, Jeff Layton wrote:
>> >> > > On Thu, 2017-03-30 at 08:47 +0200, Jan Kara wrote:
>> >> > > > Because if above is acceptable we could make reported i_version=
 to be a sum
>> >> > > > of "superblock crash counter" and "inode i_version". We increme=
nt
>> >> > > > "superblock crash counter" whenever we detect unclean filesyste=
m shutdown.
>> >> > > > That way after a crash we are guaranteed each inode will report=
 new
>> >> > > > i_version (the sum would probably have to look like "superblock=
 crash
>> >> > > > counter" * 65536 + "inode i_version" so that we avoid reusing p=
ossible
>> >> > > > i_version numbers we gave away but did not write to disk but st=
ill...).
>> >> > > > Thoughts?
>> >> >=20
>> >> > How hard is this for filesystems to support?  Do they need an on-di=
sk
>> >> > format change to keep track of the crash counter?  Maybe not, maybe=
 the
>> >> > high bits of the i_version counters are all they need.
>> >> >=20
>> >>=20
>> >> Yeah, I imagine we'd need a on-disk change for this unless there's
>> >> something already present that we could use in place of a crash count=
er.
>> >
>> > We could consider using the current time instead.  So, put the current
>> > time (or time of last boot, or this inode's ctime, or something) in the
>> > high bits of the change attribute, and keep the low bits as a counter.
>>=20
>> This is a very different proposal.
>> I don't think Jan was suggesting that the i_version be split into two
>> bit fields, one the change-counter and one the crash-counter.
>> Rather, the crash-counter was multiplied by a large-number and added to
>> the change-counter with the expectation that while not ever
>> change-counter landed on disk, at least 1 in every large-number would.
>> So after each crash we effectively add large-number to the
>> change-counter, and can be sure that number hasn't been used already.
>
> Yes, that was my thinking.
>
>> To store the crash-counter in each inode (which does appeal) you would
>> need to be able to remove it before adding the new crash counter, and
>> that requires bit-fields.  Maybe there are enough bits.
>
> Furthermore you'd have a potential problem that you need to change
> i_version on disk just because you are reading after a crash and such
> changes tend to be problematic (think of read-only mounts and stuff like
> that).
>=20=20
>> If you want to ensure read-only files can remain cached over a crash,
>> then you would have to mark a file in some way on stable storage
>> *before* allowing any change.
>> e.g. you could use the lsb.  Odd i_versions might have been changed
>> recently and crash-count*large-number needs to be added.
>> Even i_versions have not been changed recently and nothing need be
>> added.
>>=20
>> If you want to change a file with an even i_version, you subtract
>>   crash-count*large-number
>> to the i_version, then set lsb.  This is written to stable storage before
>> the change.
>>=20
>> If a file has not been changed for a while, you can add
>>   crash-count*large-number
>> and clear lsb.
>>=20
>> The lsb of the i_version would be for internal use only.  It would not
>> be visible outside the filesystem.
>>=20
>> It feels a bit clunky, but I think it would work and is the best
>> combination of Jan's idea and your requirement.
>> The biggest cost would be switching to 'odd' before an changes, and the
>> unknown is when does it make sense to switch to 'even'.
>
> Well, there is also a problem that you would need to somehow remember with
> which 'crash count' the i_version has been previously reported as that is
> not stored on disk with my scheme. So I don't think we can easily use your
> scheme.

I don't think there is a problem here.... maybe I didn't explain
properly or something.

I'm assuming there is a crash-count that is stored once per filesystem.
This might be a disk-format change, or maybe the "Last checked" time
could be used with ext4 (that is a bit horrible though).

Every on-disk i_version has a flag to choose between:
  - use this number as it is, but update it on-disk before any change
  - add multiple of current crash-count to this number before use.
      If you crash during an update, the i_version is thus automatically
      increased.

To change from the first option to the second option you subtract the
multiple of the current crash-count (which might make the stored
i_version negative), and flip the bit.
To change from the second option to the first, you add the multiple
of the current crash-count, and flip the bit.
In each case, the externally visible i_version does not change.
Nothing needs to be stored except the per-inode i_version and the per-fs
crash_count.=20

>
> So the options we have are:
>
> 1) Keep i_version as is, make clients also check for i_ctime.
>    Pro: No on-disk format changes.
>    Cons: After a crash, i_version can go backwards (but when file changes
>    i_version, i_ctime pair should be still different) or not, data can be
>    old or not.

I like to think of this approach as using the i_version as an extension
to the i_ctime.
i_ctime doesn't necessarily change on every file modification, either
because it is not a modification that is meant to change i_ctime, or
because i_ctime doesn't have the resolution to show a very small change
in time, or because the clock that is used to update i_ctime doesn't
have much resolution.
So when a change happens, if the stored c_time changes, set i_version to
zero, otherwise increment i_version.
Then the externally visible i-version is a combination of the stored
c_time and the stored i_version.
If you only used 1-second ctime resolution for versioning purposes, you
could provide a 64bit i_version as 34 bits of ctime and 30 bits of
changes-in-one-second.
It is important that the resolution of ctime used is less that the
fastest possible restart after a crash.

I don't think that i_version going backwards should be a problem, as
long as an old version means exactly the same old data.  Presumably
journalling would ensure that the data and ctime/version are updated
atomically.

>
> 2) Fsync when reporting i_version.
>    Pro: No on-disk format changes, strong consistency of i_version and
>         data.
>    Cons: Difficult to implement for filesystems due to locking constrains.
>          High performance overhead or i_version reporting.

This reminds me of the old ext3 fsync-when-renaming a file.  People
might depend on it for all the wrong reasons, and other people might
studiously avoid it due to the performance implications.

>
> 3) Some variant of crash counter.
>    Pro: i_version cannot go backwards.
>    Cons: Requires on-disk format changes. After a crash data can be old
>          (however i_version increased).

If it is essential for i_version to always go forward, then I think this
is the best approach.
If an i_version reset can be tolerated, then I think a
time-plus-version-count approach is likely to be best.

Thanks,
NeilBrown

>
> 								Honza
> --=20
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljlleIACgkQOeye3VZi
gblP2Q/9He4MLbp89QrFj6UTVGlKpsKko8p1lU3WX9ERqkyS2tjHAuiy953nFc32
fEiiTUDhjD5wjyMhj1sBxcqyvvgPq6QK+ObnTUanGZKdkpBHgSm4D209MEfjMbQN
GFKSBpagrZ3/orLjq8YSUdV5RaJDuu6cFhexNidhI6Jvxnpm12VKmz67Tb2+1iof
yKVCvPzWBJ5b7WvnILiIRWVAjNfRYq8nFdGLYefMJLD25j2opHZRlyGVFkf5GsEb
ZJgyOw5zLRtgGHxdI1/HtdxOLA74ef1HABak0lfyIqVnbwS9eEztZrJ+cm7D/tx7
Kb1g8LcVtj8DFJAYHOkSegDL1Q1oqo/SgSiE1xI29auJYBxHeymOYdjTg8Mf/eS8
P006SbdaAP2ELuJdvm55KmyJO9X4HegpMHgHe+HFaeY7YvFLjePwoZltmwwNZbBt
l9ZVrvosYYd0MPfG5ITmUtemSCpiDR09nyBx/WVstD93vZ60WKySJ4/MMukUdsEY
OoOjLF+O9AVHIKU2xMMojyic9NkGOUqRcYZpYO8YfSIuYa+id9UvF6rwc8dy9jjz
Z/dzc+TEM/rO8oeInrKPi0o5u0DDTjoTX306ZPDU91YHBo/3BAJkwZk0xQGgyYh+
wzgtOud+JSfM4s/xqV51YoevWKzcdubT6IQAKqBGMRQhDxtQyRI=
=SiP6
-----END PGP SIGNATURE-----
--=-=-=--
