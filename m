Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43653 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753157AbdDEB1Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 21:27:25 -0400
From: NeilBrown <neil@brown.name>
Date: Wed, 05 Apr 2017 11:26:40 +1000
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
In-Reply-To: <20170404123414.GA23007@dastard>
References: <1490117004.2542.1.camel@redhat.com> <20170321183006.GD17872@fieldses.org> <1490122013.2593.1.camel@redhat.com> <20170329111507.GA18467@quack2.suse.cz> <1490810071.2678.6.camel@redhat.com> <20170330064724.GA21542@quack2.suse.cz> <1490872308.2694.1.camel@redhat.com> <20170330161231.GA9824@fieldses.org> <20170401230526.GW23007@dastard> <20170403140055.GF15168@quack2.suse.cz> <20170404123414.GA23007@dastard>
Message-ID: <87bmsbiqzz.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04 2017, Dave Chinner wrote:

> On Mon, Apr 03, 2017 at 04:00:55PM +0200, Jan Kara wrote:
>> On Sun 02-04-17 09:05:26, Dave Chinner wrote:
>> > On Thu, Mar 30, 2017 at 12:12:31PM -0400, J. Bruce Fields wrote:
>> > > On Thu, Mar 30, 2017 at 07:11:48AM -0400, Jeff Layton wrote:
>> > > > On Thu, 2017-03-30 at 08:47 +0200, Jan Kara wrote:
>> > > > > Because if above is acceptable we could make reported i_version =
to be a sum
>> > > > > of "superblock crash counter" and "inode i_version". We increment
>> > > > > "superblock crash counter" whenever we detect unclean filesystem=
 shutdown.
>> > > > > That way after a crash we are guaranteed each inode will report =
new
>> > > > > i_version (the sum would probably have to look like "superblock =
crash
>> > > > > counter" * 65536 + "inode i_version" so that we avoid reusing po=
ssible
>> > > > > i_version numbers we gave away but did not write to disk but sti=
ll...).
>> > > > > Thoughts?
>> > >=20
>> > > How hard is this for filesystems to support?  Do they need an on-disk
>> > > format change to keep track of the crash counter?
>> >=20
>> > Yes. We'll need version counter in the superblock, and we'll need to
>> > know what the increment semantics are.=20
>> >=20
>> > The big question is how do we know there was a crash? The only thing
>> > a journalling filesystem knows at mount time is whether it is clean
>> > or requires recovery. Filesystems can require recovery for many
>> > reasons that don't involve a crash (e.g. root fs is never unmounted
>> > cleanly, so always requires recovery). Further, some filesystems may
>> > not even know there was a crash at mount time because their
>> > architecture always leaves a consistent filesystem on disk (e.g. COW
>> > filesystems)....
>>=20
>> What filesystems can or cannot easily do obviously differs. Ext4 has a
>> recovery flag set in superblock on RW mount/remount and cleared on
>> umount/RO remount.
>
> Even this doesn't help. A recent bug that was reported to the XFS
> list - turns out that systemd can't remount-ro the root
> filesystem sucessfully on shutdown because there are open write fds
> on the root filesystem when it attempts the remount. So it just
> reboots without a remount-ro. This uncovered a bug in grub in

Filesystems could use register_reboot_notifier() to get a notification
that even systemd cannot stuff-up.  It could check for dirty data and, if
there is none (which there shouldn't be if a sync happened), it does a
single write to disk to update the superblock (or a single write to each
disk... or something).
md does this, because getting the root device to be marked read-only is
even harder than getting the root filesystem to be remounted read-only.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljkR9AACgkQOeye3VZi
gbluYQ/+KPeRyvmTx/86TOTxdcoyUrCPKFv0pPTg1MBydiXed5+eGTqg6zCScXOH
SxOJ8DmwH8l+RRRwhfnTXjsbIYYomlT2s4iFXqqsdzbGeKpNIqjPJ/xI0VuKUD9/
8SU9OOWviq08QPAm725DARNyyfor9+OcO+0JtG7SDLS4apLy8UJwJYdWZXa6lFTo
foOOIUVR2SQvuwWRhabuTr4JnfiBydg/x6+WPL/LEezPCG/jKRfg0OqB7+tXcIuT
QloDM+hCQNV2KPm64LNW8dmLtnhKHuT36hQ71iup7uHVuGa8nbobU6gW5L0NVQcQ
W6KqcAdBk4eWQS8+aI0r1jRrjvwA7vY8UyshE2eQ7lakS/u/xIpBr8jbr2+tXw6n
6NaYqmEwXE1e9jgZwdI7HRJf562Tph3hiMYIJg5BZiAtJSWhL3VFGUh5FVBCnR7G
J7Y9g39M8GYyGANuKz3U87VQvbpV7dzDN4+fG5wMN2OrWXDnx4+vM090n3oSGGq3
GNfgv9m4dt+WLCII786yEPezkaP2Xy8dZ/DPSoFDEdVAVP/MiQTu7JJMxaiZt8R2
CHK5MgUft0FFIfY6mT66bVq8XIAykZU6JiFd9ocoOTLTCY543yUkbEk0zbQ7WYfL
NmQRvSjaaEFlZ9jaU0ztjfrAB5u+kuJ2kemssAGa/rRFit0h1Yg=
=460V
-----END PGP SIGNATURE-----
--=-=-=--
