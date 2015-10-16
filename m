Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C1197FB3
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 13:28:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A74D8F804B
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 11:28:12 -0700 (PDT)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
	[209.85.213.182]) by cuda.sgi.com with ESMTP id
	yj6DhgxuHfYti0NL (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 11:28:11 -0700 (PDT)
Received: by igbdj2 with SMTP id dj2so19933471igb.1
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 11:28:10 -0700 (PDT)
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <562141AD.60302@gmail.com>
Date: Fri, 16 Oct 2015 14:27:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4669003408224274888=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This is a cryptographically signed message in MIME format.

--===============4669003408224274888==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020706030005000206080603"

This is a cryptographically signed message in MIME format.

--------------ms020706030005000206080603
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-16 13:41, Andreas Gruenbacher wrote:
> On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> I would like to re-iterate, on both XFS and ext4, I _really_ think thi=
s
>> should be a ro_compat flag, and not an incompat one.  If a person has =
the
>> ability to mount the FS (even if it's a read-only mount), then they by=

>> definition have read access to the file or partition that the filesyst=
em is
>> contained in, which means that any ACL's stored on the filesystem are
>> functionally irrelevant,
>
> It is unfortunately not safe to make such a file system accessible to
> other users, so the feature is not strictly read-only compatible.
If it's not safe WRT data integrity, then the design needs to be=20
reworked, as that directly implies that isn't safe for even every day=20
usage on a writable filesystem.

If it's not safe WRT the ACL's being honored, then that really isn't=20
something we should be worrying about.  POSIX ACL's have this issue, as=20
does mounting a filesystem on any system with a different=20
/etc/{passwd,shadow,group,gshadow} than the one that wrote the=20
permissions to the FS in the first place, and as such this is the type=20
of thing any sensible system administrator will already expect to be=20
dangerous, which means in turn that they will only do it if there is no=20
other choice.

Trying to rely on making this an incompat feature to 'enforce' the ACL's =

is inherently flawed for two very specific reasons:
1. If the person theoretically trying to attack the system has write=20
access to the disk, they can flip the feature bit and get access anyway=20
(seriously, this takes maybe ten minutes of looking at the source code,=20
some simple math and a hex editor).
2. If the disk is read-only (or even if it's writable), they can just=20
forgo mounting the filesystem entirely and use any of a number of=20
existing tools to pull the data directly off of the disk.

As I said in a previous discussion about this, the three most likely=20
reasons for someone mounting a filesystem with this feature on a kernel=20
that doesn't support it are:
1. They've booted into a recovery environment (eg SystemRescueCD) to=20
attempt to recover data from the system itself (this usage implies=20
access to the hardware, and therefore the ACL's are inherently useless=20
for protecting the data anyway).
2. They've pulled the disk and hooked it up to a different system to=20
recover data from it (again, this implies access to the hardware, and=20
ACL's are inherently useless for protecting from this).
3. They're trying to bisect a kernel bug introduced at around the same=20
time that richacls went in (which means again they have hardware access=20
and ACL's are useless).
All that making this an incompat feature will do is make things harder=20
for these legitimate use cases, for any competent attacker it will only=20
be a minor inconvenience.


--------------ms020706030005000206080603
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDE2MTgyNzU3WjBPBgkq
hkiG9w0BCQQxQgRA+legPYobTKQcNAlViBgbnbYH3l0LrmDzA+1d4HDqf78AGERVacY0t0rX
cVtNZgQ9+3gcw2Yp4e9SE9Hp4Z7ogzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCE1YBQWrj+xmJfwSsbrMUCUnR7kITafUuZhzO4oEaiiVtUdQvt
uo5j/AnoPs4vQBZjTAn7zGcIu0e/WRUwTAztl+tQFb+KTzlUypS74y4ilWH7rPgw80Opta9Z
EUHnUM0PmIvRK0zP3metSCSXACmYJx7S62Tl+E5wXVJfGeKyT0OG+dshdlC3Tbw9CefCfMvd
0K8Fwz+yG7ZTgZ67iTo/IcyaDlPw8jO9HI1FrpfdLoEnzpbVKdyDcHtUFOwfu7VJafBCa+28
QoRmWEZTFIm3cOk74sz0Lhoxow5CWRt90+sQtyqf1ids/r4nxStPkMmt2axEZPVKNZ04Gv7F
vC8IY53dxC4T8hzIjB4a3CxwI2geElfbuggV84yKNmIpL+XytexEAlbU6WdE0cuWZcLIPuWl
5C56X2yTAZlOou95+DtguWWpsbeQfoGET9WeXIko2r5yDqEjHmLTUh29OA6xSQbTWX8/n3c5
rO8nwyzbqBmxnoq6bmAdEVZBbzRVzjiltn+DehfydNmLoS2VMGZwV/A0KhL7JrW2ogEQDAjj
eLxfTSOVhqeW9RrEGaCM7Le4HuAHxnPOYrPNWCnq2tpBrg/2iMVnG4YbOLVqyked1TC0ZsZu
CnNBSrHExCCCJ7pqQUY208PUiSyadAixss0U/Zicby+ejKQza20nCNJQjQAAAAAAAA==
--------------ms020706030005000206080603--


--===============4669003408224274888==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4669003408224274888==--
