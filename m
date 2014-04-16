Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1749B7F62
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 15:59:56 -0500 (CDT)
Message-ID: <534EEF47.4000706@sgi.com>
Date: Wed, 16 Apr 2014 15:59:51 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: new 64 bit math link fail in xfs in linux-next today
References: <534EAB41.60901@windriver.com>
In-Reply-To: <534EAB41.60901@windriver.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, xfs@oss.sgi.com

On 04/16/14 11:09, Paul Gortmaker wrote:
> Hi Dave,
>
> Not sure if this has been reported yet, but this new failure showed
> up in the xtensa link of today's linux-next builds.
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/10938384/
>
> Paul.
>

Try this works on i386. sorry if my mailer wraps the line:

The roundup in commit 68c1fb5d should be a roundup_64()
because it is desired to round a 64 bit type by an integer
and that will result in a 64 bit value. On 32 bit machines
using roundup() in this case will result in the error:

  ERROR: "__divdi3" [fs/xfs/xfs.ko] undefined!

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
  fs/xfs/xfs_aops.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/xfs/xfs_aops.c
===================================================================
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1365,7 +1365,7 @@ __xfs_get_blocks(
  		if (offset < i_size_read(inode) &&
  		    offset + mapping_size >= i_size_read(inode)) {
  			/* limit mapping to block that spans EOF */
-			mapping_size = roundup(i_size_read(inode) - offset,
+			mapping_size = roundup_64(i_size_read(inode) - offset,
  					       1 << inode->i_blkbits);
  		}
  		if (mapping_size > LONG_MAX)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
