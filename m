Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 15:12:30 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA2NCHM3031313
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 15:12:18 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E586E7B0667
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 15:12:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id i4EsuehxOpHu5pY5 for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 15:12:19 -0800 (PST)
Message-ID: <490E33D1.8030306@sandeen.net>
Date: Sun, 02 Nov 2008 17:12:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: create tape group
References: <490C7CAC.2070902@sandeen.net> <20081102220551.GG19509@disturbed>
In-Reply-To: <20081102220551.GG19509@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:

> On Sat, Nov 01, 2008 at 10:58:36AM -0500, Eric Sandeen wrote:
>   
>> Create a tape group for anything which expects
>> to dump to tape (I guess this is a superset
>> of "remote" and a few others).
>>     
>
> Given that most ppl don't have tape drives, should these be left in
> the auto group now that they can easily be run by 'check -g tape'? I
> know I've never had a config to run them the *entire* time I've 
> personally run XFSQA...
>
> Cheers,
>
> Dave.
>   
Sounds like a plan.  We probably don't even know (?) if they run
well enough to be in the auto group?  Revised patch below:

-----------------

Create a tape group for anything which expects
to dump to tape (I guess this is a superset
of "remote" and a few others).  Also, remove
this from the auto group; most people won't have tapes
and -g tape is easy enough (per dchinner's suggestion).

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfstests/group
===================================================================
--- xfs-cmds.orig/xfstests/group
+++ xfs-cmds/xfstests/group
@@ -35,6 +35,9 @@ v2log		tes@sgi.com
 # xfsdump, xfsrestore, xfsinvutil
 dump		tes@sgi.com ivanr@sgi.com
 
+# xfsdump, xfsrestore to tapes
+tape		tes@sgi.com ivanr@sgi.com
+
 # xfsdump, xfsrestore to remote tapes
 remote		tes@sgi.com ivanr@sgi.com
 
@@ -118,10 +121,10 @@ nfs4acl		tes@sgi.com donaldd@sgi.com
 019 mkfs auto
 020 metadata attr udf auto
 021 db attr auto
-022 dump ioctl auto
-023 dump ioctl auto
-024 dump ioctl auto
-025 dump ioctl auto
+022 dump ioctl tape
+023 dump ioctl tape
+024 dump ioctl tape
+025 dump ioctl tape
 026 dump ioctl auto
 027 dump ioctl auto
 028 dump ioctl auto
@@ -131,15 +134,15 @@ nfs4acl		tes@sgi.com donaldd@sgi.com
 032 mkfs auto
 033 repair auto
 034 other auto
-035 dump ioctl auto
-036 dump ioctl remote auto
-037 dump ioctl remote auto
-038 dump ioctl remote auto
-039 dump ioctl remote auto
+035 dump ioctl tape auto
+036 dump ioctl remote tape
+037 dump ioctl remote tape
+038 dump ioctl remote tape
+039 dump ioctl remote tape
 040 other auto
 041 growfs ioctl auto
 042 fsr ioctl auto
-043 dump ioctl auto
+043 dump ioctl tape
 044 other auto
 045 other auto
 046 dump ioctl auto
@@ -151,7 +154,7 @@ nfs4acl		tes@sgi.com donaldd@sgi.com
 052 quota db auto
 053 acl repair auto
 054 quota auto
-055 dump ioctl remote auto
+055 dump ioctl remote tape
 056 dump ioctl auto
 057 acl auto
 058 acl auto
