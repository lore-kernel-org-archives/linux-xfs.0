Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA3377F59
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 12:03:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4896FAC00A
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 10:03:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FL28a5W4glKQHYGo for
	<xfs@oss.sgi.com>; Fri, 30 Aug 2013 10:03:36 -0700 (PDT)
Date: Fri, 30 Aug 2013 14:03:28 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] mkfs: add noalign option to usage()
Message-ID: <20130830170327.GA7362@andromeda.usersys.redhat.com>
References: <1377792190-21220-1-git-send-email-cmaiolino@redhat.com>
	<521F782E.2030400@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <521F782E.2030400@sandeen.net>
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

On Thu, Aug 29, 2013 at 11:34:54AM -0500, Eric Sandeen wrote:
> On 8/29/13 11:03 AM, Carlos Maiolino wrote:
> > Although it has been added to manpage, there is no information about the
> > existence of noalign option into the usage().
> > 
> > Changelog:
> > 
> > V2: Remove space in comma separated options
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  mkfs/xfs_mkfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 4bdacee..ef1d758 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3033,7 +3033,7 @@ usage( void )
> >  /* metadata */		[-m crc=[0|1]\n\
> >  /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
> >  			    (sunit=value,swidth=value|su=num,sw=num),\n\
> > -			    sectlog=n|sectsize=num\n\
> > +			    noalign,sectlog=n|sectsize=num\n\
> 
> I'd really rather see it as I suggested, for clarity.
> 
> su/sw vs. sunit/swidth vs. noalign are mutually exclusive.
> 
> su/sw & sunit/swidth are shown to be so via the (A|B) notation.
> 
> Adding noalign outside the (A|B) makes it look like it can be specified in
> addition to alignment options, which really makes no sense.
> 
> Can you do:
> 
> -  			    (sunit=value,swidth=value|su=num,sw=num),\n\
> +  			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
> 
> instead?
Sure, didn't think about mutual exclusive options being packed together, will
send a v3
> 
> -Eric
> 
> >  /* force overwrite */	[-f]\n\
> >  /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
> >  			    projid32bit=0|1]\n\
> > 
> 

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
