Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA76FfaK040059 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 00:15:41 -0600
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65B132264EE
	for <xfs@oss.sgi.com>; Sun,  6 Nov 2011 22:15:39 -0800 (PST)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id HUnQHpT0Xcod5Q0S
	for <xfs@oss.sgi.com>; Sun, 06 Nov 2011 22:15:39 -0800 (PST)
Received: by bkaq10 with SMTP id q10so1718093bka.26
	for <xfs@oss.sgi.com>; Sun, 06 Nov 2011 22:15:39 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 7/9] xfstests: add a new quota test that runs fsstress
	under ENOSPC conditions
In-Reply-To: <20111103193935.GA23014@infradead.org>
References: <1320342953-7973-1-git-send-email-dmonakhov@openvz.org>
	<1320342953-7973-7-git-send-email-dmonakhov@openvz.org>
	<20111103193935.GA23014@infradead.org>
Date: Mon, 07 Nov 2011 10:15:33 +0400
Message-ID: <871utkmpa2.fsf@dmbot.sw.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, hch@lst.de, aelder@sgi.com

--=-=-=

On Thu, 3 Nov 2011 15:39:35 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Nov 03, 2011 at 09:55:51PM +0400, Dmitry Monakhov wrote:
> > - Same as 264 but with quota enabled.
> 
> 269 is the new 270
> 
> > - IO performed from $qa_user user
> > - fsstress granted with CAP_CHOWN capability.
> 
> This fails in my test VM because it doesn't have setcap.  If you
> want to use additional non-standard tools please do a _notrun if
> they aren't present.
> 
> I don't quite understand why it would need CAP_CHOWN - chowns
> from owned files do not require it, and the test runs fine with
> the setcap line commented out.
Yes, but fsstress want chown to random uid/gid 
int inode_change_ok(..)
...
        /* Make sure a caller can chown. */
        if ((ia_valid & ATTR_UID) &&
            (current_fsuid() != inode->i_uid ||
             attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
                return -EPERM;
>From my experience fssstess with chown enabled is the most valuable
quota accounting test. W/o chown this is just an useless time consumer.
> 
> I'll commit it as-is for now, but unless I get some feedback on
> why the setcap is require I'll add another commit to remove it ASAP.


--=-=-=
Content-Disposition: inline;
 filename=0001-xfstests-270-th-test-want-use-setcap-8.patch

>From f8611f3bbc5ea2ac3672ee6c88d2d43d69351d49 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Mon, 7 Nov 2011 08:07:57 +0300
Subject: [PATCH] xfstests: 270'th test want use setcap(8)

It wants to grant CAP_CHOWN to fsstress, without this capability
chown(2) will fail due to EPERM. Since chown(2) is one of the most
error prone places of quota accounting this makes 270'th
test almost useless, so it is better to simply skip it.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 270 |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/270 b/270
index ed1e31e..90e24f5 100755
--- a/270
+++ b/270
@@ -52,6 +52,9 @@ _workout()
 	echo "fsstress $args" >> $here/$seq.full
 	# Grant chown capability 
 	cp $FSSTRESS_PROG  $tmp.fsstress.bin
+	if [ "`whereis setcap`" == "setcap:" ]; then
+            _notrun "setcap not installed."
+	fi
 	setcap cap_chown=epi  $tmp.fsstress.bin
 
 	(su $qa_user -c "$tmp.fsstress.bin $args" &) > /dev/null 2>&1
-- 
1.7.1


--=-=-=

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-=-=--
