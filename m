Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Nov 2006 16:43:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAM0hDaG027796
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 16:43:15 -0800
Date: Wed, 22 Nov 2006 11:42:17 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] Make stuff static
Message-ID: <20061122004216.GT11034@melbourne.sgi.com>
References: <20060929032856.8DA9C18001A5E@sandeen.net> <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local> <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net> <20061016232250.GM11034@melbourne.sgi.com> <1161042943.5723.117.camel@xenon.msp.redhat.com> <20061017005038.GN11034@melbourne.sgi.com> <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com> <20061017215706.GI8394166@melbourne.sgi.com> <1161125131.5723.158.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1161125131.5723.158.camel@xenon.msp.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: David Chinner <dgc@sgi.com>, Tim Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Oct 17, 2006 at 05:45:31PM -0500, Russell Cattelan wrote:
> On Wed, 2006-10-18 at 07:57 +1000, David Chinner wrote:
> > On Tue, Oct 17, 2006 at 05:13:01PM +1000, Tim Shimmin wrote:
> > > I thought that for debug, we could stop them from being inline
> > > for easier debugging. We could have a STATIC_INLINE :-)
> > 
> > We could, but I don't think it gains us anything.
> I agree with Tim on this.
> when I see STATIC in the code it's generally assumed to 
> be a way to toggle of static on/off. Adding static inline 
> to the #define STATIC starts to overload the the macro 
> and creates an obfuscation that isn't immediately obvious.
> STATIC_INLINE should be fairly obvious.

Ok, so I've had time to look at this again. Here's the definitions
of STATIC and STATIC_INLINE for debug and nondebug from the
patch (whitespace damaged):

Index: 2.6.x-xfs-new/fs/xfs/support/debug.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/support/debug.h   2006-11-22 10:54:37.089984780 +1100
+++ 2.6.x-xfs-new/fs/xfs/support/debug.h        2006-11-22 11:30:20.433326839 +1100
@@ -38,13 +38,37 @@ extern void assfail(char *expr, char *f,

 #ifndef DEBUG
 # define ASSERT(expr)  ((void)0)
-#else
+
+#ifndef STATIC
+# define STATIC static noinline
+#endif
+
+#ifndef STATIC_INLINE
+# define STATIC_INLINE static inline
+#endif
+
+#else /* DEBUG */
+
 # define ASSERT(expr)  ASSERT_ALWAYS(expr)
 extern unsigned long random(void);
-#endif

 #ifndef STATIC
-# define STATIC static
+# define STATIC noinline
+#endif
+
+/*
+ * We stop inlining of inline functions in debug mode.
+ * Unfortunately, this means static inline in header files
+ * get multiple definitions, so they need to remain static.
+ * This then gives tonnes of warnings about unused but defined
+ * functions, so we need to add the unused attribute to prevent
+ * these spurious warnings.
+ */
+#ifndef STATIC_INLINE
+# define STATIC_INLINE static __attribute__ ((unused)) noinline
 #endif

+#endif /* DEBUG */
+
+
 #endif  /* __XFS_SUPPORT_DEBUG_H__ */

------

Is this acceptible to everyone?

FWIW, there is one other thing that this conversion causes
problems with, and that's variable definitions. i.e. we can't
use STATIC on them any more because of the "noinline" attribute
it has. Do we care about this and if so, any suggestions on
how to keep this functionality (a different STATIC_xxx define
for structures)?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
