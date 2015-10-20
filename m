Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2D64C7F6C
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2015 07:34:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0633F8F8035
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2015 05:34:37 -0700 (PDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com
	[209.85.223.175]) by cuda.sgi.com with ESMTP id
	9Hqmvspv1nBpoWK4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Oct 2015 05:34:35 -0700 (PDT)
Received: by iofz202 with SMTP id z202so19881485iof.2
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2015 05:34:34 -0700 (PDT)
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
	<5624ED40.7040206@gmail.com>
	<CAHc6FU4CVQAn6TCQzC8r9m9URmqD_eHQBwhDK2o_o4eb3myW=A@mail.gmail.com>
	<5625182C.3050007@gmail.com>
	<CAHc6FU75GXGeav1ho-QraPS_F8fpOXnoDyv17+b=koiF=9YE5A@mail.gmail.com>
	<56253A35.4070309@gmail.com>
	<CAHc6FU4jcatmY+A39oQb-2x9Gs8WFVsXOD_9eBV=_fgNzZx3Xg@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <562634B2.30209@gmail.com>
Date: Tue, 20 Oct 2015 08:33:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAHc6FU4jcatmY+A39oQb-2x9Gs8WFVsXOD_9eBV=_fgNzZx3Xg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1381062868233193127=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This is a cryptographically signed message in MIME format.

--===============1381062868233193127==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040606010009020500030007"

This is a cryptographically signed message in MIME format.

--------------ms040606010009020500030007
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-19 16:20, Andreas Gruenbacher wrote:
> On Mon, Oct 19, 2015 at 8:45 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-10-19 13:33, Andreas Gruenbacher wrote:
>>> Please spare me with all that nonsense. Compared to mount options,
>>> filesystem feature flags in this case simplify things (you don't have=

>>> to specify whether a filesystem contains POSIX ACLs or richacls), and=

>>> they prevent administrator errors: when a filesystem mounts, it is
>>> safe to use; when it doesn't, it is not. That's all there is to it.
>>
>> You're ignoring what I'm actually saying. I've said absolutely nothing=

>> about needing to use mount options at all, and I'm not arguing against=
 using
>> filesystem feature flags, I'm arguing for using them sensibly in a way=
 that
>> does not present a false sense of security.
>
> We could be on a multi-user system, and the user mounting the
> filesystem may not be the only user on the system. When a filesystem
> can be mounted read-only, it should be safe to use read-only. It is
> not safe in general to use such a filesystem read-only, so an
> incompatible feature flag which prevents such unsafe mounting is more
> approporiate than a read-only incompatible feature flag.
Except that mounting a filesystem that wasn't created on the system=20
mounting it always has that exact same risk, because (AFAIK) all=20
Linux/BSD/Other UNIX filesystems store GID's and UID's as numbers, not=20
names.  Perfect example of this, take a minimal install of some Linux=20
distribution, install a couple of packages that add new UID's, and mount =

the root filesystem on a completely different distribution (say mount a=20
Debian root filesystem on a Gentoo box), any of the new UID's from the=20
first system will almost certainly not map to the same user on the=20
second system (in fact, you can also do this with two Gentoo systems=20
where the packages were installed in different orders).  This is a=20
really basic security risk that any seasoned sysadmin should know, and=20
most new ones find out about rather quickly.

Also, based on established context of _every_ other feature with an=20
incompat feature flag in both ext4 and XFS, 'safe' means that you can=20
get the correct file contents off of the filesystem,and don't run the=20
risk of crashing the system, not that you have no risk of compromising=20
security.
> Mounting a filesystem read-only doesn't mean that the filesystem is
> being recovered, it is perfectly legal to mount a filesystem read-only
> for other reasons. I don't want to give people using read-only
> filesystems the false sense that everything is okay.
Yes, and this is why any sane filesystem will spit a warning out through =

