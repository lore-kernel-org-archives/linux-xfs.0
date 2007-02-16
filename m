Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Feb 2007 23:34:20 -0800 (PST)
Received: from pd2mo1so.prod.shaw.ca (shawidc-mo1.cg.shawcable.net [24.71.223.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1G7YEm7031835
	for <xfs@oss.sgi.com>; Thu, 15 Feb 2007 23:34:15 -0800
Received: from pd5mr5so.prod.shaw.ca
 (pd5mr5so-qfe3.prod.shaw.ca [10.0.141.181]) by l-daemon
 (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JDJ0017XM7NH830@l-daemon> for xfs@oss.sgi.com; Thu,
 15 Feb 2007 23:33:23 -0700 (MST)
Received: from pn2ml8so.prod.shaw.ca ([10.0.121.152])
 by pd5mr5so.prod.shaw.ca (Sun Java System Messaging Server 6.2-7.05 (built Sep
 5 2006)) with ESMTP id <0JDJ00M2MM7NWQE0@pd5mr5so.prod.shaw.ca> for
 xfs@oss.sgi.com; Thu, 15 Feb 2007 23:33:23 -0700 (MST)
Received: from mail.kevinjamieson.com ([24.87.84.75])
 by l-daemon (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JDJ0038CM7N5OG0@l-daemon> for xfs@oss.sgi.com; Thu,
 15 Feb 2007 23:33:23 -0700 (MST)
Date: Thu, 15 Feb 2007 22:33:21 -0800
From: Kevin Jamieson <kevin@kevinjamieson.com>
Subject: [PATCH] dm_create_session() calls create_proc_entry() with spinlock
 held
Reply-to: kjamieson@bycast.com
Message-id: <45D55031.1030507@kevinjamieson.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

dm_create_session() calls create_proc_read_entry() with the dm_session_lock
spinlock held. But create_proc_entry() calls kmalloc(GFP_KERNEL), which can
sleep, so this isn't safe.

We have observed this to cause deadlocks with multiple processes creating/using
DMAPI sessions concurrently (this was with SLES10's 2.6.16.21-0.8 kernel, but
the DMAPI code in question is the same in CVS HEAD):

BUG: spinlock cpu recursion on CPU#1, a1/3235
 lock: f930c49c, .magic: dead4ead, .owner: a2/22546, .owner_cpu: 1

Stack traceback for pid 6144
0xdfc98270     6144     2748  1    0   R  0xdfc98450  a1
EBP        EIP        Function (args)
0xf0f5be24 0xc010d89f delay_tsc+0xc (0xf0f5be44)
0xf0f5be2c 0xc01cd928 __delay+0xc (0x1, 0x18, 0xf0f5be90, 0xf0f5be8c)
           0xc01ceb85 _raw_spin_lock+0x79
0xf0f5be4c 0xc02afd93 _spin_lock+0x8 (0x1, 0x18, 0xf0f5be8c, 0x1)
0xf0f5be64 0xf9307302 [dmapi]dm_find_session_and_lock+0x1a (0x2220a, 0x1,
0x8fb5b198, 0x6f6b8864, 0xe)
0xf0f5bea0 0xf93062eb [dmapi]dm_app_get_tdp+0x87 (0xffffffff, 0x2, 0x1,
0xf0f5beb8, 0x3000)
0xf0f5bec0 0xf9302cf6 [dmapi]dm_read_invis_rvp+0x17 (0xffffffff,
0x27c4000, 0x0, 0x4000, 0x0)
0xf0f5bf48 0xf93014b9 [dmapi]dmapi_ioctl+0x4ab (0xab0be160, 0x28,
0xfffffff7, 0xf787f9c0, 0xab0be160)
0xf0f5bf64 0xc01700d3 do_ioctl+0x4f (0xaf345000, 0xf6f58240, 0x1b, 0x2,
0xaf3459ac)
0xf0f5bf98 0xc0170346 vfs_ioctl+0x25a (0xab0be160, 0x1, 0x1b, 0x0,
0xb7825bf0)
0xf0f5bfb4 0xc01703a9 sys_ioctl+0x50
           0xc0103d1b sysenter_past_esp+0x54

Stack traceback for pid 3254
0xdfec0720     3254     2748  1    1   R  0xdfec0900 *a1
EBP        EIP        Function (args)
0xf6f71e40 0xc01ce862 spin_bug (0xf66cbf20, 0xffffffda, 0xf6f71ec0,
0xf6f71ebc)
           0xc01ceb58 _raw_spin_lock+0x4c
0xf6f71e48 0xc02afd93 _spin_lock+0x8 (0x1, 0xffffffda, 0x0, 0xb32f01d0)
0xf6f71e60 0xf9307302 [dmapi]dm_find_session_and_lock+0x1a (0x0, 0x1, 0x0,
0x0, 0x3)
0xf6f71ed0 0xf9307538 [dmapi]dm_get_events+0x24 (0xfff, 0xad2e2ae8,
0xb32f02c8, 0x1, 0x0)
0xf6f71f48 0xf9301274 [dmapi]dmapi_ioctl+0x266 (0xb32f01d0, 0x12,
0xfffffff7, 0xf787f9c0, 0xb32f01d0)
0xf6f71f64 0xc01700d3 do_ioctl+0x4f (0x0, 0x0, 0x1b, 0xf66d31cc,
0x8517980)
0xf6f71f98 0xc0170346 vfs_ioctl+0x25a (0xb32f01d0, 0x1, 0x1b, 0xad2f7400,
0xb32f02c4)
0xf6f71fb4 0xc01703a9 sys_ioctl+0x50
           0xc0103d1b sysenter_past_esp+0x54

Stack traceback for pid 12452
0xdfb047e0    12452    12451  0    1   R  0xdfb049c0  a2
EBP        EIP        Function (args)
0xf14cbcbc 0xc02ae254 schedule+0xb84 (0xdffff180)
0xf14cbcc8 0xc02ae33b cond_resched+0x36 (0x0, 0x1, 0xf14cbe53)
0xf14cbcdc 0xc015d07a __kmalloc+0x4a (0x1, 0x8124, 0xa, 0x8, 0xf14cbe48)
0xf14cbd04 0xc018ef93 proc_create+0x8c (0x1, 0xf784d440, 0xf14cbe34,
0xd53b5de8)
0xf14cbd1c 0xc018f045 create_proc_entry+0x5f (0xf14cbe34, 0xf9309030,
0xd53b5de8, 0x7, 0x61637942)
0xf14cbedc 0xf9307c14 [dmapi]dm_create_session+0x234 (0x0, 0x0, 0x80db388,
0xb7fccff4, 0x82fa604)
0xf14cbf48 0xf93010b0 [dmapi]dmapi_ioctl+0xa2 (0xbfd1fb00, 0x3,
0xfffffff7, 0xf1399540, 0xbfd1fb00)
0xf14cbf64 0xc01700d3 do_ioctl+0x4f (0xf54cf080, 0xf782cee4, 0x3,
0xc02b0c16, 0x0)
0xf14cbf98 0xc0170346 vfs_ioctl+0x25a (0xbfd1fb00, 0x0, 0x3, 0x82fa600,
0x2)
0xf14cbfb4 0xc01703a9 sys_ioctl+0x50
           0xc0103d1b sysenter_past_esp+0x54


It doesn't appear necessary for create/remove_proc_entry() to be called with the
dm_session_lock spinlock held. The following patch moves these calls outside of
the spinlock.


Signed-off-by: Kevin Jamieson <kjamieson@bycast.com> 

Index: fs/dmapi/dmapi_session.c
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/dmapi/dmapi_session.c,v
retrieving revision 1.31
diff -u -r1.31 dmapi_session.c
--- fs/dmapi/dmapi_session.c	12 Jan 2007 15:07:58 -0000	1.31
+++ fs/dmapi/dmapi_session.c	16 Feb 2007 06:14:08 -0000
@@ -519,13 +519,14 @@
 		sv_init(&s->sn_readerq, SV_DEFAULT, "dmreadq");
 		sv_init(&s->sn_writerq, SV_DEFAULT, "dmwritq");
 		spinlock_init(&s->sn_qlock, "sn_qlock");
-		lc = mutex_spinlock(&dm_session_lock);
 	} else {
 		lc = mutex_spinlock(&dm_session_lock);
 		if ((error = dm_find_session(old, &s)) != 0) {
 			mutex_spinunlock(&dm_session_lock, lc);
 			return(error);
 		}
+		unlink_session(s);
+		mutex_spinunlock(&dm_session_lock, lc);
 #ifdef CONFIG_PROC_FS
 		{
 		char buf[100];
@@ -533,12 +534,13 @@
 		remove_proc_entry(buf, NULL);
 		}
 #endif
-		unlink_session(s);
 	}
 	memcpy(s->sn_info, sessinfo, len);
 	s->sn_info[len-1] = 0;		/* if not NULL, then now 'tis */
 	s->sn_sessid = sid;
+	lc = mutex_spinlock(&dm_session_lock);
 	link_session(s);
+	mutex_spinunlock(&dm_session_lock, lc);
 #ifdef CONFIG_PROC_FS
 	{
 	char buf[100];
@@ -549,7 +551,6 @@
 	entry->owner = THIS_MODULE;
 	}
 #endif
-	mutex_spinunlock(&dm_session_lock, lc);
 	return(0);
 }
 
@@ -583,6 +584,12 @@
 		mutex_spinunlock(&dm_session_lock, lc);
 		return(-EBUSY);
 	}
+	
+	/* The session is not in use.  Dequeue it from the session chain. */
+
+	unlink_session(s);
+	nested_spinunlock(&s->sn_qlock);
+	mutex_spinunlock(&dm_session_lock, lc);
 
 #ifdef CONFIG_PROC_FS
 	{
@@ -592,12 +599,6 @@
 	}
 #endif
 
-	/* The session is not in use.  Dequeue it from the session chain. */
-
-	unlink_session(s);
-	nested_spinunlock(&s->sn_qlock);
-	mutex_spinunlock(&dm_session_lock, lc);
-
 	/* Now clear the sessions's disposition registration, and then destroy
 	   the session structure.
 	*/
