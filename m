Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1SLOB9h159043 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 15:24:11 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3C61304BCB
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 13:26:59 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id VEvZCJOTLaTUOWWw for <xfs@oss.sgi.com>;
	Mon, 28 Feb 2011 13:26:59 -0800 (PST)
Message-ID: <4D6C1322.10102@sandeen.net>
Date: Mon, 28 Feb 2011 15:26:58 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] libxcmd: return error from cvtnum() on overflow
References: <4D6C075F.1010509@redhat.com>
In-Reply-To: <4D6C075F.1010509@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

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

V2: zero errno first so we don't pick up a stale errno.

Note:
... should I change all callsites from "non-numeric" to "invalid" perhaps?

diff --git a/libxcmd/input.c b/libxcmd/input.c
index d7f29c1..c2bc4a0 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -152,7 +152,12 @@ cvtnum(
 	char		*sp;
 	int		c;
 
+	errno = 0;
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
