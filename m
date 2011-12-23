Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBNELGTj221772 for <xfs@oss.sgi.com>; Fri, 23 Dec 2011 08:21:18 -0600
Received: from TX2EHSOBE004.bigfish.com (tx2ehsobe002.messaging.microsoft.com
	[65.55.88.12]) by cuda.sgi.com with ESMTP id D1qzZHupkmIUo6HI
	for <xfs@oss.sgi.com>; Fri, 23 Dec 2011 06:21:13 -0800 (PST)
From: Luo Zhenhua-B19537 <B19537@freescale.com>
Subject: RE: [PATCH] xfsprogs: use uid/gid instead of actual name to fix
	install issue
Date: Fri, 23 Dec 2011 14:20:24 +0000
Message-ID: <CA452391058F6D4E9715FB2C29D9312A010BC015@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1324623173-32707-1-git-send-email-b19537@freescale.com>
	<20111223100135.GA12731@dastard>
In-Reply-To: <20111223100135.GA12731@dastard>
Content-Language: en-US
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

If the specified user/group is invalid, I think this should be an usage error instead of script error.

Current the problem I met is that, even if I specified a valid user/group of my host, "chown user:group file" failed, after switching to corresponding uid/gid, the script can be executed successfully during the install process. 


Best Regards,

Zhenhua


> -----Original Message-----
> From: Dave Chinner [mailto:david@fromorbit.com]
> Sent: Friday, December 23, 2011 6:02 PM
> To: Luo Zhenhua-B19537
> Cc: xfs@oss.sgi.com
> Subject: Re: [PATCH] xfsprogs: use uid/gid instead of actual name to fix install
> issue
> 
> On Fri, Dec 23, 2011 at 02:52:53PM +0800, b19537@freescale.com wrote:
> > From: Zhenhua Luo <b19537@freescale.com>
> >
> >     > when running install-sh during the install process, following
> >       error might appear:
> > 	> ../../install-sh -o bj -g bj -m 644 -T so_dot_version libhandle.lai
> /lib; ../../install-sh -o bj -g bj -T so_dot_current libhandle.lai /lib
> > 	> chown: invalid user: `bj:bj'
> > 	> chown: invalid user: `bj:bj'
> > 	> Installing libdisk-install
> > 	> make[1]: Nothing to be done for `install'.
> > 	> Installing copy-install
> > 	> ../install-sh -o bj -g bj -m 755 -d /usr/sbin
> > 	> chown: invalid user: `bj:bj'
> > 	> make[1]: *** [install] Error 1
> > 	> make: *** [copy-install] Error 2
> >
> > Signed-off-by: Zhenhua Luo <b19537@freescale.com>
> > ---
> >  include/install-sh |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/install-sh b/include/install-sh index
> > 18c051f..9d8ff06 100755
> > --- a/include/install-sh
> > +++ b/include/install-sh
> > @@ -105,10 +105,10 @@ do
> >     c)
> >  	;;
> >     g)
> > -	GROUP=$OPTARG
> > +	GROUP=`id -g $OPTARG`
> >  	;;
> >     o)
> > -	OWNER=$OPTARG
> > +	OWNER=`id -u $OPTARG`
> >  	;;
> >     m)
> >  	DIRMODE=`expr $OPTARG`
> 
> How does this fix the the problem that the user/group "bj" does not exist?
> 
> $ id -g bj
> id: bj: No such user
> $ id -g bj 2> /dev/null
> $
> 
> All this patch does is result in a OWNER/GROUP variable that is empty when an
> invalid user/group is specified. Hence it will make the install complete with a
> different user to the one specified in the install command line. It should error
> out (like it does now) if a user/group does not exist, not install as some other
> (unknown) user.
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
