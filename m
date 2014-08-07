Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 69AAA7FA2
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 19:09:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5884B8F8052
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 17:09:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DTixTeFzKYSywLyA for <xfs@oss.sgi.com>;
	Wed, 06 Aug 2014 17:09:34 -0700 (PDT)
Date: Thu, 7 Aug 2014 10:09:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [DISCUSS] Moving from oss.sgi.com to kernel.org
Message-ID: <20140807000922.GA26465@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8053165494245948395=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: fstests@vger.kernel.org


--===============8053165494245948395==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

A few recent incidents, discoveries and comments have me concerned
about the viability of using oss.sgi.com to host XFS deveopment and
community support.

We are very grateful for the time, effort and money that SGI has put
into providing oss.sgi.com for us over many, many years, but these
recent issues have brought the state of oss.sgi.com and hence it's
viability as a host for XFS development to my immediate attention.

Ultimately, as the XFS maintainer, I'm responsible for the contents
of the pull requests sent to Linus and the code we distribute to
users, distros and developers. That means I need to be able to trust
that the hosting infrastructure is secure and well maintained.

The short story is that I can't trust oss.sgi.com to be maintained
and secure anymore. The recent DOS issues with oss.sgi.com made it
clear that it is essentially unmaintained and the SGI admins don't
have time to address issues that arise. This little snippet of the
conversion about blocking the rogue spider causing the recent
ftp and gitweb DOS problems is instructive:

[19/07/14 09:07] <sandeen> trev, it's you guys' box :)
[19/07/14 09:07] <sandeen> you get to make it work=20
[19/07/14 09:07] <dchinner__> I am not eh administrator, and if I'm forced =
to do this sort of thing I'll just take the content elsewhere....
[19/07/14 09:08] <trev> dchinner__, please do so. I don't have much time fo=
r oss anymore

It should be no surprise that since this conversation I've been
looking at what is involved in moving everything XFS off oss.sgi.com
to kernel.org.  Right now I have the main XFS repositories up to
date on kernel.org.  For userspace I've simply pushed the current
trees and tags to the pre-existing repositories here:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git
	git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

These trees currently have the same content as the trees on
oss.sgi.com.  I may rename these as a result of discussions here
(e.g. some people don't like the -dev suffix on the trees) so it's
best for people to continue to use the trees on oss.sgi.com until
this disucssion comes to a conclusion.

My new kernel dev tree can be found here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

This is my immediate concern: this tree, regardless of anything
else, the tree I am going to be asking Linus to pull from - it is
now *my* master tree and the tree on oss.sgi.com will simply mirror
that tree.

For the short term, I will set up a cron job to keep the oss trees
up to date with the trees on kernel.org. By "short-term" I mean till
the end of the year at most. This will allow people time to change
their workflows, update their repos, bookmarks, etc in their own
time so hopefully not take anyone by surprise when the trees on
oss.sgi.com stop updating. "short-term" is a rubbery concept - if
anyone things it should be longer or shorter or whether a completely
different approach is warranted, please speak up.

Over the next few days I will move the remaining xfs trees to
kernel.org - the historical kernel archive and documentation trees -
and then I'll maintain them as the primary trees with the same
short term mirroring backup.

In moving these trees, we will need to update some documentation
(e.g. the "where to get" documentation on the xfs.org wiki) and
links, as well as place a "readme" in the gitweb main page on
oss.sgi.com to indicate that the up-to-date XFS trees are now on
kernel.org and documenting the drop-dead date to when the trees on
oss will no longer be kept up to date.

The only remaining issue is what to do about tarball releases for
xfsprogs/xfsdump/fstests. We currently have a bunch of historic
releases in the ftp release area on oss.sgi.com. I will organise a
release directory on kernel.org for future releases (location yet to
be confirmed), but I'm not sure what to do with the older releases.
I'm open to suggestions here, but the limit of what I will try to
move to kernel.org is signed tarballs that I have verified.

For xfstests, I think this would be a good time to rename the
project officially as well (i.e. to "fstests"). I'll need to talk to
the kernel.org admins on where to locate it (pub/scm/fs/fstests is
the best candidate, I think), but in the mean time I'll just mirror
to oss.sgi.com as per the above so nobody needs to change anything
until we sort out the final location/name of the tree. If anyone has
any other ideas on this, please let me know, otherwise I'll just
proceed with this plan.

In conjunction with this source tree move, I'd also like to start the
move the mailing list. We have ongoing spam, performance and user
access issues with oss.sgi.com, so IMO if we are moving source trees
off this host we should also move the mailing list to kernel.org
infrastructure.

To that end, there is a linux-xfs@vger.kernel.org
list already - it was created at the same time that the above
kernel.org repositories were created, but we've never used it. It
is archived here:

	http://www.spinics.net/lists/linux-xfs/

Moving the mailing list is going to be something that affects more
than just the developers - we've got lots of documentation that
points at this list and there are lots of users that are subscribed,
read it though nntp gateways, have aliases for it, etc so we need
a good transition plan here.

I'm not sure what the best approach - perhaps just
forwarding all email from xfs@oss.sgi.com to
linux-xfs@vger.kernel.org will solve most transitional problems
for users that aren't aware of the change or are following old
documentation or "please report bug" messages from xfs_repair.
But it means that everyone needs to subscribe to the new list
and probably unsubscribe from the old list. I dont see how we can
avoid that in the long term, but I'd like to minimise the pain
as much as possible for everyone.

Again, I'm open to suggestions on how to approach this and maintain
the oss list aliases for long enough that people and search engines
learn about the new list.

I would like to make this as painless as possible for everyone. This
isn't the only solution to the problems we have with oss.sgi.com,
but it's the path of least effort/greatest gain for me. If anyone
has any ideas on alternative solutions, reservations about moving to
kernel.org infrastructure and/or suggestions to make it less painful
for everyone, please speak up now.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4sOxAAoJEK3oKUf0dfodHRsQANRBTF02Q742McbEZxb0J9IB
EKz+eLegRB5zRaHQAa7GEVq5xSnEJvX4/M2XTCK+HBCNdGy6DPH3777Tf6869uLt
5YLf1hIhQso/o3FPqaRdb9UmaV/fXGjAjBIcTneCHThMO1JWRpyLlZBAcYIrO3yQ
MD8xjypUk/KxRxLZU54kXHZG5TZ6abXF6MAksBBX7gnKlLMBeVwBznn64WLUebAF
aJEJCiaiBKYo0Hcd7MkKLtBdbi977Mk/pkMS1U3AILrRBN40jl7o7pFDnyApzTy6
r03VbWTuZSgaPQF32SfSqBXUTAKaOJA4zEr61QuS7yyvVhm2a6YcY92/yw1ia7AY
kT5eMqn9vxZwPHI8b/38Dhrm/HJEXS/TkCAafCQlaMN7U0auvpsZtHQain2s4Vm4
SW7hzb26Y1zy/A0pLDGz0GHEs+Hml9DuZvu5BbmCtFnrsi6u0DpHUorwQ4JxWuiJ
SbonlU1Wf4g7h2SwShoPmtRKS2ar2vFmS5jnuUoq7HtWjLJwFryKuDHHjaDReVVA
JeV4Ux13BeRnGqFpn7Xbaphm/3I3fFQc7h6qU+u/Clt6u6bC1+2j41Nq35fCT04M
wB7ogbW19elsr/hbZBINLWmb5k6lZ8WFXMKuvlUdEvwTL89FTOhimWZRrKNlDSDc
TSDH886bZf4WgoN8h505
=4kZa
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--


--===============8053165494245948395==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8053165494245948395==--
