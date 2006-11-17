Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 20:10:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAH4ANaG029398
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 20:10:26 -0800
Date: Fri, 17 Nov 2006 14:11:12 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <CEB981736A0E8C7DF9ABD7C8@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20061117023946.GN11034@melbourne.sgi.com>
References: <455CB54F.8080901@sandeen.net>
 <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local>
 <20061117023946.GN11034@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hi Dave,

--On 17 November 2006 1:39:46 PM +1100 David Chinner <dgc@sgi.com> wrote:

> On Fri, Nov 17, 2006 at 11:08:40AM +1000, Timothy Shimmin wrote:
>> Hi Eric,
>>
>>
>> Well there is a bug in the sb endian translation code then or its setup.
>> All the field accesses should be correct, no?
>
> The problem is the size of the variable translated in xfs_xlatesb()
> is the offset of the next field minus the offset of the current
> field.
>
Yep.

> With the last filed of the structure, it ends up being the
> size of the structure minus the offset of the field. On a 32 bit
> machine, the structure is 4 bytes larger that the offset of
> the feature2 field. On 64 bit machine, the strucutre is
> 8 bytes larger than the offset of the features2 field,
Yep.

> so it translates is as though it was a 64 bit field,
> not a 32 bit field.....
>

So why not change xfs_sb_info to give the real offset of where
the next field should go (if there was one), instead of giving the sizeof the
structure which is not where say a 32 bit field would go and
is wrong IMHO.

i.e.

===========================================================================
Index: fs/xfs/xfs_mount.c
===========================================================================

--- a/fs/xfs/xfs_mount.c	2006-11-17 15:02:21.000000000 +1100
+++ b/fs/xfs/xfs_mount.c	2006-11-17 14:48:43.261937705 +1100
@@ -121,7 +121,7 @@ static const struct {
     { offsetof(xfs_sb_t, sb_logsectsize),0 },
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
-    { sizeof(xfs_sb_t),			 0 }
+    { offsetof(xfs_sb_t, sb_features2) + sizeof(__uint32_t), 0 }
 };

 /*

--Tim
