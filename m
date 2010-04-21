Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3LGh9Ds127732 for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 11:43:10 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B99712F2DB1
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 09:45:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gc2VeH4fKnUg2ASU for
	<xfs@oss.sgi.com>; Wed, 21 Apr 2010 09:45:09 -0700 (PDT)
Received: from int-mx03.intmail.prod.int.phx2.redhat.com
	(int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3LGj8wG007525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 12:45:08 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o3LGj7Ll025944
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 12:45:08 -0400
Message-ID: <4BCF2B93.6090607@sandeen.net>
Date: Wed, 21 Apr 2010 11:45:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsdocs: comment out Author_Group include
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3817280791318634623=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--===============3817280791318634623==
Content-Type: multipart/alternative;
 boundary="------------050003090600030005000004"

This is a multi-part message in MIME format.
--------------050003090600030005000004
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

This is breaking the PDF build for now, let's comment it
out so we can generate PDFs.  The publican folks know and will fix it.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/XFS_Filesystem_Structure/en-US/Book_Info.xml b/XFS_Filesystem_Structure/en-US/Book_Info.xml
index e1e5007..f0ddfed 100644
--- a/XFS_Filesystem_Structure/en-US/Book_Info.xml
+++ b/XFS_Filesystem_Structure/en-US/Book_Info.xml
@@ -29,5 +29,5 @@
 	<legalnotice>
 		<para>© Copyright 2006 Silicon Graphics Inc. All rights reserved.  Permission is granted to copy, distribute, and/or modify this document under the terms of the Creative Commons Attribution-Share Alike, Version 3.0 or any later version published by the Creative Commons Corp. A copy of the license is available at <ulink url="http://creativecommons.org/licenses/by-sa/3.0/us/"/>.</para>
 	</legalnotice>
-	<xi:include href="Author_Group.xml" xmlns:xi="http://www.w3.org/2001/XInclude" />
+	<!-- <xi:include href="Author_Group.xml" xmlns:xi="http://www.w3.org/2001/XInclude" /> -->
 </bookinfo>
diff --git a/XFS_Labs/en-US/Book_Info.xml b/XFS_Labs/en-US/Book_Info.xml
index a72da91..2ebf4fb 100644
--- a/XFS_Labs/en-US/Book_Info.xml
+++ b/XFS_Labs/en-US/Book_Info.xml
@@ -27,6 +27,6 @@
 	<legalnotice>
 		<para>© Copyright 2006 Silicon Graphics Inc. All rights reserved.  Permission is granted to copy, distribute, and/or modify this document under the terms of the Creative Commons Attribution-Share Alike, Version 3.0 or any later version published by the Creative Commons Corp. A copy of the license is available at <ulink url="http://creativecommons.org/licenses/by-sa/3.0/us/"/>.</para>
 	</legalnotice>
-	<xi:include href="Author_Group.xml" xmlns:xi="http://www.w3.org/2001/XInclude" />
+	<!-- <xi:include href="Author_Group.xml" xmlns:xi="http://www.w3.org/2001/XInclude" /> -->
 </bookinfo>
 
diff --git a/XFS_User_Guide/en-US/Article_Info.xml b/XFS_User_Guide/en-US/Article_Info.xml
index d1adeb2..899e499 100644
--- a/XFS_User_Guide/en-US/Article_Info.xml
+++ b/XFS_User_Guide/en-US/Article_Info.xml
@@ -21,6 +21,6 @@
 		</inlinemediaobject>
 	</corpauthor>
 	<xi:include href="Common_Content/Legal_Notice.xml" xmlns:xi="http://www.w3.org/2001/XInclude" />
-	<xi:include href="Author_Group.xml" xmlns:xi="http://www.w3.org/2001/XInclude" />
+	<!-- <xi:include href="Author_Group.xml" xmlns:xi="http://www.w3.org/2001/XInclude" /> -->
 </articleinfo>
 
diff --git a/XFS_User_Guide/en-US/Book_Info.xml b/XFS_User_Guide/en-US/Book_Info.xml
index 69d1da2..d464899 100644
--- a/XFS_User_Guide/en-US/Book_Info.xml
+++ b/XFS_User_Guide/en-US/Book_Info.xml
@@ -27,6 +27,6 @@
 	<legalnotice>
 		<para>© Copyright 2006 Silicon Graphics Inc. All rights reserved.  Permission is granted to copy, distribute, and/or modify this document under the terms of the Creative Commons Attribution-Share Alike, Version 3.0 or any later version published by the Creative Commons Corp. A copy of the license is available at <ulink url="http://creativecommons.org/licenses/by-sa/3.0/us/"/>.</para>
 	</legalnotice>
-	<xi:include href="Author_Group.xml" xmlns:xi="http://www.w3.org/2001/XInclude" />
+	<!-- <xi:include href="Author_Group.xml" xmlns:xi="http://www.w3.org/2001/XInclude" /> -->
 </bookinfo>
 


--------------050003090600030005000004
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
</head>
<body bgcolor="#ffffff" text="#000000">
<pre>This is breaking the PDF build for now, let's comment it
out so we can generate PDFs.  The publican folks know and will fix it.

Signed-off-by: Eric Sandeen <a class="moz-txt-link-rfc2396E" href="mailto:sandeen@sandeen.net">&lt;sandeen@sandeen.net&gt;</a>
---
</pre>
<div class="moz-text-plain" wrap="true" graphical-quote="true"
 style="font-family: -moz-fixed; font-size: 14px;" lang="x-western">
<pre wrap="">diff --git a/XFS_Filesystem_Structure/en-US/Book_Info.xml b/XFS_Filesystem_Structure/en-US/Book_Info.xml
index e1e5007..f0ddfed 100644
--- a/XFS_Filesystem_Structure/en-US/Book_Info.xml
+++ b/XFS_Filesystem_Structure/en-US/Book_Info.xml
@@ -29,5 +29,5 @@
 	&lt;legalnotice&gt;
 		&lt;para&gt;&copy; Copyright 2006 Silicon Graphics Inc. All rights reserved.  Permission is granted to copy, distribute, and/or modify this document under the terms of the Creative Commons Attribution-Share Alike, Version 3.0 or any later version published by the Creative Commons Corp. A copy of the license is available at &lt;ulink url=<a
 class="moz-txt-link-rfc2396E"
 href="http://creativecommons.org/licenses/by-sa/3.0/us/">"http://creativecommons.org/licenses/by-sa/3.0/us/"</a>/&gt;.&lt;/para&gt;
 	&lt;/legalnotice&gt;
-	&lt;xi:include href="Author_Group.xml" xmlns:xi=<a
 class="moz-txt-link-rfc2396E" href="http://www.w3.org/2001/XInclude">"http://www.w3.org/2001/XInclude"</a> /&gt;
+	&lt;!-- &lt;xi:include href="Author_Group.xml" xmlns:xi=<a
 class="moz-txt-link-rfc2396E" href="http://www.w3.org/2001/XInclude">"http://www.w3.org/2001/XInclude"</a> /&gt; --&gt;
 &lt;/bookinfo&gt;
diff --git a/XFS_Labs/en-US/Book_Info.xml b/XFS_Labs/en-US/Book_Info.xml
index a72da91..2ebf4fb 100644
--- a/XFS_Labs/en-US/Book_Info.xml
+++ b/XFS_Labs/en-US/Book_Info.xml
@@ -27,6 +27,6 @@
 	&lt;legalnotice&gt;
 		&lt;para&gt;&copy; Copyright 2006 Silicon Graphics Inc. All rights reserved.  Permission is granted to copy, distribute, and/or modify this document under the terms of the Creative Commons Attribution-Share Alike, Version 3.0 or any later version published by the Creative Commons Corp. A copy of the license is available at &lt;ulink url=<a
 class="moz-txt-link-rfc2396E"
 href="http://creativecommons.org/licenses/by-sa/3.0/us/">"http://creativecommons.org/licenses/by-sa/3.0/us/"</a>/&gt;.&lt;/para&gt;
 	&lt;/legalnotice&gt;
-	&lt;xi:include href="Author_Group.xml" xmlns:xi=<a
 class="moz-txt-link-rfc2396E" href="http://www.w3.org/2001/XInclude">"http://www.w3.org/2001/XInclude"</a> /&gt;
+	&lt;!-- &lt;xi:include href="Author_Group.xml" xmlns:xi=<a
 class="moz-txt-link-rfc2396E" href="http://www.w3.org/2001/XInclude">"http://www.w3.org/2001/XInclude"</a> /&gt; --&gt;
 &lt;/bookinfo&gt;
 
diff --git a/XFS_User_Guide/en-US/Article_Info.xml b/XFS_User_Guide/en-US/Article_Info.xml
index d1adeb2..899e499 100644
--- a/XFS_User_Guide/en-US/Article_Info.xml
+++ b/XFS_User_Guide/en-US/Article_Info.xml
@@ -21,6 +21,6 @@
 		&lt;/inlinemediaobject&gt;
 	&lt;/corpauthor&gt;
 	&lt;xi:include href="Common_Content/Legal_Notice.xml" xmlns:xi=<a
 class="moz-txt-link-rfc2396E" href="http://www.w3.org/2001/XInclude">"http://www.w3.org/2001/XInclude"</a> /&gt;
-	&lt;xi:include href="Author_Group.xml" xmlns:xi=<a
 class="moz-txt-link-rfc2396E" href="http://www.w3.org/2001/XInclude">"http://www.w3.org/2001/XInclude"</a> /&gt;
+	&lt;!-- &lt;xi:include href="Author_Group.xml" xmlns:xi=<a
 class="moz-txt-link-rfc2396E" href="http://www.w3.org/2001/XInclude">"http://www.w3.org/2001/XInclude"</a> /&gt; --&gt;
 &lt;/articleinfo&gt;
 
diff --git a/XFS_User_Guide/en-US/Book_Info.xml b/XFS_User_Guide/en-US/Book_Info.xml
index 69d1da2..d464899 100644
--- a/XFS_User_Guide/en-US/Book_Info.xml
+++ b/XFS_User_Guide/en-US/Book_Info.xml
@@ -27,6 +27,6 @@
 	&lt;legalnotice&gt;
 		&lt;para&gt;&copy; Copyright 2006 Silicon Graphics Inc. All rights reserved.  Permission is granted to copy, distribute, and/or modify this document under the terms of the Creative Commons Attribution-Share Alike, Version 3.0 or any later version published by the Creative Commons Corp. A copy of the license is available at &lt;ulink url=<a
 class="moz-txt-link-rfc2396E"
 href="http://creativecommons.org/licenses/by-sa/3.0/us/">"http://creativecommons.org/licenses/by-sa/3.0/us/"</a>/&gt;.&lt;/para&gt;
 	&lt;/legalnotice&gt;
-	&lt;xi:include href="Author_Group.xml" xmlns:xi=<a
 class="moz-txt-link-rfc2396E" href="http://www.w3.org/2001/XInclude">"http://www.w3.org/2001/XInclude"</a> /&gt;
+	&lt;!-- &lt;xi:include href="Author_Group.xml" xmlns:xi=<a
 class="moz-txt-link-rfc2396E" href="http://www.w3.org/2001/XInclude">"http://www.w3.org/2001/XInclude"</a> /&gt; --&gt;
 &lt;/bookinfo&gt;
 
</pre>
</div>
</body>
</html>

--------------050003090600030005000004--


--===============3817280791318634623==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3817280791318634623==--
