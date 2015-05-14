Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A80617F4E
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 20:04:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A6048F8052
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 18:04:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MBGvNRe3emZ4N3j2 for <xfs@oss.sgi.com>;
	Wed, 13 May 2015 18:04:38 -0700 (PDT)
Date: Thu, 14 May 2015 11:04:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE, DISCUSS] xfsprogs: libxfs-4.1-update branch created
Message-ID: <20150514010402.GE4316@dastard>
References: <20150511000508.GD16689@dastard>
 <5553CCD2.1010906@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5553CCD2.1010906@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, May 13, 2015 at 05:14:42PM -0500, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> One interesting problem that arises from this is in xfs_format.h:
> 
> /* On-disk XFS extended attribute names */
> #define SGI_ACL_FILE            (char *)"SGI_ACL_FILE"
> #define SGI_ACL_DEFAULT         (char *)"SGI_ACL_DEFAULT"
> #define SGI_ACL_FILE_SIZE       (sizeof(SGI_ACL_FILE)-1)
> #define SGI_ACL_DEFAULT_SIZE    (sizeof(SGI_ACL_DEFAULT)-1)
> 
> (aside: why is it unsigned in the kernel but not here?)

Because otherwise xfsprogs throws compile warnings all over the
place about pasing unsigned char * to strn*() functions.

And, IIRC, if we make the char * in the kernel, then they throw
compile warnings for passing char * to const unsigned char *
function parameters....

The kernel fs code (all of it, not just XFS) is an utter mess of
unsigned/signed char used for names and strings - don't ever try
turning on warn-unsigned when you build the kernel....

> Anyway: that "sizeof" gives us 7, because it's getting the 
> size of the pointer, not the string literal.  Cool eh!
> Never mattered in the kernel, because the _SIZE macros aren't
> used.

Yeah, that's a bug ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
