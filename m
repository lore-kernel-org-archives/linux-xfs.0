Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 07CB97F47
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 20:01:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8F01304039
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 18:01:16 -0800 (PST)
Received: from mailgw-02.dd24.net (mailgw-02.dd24.net [193.46.215.43]) by
	cuda.sgi.com with ESMTP id 769ZDWEqrWQFC1JE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Dec 2015 18:01:10 -0800 (PST)
Message-ID: <1450404066.6498.70.camel@scientia.net>
Subject: Re: Ideas on unified real-ro mount option across all filesystems
From: Christoph Anton Mitterer <calestyo@scientia.net>
Date: Fri, 18 Dec 2015 03:01:06 +0100
In-Reply-To: <5673616C.1040706@cn.fujitsu.com>
References: <567212DA.8050808@cn.fujitsu.com> <567228EF.80007@redhat.com>
	<5673616C.1040706@cn.fujitsu.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4461633922730749002=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, btrfs <linux-btrfs@vger.kernel.org>, kzak@redhat.com
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com


--===============4461633922730749002==
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-pLbtHkHbOhtxRxXh8LCr"


--=-pLbtHkHbOhtxRxXh8LCr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-12-18 at 09:29 +0800, Qu Wenruo wrote:
> Given that nothing in the documentation implies that the block
> > device itself
> > must remain unchanged on a read-only mount, I don't see any problem
> > which
> > needs fixing.=C2=A0=C2=A0MS_RDONLY rejects user IO; that's all.
>=20
> And thanks for the info provided by Karel, it's clear that at least=C2=A0
> mount(8) itself already has explain on what ro will do and what it
> won't do.

I wouldn't really agree, here. At least not from the non-developer side
(and one should hope filesystems and their manpages aren't only made
for fs-devlopers).

The manpage says:
> ro=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Mount the filesystem read-only.
> rw=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Mount the filesystem read-write.

IMHO, that leaves absolutely unclear, what this actually means,
especially given that most end-users will probably consider the
filesystem and its device being basically "the same".

Especially, "the filesystem read-only", does not imply at all, whether
this property means "anything accessed via the filesystem", where the
filesystem would be the interface to the data, so that would mean, that
users cannot change files, their properties, permissions, xattrs, acls,
*time, and of course contents of any files,... nor whether it means
"the filesystem as the full number of bytes that comprise the
filesystem", which would include anything that is hidden from the user
(like journals etc.).

In fact, though I know it's not the case in practise, alone from the
wording above, which uses "filesystem", I'd rather tend to says that
this includes any hidden structures and that "ro" in fact means, that
the filesystem driver doesn't change the filesystem (in other words, no
writes to the device, from the fs).

=46rom what the mount option "ro" actually means, I'd rather expect that
the manpage should read:
> ro=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Mount the filehierarchy read-only.


I do not dispute, that it makes sense to have a soft "ro" which just
means that the exported file-hierarchy is read-only.
But similarly it makes sense to have a "hard ro", which means, that the
filesystem doesn't do any writes. That implies of course the soft ro,
but also means, no journal replays, no mount time updates, no rebuilds
in case of multi-device setups.


This may be helpful in several situations (when doing device backups
from mounted filesystems, in any disaster recovery or forensic
situation).
Now people may argue, that there's blockdev --setro, which is true of
course,... but a) I'd now quite some people whom I'd consider not to be
totally stupid end-users and who'd, by the above documentation of "ro"
assume that there are no changes on the block device, and b) it may be
helpful for the filesystem driver itself, to not even try to do writes
(and then error out), but from the beginning be in a I-don't-wanna-
write-mode.


As it has been discussed by some people on linux-btrfs, norecovery, no
load, nologreplay or whatever options there are, which *currently* make
certain fs types behave like that, i.e. make them "hard ro", are not
that suited, neither from their name, nor from their semantics.
"nologreplay" may be the option that *right now* makes btrfs not
writing to the device, but in 5 years other features may have been
introduced which would also people require to add the mountoption
"nofoobarmagic".
For normal users, not following each commit of development (and who
certainly don't read the manpage every day again, not to talk that
these often are ambiguous or outdated), a option which is defined to
imply everything that's necessary to make the filesystem not touch its
underlying devices seems quite reasonable.

