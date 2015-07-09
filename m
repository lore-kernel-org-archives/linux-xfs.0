Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E99B7F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 17:47:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31BBD304032
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 15:47:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	aiVrSRoDy9lQbF0q for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 15:47:55 -0700 (PDT)
Date: Fri, 10 Jul 2015 08:47:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: The (desired) state OS X support for xfsprogs
Message-ID: <20150709224754.GC7943@dastard>
References: <1005907288.25490237.1436440850135.JavaMail.zimbra@redhat.com>
	<1934296067.25506110.1436444322496.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1934296067.25506110.1436444322496.JavaMail.zimbra@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 09, 2015 at 08:18:42AM -0400, Jan Tulak wrote:
> Hi all
> 
> As I started the theme a bit it in another thread, I post it here in a
> standalone email, to bring it to a wider audience.
> 
> What are the plans regarding xfsprogs on OS X? Officially,
> by documentation, it should be buildable, though only some binaries
> (like mkfs and repair) are usable. But when I did a small reality check
> on OS X Yosemite (10.10) and tried to build it by the doc/INSTALL,
> I got tons of this.
> 
> 
> libxfs_priv.h:371:0: error: syntax error in macro parameter list
>  #define xfs_cmn_err(tag,level,mp,fmt,args...) cmn_err(level,fmt, ## args)
>  ^
> libxfs_priv.h:372:0: error: syntax error in macro parameter list
>  #define xfs_warn(mp,fmt,args...)  cmn_err(CE_WARN,fmt, ## args)
>  ^
> libxfs_priv.h:373:0: error: syntax error in macro parameter list
>  #define xfs_alert(mp,fmt,args...)  cmn_err(CE_ALERT,fmt, ## args)
> 
> 
> There are more macros with the same error. (Of course, the same code compiles
> on Linux with no issue.) As a bonus, to even get to compiling the code,
> I had to throw away the Xcode clang and install a gcc myself (from macports),
> because of some arguments passed to the compiler that aren't supported in the
> ones shipped by Apple. (Didn't remember them, sorry.)
> 
> Formally we claim to support OS X, but apparently it doesn't work as we
> declare. So the question is, should we fix it and continue in the support?
> Or should we drop it?

Alternative platform support will work if someone with an interest
in maintaining it sends patches to make it work ;) I'm happy to take
such patches - that's how we got the multiple platform support in
the first place....

It sounds like a compiler support check is needed in the autoconf
code (i.e. check for ## macro vararg support, etc) so that it fails
fast on apple's compiler.

> P.S.: For the question "who would do it" - most likely me. I have
> a Mac and being able to build xfsprogs locally when working on it
> would be nice.  But I'm really not sure if there is any other boon
> except my own leisure. :-)

If you want to make it work, then by all means make it work. I'm not
going to stop you ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
