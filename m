Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E1A27F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 21:12:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0302FAC003
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 19:12:14 -0800 (PST)
Received: from mail.uberzach.com (rondo.uberzach.com [64.22.125.169]) by
	cuda.sgi.com with ESMTP id AjadKbCixq6mewwD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 19:12:13 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
From: Zachary Kotlarek <zach@kotlarek.com>
In-Reply-To: <20140114022414.GM3469@dastard>
Date: Mon, 13 Jan 2014 19:12:07 -0800
Message-Id: <BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>
References: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
	<52D2E358.6070106@hardwarefreak.com>
	<CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
	<20140113015007.GC3469@dastard>
	<EDB09149-717F-4089-9C21-1D342CF77A7D@kotlarek.com>
	<20140113031947.GG3469@dastard>
	<E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
	<20140113192732.GI3469@dastard>
	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
	<20140114022414.GM3469@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6215309088498590431=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============6215309088498590431==
Content-Type: multipart/signed; boundary="Apple-Mail=_4874D299-B718-43DD-A56E-AC57030C8C91"; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail=_4874D299-B718-43DD-A56E-AC57030C8C91
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Jan 13, 2014, at 6:24 PM, Dave Chinner <david@fromorbit.com> wrote:

>> Got one. bu[9] is the file that doesn=92t work:
> .....
>> bu[9].inumber =3D 68719478814
>> bu[9].namelen =3D 26
>> bu[9].name =3D "07 - Se\303\261or Macho Solo.m4v"
>> bu[9].tag =3D 0x130
>=20
> That looks completely valid. It's a utf-8 encoded directory entry.
> It doesn't look like there's any corruption on disk here.
>=20
> The ls -l output full of ???? usually means the stat of the inode
> the dirent pointed to, so that implies that the stat has failed.
> So, what does and strace of the 'ls -l' of that directory tell you
> about the directory entry that is returned to userspace?


It just returns ENOENT:
stat("/mnt/media/TV/30 Rock/Season 3/07 - Se=F1or Macho Solo.m4v", =
0x15990f0) =3D -1 ENOENT (No such file or directory)
lstat("/mnt/media/TV/30 Rock/Season 3/07 - Se=F1or Macho Solo.m4v", =
0x15990f0) =3D -1 ENOENT (No such file or directory)


>> bleaf[5].hashval =3D 0x16d07074
>> bleaf[5].address =3D 0x26
>=20
> That's the hash entry in the directory for the name. That may be
> wrong, I guess. can you create another file with the same name
> in a different directory so we can check that the hash is correct?


bu[16].inumber =3D 9255716888
bu[16].namelen =3D 26
bu[16].name =3D "07 - Se\303\261or Macho Solo.m4v"
bu[16].tag =3D 0x1d8

I don=92t understand how to find the right bleaf, but 0x16d07074 doesn=92t=
 appear in any of the hashvals for that directory:

bleaf[0].hashval =3D 0x2e
bleaf[0].address =3D 0x2
bleaf[1].hashval =3D 0x172e
bleaf[1].address =3D 0x4
bleaf[2].hashval =3D 0x1052379a
bleaf[2].address =3D 0x22
bleaf[3].hashval =3D 0x16d0707c
bleaf[3].address =3D 0x3b
bleaf[4].hashval =3D 0x3d1c0738
bleaf[4].address =3D 0x1b
bleaf[5].hashval =3D 0x3d1c0739
bleaf[5].address =3D 0x18
bleaf[6].hashval =3D 0x3d1c073a
bleaf[6].address =3D 0x15
bleaf[7].hashval =3D 0x3d1c073b
bleaf[7].address =3D 0x12
bleaf[8].hashval =3D 0x3d1c073c
bleaf[8].address =3D 0xf
bleaf[9].hashval =3D 0x3d1c073d
bleaf[9].address =3D 0xc
bleaf[10].hashval =3D 0x3d1c073e
bleaf[10].address =3D 0x9
bleaf[11].hashval =3D 0x3d1c073f
bleaf[11].address =3D 0x6
bleaf[12].hashval =3D 0x7f92e42b
bleaf[12].address =3D 0x2b
bleaf[13].hashval =3D 0x9f92e6c0
bleaf[13].address =3D 0x36


>> u.bmx[0] =3D [startoff,startblock,blockcount,extentflag] =
0:[0,509696,79700,0]
>>=20
>> I=92m not sure if this the right way to get the related first data =
block. If I did it wrong let me know:
>>=20
>> xfs_db> daddr 509696
>=20
> fsb 509696, not daddr.


xfs_db> fsb 509696=20
xfs_db> p
000: 0000001c 66747970 6d703432 00000000 6d703432 69736f6d 61766331 =
00000084

And that looks like the MP4 magic number across the first 3 segments, =
which is what I=92m expecting.

	Zach


--Apple-Mail=_4874D299-B718-43DD-A56E-AC57030C8C91
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
eMCmEpL2aQAAAAAAAA==

--Apple-Mail=_4874D299-B718-43DD-A56E-AC57030C8C91--


--===============6215309088498590431==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6215309088498590431==--
