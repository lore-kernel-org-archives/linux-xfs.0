Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B323E7F37
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 19:25:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 307C8AC001
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 17:24:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DRx8TG42gJEURyHH for <xfs@oss.sgi.com>;
	Thu, 08 Oct 2015 17:24:56 -0700 (PDT)
Received: from Liberator.local (unknown [205.215.222.148])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4C3EE61F8992
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 19:24:56 -0500 (CDT)
Subject: [PATCH 1/4] libxfs: avoid negative (and full-width) shifts in
	radix-tree.c
References: <56170906.5090301@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56170955.9020105@sandeen.net>
Date: Thu, 8 Oct 2015 19:24:53 -0500
MIME-Version: 1.0
In-Reply-To: <56170906.5090301@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Pull this commit over from the kernel, as libubsan spotted a
bad shift at runtime:

    commit 430d275a399175c7c0673459738979287ec1fd22
    Author: Peter Lund <firefly@vax64.dk>
    Date:   Tue Oct 16 23:29:35 2007 -0700

    avoid negative (and full-width) shifts in radix-tree.c

    Negative shifts are not allowed in C (the result is undefined).  Same thing
    with full-width shifts.

    It works on most platforms but not on the VAX with gcc 4.0.1 (it results in an
    "operand reserved" fault).

    Shifting by more than the width of the value on the left is also not
    allowed.  I think the extra '>> 1' tacked on at the end in the original
    code was an attempt to work around that.  Getting rid of that is an extra
    feature of this patch.

    Here's the chapter and verse, taken from the final draft of the C99
    standard ("6.5.7 Bitwise shift operators", paragraph 3):

      "The integer promotions are performed on each of the operands. The
      type of the result is that of the promoted left operand. If the
      value of the right operand is negative or is greater than or equal
      to the width of the promoted left operand, the behavior is
      undefined."

    Thank you to Jan-Benedict Glaw, Christoph Hellwig, Maciej Rozycki, Pekka
    Enberg, Andreas Schwab, and Christoph Lameter for review.  Special thanks
    to Andreas for spotting that my fix only removed half the undefined
    behaviour.

    Signed-off-by: Peter Lund <firefly@vax64.dk>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/radix-tree.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/libxfs/radix-tree.c b/libxfs/radix-tree.c
index 4d44ab4..eef9c36 100644
--- a/libxfs/radix-tree.c
+++ b/libxfs/radix-tree.c
@@ -784,12 +784,14 @@ int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag)
 
 static unsigned long __maxindex(unsigned int height)
 {
-	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
-	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
-
-	if (tmp >= RADIX_TREE_INDEX_BITS)
-		index = ~0UL;
-	return index;
+	unsigned int width = height * RADIX_TREE_MAP_SHIFT;
+	int shift = RADIX_TREE_INDEX_BITS - width;
+
+	if (shift < 0)
+		return ~0UL;
+	if (shift >= BITS_PER_LONG)
+		return 0UL;
+	return ~0UL >> shift;
 }
 
 static void radix_tree_init_maxindex(void)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
