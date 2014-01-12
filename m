Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 441B37F3F
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 07:28:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C2922AC003
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 05:28:36 -0800 (PST)
Received: from mail.uberzach.com (rondo.uberzach.com [64.22.125.169]) by
	cuda.sgi.com with ESMTP id hEI0QUpLAiRiPRus (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Jan 2014 05:28:35 -0800 (PST)
Received: from [172.19.7.2] (unknown [74.93.97.69])
	(Authenticated sender: profplump)
	by mail.uberzach.com (Postfix) with ESMTPSA id B3E8158070
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 05:28:32 -0800 (PST)
From: Zachary Kotlarek <zach@kotlarek.com>
Subject: Files with non-ASCII names inaccessible after xfs_repair
Message-Id: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
Date: Sun, 12 Jan 2014 05:28:29 -0800
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3774913956142456528=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3774913956142456528==
Content-Type: multipart/signed; boundary="Apple-Mail=_79EA3A49-24DA-4006-A387-93EAC9E1CBA3"; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail=_79EA3A49-24DA-4006-A387-93EAC9E1CBA3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

My XFS filesystem dismounted while copying a ~3 GB file. I won=92t claim =
to know why; I=92m fairly confident only that 1 file was being modified =
at the time. The log replayed cleanly when remounting, but attempting to =
remove the file in question caused the same dismount.

So I ran xfs_repair. It put one file in lost+found (which appears to be =
written when if failed initially) and reported a number or warnings to =
the effect of:
	bad hash table for directory inode 2054 (hash value mismatch): =
rebuilding
	rebuilding directory inode 2054=20
which I didn=92t take to be serious, though I suspect now that=92s where =
things went wrong.

I now have 23 directories (matching the 23 =93rebuilding" messages) =
where a file or directory with non-ASCII characters in the name exists =
in the directory list but cannot be read or deleted:

ls -la
ls: cannot access 07 - Se=F1or Macho Solo.m4v: No such file or directory
-rw-rw----+  1 profplump media 332M Sep 11  2010 06 - Christmas =
Special.m4v
???????????  ? ?         ?        ?            ? 07 - Se??or Macho =
Solo.m4v
-rw-rw----+  1 profplump media 304M Sep 11  2010 08 - Flu Shot.m4v

So the file exists in the directory listing (`ls` and `find` can both =
see it) but I cannot delete or stat or open it. If I touch the affected =
filename I get a second entry in the directory listing, both apparently =
pointing to the same, new, empty file. If I then delete the same =
filename I get back to the original state =97 a single, unusable =
directory entry.

I=92d like to (if possible) re-link those directory listings to the =
related files, or at least delete them so the files can be restored and =
folders can be used normally. I=92m also worried that running xfs_repair =
in the future might re-create this problem.

But I don=92t even know where to start in trying to fix this. And I =
still cannot delete the file that started this whole sequence of events. =
So if anyone has suggestions I=92d be happy to hear them.

	Zach


--Apple-Mail=_79EA3A49-24DA-4006-A387-93EAC9E1CBA3
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
8UWvrqoVWQAAAAAAAA==

--Apple-Mail=_79EA3A49-24DA-4006-A387-93EAC9E1CBA3--


--===============3774913956142456528==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3774913956142456528==--
