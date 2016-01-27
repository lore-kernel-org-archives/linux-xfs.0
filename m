Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F40427CA2
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 16:51:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E3BE08F8040
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 14:51:32 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BBdaA5I8nldhcY9U for <xfs@oss.sgi.com>;
	Wed, 27 Jan 2016 14:51:31 -0800 (PST)
Received: from Liberator.local (70-90-76-85-BusName-mn.hfc.comcastbusiness.net
	[70.90.76.85])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5E1C9660C83E
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 16:51:31 -0600 (CST)
Subject: [PATCH 2/2] xfs_quota: fix up timer command help
References: <56A9497C.9070400@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A949F2.8080802@sandeen.net>
Date: Wed, 27 Jan 2016 16:51:30 -0600
MIME-Version: 1.0
In-Reply-To: <56A9497C.9070400@sandeen.net>
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

The timer command help output suggests that either default, or a
specific ID, can be specified, but this is not the case.  Timers
are fs-wide for each quota type, not specific to the user.  So
remove the "-d|id|name" from the help output.  Also remove
"get" from the description, because it only sets these timers;
"state" returns their values.  Well actually just one of them,
but that's a different problem...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/edit.c b/quota/edit.c
index c55fa1a..6146f7e 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -701,8 +701,8 @@ edit_init(void)
 	timer_cmd.cfunc = timer_f;
 	timer_cmd.argmin = 2;
 	timer_cmd.argmax = -1;
-	timer_cmd.args = _("[-bir] [-gpu] value -d|id|name");
-	timer_cmd.oneline = _("get/set quota enforcement timeouts");
+	timer_cmd.args = _("[-bir] [-gpu] value");
+	timer_cmd.oneline = _("set quota enforcement timeouts");
 	timer_cmd.help = timer_help;
 
 	warn_cmd.name = "warn";

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
