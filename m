Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 564CE7F51
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:36:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CF6B304039
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:36:53 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id a7L9aYkrwZ3F8XUF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:36:51 -0800 (PST)
Subject: [PATCH 1/5] tools/mvtest: call out to the correct group sort program
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Jan 2016 16:36:48 -0800
Message-ID: <20160123003648.2666.37062.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

mvtest should call the actual name of the sort-group program.
Fix a cut-paste error in finding the destination group file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/mvtest |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tools/mvtest b/tools/mvtest
index af601d6..20bc23e 100755
--- a/tools/mvtest
+++ b/tools/mvtest
@@ -33,7 +33,7 @@ sgroup="$(basename "$(dirname "tests/${src}")")"
 dgroup="$(basename "$(dirname "tests/${dest}")")"
 
 sgroupfile="tests/${sgroup}/group"
-dgroupfile="tests/${sgroup}/group"
+dgroupfile="tests/${dgroup}/group"
 
 git mv "tests/${src}" "tests/${dest}"
 git mv "tests/${src}.out" "tests/${dest}.out"
@@ -47,7 +47,7 @@ newgrpline="$(echo "${grpline}" | sed -e "s/^${sid} /${did} /g")"
 sed -e "/^${sid}.*$/d" -i "${sgroupfile}"
 cp "${dgroupfile}" "${dgroupfile}.new"
 append "${dgroupfile}.new" "${newgrpline}"
-"${dir}/sort-group.py" "${dgroupfile}.new"
+"${dir}/sort-group" "${dgroupfile}.new"
 mv "${dgroupfile}.new" "${dgroupfile}"
 
 echo "Moved \"${src}\" to \"${dest}\"."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
