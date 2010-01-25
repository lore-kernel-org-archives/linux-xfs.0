Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0P4SRmh029759 for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 22:28:27 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 319EB11FD2C1
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 20:29:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	EIjVhaZ0HwFLvBuA for <xfs@oss.sgi.com>;
	Sun, 24 Jan 2010 20:29:28 -0800 (PST)
Date: Mon, 25 Jan 2010 15:29:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: linux-next: vfs/fsnotify trees build warning
Message-ID: <20100125042925.GM25842@discord.disaster>
References: <20100125150456.c796f0b0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100125150456.c796f0b0.sfr@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: xfs@oss.sgi.com, linux-next@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 03:04:56PM +1100, Stephen Rothwell wrote:
> Hi Eric, Al,
> 
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> In file included from include/linux/security.h:26,
>                  from fs/xfs/linux-2.6/xfs_iops.c:56:
> include/linux/fsnotify.h: In function 'fsnotify_move':
> include/linux/fsnotify.h:87: warning: pointer targets in initialization differ in signedness
> include/linux/fsnotify.h: In function 'fsnotify_create':
> include/linux/fsnotify.h:154: warning: pointer targets in passing argument 5 of 'fsnotify' differ in signedness
> include/linux/fsnotify_backend.h:300: note: expected 'const char *' but argument is of type 'const unsigned char *'
> include/linux/fsnotify.h: In function 'fsnotify_link':
> include/linux/fsnotify.h:167: warning: pointer targets in passing argument 5 of 'fsnotify' differ in signedness
> include/linux/fsnotify_backend.h:300: note: expected 'const char *' but argument is of type 'const unsigned char *'
> include/linux/fsnotify.h: In function 'fsnotify_mkdir':
> include/linux/fsnotify.h:180: warning: pointer targets in passing argument 5 of 'fsnotify' differ in signedness
> include/linux/fsnotify_backend.h:300: note: expected 'const char *' but argument is of type 'const unsigned char *'
> 
> I am not sure why these started turning up (they were there on Friday as
> well and I may have missed them earlier).

I cleaned up the all the sign warnings in the XFS code because
we mirror the kernel code into userspace for tool building (libxfs)
and that results in lots of sign warnings. I left the kernel
warnings switched on in the XFS makefile so we wouldn't re-introduce
the same problems.

Don't know why this isn't showing up in my build though, because:

CONFIG_FSNOTIFY=y

is set and it is obvious the fsnotify wrappers are passing an
unsigned char * (dentry name) to fsnotify() which takes a const char
* for the file name. There's mismatches like this all over the VFS,
so I'm not going to try to fix them....

The patch below should silence the warnings, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: turn off sign warnings

Because they cause warnings in static inline functions conditionally
compiled into XFS from the VFS (e.g. fsnotify).

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 1926701..5c5a366 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -16,7 +16,7 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
-EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6 -Wpointer-sign
+EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6
 
 XFS_LINUX := linux-2.6
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
