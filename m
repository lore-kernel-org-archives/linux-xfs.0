Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VN7F5F128936 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 17:07:16 -0600
Received: from postoffice2.aconex.com (mail.aconex.com [203.166.49.3]) by
	cuda.sgi.com with ESMTP id 1BeKEtokBbopMcer for
	<xfs@oss.sgi.com>; Tue, 31 Jan 2012 15:07:13 -0800 (PST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.35.100])
	by postoffice2.aconex.com with ESMTP id ODZKVXFjUUl0Zamp for
	<xfs@oss.sgi.com>; Wed, 01 Feb 2012 10:07:11 +1100 (EST)
Received: from gatekeeper.aconex.com (gatekeeper.yarra.acx [192.168.35.102])
	by postoffice.aconex.com (Postfix) with ESMTP id 73DBC3CE00B5
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 10:06:55 +1100 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by gatekeeper.aconex.com (Postfix) with ESMTP id 8F0379E0002
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 10:07:11 +1100 (EST)
Received: from gatekeeper.aconex.com ([127.0.0.1])
	by localhost (gatekeeper.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id gLMO2l+aimoa for <xfs@oss.sgi.com>;
	Wed,  1 Feb 2012 10:07:09 +1100 (EST)
Received: from acxmail-au2.aconex.com (acxmail-au2.aconex.com [192.168.35.104])
	by gatekeeper.aconex.com (Postfix) with ESMTP id 2010B9E0001
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 10:07:09 +1100 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by acxmail-au2.aconex.com (Postfix) with ESMTP id 1C0AA3B20003
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 10:07:09 +1100 (EST)
Received: from acxmail-au2.aconex.com ([127.0.0.1])
	by localhost (acxmail-au2.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id Vkv7SPUxkPHd for <xfs@oss.sgi.com>;
	Wed,  1 Feb 2012 10:07:08 +1100 (EST)
Received: from acxmail-au2.aconex.com (localhost.localdomain [127.0.0.1])
	by acxmail-au2.aconex.com (Postfix) with ESMTP id E776A3B20001
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 10:07:08 +1100 (EST)
Date: Wed, 1 Feb 2012 10:07:08 +1100 (EST)
From: Nathan Scott <nathans@debian.org>
Message-ID: <419906537.69741.1328051228836.JavaMail.root@acxmail-au2.aconex.com>
In-Reply-To: <1317955640.69734.1328051152460.JavaMail.root@acxmail-au2.aconex.com>
Subject: [patch] xfsprogs: add debian linux-libc-dev build dependency
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_69740_686805766.1328051228834"
Reply-To: Nathan Scott <nathans@debian.org>
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

------=_Part_69740_686805766.1328051228834
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Add a build dependency on linux-libc-dev, to ensure we build
packages with have_fiemap set to true if the headers support
it.  Noticed by Dave, some package builds didn't enable this
when they should have.

Signed-off-by: Nathan Scott <nathans@debian.org>

------=_Part_69740_686805766.1328051228834
Content-Type: text/x-patch; name=debiandeps.patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=debiandeps.patch

ZGlmZiAtLWdpdCBhL2RlYmlhbi9jb250cm9sIGIvZGViaWFuL2NvbnRyb2wKaW5kZXggY2E1MTdh
ZC4uNTAyYjQ4YiAxMDA2NDQKLS0tIGEvZGViaWFuL2NvbnRyb2wKKysrIGIvZGViaWFuL2NvbnRy
b2wKQEAgLTMsNyArMyw3IEBAIFNlY3Rpb246IGFkbWluCiBQcmlvcml0eTogb3B0aW9uYWwKIE1h
aW50YWluZXI6IFhGUyBEZXZlbG9wbWVudCBUZWFtIDx4ZnNAb3NzLnNnaS5jb20+CiBVcGxvYWRl
cnM6IE5hdGhhbiBTY290dCA8bmF0aGFuc0BkZWJpYW4ub3JnPiwgQW5pYmFsIE1vbnNhbHZlIFNh
bGF6YXIgPGFuaWJhbEBkZWJpYW4ub3JnPgotQnVpbGQtRGVwZW5kczogdXVpZC1kZXYsIGF1dG9j
b25mLCBkZWJoZWxwZXIgKD49IDUpLCBnZXR0ZXh0LCBsaWJ0b29sLCBsaWJyZWFkbGluZS1ncGx2
Mi1kZXYgfCBsaWJyZWFkbGluZTUtZGV2LCBsaWJibGtpZC1kZXYgKD49IDIuMTcpCitCdWlsZC1E
ZXBlbmRzOiB1dWlkLWRldiwgYXV0b2NvbmYsIGRlYmhlbHBlciAoPj0gNSksIGdldHRleHQsIGxp
YnRvb2wsIGxpYnJlYWRsaW5lLWdwbHYyLWRldiB8IGxpYnJlYWRsaW5lNS1kZXYsIGxpYmJsa2lk
LWRldiAoPj0gMi4xNyksIGxpbnV4LWxpYmMtZGV2CiBTdGFuZGFyZHMtVmVyc2lvbjogMy45LjEK
IEhvbWVwYWdlOiBodHRwOi8vb3NzLnNnaS5jb20vcHJvamVjdHMveGZzLwogCg==
------=_Part_69740_686805766.1328051228834
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_69740_686805766.1328051228834--
