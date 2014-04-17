Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A327C7F4E
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 19:21:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86BCB30408D
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 17:20:59 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id E0QIU2WHS8s3L8Ql (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 17:20:58 -0700 (PDT)
Date: Thu, 17 Apr 2014 10:20:48 +1000
From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH/RFC 00/19] Support loop-back NFS mounts
Message-ID: <20140417102048.2fc8275c@notabene.brown>
In-Reply-To: <20140416104207.75b044e8@tlielax.poochiereds.net>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416104207.75b044e8@tlielax.poochiereds.net>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6047043044285991574=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-nfs@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>

--===============6047043044285991574==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZiKmG43mXH3JoeDwPbs7CZV"; protocol="application/pgp-signature"

--Sig_/ZiKmG43mXH3JoeDwPbs7CZV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Apr 2014 10:42:07 -0400 Jeff Layton <jlayton@redhat.com> wrote:

> On Wed, 16 Apr 2014 14:03:35 +1000
> NeilBrown <neilb@suse.de> wrote:
>=20

> > Comments, criticisms, etc most welcome.
> >=20
> > Thanks,
> > NeilBrown
> >=20
>=20
> I've only given this a once-over, but the basic concept seems a bit
> flawed. IIUC, the basic idea is to disallow allocations done in knfsd
> threads context from doing fs-based reclaim.
>=20
> This seems very heavy-handed, and like it could cause problems on a
> busy NFS server. Those sorts of servers are likely to have a lot of
> data in pagecache and thus we generally want to allow them to do do
> writeback when memory is tight.
>=20
> It's generally acceptable for knfsd to recurse into local filesystem
> code for writeback. What you want to avoid in this situation is reclaim
> on NFS filesystems that happen to be from knfsd on the same box.
>=20
> If you really want to fix this, what may make more sense is trying to
> plumb that information down more granularly. Maybe GFP_NONETFS and/or
> PF_NETFSTRANS flags?

Hi Jeff,
 a few clarifications first:

 1/ These changes probably won't affect a "busy NFS server" at all.  The
    PF_FSTRANS flag only get set in nfsd when it sees a request from the lo=
cal
    host.  Most busy NFS servers would never see that, and so would never s=
et
    PF_FSTRANS.

 2/ Setting PF_FSTRANS does not affect where writeback is done.  Direct
    reclaim hasn't performed filesystem writeback since 3.2, it is all done
    by kswapd (I think direct reclaim still writes to swap sometimes).
    The main effects of setting PF_FSTRANS (as modified by this page set)
    are:
      - when reclaim calls ->releasepage  __GFP_FS is not set in the gfp_t =
arg
      - various caches like dcache, icache etc are not shrunk from
        direct reclaim
    There are other effects, but I'm less clear on exactly what they mean.

A flag specific to network filesystems might make sense, but I don't think =
it
would solve all the deadlocks.

A good example is the deadlock with the flush-* threads.
flush-* will lock a page, and  then call ->writepage.  If ->writepage
allocates memory it can enter reclaim, call ->releasepage on NFS, and block
waiting for a COMMIT to complete.
The COMMIT might already be running, performing fsync on that same file that
flush-* is flushing.  It locks each page in turn.  When it  gets to the page
that flush-* has locked, it will deadlock.

xfs_vm_writepage does allocate memory with __GFP_FS set
   xfs_vm_writepage -> xfs_setfilesize_trans_alloc -> xfs_trans_alloc ->
   _xfs_trans_allo

and I have had this deadlock happen.  To avoid this we need flush-* to ensu=
re
that no memory allocation blocks on NFS.  We could set a PF_NETFSTRANS ther=
e,
but as that code really has nothing to do with networks it would seem an odd
place to put a network-fs-specific flag.

In general, if nfsd is allowed to block on local filesystem, and local
filesystem is allowed to block on NFS, then a deadlock can happen.
We would need a clear hierarchy

   __GFP_NETFS > __GFP_FS > __GFP_IO

for it to work.  I'm not sure the extra level really helps a lot and it wou=
ld
be a lot of churn.


Thanks,
NeilBrown


--Sig_/ZiKmG43mXH3JoeDwPbs7CZV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU08eYDnsnt1WYoG5AQI3mQ//b09b32kYZg134oqC28wk4GuKXD4068sE
Vcj1k1jm+zz0nHfY1XbLA2PYmLGeNc1bUSGwtOwVwNvbI1xrae4Da2J6sfQ600nO
8ozsbNXA32Bwp9h4LySPfpvJFatGmW5Kad/88qFc0a9vxXFFjIlm2hmhCuIopTCt
PnwHRuTudFWi+Uu2JeqvmNRzcCTt0udNsc7xXlEwk5IXlYj/Qj7WVat40NjQd84E
We+y6vTsMkHd2G/yoGdBNTQQedOgrAwyiGudq3VHPUpXgbkpnrnU0tikA2dssL10
XlY37WlZeuqS7NKCAhLJbrJijHI8Js+cUbAhb/zNGW3llCFddYXBjWzWHT07/ISv
A8+vuItTa0f/PsI8VkXbJ5P1QMmMtkgsbE+UOJ573v3v9Z2CKemZVrUBmCuOX/x7
iY8eSdU0SsBWTu6OO6TS4BvIu5yvX4PYdt3MvjF1LspLv6ggZ93LUr1+KV0TyUs2
ugbsf9Mq7vrnDdYR3z4Xb38xnAwz+5OmDgaDHTaA67VMYA2Y5K9IoVxMwTdEwGQ5
WOy/KviX2JBbOKLmwcQeZgiTaEpr4CRY6rDA6fIqORBysrGqkujiY1e2OkX8sd30
yo+WHWp7DIeWiJXEUTaRXewa8CgcUY3CXATuj+bsilLTVOhxT28rK5FwtAq6y00N
Go80SPlCYvY=
=Ornx
-----END PGP SIGNATURE-----

--Sig_/ZiKmG43mXH3JoeDwPbs7CZV--


--===============6047043044285991574==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6047043044285991574==--
