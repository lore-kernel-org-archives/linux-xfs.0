Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B8147F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 08:29:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B44A8F8033
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 06:29:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZG6jMLR6I5eWquEP for
	<xfs@oss.sgi.com>; Wed, 10 Jul 2013 06:29:54 -0700 (PDT)
Date: Wed, 10 Jul 2013 10:29:46 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] mkfs: add missing noalign suboption information
Message-ID: <20130710132946.GF11948@andromeda.usersys.redhat.com>
References: <1373327110-5533-1-git-send-email-cmaiolino@redhat.com>
	<51DB52E1.8030508@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51DB52E1.8030508@sandeen.net>
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

On Mon, Jul 08, 2013 at 07:01:37PM -0500, Eric Sandeen wrote:
> On 7/8/13 6:45 PM, Carlos Maiolino wrote:
> > Adds to the mkfs man page, information about noalign mkfs option which is
> > missing until now.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  man/man8/mkfs.xfs.8 | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> > index 04c19b4..2435814 100644
> > --- a/man/man8/mkfs.xfs.8
> > +++ b/man/man8/mkfs.xfs.8
> > @@ -244,6 +244,12 @@ will automatically query the logical volume for appropriate
> >  and
> >  .B swidth
> >  values.
> > +.TP
> > +.BI noalign
> > +This option is used to bypass data alignment configuration. In rare
> > +circunstances, data alignment might decrease performance, for such cases,
> > +use this option to avoid data alignment, this will set stripe unit and
> > +stripe width to 0.
> 
> Thanks for this, Carlos.
> 
> I think it might be better to just state plainly that it overrides automatic
> stripe unit detection, and leave the tuning / performance parts out.
> Most of the manpage today is more "what" than "why."
> 
> So maybe simply:
> 
> +This option disables automatic stripe geometry detection, and creates
> +the filesystem without stripe geometry even if the underlying storage
> +device reports this information.
> 
> FWIW, there is a 'noalign' option for the realtime subvolume
> as well, and that should probably get documented too.
> 

Agreed, going to change and re-send it.

> -Eric
> 
> >  .RE
> >  .TP
> >  .B \-f
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
