Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1IHqT35228837 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 11:52:29 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4E2C129F487
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 09:55:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PrgnFOHIq6NLOGmU for
	<xfs@oss.sgi.com>; Fri, 18 Feb 2011 09:55:10 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1IHt9gq031323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 12:55:09 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p1IHt8cv000741
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 12:55:09 -0500
Message-ID: <4D5EB27C.3070306@redhat.com>
Date: Fri, 18 Feb 2011 11:55:08 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH V2] xfs_quota: don't try to report quotas which aren't there.
References: <4D5EB09A.3030605@redhat.com>
In-Reply-To: <4D5EB09A.3030605@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2252218025988210774=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--===============2252218025988210774==
Content-Type: multipart/alternative;
 boundary="------------030609000009030408040603"

This is a multi-part message in MIME format.
--------------030609000009030408040603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Red Hat bug #669333 - xfs_quota generates "XFS_GETQUOTA: No such process" errors
shows that if you do this for a filesystem w/o group quota enabled:

# xfs_quota -x -c ' report -h ' /xfsquota"

You'll get this output:

User quota on /xfsquota (/dev/vdb)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------]

XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process
...

because we're calling XFS_GETQUOTA for types which aren't enabled.

The below patch fixes it for me, just ignoring types that aren't
there.  Thanks to Arkadiusz Miskiewicz for pointing out the simpler
fix.  :)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/quota/report.c b/quota/report.c
index 0e005c3..7d391c6 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -302,7 +302,7 @@ report_mount(
 	int		count;
 
 	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
-		if (errno != ENOENT && errno != ENOSYS)
+		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH)
 			perror("XFS_GETQUOTA");
 		return 0;
 	}



--------------030609000009030408040603
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
    <title></title>
  </head>
  <body bgcolor="#ffffff" text="#000000">
    <pre wrap="">Red Hat bug #669333 - xfs_quota generates "XFS_GETQUOTA: No such process" errors
shows that if you do this for a filesystem w/o group quota enabled:

# xfs_quota -x -c ' report -h ' /xfsquota"

You'll get this output:

User quota on /xfsquota (/dev/vdb)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------]

XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process
...

because we're calling XFS_GETQUOTA for types which aren't enabled.

The below patch fixes it for me, just ignoring types that aren't
there.  Thanks to Arkadiusz Miskiewicz for pointing out the simpler
fix.  :)

Signed-off-by: Eric Sandeen <a class="moz-txt-link-rfc2396E" href="mailto:sandeen@redhat.com">&lt;sandeen@redhat.com&gt;</a>
---

</pre>
    <div class="moz-text-plain" wrap="true" style="font-family:
      -moz-fixed; font-size: 12px;" lang="x-western">
      <pre wrap="">diff --git a/quota/report.c b/quota/report.c
index 0e005c3..7d391c6 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -302,7 +302,7 @@ report_mount(
 	int		count;
 
 	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&amp;d) &lt; 0) {
-		if (errno != ENOENT &amp;&amp; errno != ENOSYS)
+		if (errno != ENOENT &amp;&amp; errno != ENOSYS &amp;&amp; errno != ESRCH)
 			perror("XFS_GETQUOTA");
 		return 0;
 	}
</pre>
    </div>
    <br>
  </body>
</html>

--------------030609000009030408040603--


--===============2252218025988210774==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2252218025988210774==--
