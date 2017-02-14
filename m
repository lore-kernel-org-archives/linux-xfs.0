Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43136 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751370AbdBNG2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 01:28:44 -0500
Message-ID: <1487053720.3125.73.camel@HansenPartnership.com>
Subject: [PATCH 1/2] fs: add inode helpers for fsuid and fsgid
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 13 Feb 2017 22:28:40 -0800
In-Reply-To: <1487053651.3125.72.camel@HansenPartnership.com>
References: <1487008001.3125.41.camel@HansenPartnership.com>
         <20170213194337.GA9852@infradead.org> <20170213213416.GA15349@dastard>
         <20170214060809.GA21114@infradead.org>
         <1487053651.3125.72.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>

Now that we have two different views of filesystem ids (the filesystem
view and the kernel view), we have a problem in that
current_fsuid/fsgid() return the kernel view but are sometimes used in
filesystem code where the filesystem view shoud be used.  This patch
introduces helpers to produce the filesystem view of current fsuid and
fsgid.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

diff --git a/include/linux/cred.h b/include/linux/cred.h
index f0e70a1..18e9c41 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -399,4 +399,9 @@ do {						\
 	*(_fsgid) = __cred->fsgid;		\
 } while(0)
 
+/* return the current id in the filesystem view */
+#define i_fsuid(i) from_kuid((i)->i_sb->s_user_ns, current_fsuid())
+#define i_fsgid(i) from_kgid((i)->i_sb->s_user_ns, current_fsgid())
+
+
 #endif /* _LINUX_CRED_H */
