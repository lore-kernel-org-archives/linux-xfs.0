Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RJQJOW230328 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 13:26:19 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ye9rzzBE3RGwcQeG for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 11:26:18 -0800 (PST)
Message-ID: <4F22FA5B.4030500@sandeen.net>
Date: Fri, 27 Jan 2012 13:26:19 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfsprogs: check for size parsing errors in xfs_quota
References: <4F1D9989.8060808@redhat.com> <20120124175612.GH9853@infradead.org>
In-Reply-To: <20120124175612.GH9853@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: James Lawrie <james@jdlawrie.co.uk>, xfs-oss <xfs@oss.sgi.com>

Doing something like 

# xfs_quota -x -c 'limit -u bhard=1.2g ...

will cause cvtnum to fail and return a value of -1LL (because it
cannot parse the decimal), but the quota caller doesn't check
for this error value, casts it to U64, shifts right, and we end
up with an answer of 16 petabytes rather than erroring out.
Fix this.

Reported-by: James Lawrie <james@jdlawrie.co.uk>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Fix mysterious change in shift size, shorten long line

diff --git a/quota/edit.c b/quota/edit.c
index b704e63..cad3aee 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -226,13 +226,19 @@ extractb(
 	uint		sectorsize,
 	__uint64_t	*value)
 {
-	__uint64_t	v;
+	long long	v;
 	char		*s = string;
 
 	if (strncmp(string, prefix, length) == 0) {
 		s = string + length + 1;
-		v = (__uint64_t)cvtnum(blocksize, sectorsize, s);
-		*value = v >> 9;	/* syscalls use basic blocks */
+		v = cvtnum(blocksize, sectorsize, s);
+		if (v == -1LL) {
+			fprintf(stderr,
+				_("%s: Error: could not parse size %s.\n"),
+				progname, s);
+			return 0;
+		}
+		*value = (__uint64_t)v >> 9;	/* syscalls use basic blocks */
 		if (v > 0 && *value == 0)
 			fprintf(stderr, _("%s: Warning: `%s' in quota blocks is 0 (unlimited).\n"), progname, s);
 		return 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
