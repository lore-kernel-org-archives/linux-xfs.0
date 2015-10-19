Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DF177F47
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 08:12:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BDF5DAC001
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 06:12:46 -0700 (PDT)
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com
	[209.85.223.173]) by cuda.sgi.com with ESMTP id
	XLwz5vdGnesr5CRm (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2015 06:12:45 -0700 (PDT)
Received: by iofz202 with SMTP id z202so44611607iof.2
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 06:12:44 -0700 (PDT)
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
	<562141AD.60302@gmail.com> <20151017231759.GV27164@dastard>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5624EC42.8050708@gmail.com>
Date: Mon, 19 Oct 2015 09:12:34 -0400
MIME-Version: 1.0
In-Reply-To: <20151017231759.GV27164@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2409286779900194158=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This is a cryptographically signed message in MIME format.

--===============2409286779900194158==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010802090608060909070409"

This is a cryptographically signed message in MIME format.

--------------ms010802090608060909070409
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-17 19:17, Dave Chinner wrote:
> On Fri, Oct 16, 2015 at 02:27:57PM -0400, Austin S Hemmelgarn wrote:
>> On 2015-10-16 13:41, Andreas Gruenbacher wrote:
>>> On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>> I would like to re-iterate, on both XFS and ext4, I _really_ think t=
his
>>>> should be a ro_compat flag, and not an incompat one.  If a person ha=
s the
>>>> ability to mount the FS (even if it's a read-only mount), then they =
by
>>>> definition have read access to the file or partition that the filesy=
stem is
>>>> contained in, which means that any ACL's stored on the filesystem ar=
e
>>>> functionally irrelevant,
>>>
>>> It is unfortunately not safe to make such a file system accessible to=

>>> other users, so the feature is not strictly read-only compatible.
>> If it's not safe WRT data integrity, then the design needs to be
>> reworked, as that directly implies that isn't safe for even every
>> day usage on a writable filesystem.
>
> This is exactly what we have *incompat feature flags for*: to
> protect old code that doesn't know about potentially dangerous new
> on-disk formats from trying to parse those formats and causing
> unpredictable bad things from happening.
However, unless things have changed (I haven't had time to re-read the=20
patch-set yet), then the only change will be a new set of xattrs, and=20
that type of change _shouldn't_ break existing code that doesn't know=20
about them. Andreas really needs to explain _exactly_ why it isn't safe=20
to mount this on a kernel that doesn't support it and let other users=20
access it, and if the answer is 'because the ACL's won't be honored'=20
then that really isn't acceptable reason IMHO, because (as I outlined in =

the previous e-mail) being able to mount the filesystem implies that=20
they have at least read access to the underlying storage, which means=20
that the ACL's in the filesystem are irrelevant as far as any competent=20
individual who is actively trying to illegitimately access the data is=20
concerned.
> Austin, your arguments hold no weight because they are no different
> to the considerations for any new on-disk feature: the user needs to
> have both kernel and userspace support to recover filesystems that
> go bad. If you are using a brand new fs/kernel feature, then it is
> expected that you know that your DR processes take this into
> account.
Except that the given argument from Andreas as to why it's an incompat=20
feature does not clarify whether it's to prevent breaking the existing=20
filesystem code (which I understand and agree is a proper usage for such =

a flag), or to try and provide some thin facade of security when there=20
really is none (which is what the bit about 'and expose it to other=20
users' really sounds like to me).  Yes the argument that I made which=20
you have replied to was admittedly shortsighted and didn't need to be=20
made to get the point that I was actually trying to make across, and I=20
sincerely apologize for that.




--------------ms010802090608060909070409
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDE5MTMxMjM0WjBPBgkq
hkiG9w0BCQQxQgRAmxOkF4plL1+dwwSYoBxHLizItbQwDrZjHhG9YUbOSe6ygHc0hiNJtVFK
Gaub22tFDKBLPwrAPce6uAazICXIWTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAvII814wRDy81RBAJMCIQY6ZG4Mi5WOHhz9sVic+8gAEJjNpP5
VTYhuVJokfgQ8YVIN5WTV4+8oEC9prO+QABhvUbKdJghrAafOiji+RHvPw53wO5ITMKLbZlY
ay0kXDIKRb5CAuLfNOEOrScZ/quNVSRb95hO7c7u0a+v54VYGgdLA7gkdHCGpiU0LWwMFqkQ
vajdy6jVj2JBftkTpBoki8eiK0PjTyp1PrSpnRq6P6bhGqwl6SirgyLbIzTBEG5BvKH8LEe/
wxRoky7aEEJUWnXwdCj8G+AZyFb2dvDjZnURihi8jpkPBH8HA7g6OE5pEsebUgiEr5dBpY/5
K7Ag0cXXvhfHBI8hSN2kFwBhbW7VAOATRf+uHjmAVRtDG52p2VWPfdmgaekpF1cqKZ0Ch8ym
twB+RNHFzWJkz3x0FDuXCgicjbkyehKZeuMPDrs/MuT/H3Y1C7twgftS8eLNDBJDDJB+/FgV
s/rKccEhbG7cgy71pa/8/3Uifg6rslx5QOKNyqLS+MESfEC16G1D6v26ocUAfLd3qsu5aevC
GAC8LBBxXTE7cFSibnC3ZVTQhxBrCMnfbBTe4VQBLNIZXwaLfiokw/SLjyTaMfYqt1s/l8i0
rJGcLE0Aw2SD1NI38lQzCFLlq4670K+mhszfc243K60zRrMy5ntEVvwEcQAAAAAAAA==
--------------ms010802090608060909070409--


--===============2409286779900194158==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2409286779900194158==--
