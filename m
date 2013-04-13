Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A3ED7F3F
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 15:50:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0875A304032
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 13:50:13 -0700 (PDT)
Received: from mail-yh0-f42.google.com (mail-yh0-f42.google.com
	[209.85.213.42]) by cuda.sgi.com with ESMTP id 5uAfDHarpdkemmF7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Apr 2013 13:50:13 -0700 (PDT)
Received: by mail-yh0-f42.google.com with SMTP id b41so598519yha.15
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 13:50:12 -0700 (PDT)
Message-ID: <5169C4FE.4030209@gmail.com>
Date: Sat, 13 Apr 2013 16:50:06 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: xfstests: kludge patch for per-dir test number sorting by ./check
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
To: xfstests <xfs@oss.sgi.com>

I'm trying to get the new xfstests to run the XFS tests first, then run 
the generic group, then run the shared group.  One attempt was to work 
with this variable in the ./check script:

SRC_GROUPS="generic shared"

There is a final file sort in ./check that means, no matter which order 
groups are specified in SRC_GROUPS, the groups will be executed in 
alphabetical order.  This sysadmin kludge patch fixes that behavior and 
seems to work.  By moving the sorting into the trim_test_list() 
function, test numbers are still sorted, but the groups seem to run in 
the order specified in the SRC_GROUPS variable.

Let me know if this helps or if I'm simply not using the new xfstests 
correctly.

Michael

--- xfstests/check.orig	2013-03-30 00:54:37.000000000 -0400
+++ xfstests/check	2013-04-13 13:41:42.002814733 -0400
@@ -138,7 +138,7 @@
  	    echo "^$t\$" >>$tmp.grep
  	    numsed=`expr $numsed + 1`
  	done
-	grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
+	grep -v -f $tmp.grep <$tmp.list | sort -n >$tmp.tmp
  	mv $tmp.tmp $tmp.list
  }

@@ -268,7 +268,7 @@
  fi

  # sort the list of tests into numeric order
-list=`sort -n $tmp.list`
+list=`cat $tmp.list`
  rm -f $tmp.list $tmp.tmp $tmp.grep

  if $randomize

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
