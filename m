Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Mar 2008 11:43:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2QIgpWM014159
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 11:42:52 -0700
Received: from mail.arkeia.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3427A6F1634
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 11:43:21 -0700 (PDT)
Received: from mail.arkeia.com (mail2.fr.arkeia.com [62.240.235.218]) by cuda.sgi.com with ESMTP id oGim0sy9uHFIa57B for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 11:43:21 -0700 (PDT)
Message-ID: <47EA99AD.9060400@free.fr>
Date: Wed, 26 Mar 2008 19:45:01 +0100
From: Hubert Verstraete <hubskml@free.fr>
MIME-Version: 1.0
Subject: [PATCH] XFS tuning on software RAID5 partitionable array; was: MDP
 major registration
References: <47D90614.9040206@free.fr> <18408.36753.223347.129420@notabene.brown> <47E92EE2.1080108@free.fr> <20080326065232.GA21970@percy.comedia.it> <47EA71BF.8050800@tmr.com> <47EA8CF4.7080201@free.fr>
In-Reply-To: <47EA8CF4.7080201@free.fr>
Content-Type: multipart/mixed;
 boundary="------------050802060205070700070009"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-raid@vger.kernel.org

This is a multi-part message in MIME format.
--------------050802060205070700070009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi XFS list,

please find attached a patch for libdisk/mkfs.xfs which tunes XFS on 
software partitionable RAID arrays, also called mdp.

Hubert Verstraete

Hubert Verstraete wrote:
> Bill Davidsen wrote:
>> Luca Berra wrote:
>>> On Tue, Mar 25, 2008 at 05:57:06PM +0100, Hubert Verstraete wrote:
>>>> Neil Brown wrote:
>>>>> On Thursday March 13, hubskml@free.fr wrote:
>>>>>> Neil,
>>>>>>
>>>>>> What is the status of the major for the partitionable arrays ?
>>>>>
>>>>> automatically determined at runtime.
>>>>>
>>>>>> I see that it is 254, which is in the experimental section, 
>>>>>> according to the official Linux device list 
>>>>>> (http://www.lanana.org/docs/device-list/).
>>>>>> Will there be an official registration ?
>>>>>
>>>>> No. Is there any need?
>>>>
>>>> I got this question in mind when I saw that mkfs.xfs source code was 
>>>> referring to the MD major to tune its parameters on an MD device, 
>>>> while it ignores MDP devices.
>>>> If there were reasons to register MD, wouldn't they apply to MDP too ?
>>>
>>> i don't think so:
>>> bluca@percy ~ $ grep mdp /proc/devices
>>> 253 mdp
>>
>> Why is it important to have XFS tune its parameters for md and not for 
>> mdp? I don't understand your conclusion here, is tuning not needed for 
>> mdp, or so meaningless that it doesn't matter, or that XFS code reads 
>> /proc/devices, or ??? I note that device-mapper also has a dynamic 
>> major, what does XFS make of that?
> 
> It reads from /proc/devices.
> 
>> I don't know how much difference tuning makes, but if it's worth doing 
>> at all, it should be done for mdp as well, I would think.
> 
> Same thought. I wrote the patch for mkfs.xfs but did not publish it for 
> two reasons:
> 1) MD is registered but not MDP. Now I understand, it's not a problem, 
> we just need to read /proc/devices as device-mapper does.
> 2) Tuning XFS for MDP can be achieved through the mkfs.xfs options. With 
> a few lines in shell, my XFS on MDP now has the same performance as XFS 
> on MD.
> 
> Hubert
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--------------050802060205070700070009
Content-Type: text/x-patch;
 name="xfsprogs_mdp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfsprogs_mdp.patch"

diff -u -r xfsprogs-2.8.11/libdisk/md.c xfsprogs-2.8.11-mdp/libdisk/md.c
--- xfsprogs-2.8.11/libdisk/md.c	2006-06-26 07:01:15.000000000 +0200
+++ xfsprogs-2.8.11-mdp/libdisk/md.c	2008-03-26 20:12:38.000000000 +0100
@@ -24,8 +24,12 @@
 	dev_t		dev)
 {
 	if (major(dev) == MD_MAJOR)
-		return 1;
-	return get_driver_block_major("md", major(dev));
+		return MD_IS_MD;
+	if (get_driver_block_major("md", major(dev)))
+		return MD_IS_MD;
+	if (get_driver_block_major("mdp", major(dev)))
+		return MD_IS_MDP;
+	return 0;
 }
 
 int
@@ -37,12 +41,32 @@
 	int		*sectalign,
 	struct stat64	*sb)
 {
-	if (mnt_is_md_subvol(sb->st_rdev)) {
+	char *pc, *dfile2 = NULL;
+	int is_md;
+
+	if ((is_md = mnt_is_md_subvol(sb->st_rdev))) {
 		struct md_array_info	md;
 		int			fd;
 
+		if (is_md == MD_IS_MDP) {
+			if (!(pc = strrchr(dfile, 'd'))
+			|| !(pc = strchr(pc, 'p'))) {
+				fprintf(stderr,
+					_("Error getting MD array device from %s\n"),
+					dfile);
+				exit(1);
+			}
+			dfile2 = (char *) malloc(pc - dfile + 1);
+			if (dfile2 == NULL) {
+				fprintf(stderr,
+					_("Couldn't malloc device string\n"));
+				exit(1);
+			}
+			strncpy(dfile2, dfile, pc - dfile);
+			dfile2[pc - dfile + 1] = '\0';
+		}
 		/* Open device */
-		fd = open(dfile, O_RDONLY);
+		fd = open(dfile2 ? dfile2 : dfile, O_RDONLY);
 		if (fd == -1)
 			return 0;
 
@@ -50,10 +74,11 @@
 		if (ioctl(fd, GET_ARRAY_INFO, &md)) {
 			fprintf(stderr,
 				_("Error getting MD array info from %s\n"),
-				dfile);
+				dfile2 ? dfile2 : dfile);
 			exit(1);
 		}
 		close(fd);
+		if (dfile2) free(dfile2);
 
 		/*
 		 * Ignore levels we don't want aligned (e.g. linear)
diff -u -r xfsprogs-2.8.11/libdisk/md.h xfsprogs-2.8.11-mdp/libdisk/md.h
--- xfsprogs-2.8.11/libdisk/md.h	2006-06-26 07:01:15.000000000 +0200
+++ xfsprogs-2.8.11-mdp/libdisk/md.h	2008-03-26 20:12:10.000000000 +0100
@@ -20,6 +20,9 @@
 #define MD_MAJOR		9 /* we also check at runtime */
 #endif
 
+#define MD_IS_MD		1
+#define MD_IS_MDP		2
+
 #define GET_ARRAY_INFO          _IOR (MD_MAJOR, 0x11, struct md_array_info)
 
 #define MD_SB_CLEAN		0

--------------050802060205070700070009--
