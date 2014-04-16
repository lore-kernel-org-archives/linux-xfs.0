Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 33DB57F60
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 16:58:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9863AC004
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 14:58:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6DGWjG7lMQ4bn83z for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 14:58:06 -0700 (PDT)
Date: Thu, 17 Apr 2014 07:57:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: new 64 bit math link fail in xfs in linux-next today
Message-ID: <20140416215733.GM15995@dastard>
References: <534EAB41.60901@windriver.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <534EAB41.60901@windriver.com>
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
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 12:09:37PM -0400, Paul Gortmaker wrote:
> Hi Dave,
> 
> Not sure if this has been reported yet, but this new failure showed
> up in the xtensa link of today's linux-next builds.
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/10938384/

fs/built-in.o: In function `__xfs_get_blocks':
/home/dave/src/build/x86-64/xfsdev/fs/xfs/xfs_aops.c:1368: undefined reference to `__divdi3'

Fmeh. The hunk that throws the error:

@@ -1354,6 +1362,12 @@ __xfs_get_blocks(
                ASSERT(mapping_size > 0);
                if (mapping_size > size)
                        mapping_size = size;
+               if (offset < i_size_read(inode) &&
+                   offset + mapping_size >= i_size_read(inode)) {
+                       /* limit mapping to block that spans EOF */
+                       mapping_size = roundup(i_size_read(inode) - offset,
+                                              1 << inode->i_blkbits);
+               }
                if (mapping_size > LONG_MAX)
                        mapping_size = LONG_MAX;

You'd think a generic function like roundup() would handle that sort
of 64/32 bit type problem, yes? But it doesn't, despite what the
comment implies:

/* The `const' in roundup() prevents gcc-3.3 from calling __divdi3 */
#define roundup(x, y) (                                 \
{                                                       \
        const typeof(y) __y = y;                        \
        (((x) + (__y - 1)) / __y) * __y;                \
}                                                       \
)

It doesn't even have type checking that might warn you of impending
problems...

<sigh>

/me looks around in the XFS code for a bit

... and finds roundup_64() in fs/xfs/xfs_linux.h. That uses do_div()
to avoid this problem. And it's a static inline function, so it has
type checking, too.

And so this hunk fixes the problem:

@@ -1365,7 +1365,7 @@ __xfs_get_blocks(
 		if (offset < i_size_read(inode) &&
 		    offset + mapping_size >= i_size_read(inode)) {
 			/* limit mapping to block that spans EOF */
-                       mapping_size = roundup(i_size_read(inode) - offset,
+                       mapping_size = roundup_64(i_size_read(inode) - offset,
 					       1 << inode->i_blkbits);
 		}
 		if (mapping_size > LONG_MAX)

Can you test it, please, and I'll push out an updated branch
hopefully in time for today's linux-next build....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
