Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B4F3E7F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 13:26:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A0220304051
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 11:25:58 -0700 (PDT)
Received: from mail-ve0-f171.google.com (mail-ve0-f171.google.com
	[209.85.128.171]) by cuda.sgi.com with ESMTP id
	POYLXAOTWKAAQB8t (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Jun 2013 11:25:50 -0700 (PDT)
Received: by mail-ve0-f171.google.com with SMTP id b10so757230vea.30
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 11:25:50 -0700 (PDT)
Message-ID: <51BB6028.1080602@gmail.com>
Date: Fri, 14 Jun 2013 14:25:44 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: replace umode_t with xfs_mode_t
References: <51BA219B.4070503@gmail.com> <20130614023758.GT29338@dastard>
In-Reply-To: <20130614023758.GT29338@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/13/2013 10:37 PM, Dave Chinner wrote:
> On Thu, Jun 13, 2013 at 03:46:35PM -0400, Michael L. Semon wrote:
>> This patch was made after applying the most recent 3.11-related 
>> patchset for xfsprogs.  It was applied against the crc-dev branch, 
>> in order to get CRC-enabled xfsprogs to build without complaining 
>> about a lack of "umode_t".  The systems used were both 32-bit 
>> slackware-current systems, against public kernel headers of kernel 
>> 3.8.x and 3.9.x vintage.
>>
>> This is an "idea" patch, a way of getting CRC-enabled xfsprogs to 
>> build on kernels later than 3.2 while staying within the conventions 
>> of my test systems.  The idea may be bad, and the XFS crew might be 
>> solving it in a different way while moving header files and functions.
>>
>> Anyway, I don't know how the Debian and Red Hat crews solve header-
>> related issues like these, so comments and flames are welcome.  In 
>> particular, I'm open to a better name than "xfs_mode_t" that does 
>> not match the grep term "umode_t".
> 
> The usual way to do this is with autoconf magic.
> 
> The thing is, we want to keep the user and kernel code as close as
> possible, so if the kernel code uses umode_t, then we need to use
> that internally in the userspace code as well.

Yeah, that's why I originally chose to get by with a one-line sysadmin-
hack typedef.  An extra postprocessing step means one more thing to go 
wrong.

If you would, please put the question, "There needs to be one more 
check, but what?" in your mind as you read this...

<asm/types.h> was used in the test, but I don't really know where 
umode_t was picked up in the past.  That's just an educated guess.

> So what we need is an autoconf rule that detects is umode_t is
> defined by the distro, and if it isn't define it ourselves.
> 
> See, for example, m4/package_types.m4 for how to detect if a
> variable is already defined. Add a new rule to detect umode_t,
> and use it to set a variable called have_umode_t. i.e.
> 
> .....
> 	], [
> 		umode_t umode;
> 	], have_umode_t=no
> 		AC_MSG_RESULT(yes),
> 		AC_MSG_RESULT(no))
> 	AC_SUBST(have_umode_t)
> 	])
> 
> then add a line like:
> 
> HAVE_UMODE_T = @have_umode_t@

I couldn't work the have_umode_t=no and AC_SUBST(have_umode_t) in 
there, so I did a copy-and-paste of one of the other checks in 
m4/package_types.m4.  [Patch is submitted at the end of this letter.]

> to include/builddefs.in, as well as add this to the platform compile
> flags like so:
> 
> ifeq ($(HAVE_UMODE_T),yes)
> PCFLAGS += -DHAVE_UMODE_T
> endif

I used this.
 
> then in include/platform_defs.h.in add something like:
> 
> #ifndef HAVE_UMODE_T
> typedef unsigned short umode_t;
> #endif

I used this, too.  My end result was that a `make install-qa` exports 
this to platform_defs.h, which is fine and solves your purposes in 
particular.  In testing, it's exported exactly that way.  Should the 
system have a conflicting definition for umode_t, the xfsdump 
configure (I think) fails with a "could not compile requisite headers" 
message.  [I had typed "typedef unsigned int umode_t;" into 
/usr/include/asm/types.h by accident and found that.]

> And then you shouldn't have to modify any of the actual libxfs code
> at all...

OK.  This was tested against the 2.6.39 headers provided by the 
Slackware 13 kernel-headers package, and xfsdump was rebuilt.  I think 
that Samba 3 uses xfs/libxfs.h in some way, and I didn't have time 
to recompile Samba to see what would happen.  If it makes a difference,
slackware-current uses `make install-qa` in its xfsprogs-3.1.11 build...

ftp://ftp.slackware.com/pub/slackware/slackware-current/source/a/xfsprogs/xfsprogs.SlackBuild

...so any exports from `make install-qa` will make it there to cause 
potential confusion later.  [And I thank Pat for making it that way.]
 
> If you need help, just ping me ;)

Thanks!

Michael (patch follows)

>From 011384927727b8ad5a6f555027b4853b077abf2f Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Fri, 14 Jun 2013 03:00:34 -0400
Subject: [PATCH] xfsprogs: define umode_t for build if not defined already

umode_t has not been exported to the kernel private headers since
around kernel 3.2.0-rc7.  Add a check for umode_t and define it
if it has not been defined already.

Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
---
 configure.ac               |  1 +
 include/builddefs.in       |  3 +++
 include/platform_defs.h.in |  5 +++++
 m4/package_types.m4        | 11 +++++++++++
 4 files changed, 20 insertions(+)

diff --git a/configure.ac b/configure.ac
index b968977..e5fd94e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -118,6 +118,7 @@ AC_CHECK_SIZEOF([char *])
 AC_TYPE_PSINT
 AC_TYPE_PSUNSIGNED
 AC_TYPE_U32
+AC_TYPE_UMODE_T
 AC_MANUAL_FORMAT
 
 AC_CONFIG_FILES([include/builddefs])
diff --git a/include/builddefs.in b/include/builddefs.in
index 0a3fa1a..744e8d3 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -109,6 +109,9 @@ GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 
 ifeq ($(PKG_PLATFORM),linux)
 PCFLAGS = -D_GNU_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 $(GCCFLAGS)
+ifeq ($(HAVE_UMODE_T),yes)
+PCFLAGS += -DHAVE_UMODE_T
+endif
 DEPENDFLAGS = -D__linux__
 endif
 ifeq ($(PKG_PLATFORM),gnukfreebsd)
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 03391f5..ac260bc 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -123,6 +123,11 @@ typedef unsigned long long __psunsigned_t;
 # endif
 #endif
 
+/* Check whether to define umode_t ourselves. */
+#ifndef HAVE_UMODE_T
+typedef unsigned short umode_t;
+#endif
+
 /* Define if you want gettext (I18N) support */
 #undef ENABLE_GETTEXT
 #ifdef ENABLE_GETTEXT
diff --git a/m4/package_types.m4 b/m4/package_types.m4
index dfcb0d9..50ce48f 100644
--- a/m4/package_types.m4
+++ b/m4/package_types.m4
@@ -39,3 +39,14 @@ AC_DEFUN([AC_TYPE_U32],
          __u32  u32;
     ], AC_DEFINE(HAVE___U32) AC_MSG_RESULT(yes) , AC_MSG_RESULT(no))
   ])
+# 
+# Check if we have umode_t
+# 
+AC_DEFUN([AC_TYPE_UMODE_T],
+  [ AC_MSG_CHECKING([for umode_t])
+    AC_TRY_COMPILE([
+#include <asm/types.h>
+    ], [
+         umode_t umode;
+    ], AC_DEFINE(HAVE_UMODE_T) AC_MSG_RESULT(yes) , AC_MSG_RESULT(no))
+  ])
-- 
1.8.2


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
