Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAHKccVG071677 for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 14:38:38 -0600
Date: Thu, 17 Nov 2011 14:38:55 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch] xfsprogs - workaround debian build daemon dependency
	resolution
Message-ID: <20111117203855.GJ29840@sgi.com>
References: <CAAp5ZgPntg0f+edJQFU8n0npBT1+46NqwwiUEtLXZPJoLwVL1g@mail.gmail.com>
	<1321558138.3015.4.camel@doink> <1321558944.3015.6.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1321558944.3015.6.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nathan Scott <nathans@debian.org>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

Hi Nathan,

On Thu, Nov 17, 2011 at 01:42:24PM -0600, Alex Elder wrote:
> On Thu, 2011-11-17 at 13:28 -0600, Alex Elder wrote:
> > On Tue, 2011-11-15 at 20:39 +1100, Nathan Scott wrote:
> > > Workaround the Debian buildd dependency handling for libreadline5 library
> > > handling
> > > 
> > > Evidently the buildd daemons process depenencies differently to local
> > > builds, and
> > > expect the first of optional dependencies to be resolved.  Flip the
> > > ordering to match
> > > this dependency.
> > > 
> > > Signed-off-by: Nathan Scott <nathans@debian.org>
> > 
> > Looks fine to me.
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> > 
> 
> Actually, it *looked* fine superficially, but it's crap.

Is this what you're after?

diff --git a/debian/control b/debian/control
index f813a43..ca517ad 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <xfs@oss.sgi.com>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline5-dev | libreadline-gplv2-dev, libblkid-dev (>= 2.17)
+Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17)
 Standards-Version: 3.9.1
 Homepage: http://oss.sgi.com/projects/xfs/



Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
