Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 01:30:29 -0700 (PDT)
Received: from zebday.corky.net (corky.net [212.150.53.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T8ULtL000562
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 01:30:23 -0700
Message-ID: <4684C168.2050605@corky.net>
Date: Fri, 29 Jun 2007 09:23:04 +0100
From: Just Marc <marc@corky.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr, performance related tweaks
References: <4683ADF5.9050901@corky.net> <1183075929.15488.148.camel@edge.yarra.acx> <4684A728.1050405@corky.net> <20070629081357.GC14519@one.firstfloor.org>
In-Reply-To: <20070629081357.GC14519@one.firstfloor.org>
Content-Type: multipart/mixed;
 boundary="------------080102000005080906000206"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: nscott@aconex.com, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------080102000005080906000206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Many files are being added concurrently, 24/7.   You might have hit the 
nail on the head, some of the files it was not able to improve are on 
filesystems that are almost full.    As the patch is done anyway here it is.

It does three things:

1. Actually make the usage printing become visible using -v,  the 
default case of getopt was never reached.
2. Reduces the number of 'stat' calls when scanning a filesystem for 
work to do, it now first checks if the file is marked as no-defrag 
before stat'ing it
3. Optionally, the -X parameter will tell fsr not to defrag files which 
it had decided it can't improve: 'No improvement will be made' ...

Marc


Andi Kleen wrote:
>> I run fsr all the time because in my case there is hundreds of gigs of 
>> new data added to each file system every day, some of it does badly need 
>> to be defragged as the files added are actively being served, not just 
>>     
>
> It might be better to investigate why XFS does such a poor job
> for your workload in the first case. Unless the file systems
> are always nearly full or you have a lot of holes it shouldn't fragment
> that badly in the first place.
>
> -Andi
>
>   


--------------080102000005080906000206
Content-Type: text/plain;
 name="xfs_fsr.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_fsr.diff"

--- xfs_fsr.c.orig	2007-06-28 07:40:42.572069164 +0100
+++ xfs_fsr.c	2007-06-29 09:18:44.330906899 +0100
@@ -68,6 +68,7 @@
 
 int vflag;
 int gflag;
+int xflag;
 static int Mflag;
 /* static int nflag; */
 int dflag = 0;
@@ -218,7 +219,7 @@
 
 	gflag = ! isatty(0);
 
-	while ((c = getopt(argc, argv, "C:p:e:MgsdnvTt:f:m:b:N:FV")) != -1 )
+	while ((c = getopt(argc, argv, "C:p:e:MgsdnvTt:f:m:b:N:FVXh")) != -1 )
 		switch (c) {
 		case 'M':
 			Mflag = 1;
@@ -267,7 +268,10 @@
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
 			exit(0);
-		default:
+		case 'X':
+			 xflag = 1; /* no eXtra work */
+			 break;
+		case 'h':
 			usage(1);
 		}
 	if (vflag)
@@ -371,6 +375,8 @@
 "       -f leftoff      Use this instead of /etc/fsrlast.\n"
 "       -m mtab         Use something other than /etc/mtab.\n"
 "       -d              Debug, print even more.\n"
+"       -h              Show usage.\n"
+"       -X              Mark as no-defrag files which can't be defragged further.\n"
 "       -v		Verbose, more -v's more verbose.\n"
 		), progname, progname);
 	exit(ret);
@@ -904,20 +910,6 @@
 		}
 	}
 
-	/* Check if there is room to copy the file */
-	if ( statvfs64( (fsname == NULL ? fname : fsname), &vfss) < 0) {
-		fsrprintf(_("unable to get fs stat on %s: %s\n"),
-			fname, strerror(errno));
-		return (-1);
-	}
-	bsize = vfss.f_frsize ? vfss.f_frsize : vfss.f_bsize;
-
-	if (statp->bs_size > ((vfss.f_bfree * bsize) - minimumfree)) {
-		fsrprintf(_("insufficient freespace for: %s: "
-			"size=%lld: ignoring\n"), fname, statp->bs_size);
-		return 1;
-	}
-
 	if ((ioctl(fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
 		fsrprintf(_("failed to get inode attrs: %s\n"), fname);
 		return(-1);
@@ -951,6 +943,20 @@
 		return -1;
 	}
 
+	/* Check if there is room to copy the file */
+	if ( statvfs64( (fsname == NULL ? fname : fsname), &vfss) < 0) {
+		fsrprintf(_("unable to get fs stat on %s: %s\n"),
+			fname, strerror(errno));
+		return (-1);
+	}
+	bsize = vfss.f_frsize ? vfss.f_frsize : vfss.f_bsize;
+
+	if (statp->bs_size > ((vfss.f_bfree * bsize) - minimumfree)) {
+		fsrprintf(_("insufficient freespace for: %s: "
+			"size=%lld: ignoring\n"), fname, statp->bs_size);
+		return 1;
+	}
+
 	/*
 	 * Previously the code forked here, & the child changed it's uid to
 	 * that of the file's owner and then called packfile(), to keep
@@ -1128,11 +1134,32 @@
 	if (dflag)
 		fsrprintf(_("Temporary file has %d extents (%d in original)\n"), new_nextents, cur_nextents);
 	if (cur_nextents <= new_nextents) {
+	 	struct fsxattr fsx_tmp;	
+
 		if (vflag)
 			fsrprintf(_("No improvement will be made (skipping): %s\n"), fname);
 		free(fbuf);
+
+	 	if (xflag) {
+			/* Get the current inode flags */
+			if ((ioctl(fd, XFS_IOC_FSGETXATTR, &fsx_tmp)) < 0) {
+				fsrprintf(_("failed to get inode attrs: %s\n"), fname);
+				return -1;
+			}
+		
+			/* Add no-defrag */
+			fsx_tmp.fsx_xflags |= XFS_XFLAG_NODEFRAG;
+
+			/* Mark it! */
+			if (ioctl(fd, XFS_IOC_FSSETXATTR, &fsx_tmp) < 0) {
+				fsrprintf(_("could not set inode attrs on: %s\n"), fname);
+				close(tfd);
+				return -1;
+			}
+		}
+	
 		close(tfd);
-		return 1; /* no change/no error */
+		return 0; /* We're done with this file, forever. */
 	}
 
 	/* Loop through block map copying the file. */

--------------080102000005080906000206--
