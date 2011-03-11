Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2BCbCde159949 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 06:37:17 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 584828F80EA
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 04:39:58 -0800 (PST)
Subject: [PATCH] xfs: don't name variables "panic"
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <AANLkTi=Hg4s5kEMQZu_KGePf4W_7jAFm0_WifM9W3PR6@mail.gmail.com>
References: <AANLkTi=Hg4s5kEMQZu_KGePf4W_7jAFm0_WifM9W3PR6@mail.gmail.com>
Date: Fri, 11 Mar 2011 06:39:51 -0600
Message-ID: <1299847191.3462.1.camel@doink>
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
To: XFS Mailing List <xfs@oss.sgi.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>

The new xfs_alert_tag() used a variable named "panic",
and that is to be avoided.  Rename it.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_message.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_message.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_message.c
+++ b/fs/xfs/linux-2.6/xfs_message.c
@@ -96,13 +96,13 @@ xfs_alert_tag(
 {
        struct va_format        vaf;
        va_list                 args;
-       int                     panic = 0;
+       int                     do_panic = 0;
        int                      r;

        if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
                xfs_printk(KERN_ALERT, mp,
                        "XFS: Transforming an alert into a BUG.");
-               panic = 1;
+               do_panic = 1;
        }

        va_start(args, fmt);
@@ -113,7 +113,7 @@ xfs_alert_tag(
        r = __xfs_printk(KERN_ALERT, mp, &vaf);
        va_end(args);

-       BUG_ON(panic);
+       BUG_ON(do_panic);

        return r;
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
