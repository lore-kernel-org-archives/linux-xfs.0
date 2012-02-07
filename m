Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17Mg4Ar008519 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 16:42:04 -0600
Date: Wed, 8 Feb 2012 04:11:54 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re:  Re: [PATCH][RFC] XFS: Fix mem leak and possible NULL deref in
	xfs_setattr_nonsize()
Message-ID: <20120207224154.GB4312@Xye>
References: <alpine.LNX.2.00.1202052220390.32529@swampdragon.chaosbits.net>
	<20120206091100.GA4350@Xye>
	<alpine.LNX.2.00.1202062145240.20117@swampdragon.chaosbits.net>
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1202062145240.20117@swampdragon.chaosbits.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1153287527134508666=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jesper Juhl <jj@chaosbits.net>
Cc: Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>


--===============1153287527134508666==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,



* On Mon, Feb 06, 2012 at 09:51:54PM +0100, Jesper Juhl <jj@chaosbits.net> =
wrote:
>On Mon, 6 Feb 2012, Raghavendra D Prabhu wrote:
>
>> Hi,
>>
>>
>> * On Sun, Feb 05, 2012 at 10:23:44PM +0100, Jesper Juhl <jj@chaosbits.ne=
t>
>> wrote:
>> > In xfs_setattr_nonsize(), xfs_trans_alloc() gets its memory from
>> > _xfs_trans_alloc() which gets it from kmem_zone_zalloc() which may
>> > fail and return NULL. So this:
>> >
>> > 	tp =3D xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
>> >
>> > may result in a NULL 'tp'.
>> > If it does, then the call:
>> >
>> > 	error =3D xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
>> >
>> > with a NULL 'tp' will explode, since xfs_trans_reserve() dereferences
>> > its first argument unconditionally.
>> >
>> > And if the memory allocation for 'tp' goes well (and thus
>> > xfs_trans_reserve() does not explode) then we may leak the memory
>> > allocated to 'tp' if xfs_trans_reserve() returns error.
>> >
>> > I believe this patch should fix both issues, but I'm not intimate with
>> > the XFS code at all, so there can easily be something I overlooked or
>> > something that should be done differently than what I did.
>> >
>> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>> > ---
>> > fs/xfs/xfs_iops.c |    7 ++++++-
>> > 1 files changed, 6 insertions(+), 1 deletions(-)
>> >
>> > Note:
>> >  Please review carefully before applying.
>> >  Especially since I don't currently have any XFS filesystems to test
>> >  this on, nor any clear idea of a good way to actually test this if I
>> >  had. So this patch is compile tested only on my end.
>> >
>> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> > index ab30253..194c9d7 100644
>> > --- a/fs/xfs/xfs_iops.c
>> > +++ b/fs/xfs/xfs_iops.c
>> > @@ -575,9 +575,14 @@ xfs_setattr_nonsize(
>> > 	}
>> >
>> > 	tp =3D xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
>> > +	if (!tp)
>> > +		goto out_dqrele;
>> > +
>> > 	error =3D xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
>> > -	if (error)
>> > +	if (error) {
>> > +		xfs_trans_cancel(tp, 0);
>> > 		goto out_dqrele;
>> > +	}
>> >
>> > 	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> >
>> > --
>> > 1.7.9
>> >
>> >
>> > Please CC me on replies.
>> >
>[...]
>>
>> The first one won't be triggered because kmem_zone_alloc (the last one i=
n call
>> chain) checks for
>>     if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
>>
>> whereas xfs_trans_alloc  calls _xfs_trans_alloc with KM_SLEEP, also all =
other
>> callers of _xfs_trans_alloc call it with KM_SLEEP (except one which call=
s with
>> KM_NOFS), so it looks like we are safe there, it keeps spinning till it =
finds
>> mem.
>>
>Good.
>
>>
>> As far as second one is concerned, looks fine, though this one should al=
so do
>> the same.
>>
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index ab30253..d331f5b 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -730,9 +730,9 @@ xfs_setattr_nonsize(
>>         return 0;
>>
>> out_trans_cancel:
>> -       xfs_trans_cancel(tp, 0);
>>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> out_dqrele:
>> +       xfs_trans_cancel(tp, 0);
>>         xfs_qm_dqrele(udqp);
>>         xfs_qm_dqrele(gdqp);
>>         return error;
>>
>
>Thank you for the feedback.
>
>I worry about the fact that this suddenly calls xfs_trans_cancel() without
>holding the lock. I don't know if that's actually significant though.
>
>If it *is* significant, then I think the patch I just submitted in reply to
>Dave Chinner is better since there we do the alloc and cancel before even
>taking the lock at all in the leaky case and all other case have
>identical behaviour as before.
>If it is *not* significant then your patch is probably better since that
>means one less thing done while holding a lock.
>
>But I don't know enough XFS details to say which it is, so I'll leave it
>to someone else to pick the best patch of the two for this.
>
>
>--=20
>Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
>Don't top-post http://www.catb.org/jargon/html/T/top-post.html
>Plain text mails only, please.
>

Thanks, I noticed it a few moments after I posted it :) but I=20
needed to know the reason behind unlock before cancel pattern=20
which was provided by David Chinner.






Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPMaiyAAoJEKYW3KHXK+l3mlMH/RTWOM/JSYqSPIMdkGHdw7Mq
7Q5977qYd4dZjo8gTxNtZ+WNsQTEsGN//61W2hhztdV/lSW4i2zpmhr5zZyz4xSY
7RHKG2SwGc/+jlhsPovJuDz0UUMbqT2nTioMwgrEXprvs9C2epRwvrrNooZP2qF6
7qHJubhqccHLkMZCf5YBMln1W86kCZ8q0HmU0EzDxv34cvsSklCuC+hul+CccACl
ew7Mw50IJ9LF2tiDWknQy87Ly4KPjy9HnJYAsjArj1oHR7Hr33qUBUe5+daEW9LW
oCyhO9/p8tIy3EWBurtXGDtHOenbGAETx94IN2m4w3HAYVyES9P89/qvaE02HHQ=
=5oUT
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--


--===============1153287527134508666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1153287527134508666==--
