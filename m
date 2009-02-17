Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1HBtugR221231 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 05:55:56 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4E7A12560C
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 03:50:21 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 9MMZC8RUEwWjqjvd for <xfs@oss.sgi.com>;
	Tue, 17 Feb 2009 03:50:21 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n1HBoKmK028554
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 06:50:20 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1HBoLoi018818
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 06:50:21 -0500
Received: from dhcp-lab-218.englab.brq.redhat.com
	(dhcp-lab-225.englab.brq.redhat.com [10.34.33.225])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n1HBoJ6V005643
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 06:50:19 -0500
Message-ID: <499AA47A.2050106@redhat.com>
Date: Tue, 17 Feb 2009 12:50:18 +0100
From: Zdenek Prikryl <zprikryl@redhat.com>
MIME-Version: 1.0
Subject: libattr - severe memory leaks from attr_copy_file()
Content-Type: multipart/mixed; boundary="------------060803030106040801010105"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------060803030106040801010105
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,
libattr's function attr_copy_file() seems to be producing severe memory leaks.
I'm sending a patch which removes sources of leaks.

Regards.

-- 
Zdenek Prikryl <zprikryl@redhat.com>


--------------060803030106040801010105
Content-Type: text/plain;
 name="attr-2.4.32-leak.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="attr-2.4.32-leak.patch"

ZGlmZiAtdXAgYXR0ci0yLjQuNDMvbGliYXR0ci9hdHRyX2NvcHlfYWN0aW9uLmMubGVhayBh
dHRyLTIuNC40My9saWJhdHRyL2F0dHJfY29weV9hY3Rpb24uYwotLS0gYXR0ci0yLjQuNDMv
bGliYXR0ci9hdHRyX2NvcHlfYWN0aW9uLmMubGVhawkyMDA4LTA2LTMwIDA3OjIyOjUwLjAw
MDAwMDAwMCArMDIwMAorKysgYXR0ci0yLjQuNDMvbGliYXR0ci9hdHRyX2NvcHlfYWN0aW9u
LmMJMjAwOS0wMi0xNyAwOTo1MDozOC4wMDAwMDAwMDAgKzAxMDAKQEAgLTUzLDcgKzUzLDcg
QEAgZnJlZV9hdHRyX2FjdGlvbnModm9pZCkKIHN0YXRpYyBpbnQKIGF0dHJfcGFyc2VfYXR0
cl9jb25mKHN0cnVjdCBlcnJvcl9jb250ZXh0ICpjdHgpCiB7Ci0JY2hhciAqdGV4dCwgKnQ7
CisJY2hhciAqdGV4dCA9IE5VTEwsICp0OwogCXNpemVfdCBzaXplX2d1ZXNzID0gNDA5Niwg
bGVuOwogCUZJTEUgKmZpbGU7CiAJY2hhciAqcGF0dGVybiA9IE5VTEw7CkBAIC02NCwxNSAr
NjQsMTYgQEAgYXR0cl9wYXJzZV9hdHRyX2NvbmYoc3RydWN0IGVycm9yX2NvbnRleAogCQly
ZXR1cm4gMDsKIAogcmVwZWF0OgotCXRleHQgPSBtYWxsb2Moc2l6ZV9ndWVzcyArIDEpOwot
CWlmICghdGV4dCkKLQkJZ290byBmYWlsOwotCiAJaWYgKChmaWxlID0gZm9wZW4oQVRUUl9D
T05GLCAiciIpKSA9PSBOVUxMKSB7CiAJCWlmIChlcnJubyA9PSBFTk9FTlQpCiAJCQlyZXR1
cm4gMDsKIAkJZ290byBmYWlsOwogCX0KKworCXRleHQgPSBtYWxsb2Moc2l6ZV9ndWVzcyAr
IDEpOworCWlmICghdGV4dCkKKwkJZ290byBmYWlsOworCiAJbGVuID0gZnJlYWQodGV4dCwg
MSwgc2l6ZV9ndWVzcywgZmlsZSk7CiAJaWYgKGZlcnJvcihmaWxlKSkKIAkJZ290byBmYWls
OwpAQCAtMTQwLDEwICsxNDEsMTIgQEAgZmFpbDoKIAkJcXVvdGVfZnJlZSAoY3R4LCBxKTsK
IAl9CiAKLQlmcmVlKHBhdHRlcm4pOworCWlmIChwYXR0ZXJuKQorCQlmcmVlKHBhdHRlcm4p
OwogCWlmIChmaWxlKQogCQlmY2xvc2UoZmlsZSk7Ci0JZnJlZSh0ZXh0KTsKKwlpZiAodGV4
dCkKKwkJZnJlZSh0ZXh0KTsKIAlmcmVlX2F0dHJfYWN0aW9ucygpOwogCXJldHVybiAtMTsK
IH0K
--------------060803030106040801010105
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------060803030106040801010105--
