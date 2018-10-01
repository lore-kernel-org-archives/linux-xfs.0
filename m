Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:51551 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbeJBCaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 22:30:39 -0400
Received: by mail-it1-f194.google.com with SMTP id 74-v6so12352itw.1
        for <linux-xfs@vger.kernel.org>; Mon, 01 Oct 2018 12:51:16 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <FE6394EC-5CB0-4A16-AAC6-97F465A4E50C@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6FD6155E-4B53-4E0B-BBB4-240C9582FC05";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: cross-fs copy support
Date: Mon, 1 Oct 2018 13:51:09 -0600
In-Reply-To: <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
 <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Joshi <joshiiitr@gmail.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org


--Apple-Mail=_6FD6155E-4B53-4E0B-BBB4-240C9582FC05
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

=1D=08=1D=1DOn Oct 1, 2018, at 9:49 AM, Eric Sandeen =
<sandeen@sandeen.net> wrote:
>=20
>=20
> On 10/1/18 9:48 AM, Qu Wenruo wrote:
>>=20
>>=20
>> On 2018/10/1 =E4=B8=8B=E5=8D=8810:32, Joshi wrote:
>>> I was wondering about the cross-fs copy through copy_file_range.
>>=20
>> The term "cross-fs" looks pretty confusing.
>>=20
>> If you mean "cross-subvolume", then it should work without problem in =
btrfs.
>>=20
>> If you mean reflink across two different file systems (not matter the
>> same fs type or not).
>> Then it's impossible to work.
>=20
> I believe Joshi is talking about vfs_copy_file_range() not
> vfs_clone_file range(), although _copy_ does call _clone_ if it can.
>=20
>> Reflink (clone_file_range) works by inserting data pointers into the
>> filesystem other than really copying the data.
>> Thus if the source is outside of the fs, it's really impossible to =
work,
>> as the source pointer/data is completely out of control of the dest =
fs.
>=20
> Yes, I would expect there to be problems with his modified kernel
> for a filesystem that supports clone_file_range, because
> vfs_copy_file_range() will clone if possible, and this should fail =
across
> filesystems.
>=20
> In general, though, I don't know for sure why we don't fall back to
> do_splice_direct() across filesystems, although the filesystems that
> implement their own ->copy_file_range ops may have their own,
> further restrictions within their implementations.
>=20
> This call /is/ documented in the manpage as only being valid for
> files on the same filesystem, though:
> http://man7.org/linux/man-pages/man2/copy_file_range.2.html

There was a patch to allow cross-mount copy for NFS, but it hasn't =
landed
yet.

Cheers, Andreas






--Apple-Mail=_6FD6155E-4B53-4E0B-BBB4-240C9582FC05
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAluyeq0ACgkQcqXauRfM
H+CA/BAAlqfHLiBffwXGdhOXxmPi4v2pdAwCq1EtDwY2FrQ9pouuSEwVc5WimoYA
8hPkLHmLw2DBwGon9YHgI90Or73VHWHY7hQDKJdU1kgo6BVSYDKSc2fj197DFuau
1SJbsERSn+VGlgoJgnzLsWUFbsl7jU8wXQAVh53zh1xHQtKrTWpfwlMO1/LmkO5M
FW5XIID7cE8iZHLMCdftciOufamoXiU1h1ILoWvMqmsL0lB8Ie2K2KKtw9EC6v2z
+CjMDPoNHIlbOFB+LIUKSTCNB064Sts3OUKF1EjfIYYoPAjM4JCuWU7rh5q1mv3o
gy7kxhx3IM8NpGDiGeUttCabdzqSMlY0VRyYLtTiqP5h6WkgHgrMkSb0zH26A2GZ
AKzzJZzUk24QMEaLoQPCYbN8EnwFwES/4vxGpeAmb3FAtSk2jDJiZ3QitTWbamSY
N2JydBps2Y+pi8W66VPKse/0u7REk9B79JSyouuB2VlyCxwGPME+VGCpAoMumrIA
FUkYzp699AlMOwCCsdJocsVUfSCOnfwD2sU73n7ytBvqyKF4LaGN1q6VMxaWvZAf
rM22YDLk3ATvYF2hp+hAzVJrVfEcPY+nadhUuFRt4AvgFrql56rGNEJzJ1e5kbe8
f2BgJ6dQV09n3zywL7O5nLE4b1BMHDl4jGkiPeKB+COydXzj9Pw=
=pSPg
-----END PGP SIGNATURE-----

--Apple-Mail=_6FD6155E-4B53-4E0B-BBB4-240C9582FC05--