I myself had proposed the name "nodevwrites" (or something like that)
over at linux-btrfs, since that seems the semantics that were desired
(plus it's, AFAICS, not used already).
It could be commonly "reserved" for that purpose, and each filesystem
type that wants to support it could make it imply everything needed to
make mounts of that filesystem truly read-only in the sense of "do not
change a single bit on the device".
Doesn't seem to be a too invasive change, and seems worth it.

And obviously, such a option that means "hard ro", should per
definition include noatime (just in the case there are filesystems
left, which would update the atimes even when mounted "ro").


Oh and I'd actually think, that changing the mount(8) manpage to use
"file-hierarchy" instead of "filesystem" and perhaps loosing a short
sentence what this actually means (something like "no file data
changes, no permissions, owners, acls, xattrs, [a|m|c|*]time changes -
but especially any other fs internal changes are still allowed").


Cheers,
Chris.
--=-pLbtHkHbOhtxRxXh8LCr
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEZIw
ggW/MIIDp6ADAgECAgMCOakwDQYJKoZIhvcNAQENBQAwVDEUMBIGA1UEChMLQ0FjZXJ0IEluYy4x
HjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0IENsYXNzIDMg
Um9vdDAeFw0xNDA2MTIxNjM2MThaFw0xNjA2MTExNjM2MThaMHwxITAfBgNVBAMTGENocmlzdG9w
aCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50aWEubmV0MTEw
LwYJKoZIhvcNAQkBFiJtYWlsQGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4phP/j9vT9dZT+k3ffHxvRWMOuzBnu5O3Fl4y2+WL7pL
rfLiEhWzGXhHvjSqpt4vCNSdqy43453nnu8+hMb+uEtqSIL1AHU5eLhuDNVN9S4bt9E7nA2WKYBU
LCUi/xCD/GL7ToyJNwhrhzcCZ7pXSc3xVqFoC4f6weU9ExhoEZQNRpTM0BFCOi4fRxvKFNnUYgjK
hqy0Ta5H0Xx86mAp0Q4dxoD7mhI5iTF6TRkUheELxF24JCuAf04M89Cwft6DRH1FpJ3yvgW2B5U5
aFSL4ZnF4N/wyCB7Dkm1rQ7RCAvw5btkf0VdPnU7ccDCx8HEc2nxK/lbCjrznvh3sa1CCwIDAQAB
o4IBcDCCAWwwDAYDVR0TAQH/BAIwADBWBglghkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNl
cnRpZmljYXRlIGZvciBGUkVFIGhlYWQgb3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYD
VR0PAQH/BAQDAgOoMEAGA1UdJQQ5MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYK
KwYBBAGCNwoDAwYJYIZIAYb4QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDov
L29jc3AuY2FjZXJ0Lm9yZzA4BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLmNhY2VydC5vcmcv
Y2xhc3MzLXJldm9rZS5jcmwwRAYDVR0RBD0wO4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0gSJtYWls
QGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMA0GCSqGSIb3DQEBDQUAA4ICAQBefctiLgGl
e5baspuozyA4k7Up7SVhGHbif6pQfoFc/9Thx9GXnYpX+U64PMyWBfWwHZIy52Vg0RVkvPi1t6mi
GyBfoSpC6ooR0bKWtUIogw/ymqKWlTLVR8kbLqRmRk4juMtCXG2K3yMygX/rjkuUSuFj2Bjpkmzg
CtMojbUMYbszePmhQ7DJ62YEdtKpcjN94QAsI5GWlIAbs3KJazAcaNCRJeXCLcUMchyKHJA+NXH5
az/ekBxBMBzJP2An20PP88UI4JW18z31KiG9UVGa2uO4l4aWgVe2GnhNEdCD/o48msJEWKAt5vl2
yMqr7ihmNPocU2+/FW0xPe/vftdOTD9pgXdSGf4prdD+23q2YvpalOCzr2p8yCJZNVBPMxAP4mL0
3OEktXza4wohqAmceXKfGUNwRGBaPvtIGnPrpLhCQ+2YJDg8g1UEsk23bKyZlJWeKJyVqOBsDJmj
aBsN/qKhQFnav+zQdqGhMeaSisF/53mD3gyVYg2JRl18apgGbg32kyLmomqa0JbhnY3Dc3FVtZfe
+P+s2Cyep3pVKvFer2llRoGm8TwraG5Yhyx8Oq/1qETpstjbURJOVBLDCV4AjOEUj0ZnE/tEo/DK
yexgGaViNvjp+IZdFdJhYmsVjw4Q3vG7O0pfsLiYEyQjeDgjNEWDfa5/MufPywIfxzCCBb8wggOn
oAMCAQICAwI5qTANBgkqhkiG9w0BAQ0FADBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UE
CxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290MB4X
DTE0MDYxMjE2MzYxOFoXDTE2MDYxMTE2MzYxOFowfDEhMB8GA1UEAxMYQ2hyaXN0b3BoIEFudG9u
IE1pdHRlcmVyMSQwIgYJKoZIhvcNAQkBFhVjYWxlc3R5b0BzY2llbnRpYS5uZXQxMTAvBgkqhkiG
9w0BCQEWIm1haWxAY2hyaXN0b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDimE/+P29P11lP6Td98fG9FYw67MGe7k7cWXjLb5Yvukut8uISFbMZ
eEe+NKqm3i8I1J2rLjfjneee7z6Exv64S2pIgvUAdTl4uG4M1U31Lhu30TucDZYpgFQsJSL/EIP8
YvtOjIk3CGuHNwJnuldJzfFWoWgLh/rB5T0TGGgRlA1GlMzQEUI6Lh9HG8oU2dRiCMqGrLRNrkfR
fHzqYCnRDh3GgPuaEjmJMXpNGRSF4QvEXbgkK4B/Tgzz0LB+3oNEfUWknfK+BbYHlTloVIvhmcXg
3/DIIHsOSbWtDtEIC/Dlu2R/RV0+dTtxwMLHwcRzafEr+VsKOvOe+HexrUILAgMBAAGjggFwMIIB
bDAMBgNVHRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNh
dGUgZm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEEAYI3
CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC5j
YWNlcnQub3JnMDgGA1UdHwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuY2FjZXJ0Lm9yZy9jbGFzczMt
cmV2b2tlLmNybDBEBgNVHREEPTA7gRVjYWxlc3R5b0BzY2llbnRpYS5uZXSBIm1haWxAY2hyaXN0
b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwDQYJKoZIhvcNAQENBQADggIBAF59y2IuAaV7ltqym6jP
IDiTtSntJWEYduJ/qlB+gVz/1OHH0Zedilf5Trg8zJYF9bAdkjLnZWDRFWS8+LW3qaIbIF+hKkLq
ihHRspa1QiiDD/KaopaVMtVHyRsupGZGTiO4y0JcbYrfIzKBf+uOS5RK4WPYGOmSbOAK0yiNtQxh
uzN4+aFDsMnrZgR20qlyM33hACwjkZaUgBuzcolrMBxo0JEl5cItxQxyHIockD41cflrP96QHEEw
HMk/YCfbQ8/zxQjglbXzPfUqIb1RUZra47iXhpaBV7YaeE0R0IP+jjyawkRYoC3m+XbIyqvuKGY0
+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
AukCAQEwWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCOakwDQYJYIZIAWUDBAIDBQCg
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIxODAyMDEw
NlowTwYJKoZIhvcNAQkEMUIEQDUBUwspPgyE3f07VFdyU7Fra9oldd5wE95DxOzyWScf6iquUt0C
/JGgyfhG118gcc1ZGtBc5ETE1RnxxLp2E2IwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQBcEbEv3RFknkuuPP/TSSYZlPXLvjA/
oV7YBl/S9WfiwaYe4qNSG6pfYCc+d7PCHo8hj41cYfTygmz8MznYIHbBWM+zpbp7LW87Cxudr0HI
wT6hRmiOdpt1X4R7R6Fg9zZn7K45zmchLyRtKjbTqvPDhpYUR/7NcyvcTC6PnhDfHUwszLj807r3
5qIwCxYhM7EFs6HeuLCfRfufMtjCO74B6pfsHb28vp9T8NAFk0c5I/ZNWaaW8gcBHsiz8pghzGFT
pCyUPzhL0mOZuy/CgDIbJE3sr8l7xDbaIQJP2SM7Ba2kMG5cZiW8GzayPBEir8VnoZ+1GclqzQyQ
rstNdE99AAAAAAAA


--=-pLbtHkHbOhtxRxXh8LCr--


--===============4461633922730749002==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4461633922730749002==--
