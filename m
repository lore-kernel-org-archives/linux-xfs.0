Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sequoia-grove.ad.secure-endpoints.com ([208.125.0.235]:57210
        "EHLO smtp.secure-endpoints.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756368AbdLPQdq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Dec 2017 11:33:46 -0500
Subject: Re: [PATCH v2 05/19] afs: convert to new i_version API
References: <20171216134656.15561-1-jlayton@kernel.org>
 <20171216134656.15561-6-jlayton@kernel.org>
 <1513432186.3428.6.camel@kernel.org>
From: Jeffrey Altman <jaltman@auristor.com>
Message-ID: <82157aa3-ec0b-25e6-517b-704a3f81ec61@auristor.com>
Date: Sat, 16 Dec 2017 11:18:41 -0500
MIME-Version: 1.0
In-Reply-To: <1513432186.3428.6.camel@kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030408000205080100010300"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

This is a cryptographically signed message in MIME format.

--------------ms030408000205080100010300
Content-Type: multipart/mixed;
 boundary="------------C920308AD3530271D6778AFC"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------C920308AD3530271D6778AFC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

A few thoughts on AFS usage below which might impact a future revision
of the API.  I hope they are useful.

On 12/16/2017 8:49 AM, Jeff Layton wrote:
> On Sat, 2017-12-16 at 08:46 -0500, Jeff Layton wrote:
>> From: Jeff Layton <jlayton@redhat.com>
>>
>> For AFS, it's generally treated as an opaque value, so we use the
>> *_raw variants of the API here.
>>
>> Note that AFS has quite a different definition for this counter. AFS
>> only increments it on changes to the data, not for the metadata. We'll=

>> need to reconcile that somehow if we ever want to present this to
>> userspace via statx.
>>

=46rom the patch series notes:

"The inode->i_version field is supposed to be a value that changes
whenever there is any data or metadata change to the inode. Some
filesystems use it internally to detect directory changes during
readdir. knfsd will use it if the filesystem has MS_I_VERSION set. IMA
will also use it to optimize away some remeasurement if it's available.
NFS and AFS just use it to store an opaque change attribute from the
server.

"Only btrfs, ext4, and xfs increment it for data changes. Because of
this, these filesystems must log the inode to disk whenever the
i_version counter changes. That has a non-zero performance impact,
especially on write-heavy workloads, because we end up dirtying the
inode metadata on every write, not just when the times change. [1]"


The AFS/AuriStorFS data version is an unsigned 64-bit value that is
incremented by the file server as part of a data changing operation. For
files, a StoreData and for directories entry manipulations such as
create, rename, delete.  This data version is used to tag the version of
any subset of the data stream for caching and replication purposes.

As Jeff notes, the AFS data version is not incremented for metadata
changes.  Metadata cannot be trusted by clients without acquiring a
callback promise from a fileserver.  The callback promise will either be
satisfied by the issuing fileserver sending a CallBack notification that
the metadata is no longer valid OR the callback promise will expire.

Something else that is important to note that it is assumed that local
data changes that occur under a valid callback promise is newer than the
data on the fileserver.  It might be useful if the new i_version API
supported major and minor version numbers.  AFS implementations would
store the fileserver provided data version number as the major version
and would increment the minor version when local changes have been made
which have yet to be stored back to the fileserver.  This functionality
would be especially useful if disconnected operations were implemented
for the AFS implementation.

It might also be useful to separate metadata version and data version
although some filesystems would set the same value to both.  For AFS,
the metadata major version would the timestamp at which the callback was
issued.

Jeffrey Altman

--------------C920308AD3530271D6778AFC
Content-Type: text/x-vcard; charset=utf-8;
 name="jaltman.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="jaltman.vcf"

begin:vcard
fn:Jeffrey Altman
n:Altman;Jeffrey
org:AuriStor, Inc.
adr:Suite 6B;;255 West 94Th Street;New York;New York;10025-6985;United St=
ates
email;internet:jaltman@auristor.com
title:Founder and CEO
tel;work:+1-212-769-9018
note;quoted-printable:LinkedIn: https://www.linkedin.com/in/jeffreyaltman=
=3D0D=3D0A=3D
	Skype: jeffrey.e.altman=3D0D=3D0A=3D
=09
url:https://www.auristor.com/
version:2.1
end:vcard


--------------C920308AD3530271D6778AFC--

--------------ms030408000205080100010300
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DIIwggXpMIIE0aADAgECAhBAAV7gPRitcrlGsJTzkwjvMA0GCSqGSIb3DQEBCwUAMDoxCzAJ
BgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQgQ0EgQTEy
MB4XDTE3MTAwMzAzMTczM1oXDTE4MTEwMzAzMTczM1owgYUxLTArBgNVBAsMJFZlcmlmaWVk
IEVtYWlsOiBqYWx0bWFuQGF1cmlzdG9yLmNvbTEjMCEGCSqGSIb3DQEJARYUamFsdG1hbkBh
dXJpc3Rvci5jb20xLzAtBgoJkiaJk/IsZAEBEx9BMDE0MjdFMDAwMDAxNUVFMDNEMTg3QTAw
MDA0QUE1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqqJC89ZA1DSS7t/Ug8Dd
BQv5nBDumInWtFvHwVCORitVCvlkX4SfqKpERATq0eHOSc0zEz1PUjhAT8lgbNj8Bs92pL9t
DW/VHHpq11w06rCEmZJNxgErAIvMpRuAhGrzvBpQBLj8nDArHWw+5nRn/KnK7ZO81LEEj4TG
w0PEKGSa0aFA+JdRTJ6BZSDP2o/8AHx+Bw4JgW8VppAe4IuY/F+JoYtyQDL+fm1YMnFMtf1A
6IvlGXD7gMksPRbVIfD+QpHZbQvNXZAVVDaCWZuWQq46Vl4lSlkmW9yMlGddvFGl2zSMK7ny
f0kbWJLw9lZxXDegY0/ciJPACPsyBwuyLwIDAQABo4ICnTCCApkwDgYDVR0PAQH/BAQDAgWg
MIGEBggrBgEFBQcBAQR4MHYwMAYIKwYBBQUHMAGGJGh0dHA6Ly9jb21tZXJjaWFsLm9jc3Au
aWRlbnRydXN0LmNvbTBCBggrBgEFBQcwAoY2aHR0cDovL3ZhbGlkYXRpb24uaWRlbnRydXN0
LmNvbS9jZXJ0cy90cnVzdGlkY2FhMTIucDdjMB8GA1UdIwQYMBaAFKRz2u9pNYp1zKAZewgy
+GuJ5ELsMAkGA1UdEwQCMAAwggEsBgNVHSAEggEjMIIBHzCCARsGC2CGSAGG+S8ABgsBMIIB
CjBKBggrBgEFBQcCARY+aHR0cHM6Ly9zZWN1cmUuaWRlbnRydXN0LmNvbS9jZXJ0aWZpY2F0
ZXMvcG9saWN5L3RzL2luZGV4Lmh0bWwwgbsGCCsGAQUFBwICMIGuGoGrVGhpcyBUcnVzdElE
IENlcnRpZmljYXRlIGhhcyBiZWVuIGlzc3VlZCBpbiBhY2NvcmRhbmNlIHdpdGggCklkZW5U
cnVzdCdzIFRydXN0SUQgQ2VydGlmaWNhdGUgUG9saWN5IGZvdW5kIGF0IGh0dHBzOi8vc2Vj
dXJlLmlkZW50cnVzdC5jb20vY2VydGlmaWNhdGVzL3BvbGljeS90cy9pbmRleC5odG1sMEUG
A1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly92YWxpZGF0aW9uLmlkZW50cnVzdC5jb20vY3JsL3Ry
dXN0aWRjYWExMi5jcmwwHwYDVR0RBBgwFoEUamFsdG1hbkBhdXJpc3Rvci5jb20wHQYDVR0O
BBYEFNefZrPaqPUvaS6V6kAmHDwFhoDiMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
BDANBgkqhkiG9w0BAQsFAAOCAQEAKlssrfOJ5+WwHyhFSeSsioN0qpg2QDX/uvodF38JbquO
1U0my0j3Cc/bwk48++bjzp0Fvk/Kkcmss5/6zzJMjr9rf12QCQfKkbO9nMm8Bg6IP3pYgk0W
/F1h3ZQF3OgBn3zZoOd3f1a6dF6z12MqKA/2g5GKrQFxkdzTGrNw6ISE9uY8ysvc3i2N2kas
HNi5Etk7StZ1jvFX5sQMIeNdlF+z+BU/AyT7NoBS4gCH+ggF+DG7fAYywvy42Lfu8p6kopKT
5JZpYce1cNjnOaDhzhgeR+oXxoDbekF27JinXHQSKjBxhujcZu5leAkpctFpZxnIKZJZUBiu
31Nm7xYaijCCBpEwggR5oAMCAQICEQD53lZ/yU0Md3D5YBtS2hU7MA0GCSqGSIb3DQEBCwUA
MEoxCzAJBgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxJzAlBgNVBAMTHklkZW5UcnVz
dCBDb21tZXJjaWFsIFJvb3QgQ0EgMTAeFw0xNTAyMTgyMjI1MTlaFw0yMzAyMTgyMjI1MTla
MDoxCzAJBgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQg
Q0EgQTEyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0ZFNPM8KJzSSrkvpmtQl
a3ksT+fq1s9c+Ea3YSC/umUkygSm9UkkOoaoNjKZoCx3wef1kwC4pQQV2XHk+AKR+7uMvnOC
Iw2cAVUP0/Kuy4X6miqaXGGVDTqwVjaFuFCRVVDTQoI2BTMpwFQi+O/TjD5+E0+TAZbkzsB7
krk4YUbA6hFyT0YboxRUq9M2QHDb+80w53b1UZVO1HS2Mfk9LnINeyzjxiXU/iENK07YvjBO
xbY/ftAYPbv/9cY3wrpqZYHoXZc6B9/8+aVCNA45FP3k+YuTDC+ZrmePQBLQJWnyS/QrZEdX
saieWUqkUMxPQKTExArCiP61YRYlOIMpKwIDAQABo4ICgDCCAnwwgYkGCCsGAQUFBwEBBH0w
ezAwBggrBgEFBQcwAYYkaHR0cDovL2NvbW1lcmNpYWwub2NzcC5pZGVudHJ1c3QuY29tMEcG
CCsGAQUFBzAChjtodHRwOi8vdmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL3Jvb3RzL2NvbW1l
cmNpYWxyb290Y2ExLnA3YzAfBgNVHSMEGDAWgBTtRBnA0/AGi+6ke75C5yZUyI42djAPBgNV
HRMBAf8EBTADAQH/MIIBIAYDVR0gBIIBFzCCARMwggEPBgRVHSAAMIIBBTCCAQEGCCsGAQUF
BwICMIH0MEUWPmh0dHBzOi8vc2VjdXJlLmlkZW50cnVzdC5jb20vY2VydGlmaWNhdGVzL3Bv
bGljeS90cy9pbmRleC5odG1sMAMCAQEagapUaGlzIFRydXN0SUQgQ2VydGlmaWNhdGUgaGFz
IGJlZW4gaXNzdWVkIGluIGFjY29yZGFuY2Ugd2l0aCBJZGVuVHJ1c3QncyBUcnVzdElEIENl
cnRpZmljYXRlIFBvbGljeSBmb3VuZCBhdCBodHRwczovL3NlY3VyZS5pZGVudHJ1c3QuY29t
L2NlcnRpZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRtbDBKBgNVHR8EQzBBMD+gPaA7hjlo
dHRwOi8vdmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NybC9jb21tZXJjaWFscm9vdGNhMS5j
cmwwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMA4GA1UdDwEB/wQEAwIBhjAdBgNV
HQ4EFgQUpHPa72k1inXMoBl7CDL4a4nkQuwwDQYJKoZIhvcNAQELBQADggIBAA3hgq7S+/Tr
Yxl+D7ExI1Rdgq8fC9kiT7ofWlSaK/IMjgjoDfBbPGWvzdkmbSgYgXo8GxuAon9+HLIjNv68
BgUmbIjwj/SYaVz6chA25XZdjxzKk+hUkqCmfOn/twQJeRfxHg3I+0Sfwp5xs10YF0Robhrs
CRne6OUmh9mph0fE3b21k90OVnx9Hfr+YAV4ISrTA6045zQTKGzb370whliPLFo+hNL6XzEt
y5hfdFaWKtHIfpE994CLmTJI4SEbWq40d7TpAjCmKCPIVPq/+9GqggGvtakM5K3VXNc9VtKP
U9xYGCTDIYoeVBQ65JsdsdyM4PzDzAdINsv4vaF7yE03nh2jLV7XAkcqad9vS4EB4hKjFFsm
cwxa+ACUfkVWtBaWBqN4f/o1thsFJHEAu4Q6oRB6mYkzqrPigPazF2rgYw3lp0B1gSzCRj+j
RtErIVdMPeZ2p5Fdx7SNhBtabuhqmpJkFxwW9SBg6sHvy0HpzVvEiBpApFKG1ZHXMwzQl+pR
8P27wWDsblJU7Qgb8ZzGRK9l5GOFhxtN+oXZ4CCmunLMtaZ2vSai7du/VKrg64GGZNAKerEB
evjJVNFgeSnmUK9GB4kCZ7U5NWlU+2H87scntW4Q/0Y6vqQJcJeaMHg/dQnahTQ2p+hB1xJJ
K32GWIAucTFMSOKLbQHadIOiMYIDFDCCAxACAQEwTjA6MQswCQYDVQQGEwJVUzESMBAGA1UE
ChMJSWRlblRydXN0MRcwFQYDVQQDEw5UcnVzdElEIENBIEExMgIQQAFe4D0YrXK5RrCU85MI
7zANBglghkgBZQMEAgEFAKCCAZcwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMTcxMjE2MTYxODQxWjAvBgkqhkiG9w0BCQQxIgQgvVGtquTGouNy9HwKKkKB
t2x/iGviJYj/i1Nn76rNBUgwXQYJKwYBBAGCNxAEMVAwTjA6MQswCQYDVQQGEwJVUzESMBAG
A1UEChMJSWRlblRydXN0MRcwFQYDVQQDEw5UcnVzdElEIENBIEExMgIQQAFe4D0YrXK5RrCU
85MI7zBfBgsqhkiG9w0BCRACCzFQoE4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5U
cnVzdDEXMBUGA1UEAxMOVHJ1c3RJRCBDQSBBMTICEEABXuA9GK1yuUawlPOTCO8wbAYJKoZI
hvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqG
SIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDANBgkq
hkiG9w0BAQEFAASCAQCKNfbllIxdkvs7e30L/5yqAGXkpp/kIUy727/11gO+TGSgzD8D3obD
ZxkgPnilK7H2DvhOH7p8R5sNcBhg9NN3+Jv6yfQ15Vz8BgZxbJ6kwLn3nLPb1NME7Icxq5hX
lTFJ/d+F3eJ7htBo9HOBHIL+gixl2oBua24mce4FLCQyBJ0gKzKz5eOPA6EPk45Q3bZaD/Ga
xsK2NRbFOCSG+SQ50mHCGG1ve2BrnCvYIjUH6CTWu6/FBNtdKNbveTaHoA8oQZw4+etqMNaS
22+D2tICxUY+h42n2km7xvj2333My+NemYlc1K1onsGzPX9RMAh2j1vf4QU/6aGolYJxrhfN
AAAAAAAA
--------------ms030408000205080100010300--

