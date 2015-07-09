Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E2857F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 07:18:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C2207AC004
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 05:18:45 -0700 (PDT)
Received: from mx5-phx2.redhat.com (mx5-phx2.redhat.com [209.132.183.37]) by
	cuda.sgi.com with ESMTP id MY0RDBf8NaNTB6EV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 05:18:43 -0700 (PDT)
Received: from zmail22.collab.prod.int.phx2.redhat.com
	(zmail22.collab.prod.int.phx2.redhat.com [10.5.83.26])
	by mx5-phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t69CIgiG065042
	for <xfs@oss.sgi.com>; Thu, 9 Jul 2015 08:18:42 -0400
Date: Thu, 9 Jul 2015 08:18:42 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1934296067.25506110.1436444322496.JavaMail.zimbra@redhat.com>
In-Reply-To: <1005907288.25490237.1436440850135.JavaMail.zimbra@redhat.com>
Subject: The (desired) state OS X support for xfsprogs
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hi all

As I started the theme a bit it in another thread, I post it here in a
standalone email, to bring it to a wider audience.

What are the plans regarding xfsprogs on OS X? Officially,
by documentation, it should be buildable, though only some binaries
(like mkfs and repair) are usable. But when I did a small reality check
on OS X Yosemite (10.10) and tried to build it by the doc/INSTALL,
I got tons of this.


libxfs_priv.h:371:0: error: syntax error in macro parameter list
 #define xfs_cmn_err(tag,level,mp,fmt,args...) cmn_err(level,fmt, ## args)
 ^
libxfs_priv.h:372:0: error: syntax error in macro parameter list
 #define xfs_warn(mp,fmt,args...)  cmn_err(CE_WARN,fmt, ## args)
 ^
libxfs_priv.h:373:0: error: syntax error in macro parameter list
 #define xfs_alert(mp,fmt,args...)  cmn_err(CE_ALERT,fmt, ## args)


There are more macros with the same error. (Of course, the same code compiles
on Linux with no issue.) As a bonus, to even get to compiling the code,
I had to throw away the Xcode clang and install a gcc myself (from macports),
because of some arguments passed to the compiler that aren't supported in the
ones shipped by Apple. (Didn't remember them, sorry.)

Formally we claim to support OS X, but apparently it doesn't work as we
declare. So the question is, should we fix it and continue in the support?
Or should we drop it? What I saw, it doesn't look like if it is used.
Macports, Homebrew and Fink (software repositories like yum, apt...) doesn't
ship it at all, and when I searched in this mailing list archive for last
five years, I didn't saw any "xfsprogs on OS X" related email. Some attempts
in bringing xfs to fuse on OS X exists, but are long time without any update:

http://sourceforge.net/projects/fusexfs/ - last update in 2012

Hopefully the required changes in fixing it shouldn't be complicated, but is
it worth of the time? I'm not sure.

Cheers,
Jan

P.S.: For the question "who would do it" - most likely me. I have a Mac and
being able to build xfsprogs locally when working on it would be nice. 
But I'm really not sure if there is any other boon except my own leisure. :-)


System info:

OS X Yosemite (10.10 - most recent version)

$ gcc --version
gcc (MacPorts gcc5 5.1.0_1) 5.1.0
--
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
