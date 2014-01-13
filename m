Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D9A929DF8
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 20:36:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68E27304053
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 18:36:08 -0800 (PST)
Received: from mail.uberzach.com (rondo.uberzach.com [64.22.125.169]) by
	cuda.sgi.com with ESMTP id vjDZHly6d5KlduAQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Jan 2014 18:36:07 -0800 (PST)
Received: from archer.uberzach.com (unknown
	[IPv6:2602:3f:e50d:7605:60c:ceff:fed3:ff7e])
	(Authenticated sender: profplump)
	by mail.uberzach.com (Postfix) with ESMTPSA id 8D0A258064
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 18:36:05 -0800 (PST)
From: Zachary Kotlarek <zach@kotlarek.com>
Message-Id: <EDB09149-717F-4089-9C21-1D342CF77A7D@kotlarek.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Date: Sun, 12 Jan 2014 18:36:03 -0800
References: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
	<52D2E358.6070106@hardwarefreak.com>
	<CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
	<20140113015007.GC3469@dastard>
In-Reply-To: <20140113015007.GC3469@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3502089654571298352=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3502089654571298352==
Content-Type: multipart/signed; boundary="Apple-Mail=_66F37279-2053-4319-AC27-5F705B2599B9"; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail=_66F37279-2053-4319-AC27-5F705B2599B9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Jan 12, 2014, at 5:50 PM, Dave Chinner <david@fromorbit.com> wrote:

>> Attempts to access the now-busted files/directories with accents in =
their paths result in a kernel log like:
>> Jan 11 02:05:39 vera XFS (dm-31): I/O error occurred: meta-data dev =
dm-31 block 0x3c8ff73e0       ("xfs_trans_read_buf") error 11 buf count =
4096
>=20
> error 11 =3D EAGAIN/EWOULDBLOCK
>=20
> That tends to imply that there's some interesting error occurring in
> the layers below XFS here.


The error you note only started showing up *after* the xfs_repair, and =
only when attempting to access the non-ascii file paths. It doesn=92t =
take the filesystem offline; other than those particular paths being =
inaccessible the filesystem seems to be working correctly (though I=92ve =
suspended user writes until this is worked out). The affected paths are =
all around the disk, all contain non-ascii characters in final portion =
of the path name, and do not affect other paths in the same directory.

I can find a newer kernel to boot off and see how it behaves if you =
think it would make any difference, but I=92m pretty sure xfs_repair =
re-wrote the affected directory entries and broke them as opposed to =
some sort of block-layer corruption being responsible for breaking only =
these files.

	Zach


--Apple-Mail=_66F37279-2053-4319-AC27-5F705B2599B9
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGGTCCBhUw
ggP9oAMCAQICAQEwDQYJKoZIhvcNAQEFBQAwgYsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApXYXNo
aW5ndG9uMRAwDgYDVQQHDAdTZWF0dGxlMRwwGgYDVQQKDBNaYWNoYXJ5IFAuIEtvdGxhcmVrMRUw
EwYDVQQDDAx1YmVyemFjaC5jb20xIDAeBgkqhkiG9w0BCQEWEXphY2hAa290bGFyZWsuY29tMB4X
DTEzMDgxMzAwMjMzM1oXDTE4MDgxMjAwMjMzM1owgZIxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApX
YXNoaW5ndG9uMRAwDgYDVQQHDAdTZWF0dGxlMRwwGgYDVQQKDBNaYWNoYXJ5IFAuIEtvdGxhcmVr
MRwwGgYDVQQDDBNaYWNoYXJ5IFAuIEtvdGxhcmVrMSAwHgYJKoZIhvcNAQkBFhF6YWNoQGtvdGxh
cmVrLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANL424NB+EzPp7/CqB/kxV+u
7MSpl9A8NlMqLldoPPJjpEwH9+4wfYrx+yUOBddih4WIgCD9NiF41+9tHu9gUqm+PZT8kdGXUIRP
fuQuwKyzAv0rSyydXBQD/Q/gRrFaEJvJ5wVUxgE51K/ugGATmyWTSeMwATOJR4qTs1u2dfxBliyR
xc2LCJCAgvuonwhfP1JprFYz+ycmlb/od3cAC5+8ggof5YJiitsUM6FPQtDykGPNWxhFnBwrVlQ+
vAxA1aT2v33C4MMK3hY3Ik8BUCZrAr4r/eWDSCBmcQydoawrUllAzEsVuozYqOW+EwbFp9RFDAZZ
UZH/pMSEK5v2yQcf2m3zx4+9S5fLbvX660DFY90C1GSt9MyDjfpgx+Mtx7RtJI2abcei2PEXt38p
U2aLypsHWsdloWhouzM4JpTkDXqCyUOm5hkUPgMdOXKHY5jCj0e7ok/Rknty7fJjolo4uyOKfJHQ
cjoU1xuzA8ob0i8zufIL03FUK72dWL7xyAGjRs4Hsa6xd/SbPYGvYHJ2afxLeTDPZwzrLErxn9no
E0wkAPnV0MfYbB+0Y/+Xaa2KIUflawzh3iQVkohrzmE9PU3gjiQJ9UqYtvx8HrUK2eEjCRinnSd5
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
2UTLEen9yAAAAAAAAA==

--Apple-Mail=_66F37279-2053-4319-AC27-5F705B2599B9--


--===============3502089654571298352==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3502089654571298352==--
