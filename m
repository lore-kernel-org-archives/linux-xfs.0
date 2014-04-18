Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 003D47F53
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 21:38:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75AD4AC003
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:38:39 -0700 (PDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
	[209.85.212.177]) by cuda.sgi.com with ESMTP id
	ENZ87xHNXozTmJoI (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Apr 2014 19:38:37 -0700 (PDT)
Received: by mail-wi0-f177.google.com with SMTP id cc10so248241wib.10
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:38:36 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: btrfs/004,
	fix filefrag filter for files with 1 block only
Date: Fri, 18 Apr 2014 04:34:23 +0100
Message-Id: <1397792063-3660-1-git-send-email-fdmanana@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jbacik@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

If the file consists of a single block, then filefrag mentions
'1 block of ...', and the filter expected 'blocks of ...'.

Example:

$ echo qwerty > foobar
$ filefrag -v foobar
Filesystem type is: ef53
File size of foobar is 7 (1 block of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:          0..         0:      1:             unknown,delalloc,eof
foobar: 1 extent found

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/004 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 211d8bc..670e1c2 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -58,7 +58,7 @@ _require_command "/usr/sbin/filefrag"
 rm -f $seqres.full
 
 FILEFRAG_FILTER='
-	if (/blocks of (\d+) bytes/) {
+	if (/blocks? of (\d+) bytes/) {
 		$blocksize = $1;
 		next
 	}
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