dmesg when a mount is forced read-only because of incompatible features. =

  If someone is actively mounting such a filesystem read-only (that is,=20
they've specified 'ro' in the mount options), then it's relatively safe=20
for the kernel to assume they are doing so for some very specific reason =

and/or already know about the data safety implications.
>
>> Making it an incompatible flag will likely cause headaches for some
>> legitimate users,
>
> Indeed. It will also make it less likely for users to accidentally
> shoot themselves in the foot. If someone knows better, they can clear
> the feature flag.
Except there will be a lot of people who think they know better but=20
really don't.  Such people will do this anyway, and by modifying the=20
filesystem run a bigger risk of shooting themselves in the foot (because =

they'll almost certainly mount the filesystem read-write, and then end=20
up turning on richacls again).  You're not removing the gun, you're just =

hiding a potentially bigger one somewhere else.

It's a separate issue entirely however whether or not you absolutely=20
need to know that the richacls have the correct syntax in a recovery=20
situation.  Fsck doesn't parse SELinux labels, (AFAIK) doesn't parse=20
filecaps attributes (bad filecaps syntax will only make things have=20
fewer privileges, but it will cause user visible brokenness), (again,=20
AFAIK) doesn't validate POSIX ACL's, and absolutely doesn't check IMA or =

EVM hashes.  IMA and EVM hashes being wrong _will_ cause almost any=20
system actually using them they way they are intended to fail to boot,=20
and incorrect SELinux labeling will make many systems not boot=20
correctly, and both situations are much worse for a significant majority =

of users than a (security leak due to a bad ACL.
>
> When recovering a broken system that contains richacl filesystems, you
> really want to have richacl support in the rescue system as well.
> Otherwise, you won't be able to fsck those filesystems.
While it's something that 'should' be the case, there are probably quite =

a few people who will not realize this until they're already in a=20
situation that they need to recover data.  On top of that some people=20
will likely assume that they just need richacl support in userspace for=20
their recovery environment.
>
>> and at most delay competent hackers by a few seconds to a
>> few minutes, and script kiddies by a few hours, and is really no bette=
r than
>> security by obscurity (and from a purely logistical standpoint, that's=
 _all_
>> it is) in that it actively tries to hide the fact that someone having =
read
>> access to the storage the filesystem is on can bypass the ACL's.
>>
>> To reiterate, if someone can call mount() on a filesystem, and mount()=
 does
>> not return -EPERM, then even if mount() returns a different error, the=
y
>> still have the ability to completely bypass all permissions and ACL's =
in
>> that filesystem, because they have the ability to read the entire file=
system
>> directly.
>>
>> The _only_ way to properly protect against people bypassing the ACL's =
is to
>> use full disk encryption and lock down root access on the system, and =
even
>> that can't completely prevent it from happening.
>
> That's all completely beside the point. I'm not talking about
> preventing attacks at all, just basic administrative workflows.
While that may be the case, there will be people who assume that because =

it's an incompat feature, their ACL's will _always_ be enforced.  Such=20
people should admittedly not be allowed to run systems with any real=20
world security requirements, but that mentality is something that still=20
needs to be considered, and this is arguably making it easier for them=20
to shoot themselves in the foot.


--------------ms040606010009020500030007
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIwMTIzMzU0WjBPBgkq
hkiG9w0BCQQxQgRAj1L+Syg4dbUYi2qcwmE+jNm5rTyYPrSY5Ob8jRK38O9LlayAfHOj9jb8
SEf1wFoaPsAGxvubcBrHDkkKizb5cjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCWWuFoUTqUSz3x3mcTcR+lwaVb2l1uaKJ+t2BrrztgX2LuV6bR
W5Bu+AZ5fiuCz0DkRWPTLylUlHpRhcMxbWk+K1fdwIoQ4eahjhm7IGJxCgKtl5RXhV9wQC3Q
Epb/iIZbbRVQE/BjZKayDRlJlQTUxVGm6rq8eK2xK93KLraCKpDkXm8bE2bjzq4pcj0l1+6g
+EcnJXt+lTVlgdiUO8iEtXbsl+JNldmLY2PFSWvHWjZmk9Io6qIABx5usfQwro7/g9WZng7N
WzsyAHDo4OM4+wjo7hKf6jlrCTAhq2TYqJ0xfbM4qh+2NX3IE5scQxX+Tawrq729onQ+6uN9
UvZOCljtOKWJPshwWQgWBnJk84ijIp55KYTyWwfdMFhzQxcU0MRh5gaKD8AhPAW/dY3yyhaT
alt8FA1BkOLb1XwC1AfTZ9LSiK4aB2x9RNl1P671wl1e81zrzBXde04EsSs38hIZFbooxXc7
NANxTEmDhKX85MRll75lDLU7sQCajx8BtYEfbSvHwh6Fs2d6DuBamBcQbL9sEK8Vu29S7CYB
No/SBmsFRim1bLpAhUIRNo/7FnYt112SVUIVp+vpnZpybjCpz4vproYMhMiJBeXYxSVPFjGd
AKxZRXd2s2IMc5LukNGsVk0AyBn/jtY5Jg1l1YcUKoVY6W14hA2IxbbNHwAAAAAAAA==
--------------ms040606010009020500030007--


--===============1381062868233193127==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1381062868233193127==--
