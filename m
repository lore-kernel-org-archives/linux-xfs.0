Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51189 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbeC1Gzi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 02:55:38 -0400
Subject: Re: [PATCH v2 3/3] fstests: generic: Check the fs after each FUA
 writes
References: <20180328044023.22078-1-wqu@suse.com>
 <20180328044023.22078-3-wqu@suse.com>
 <CAOQ4uxj5ff5-AhoACxZGG+ZeHRh0Qr_=uPqyzMUv5h934dicuQ@mail.gmail.com>
 <2956631d-3843-aaf6-8d75-3a2028fea88b@gmx.com>
 <20180328061945.GF30836@localhost.localdomain>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2b349e90-c406-2f0d-04a7-66bc66a645c8@gmx.com>
Date: Wed, 28 Mar 2018 14:55:22 +0800
MIME-Version: 1.0
In-Reply-To: <20180328061945.GF30836@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Z9yK1icynYpknIDT768rsLcFEHAzc3iEJ"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <wqu@suse.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Z9yK1icynYpknIDT768rsLcFEHAzc3iEJ
Content-Type: multipart/mixed; boundary="NX1AihsqT5ZVmUqncDgNoPrG1r9u3Mzye";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <wqu@suse.com>,
 Linux Btrfs <linux-btrfs@vger.kernel.org>, fstests
 <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>,
 Ext4 <linux-ext4@vger.kernel.org>
Message-ID: <2b349e90-c406-2f0d-04a7-66bc66a645c8@gmx.com>
Subject: Re: [PATCH v2 3/3] fstests: generic: Check the fs after each FUA
 writes
References: <20180328044023.22078-1-wqu@suse.com>
 <20180328044023.22078-3-wqu@suse.com>
 <CAOQ4uxj5ff5-AhoACxZGG+ZeHRh0Qr_=uPqyzMUv5h934dicuQ@mail.gmail.com>
 <2956631d-3843-aaf6-8d75-3a2028fea88b@gmx.com>
 <20180328061945.GF30836@localhost.localdomain>
In-Reply-To: <20180328061945.GF30836@localhost.localdomain>

--NX1AihsqT5ZVmUqncDgNoPrG1r9u3Mzye
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8828=E6=97=A5 14:19, Eryu Guan wrote:
> On Wed, Mar 28, 2018 at 01:51:44PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8828=E6=97=A5 13:04, Amir Goldstein wrote:
>>> On Wed, Mar 28, 2018 at 7:40 AM, Qu Wenruo <wqu@suse.com> wrote:
>>>> Basic test case which triggers fsstress with dm-log-writes, and then=

>>>> check the fs after each FUA writes.
>>>> With needed infrastructure and special handlers for journal based fs=
=2E
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>> changelog:
>>>> v2:
>>>>   Use proper "SUSE Linux Products GmbH" instead of "SuSE"
>>>>   Get rid of dm-snapshot which is pretty slow if we're creating and
>>>>   deleting snapshots repeatedly.
>>>>   (Maybe LVM thin provision would be much better, but current replay=

>>>>    solution is good so far, and no slower than dm-snapshot)
>>>>   Add back run_check so that we can get the seed.
>>>> ---
>>>> Unfortunately, neither xfs nor ext4 survies this test for even singl=
e
>>>> success, while btrfs survives.
>>>> (Although not what I want, I'm just trying my luck
>>>> to reproduce a serious btrfs corruption situation)
>>>>
>>>> Although btrfs may be the fastest fs for the test, since it has fixe=
d
>>>> small amount of write in mkfs and almost nothing to replay, it still=

>>>> takes about 240s~300s to finish (the same level using snapshot).
>>>>
>>>> It would take longer time for ext4 for its large amount of write dur=
ing
>>>> mkfs, if it can survive the test in the first space.
>>>
>>> Hmm, how much time would the total test would take if you don't fail
>>> it on fsck? I am asking because it may be possible to improve this wi=
th
>>> only a single snapshot after mkfs.
>>
>> The only fs which can pass the test right now is btrfs, so other
>> estimation is mostly based on guess.
>>
>>>
>>> Anyway, if total test run time is expected to be under 10min I wouldn=
't
>>> bother with this optimization, at least not right now. IMO it is more=

