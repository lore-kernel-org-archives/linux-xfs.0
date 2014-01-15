Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C81487F3F
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 02:21:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 825A2AC007
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 00:21:44 -0800 (PST)
Received: from mail.uberzach.com (rondo.uberzach.com [64.22.125.169]) by
	cuda.sgi.com with ESMTP id BXZIHUg0sXL2k5qu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jan 2014 00:21:42 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
From: Zachary Kotlarek <zach@kotlarek.com>
In-Reply-To: <20140115063722.GW3469@dastard>
Date: Wed, 15 Jan 2014 00:21:35 -0800
Message-Id: <2BDD1F72-33BF-4CB1-B466-C22889F3486D@kotlarek.com>
References: <20140113031947.GG3469@dastard>
	<E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
	<20140113192732.GI3469@dastard>
	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
	<20140114022414.GM3469@dastard>
	<BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>
	<20140115015350.GR3469@dastard>
	<61E74CEF-8244-4E90-BA7D-91D54DADC3C1@kotlarek.com>
	<20140115034803.GT3469@dastard>
	<1E5E569C-2E11-42A1-A771-89D4800BC412@kotlarek.com>
	<20140115063722.GW3469@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8512156375303754630=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============8512156375303754630==
Content-Type: multipart/signed; boundary="Apple-Mail=_1C98CBF1-7221-4651-BD51-BCAB4A87B7D7"; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail=_1C98CBF1-7221-4651-BD51-BCAB4A87B7D7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Jan 14, 2014, at 10:37 PM, Dave Chinner <david@fromorbit.com> wrote:

> Sure. Can you write a patch to add explanation that explain the
> problem you've had?


Will do.


>> Theoretically I could find the expected hashvals and overwrite
>> them with xfs_db, right?
>=20
> In theory, but hashvals need to be ordered correctly and that
> potentially means having to update btree node pointers and all sorts
> of other complexities. xfs_db is really not designed to rewrite
> directory structures manually.


It occurs to me the other way around is probably easier anyway =97 =
change the name entry to something ASCII-only (of the same byte length) =
and let xfs_repair rebuild the hash. That=92s what got me into this =
mess, so by cartoon logic it should fix things if I do it again. ;-)

After testing that theory on a metadata dump I spun up an LVM snapshot, =
where it also seems to work. So that gets me back into a functional =
state, but given all the mucking I think I=92ll restore a clean FS again =
anyway.

Thanks again for your help.

	Zach


--Apple-Mail=_1C98CBF1-7221-4651-BD51-BCAB4A87B7D7
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
Uu3F8pffHQAAAAAAAA==

--Apple-Mail=_1C98CBF1-7221-4651-BD51-BCAB4A87B7D7--


--===============8512156375303754630==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8512156375303754630==--
