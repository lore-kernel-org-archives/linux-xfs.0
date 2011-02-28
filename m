Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1SKY12G157288 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 14:34:01 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 965461DDB819
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 12:36:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b5ZoTwFdhwGeFEZ3 for
	<xfs@oss.sgi.com>; Mon, 28 Feb 2011 12:36:49 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1SKamxA021780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 15:36:48 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p1SKalUD001107
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 15:36:48 -0500
Message-ID: <4D6C075F.1010509@redhat.com>
Date: Mon, 28 Feb 2011 14:36:47 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] libxcmd: return error from cvtnum() on overflow
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Test 071 was failing in weird ways, partly because it was trying
to pass in offsets larger than strtoll() could accept, which then
silently returned LLONG_MAX instead.  For DIO tests, this was
unaligned, so we got unexpected (to me, anyay) alignment errors.

At least printing out the perror() makes this more obvious,
but unfortunately we then get the somewhat odd output:

# xfs_io -f -d -c "pwrite 9223373136366403584  4096" /mnt/test/grrr
cvtnum: Numerical result out of range
non-numeric offset argument -- 9223373136366403584

Test 071 still fails, but at least it's a bit more obvious as to why.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note:
... should I change all callsites from "non-numeric" to "invalid" perhaps?

diff --git a/libxcmd/input.c b/libxcmd/input.c
index d7f29c1..6d4c003 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -153,6 +153,10 @@ cvtnum(
 	int		c;
 
 	i = strtoll(s, &sp, 0);
+	if (errno == ERANGE) {
+		perror("cvtnum");
+		return -1LL;
+	}
 	if (i == 0 && sp == s)
 		return -1LL;
 	if (*sp == '\0')

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
