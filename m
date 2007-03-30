Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 18:32:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2U1WO6p021325
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 18:32:25 -0700
Message-ID: <460C691D.9080100@sgi.com>
Date: Fri, 30 Mar 2007 11:34:21 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Review: do not hold dm_reg_lock spinlock when calling dm_add_fsys_entry()
Content-Type: multipart/mixed;
 boundary="------------010501070808020005050807"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------010501070808020005050807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


dm_reg_lock spinlock has been held when calling dm_add_fsys_entry()

Attached is a fix.

Regards,
Vlad

--------------010501070808020005050807
Content-Type: text/x-patch;
 name="sleeping-in-atomic-in-dmapi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sleeping-in-atomic-in-dmapi.patch"

Index: linux/fs/dmapi/dmapi_register.c
===================================================================
--- linux.orig/fs/dmapi/dmapi_register.c
+++ linux/fs/dmapi/dmapi_register.c
@@ -252,6 +252,7 @@ dm_add_fsys_entry(
 		fsrp->fr_next = dm_registers;
 		dm_registers = fsrp;
 		dm_fsys_cnt++;
+		mutex_spinunlock(&dm_reg_lock, lc);
 #ifdef CONFIG_PROC_FS
 		{
 		char buf[100];
@@ -262,7 +263,6 @@ dm_add_fsys_entry(
 		entry->owner = THIS_MODULE;
 		}
 #endif
-		mutex_spinunlock(&dm_reg_lock, lc);
 		return(0);
 	}
 

--------------010501070808020005050807--