>>> important to get the test out there to get the corruption bugs floati=
ng.
>>
>> I'd say from current status, if XFS doesn't fail, it would definitely
>> finish in 10min.
>> For EXT4 I'm not pretty sure.
>                                                                        =
                                                                         =
                                              =20
> 10min might be a bit long, 5min would be good enough. I may need to
> adjust the fsstress "-n" param based on test results when I got some
> time, hopefully this week..
>=20
> And I noticed that fsstress "-p" is based on nr_cpus, I'd like to cap i=
t
> with a max allowed number, so test won't run for too long on hosts with=

> hundreds of cpus. It could always be scaled with _scale_fsstress_args.
>=20
> +nr_cpus=3D$("$here/src/feature" -o)
> +fsstress_args=3D$(_scale_fsstress_args -w -d $SCRATCH_MNT -n 512 -p $n=
r_cpus \
> +               $FSSTRESS_AVOID)

This makes sense.

(I used to think 4 cores was enough and now mainstream desktop is push 8
cores)

Thanks,
Qu

>=20
>>
>> I'd like to  keep current test case as simple as possible right now, a=
nd
>> for later enhancement, I have several different ideas:
>=20
> Please make new tests then :)
>=20
>>
>> 1) Reflink fs + loopback
>>    Yep, use btrfs/xfs as base filesystem and create copy using reflink=
,
>>    then use such files as loopback device.
>>    The good thing is, AFAIK btrfs/xfs reflink is really fast.
>>    Much much faster than dm-snapshot or even LVM thin.
>>
>>    The much much smaller block size (4K default) makes CoW overhead
>>    (LVM thin is 64K, not sure about dm-snapshot though).
>>
>>    The problem is, such setup needs extra mount point and can be a
>>    little hard to setup, and we're introducing another layer of fs,
>>    if the fs itself has some hidden bug, it would screw up the test
>>    case.
>>
>> 2) LVM thin provision
>>    LVM thin provision looks much like btrfs/xfs for block level, and
>>    smaller default block size (64K vs original 2M) makes CoW overhead
>>    smaller.
>>
>>    I'm currently testing this method, the good thing is it's a little
>>    easier to setup and we can use single mount point.
>>
>> Anyway, with proper and efficient snapshot ability implemented, I will=

>> definitely convert this test case, and add Flush test case.
>>
>> Thanks for your review too,
>> Qu
>>
>>>
>>> Thanks for working on this!
>>> You can add
>>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>=20
> Thank you both!
>=20
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--NX1AihsqT5ZVmUqncDgNoPrG1r9u3Mzye--

--Z9yK1icynYpknIDT768rsLcFEHAzc3iEJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq7PFsACgkQwj2R86El
/qhjGgf5ASuBLxGdGSEJ0KTG68199sFrwvpFzmQWOuacj9f7ceiwxBFOYA4pbP+B
8xsUH8LCaLl23ikBDqFYR1VVXnwx6tHI2tlpMV9Xqh0coR5+VdveWkctvwJsyNhG
QW18/gZdhBeT75aa65IuF3RwjcLq56RGXcK9RtVI/V4+Rd5VOgVdwU5UuXYZdmgr
TsxWi/RXHU0xajfjpj1sCY+fC0OEW581UyMO1rXy7d0eBArBQK+4L3nJ2wWvvkDl
PfiTqUqxvLC5SmxUojubEVJVUAYFofj1qhWqDGvpcPPgkQNTHdtRu6PtxI2xF3zI
chGCn8MrS+ln+9ImcVHX+en4+8GgMA==
=sV9b
-----END PGP SIGNATURE-----

--Z9yK1icynYpknIDT768rsLcFEHAzc3iEJ--
