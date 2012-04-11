Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3BGPDHS083135 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 11:25:13 -0500
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 56E748F8054
	for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 09:25:10 -0700 (PDT)
Date: Wed, 11 Apr 2012 11:26:27 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH] disable tags in post-receive hook
Message-ID: <20120411162627.GJ1802@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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

Hey Folks,

    Yesterday I pushed tags to the oss.sgi.com xfs git repository and forgot to
    disable the post-receive hook which generates email to the list at commit
    time.  You probably saw the resulting mailbomb.  I'm sorry about that.  In
    order to make sure it doesn't happen again next time, I have applied the
    following patch to our post-receive hook:


--- post-receive-email.xfs	2009-01-16 01:05:09.000000000 -0600
+++ post-receive-email.xfs.tags_disabled	2012-04-11 10:39:30.542537604 -0500
@@ -105,6 +105,9 @@
 			# un-annotated tag
 			refname_type="tag"
 			short_refname=${refname##refs/tags/}
+			# bpm: clear recipients to disable sending email for 
+			# tags.  I just mail bombed the list.  3/11/12
+			recipients=""
 			;;
 		refs/tags/*,tag)
 			# annotated tag
@@ -114,6 +117,9 @@
 			if [ -n "$announcerecipients" ]; then
 				recipients="$announcerecipients"
 			fi
+			# bpm: clear recipients to disable sending email for 
+			# tags.  I just mail bombed the list.  3/11/12
+			recipients=""
 			;;
 		refs/heads/*,commit)
 			# branch


    I've tested it out and it seems to have the desired effect.  So... just a
    heads up, you won't be receiving mail for new tags in the xfs git repo on
    oss.sgi.com.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
