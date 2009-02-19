Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1J74rmb086872 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 01:04:54 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE6B6132B94
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2009 23:04:19 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id F6Eaoomh4jUhPfPN for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2009 23:04:19 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n1J74Jql021060
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 02:04:19 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1J74JnY026831
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 02:04:19 -0500
Received: from dhcp-lab-218.englab.brq.redhat.com
	(dhcp-lab-225.englab.brq.redhat.com [10.34.33.225])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n1J74Hjv025933
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 02:04:17 -0500
Message-ID: <499D0471.6000600@redhat.com>
Date: Thu, 19 Feb 2009 08:04:17 +0100
From: Zdenek Prikryl <zprikryl@redhat.com>
MIME-Version: 1.0
Subject: Re: libattr - severe memory leaks from attr_copy_file()
Content-Type: multipart/mixed; boundary="------------090904040605040905020901"
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
--------------090904040605040905020901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> And the variable, text, is assigned straight away before any use,
> so I missed where the problem is.
>
> --Tim

The memory leak is really there. Look:

54 attr_parse_attr_conf(struct error_context *ctx)
...
66 repeat:
67         text = malloc(size_guess + 1);
68         if (!text)
69                 goto fail;
70
71         if ((file = fopen(ATTR_CONF, "r")) == NULL) {
72                 if (errno == ENOENT)
73                         return 0;
74                 goto fail;
75         }

Let's say that malloc() on the line 67 success, so we have text != NULL. Then,
fopen() on the line 71 fails and errno == ENOENT. In that case
attr_parse_attr_conf() simply returns 0, but text isn't freed. That's the point,
where memory leaks arise. I rewrote the patch, so now is more simpler.

-- 
Zdenek Prikryl <zprikryl@redhat.com>


--------------090904040605040905020901
Content-Type: text/plain;
 name="attr-2.4.43-leak.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="attr-2.4.43-leak.patch"

ZGlmZiAtdXAgYXR0ci0yLjQuNDMvbGliYXR0ci9hdHRyX2NvcHlfYWN0aW9uLmMubGVhayBh
dHRyLTIuNC40My9saWJhdHRyL2F0dHJfY29weV9hY3Rpb24uYw0KLS0tIGF0dHItMi40LjQz
L2xpYmF0dHIvYXR0cl9jb3B5X2FjdGlvbi5jLmxlYWsJMjAwOC0wNi0zMCAwNzoyMjo1MC4w
MDAwMDAwMDAgKzAyMDANCisrKyBhdHRyLTIuNC40My9saWJhdHRyL2F0dHJfY29weV9hY3Rp
b24uYwkyMDA5LTAyLTE3IDA5OjUwOjM4LjAwMDAwMDAwMCArMDEwMA0KQEAgLTUzLDcgKzUz
LDcgQEAgZnJlZV9hdHRyX2FjdGlvbnModm9pZCkNCiBzdGF0aWMgaW50DQogYXR0cl9wYXJz
ZV9hdHRyX2NvbmYoc3RydWN0IGVycm9yX2NvbnRleHQgKmN0eCkNCiB7DQotCWNoYXIgKnRl
eHQsICp0Ow0KKwljaGFyICp0ZXh0ID0gTlVMTCwgKnQ7DQogCXNpemVfdCBzaXplX2d1ZXNz
ID0gNDA5NiwgbGVuOw0KIAlGSUxFICpmaWxlOw0KIAljaGFyICpwYXR0ZXJuID0gTlVMTDsN
CkBAIC02NCwxNSArNjQsMTYgQEAgYXR0cl9wYXJzZV9hdHRyX2NvbmYoc3RydWN0IGVycm9y
X2NvbnRleA0KIAkJcmV0dXJuIDA7DQogDQogcmVwZWF0Og0KLQl0ZXh0ID0gbWFsbG9jKHNp
emVfZ3Vlc3MgKyAxKTsNCi0JaWYgKCF0ZXh0KQ0KLQkJZ290byBmYWlsOw0KLQ0KIAlpZiAo
KGZpbGUgPSBmb3BlbihBVFRSX0NPTkYsICJyIikpID09IE5VTEwpIHsNCiAJCWlmIChlcnJu
byA9PSBFTk9FTlQpDQogCQkJcmV0dXJuIDA7DQogCQlnb3RvIGZhaWw7DQogCX0NCisNCisJ
dGV4dCA9IG1hbGxvYyhzaXplX2d1ZXNzICsgMSk7DQorCWlmICghdGV4dCkNCisJCWdvdG8g
ZmFpbDsNCisNCiAJbGVuID0gZnJlYWQodGV4dCwgMSwgc2l6ZV9ndWVzcywgZmlsZSk7DQog
CWlmIChmZXJyb3IoZmlsZSkpDQogCQlnb3RvIGZhaWw7DQo=
--------------090904040605040905020901
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------090904040605040905020901--
