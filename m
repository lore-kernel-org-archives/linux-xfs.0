Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1MKjN46258231 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 14:45:24 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 91EB03040BB
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 12:48:08 -0800 (PST)
Subject: Re: [PATCH] xfs_repair: validate inode di_flaaags field
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1298407419.1960.48.camel@doink>
References: <1298407419.1960.48.camel@doink>
Date: Tue, 22 Feb 2011 14:45:56 -0600
Message-ID: <1298407556.1960.54.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

On Tue, 2011-02-22 at 14:43 -0600, Alex Elder wrote:
> (I may have missed it, but I don't believe Dave posted
> this patch so I'm doing it for him to get it on the
> list.  -Alex)
> 
> xfs-reapir is not validating the di_flags field in the inode for
> sanity. Block fuzzing indicates that we are not picking situations
> like the RT bit being set on filesystems without realtime devices.
>     
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 

I guess I should have left it up to Dave...


 repair/dinode.c |   62
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index bf04c6e..fad15b2 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2530,6 +2530,68 @@ process_dinode_int(xfs_mount_t *mp,
                goto clear_bad_out;
        }
 
+       /*
+        * check that we only have valid flags set, and those that are
set make
+        * sense.
+        */
+       if (dinoc->di_flags) {
+               uint16_t flags = be16_to_cpu(dinoc->di_flags);
+
+               if (flags & ~XFS_DIFLAG_ANY) {
+                       do_warn(_("Bad flags set in inode %llu"), lino);
+                       flags &= ~XFS_DIFLAG_ANY;
+               }
+
+               if (flags & (XFS_DIFLAG_REALTIME |
XFS_DIFLAG_RTINHERIT)) {
+                       /* need an rt-dev! */
+                       if (!rt_name) {
+                               do_warn(_(
+       "inode %llu has RT flag set but there is no RT device"), lino);
+                               flags &= ~(XFS_DIFLAG_REALTIME |
+                                               XFS_DIFLAG_RTINHERIT);
+                       }
+               }
+               if (flags & XFS_DIFLAG_NEWRTBM_BIT) {
+                       /* must be a rt bitmap inode */
+                       if (lino != mp->m_sb.sb_rbmino) {
+                               do_warn(_("inode %llu not rt bitmap"),
lino);
+                               flags &= ~XFS_DIFLAG_NEWRTBM_BIT;
+                       }
+               }
+               if (flags & (XFS_DIFLAG_RTINHERIT |
+                            XFS_DIFLAG_EXTSZINHERIT |
+                            XFS_DIFLAG_PROJINHERIT |
+                            XFS_DIFLAG_NOSYMLINKS)) {
+                       /* must be a directory */
+                       if (di_mode && !S_ISDIR(di_mode)) {
+                               do_warn(_(
+                       "directory flags set on non-directory inode %
llu"),
+                                       lino);
+                               flags &= ~(XFS_DIFLAG_RTINHERIT |
+                                               XFS_DIFLAG_EXTSZINHERIT
|
+                                               XFS_DIFLAG_PROJINHERIT |
+                                               XFS_DIFLAG_NOSYMLINKS);
+                       }
+               }
+               if (flags & (XFS_DIFLAG_REALTIME | XFS_XFLAG_EXTSIZE)) {
+                       /* must be a file */
+                       if (di_mode && !S_ISREG(di_mode)) {
+                               do_warn(_(
+                       "file flags set on non-file inode %llu"), lino);
+                               flags &= ~(XFS_DIFLAG_REALTIME |
+                                               XFS_XFLAG_EXTSIZE);
+                       }
+               }
+               if (!verify_mode && flags !=
be16_to_cpu(dinoc->di_flags)) {
+                       if (!no_modify) {
+                               do_warn(_(", fixing bad flags.\n"));
+                               dinoc->di_flags = cpu_to_be16(flags);
+                               *dirty = 1;
+                       } else
+                               do_warn(_(", would fix bad flags.\n"));
+               }
+       }
+
        if (verify_mode)
                return retval;

-- 
1.7.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
