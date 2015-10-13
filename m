Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 003427F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 14:22:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9EC298F8054
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 12:22:29 -0700 (PDT)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com
	[209.85.223.180]) by cuda.sgi.com with ESMTP id
	294DF5j8MG7ONUVx (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2015 12:22:27 -0700 (PDT)
Received: by iow1 with SMTP id 1so32485747iow.1
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 12:22:27 -0700 (PDT)
Subject: Re: [PATCH v10 24/46] xfs: Add richacl support
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-25-git-send-email-andreas.gruenbacher@gmail.com>
	<20151012001033.GA27164@dastard>
	<CAHpGcMKeJHDegs2cYKaJdX4Tw43Jp30Nv_2WoSNZfBzGJKu=BQ@mail.gmail.com>
	<20151012040545.GC27164@dastard>
	<CAHc6FU55eOK4gWH1bhKvoujQ1zkT+we0xcfPUOeWrF_X0XHXZg@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <561D59CE.9050507@gmail.com>
Date: Tue, 13 Oct 2015 15:21:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAHc6FU55eOK4gWH1bhKvoujQ1zkT+we0xcfPUOeWrF_X0XHXZg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4610945855904293471=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API Mailing List <linux-api@vger.kernel.org>, =?UTF-8?Q?Andreas_Gr=c3=bcnbacher?= <andreas.gruenbacher@gmail.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

This is a cryptographically signed message in MIME format.

--===============4610945855904293471==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060304030105080606030309"

This is a cryptographically signed message in MIME format.

--------------ms060304030105080606030309
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-12 01:57, Andreas Gruenbacher wrote:
> On Mon, Oct 12, 2015 at 6:05 AM, Dave Chinner <david@fromorbit.com> wro=
te:
>> On Mon, Oct 12, 2015 at 03:51:15AM +0200, Andreas Gr=C3=BCnbacher wrot=
e:
>>> 2015-10-12 2:10 GMT+02:00 Dave Chinner <david@fromorbit.com>:
>>>> On Mon, Oct 12, 2015 at 12:58:35AM +0200, Andreas Gruenbacher wrote:=

>>>>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.=
h
>>>>> index 9590a06..8c6da45 100644
>>>>> --- a/fs/xfs/libxfs/xfs_format.h
>>>>> +++ b/fs/xfs/libxfs/xfs_format.h
>>>>> @@ -461,10 +461,18 @@ xfs_sb_has_ro_compat_feature(
>>>>>   #define XFS_SB_FEAT_INCOMPAT_FTYPE   (1 << 0)        /* filetype =
in dirent */
>>>>>   #define XFS_SB_FEAT_INCOMPAT_SPINODES        (1 << 1)        /* s=
parse inode chunks */
>>>>>   #define XFS_SB_FEAT_INCOMPAT_META_UUID       (1 << 2)        /* m=
etadata UUID */
>>>>> +
>>>>> +#ifdef CONFIG_XFS_RICHACL
>>>>> +#define XFS_SB_FEAT_INCOMPAT_RICHACL (1 << 3)        /* richacls *=
/
>>>>> +#else
>>>>> +#define XFS_SB_FEAT_INCOMPAT_RICHACL 0
>>>>> +#endif
>>>>> +
>>>>
>>>> Regardless of whether we build in richacl support, this is wrong.
>>>> Feature bits are on-disk format definitions, so it will always have
>>>> this value whether or not the kernel supports the feature.
>>>
>>> This is so that xfs_mount_validate_sb() will complain when mounting a=

>>> richacl filesystem on a kernel which doesn't have richacl suport
>>> compiled in. The same effect can be had with extra code there of
>>> course.
>>
>> If the kernel doesn't know about a feature, then it will report
>> "unknown feature". However, as of this patch set, the kernel will
>> know about the richacl feature, and so the correct error message
>> is to say "Rich ACLs not supported by this kernel".
>>
>> Also, from a disk format perspective, this is a this is a read-only
>> compat feature, as kernels that don't have richacl support are still
>> able to mount and walk the filesystem without errors occurring. It's
>> only when allowing modifications are made that problems will arise,
>> so why did you make it an incompat feature?
>
> As a read-only compat flag, kernels that cannot enforce richacls would
> still be able to mount richacl file systems read-only. That's a
> problem when acls are used to forbid read/execute access.
It's also an irrelevant problem, anyone with a minimal knowledge of the=20
filesystem's on-disk layout can unset the feature bit by hand and force=20
it to be mounted anyway, thus bypassing the ACL's (this is the case for=20
any filesystem, not just XFS).  If someone has access to the hardware,=20
they have access to the data stored on it, period, irrespective of what=20
the data says about how it should be accessed.

The 3 most common cases for trying to mount a filesystem with this on a=20
kernel that doesn't support it are:
a. Someone is trying to recover data on their own system using something =

like SystemRescueCD.
b. Someone is trying to recover data from a non-functional system that=20
they own or have been authorized to access for this purpose by=20
connecting the disk to another system.
c. Someone is trying to bisect a kernel bug or track down what config=20
option is causing them issues.
All three of these cases _need_ to keep working properly without needing =

to manually twiddle with compat bits, otherwise it _will_ cause a lot of =

people to advocate not using richacls.


--------------ms060304030105080606030309
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCC
Brgwgga0MIIEnKADAgECAgMRLfgwDQYJKoZIhvcNAQENBQAweTEQMA4GA1UEChMHUm9vdCBD
QTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNp
Z25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcwHhcN
MTUwOTIxMTEzNTEzWhcNMTYwMzE5MTEzNTEzWjBjMRgwFgYDVQQDEw9DQWNlcnQgV29UIFVz
ZXIxIzAhBgkqhkiG9w0BCQEWFGFoZmVycm9pbjdAZ21haWwuY29tMSIwIAYJKoZIhvcNAQkB
FhNhaGVtbWVsZ0BvaGlvZ3QuY29tMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
nQ/81tq0QBQi5w316VsVNfjg6kVVIMx760TuwA1MUaNQgQ3NyUl+UyFtjhpkNwwChjgAqfGd
LIMTHAdObcwGfzO5uI2o1a8MHVQna8FRsU3QGouysIOGQlX8jFYXMKPEdnlt0GoQcd+BtESr
pivbGWUEkPs1CwM6WOrs+09bAJP3qzKIr0VxervFrzrC5Dg9Rf18r9WXHElBuWHg4GYHNJ2V
Ab8iKc10h44FnqxZK8RDN8ts/xX93i9bIBmHnFfyNRfiOUtNVeynJbf6kVtdHP+CRBkXCNRZ
qyQT7gbTGD24P92PS2UTmDfplSBcWcTn65o3xWfesbf02jF6PL3BCrVnDRI4RgYxG3zFBJuG
qvMoEODLhHKSXPAyQhwZINigZNdw5G1NqjXqUw+lIqdQvoPijK9J3eijiakh9u2bjWOMaleI
SMRR6XsdM2O5qun1dqOrCgRkM0XSNtBQ2JjY7CycIx+qifJWsRaYWZz0aQU4ZrtAI7gVhO9h
pyNaAGjvm7PdjEBiXq57e4QcgpwzvNlv8pG1c/hnt0msfDWNJtl3b6elhQ2Pz4w/QnWifZ8E
BrFEmjeeJa2dqjE3giPVWrsH+lOvQQONsYJOuVb8b0zao4vrWeGmW2q2e3pdv0Axzm/60cJQ
haZUv8+JdX9ZzqxOm5w5eUQSclt84u+D+hsCAwEAAaOCAVkwggFVMAwGA1UdEwEB/wQCMAAw
VgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBmb3IgRlJFRSBo
ZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMA4GA1UdDwEB/wQEAwIDqDBABgNV
HSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisGAQQBgjcKAwMGCWCG
SAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLmNhY2Vy
dC5vcmcwMQYDVR0fBCowKDAmoCSgIoYgaHR0cDovL2NybC5jYWNlcnQub3JnL3Jldm9rZS5j
cmwwNAYDVR0RBC0wK4EUYWhmZXJyb2luN0BnbWFpbC5jb22BE2FoZW1tZWxnQG9oaW9ndC5j
b20wDQYJKoZIhvcNAQENBQADggIBADMnxtSLiIunh/TQcjnRdf63yf2D8jMtYUm4yDoCF++J
jCXbPQBGrpCEHztlNSGIkF3PH7ohKZvlqF4XePWxpY9dkr/pNyCF1PRkwxUURqvuHXbu8Lwn
8D3U2HeOEU3KmrfEo65DcbanJCMTTW7+mU9lZICPP7ZA9/zB+L0Gm1UNFZ6AU50N/86vjQfY
WgkCd6dZD4rQ5y8L+d/lRbJW7ZGEQw1bSFVTRpkxxDTOwXH4/GpQfnfqTAtQuJ1CsKT12e+H
NSD/RUWGTr289dA3P4nunBlz7qfvKamxPymHeBEUcuICKkL9/OZrnuYnGROFwcdvfjGE5iLB
kjp/ttrY4aaVW5EsLASNgiRmA6mbgEAMlw3RwVx0sVelbiIAJg9Twzk4Ct6U9uBKiJ8S0sS2
8RCSyTmCRhJs0vvva5W9QUFGmp5kyFQEoSfBRJlbZfGX2ehI2Hi3U2/PMUm2ONuQG1E+a0AP
u7I0NJc/Xil7rqR0gdbfkbWp0a+8dAvaM6J00aIcNo+HkcQkUgtfrw+C2Oyl3q8IjivGXZqT
5UdGUb2KujLjqjG91Dun3/RJ/qgQlotH7WkVBs7YJVTCxfkdN36rToPcnMYOI30FWa0Q06gn
F6gUv9/mo6riv3A5bem/BdbgaJoPnWQD9D8wSyci9G4LKC+HQAMdLmGoeZfpJzKHMYIE0TCC
BM0CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNl
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDEzMTkyMTUwWjBPBgkq
hkiG9w0BCQQxQgRArBUGWWZFAbD+leqoCnJ+cAxw8j8yXpMSUbB7bw1UqItWlH/9270Nf4Od
pdqL+vVSWt31hcG6ZZ4aH4BBrsvPjTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBPWhX/SgfqmlcepEGctHnqt44hjsUxHb8h4h9fFAfSEfJqcXqB
29yhvZZzxCC7wr8SRrc6TfvBz8Sm5c4/kBItQJf7BJ9+GaDRm6JOFeQOE0U3edSydnBhyyPd
U2olvc89DsRzOiwH68dV01oRYlXCTDo1qxi84JS4X0HTIc+cvNF2AoMckaGGaNymtl0Noj5t
n0lYj63Wz9qO3HiFWFlsHNB+Q4Fr/pwPsK/wHrZlqbzVK4jkXeqpLmryrlfR8aSMZCmkDSzr
9IcNkbmQ3yzQZ5q5N1Q6C6NvwyhIZlKa8Jh/uAmWEeSNESbaB8CSJoCbeegnROGKVA+xOoG9
1xczV04oQZCyEhCjsF26/I2FVZHLoFMYj1QjIr4iYlBKP73hhPZa0Q3jaEQdZU3mvjJSTzz3
X+FaB3d+5Zp2ASP4u3BBUdR/AUMELyusUtIpd6H0hvVHhD7DB1mkrzp4weP4Z9BR7IDTkQLY
YHKt7nG95/J/iS4mqTJsHDRKZuv6CldVREHKua5fTQ3Q6DpJtpkeox/6zOV9elTynTMsLsn8
UdIiMFpNNIDIcD29CAy0csWlxQzBi5llrE/dOmvciiiVfb0I9MbOoKYsE4r3bzqvs1OwIlDe
zwFwNa2mLtjcDEcI1zpdMaL4lY/Kgk+9Ad5nLyT/EjN1MFw1CFn6gucXOQAAAAAAAA==
--------------ms060304030105080606030309--


--===============4610945855904293471==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4610945855904293471==--
