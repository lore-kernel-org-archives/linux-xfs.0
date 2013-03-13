Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B72E57F37
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 07:59:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9BB0130406B
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 05:59:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WSvgDC3tvhVp3To4 for
	<xfs@oss.sgi.com>; Wed, 13 Mar 2013 05:59:02 -0700 (PDT)
Date: Wed, 13 Mar 2013 09:58:56 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfsdump: properly set Parent's PID
Message-ID: <20130313125856.GB2816@andromeda.usersys.redhat.com>
References: <1359663197-30473-1-git-send-email-cmaiolino@redhat.com>
	<513F58FE.1010200@sgi.com> <513FFC0D.3030705@sandeen.net>
	<20130313124651.GA2816@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130313124651.GA2816@andromeda.usersys.redhat.com>
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
Cc: Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

Ah, my origin was pointing to the git.kernel.org xfsdump repository =[

On Wed, Mar 13, 2013 at 09:46:52AM -0300, Carlos Maiolino wrote:
> Weird, I git pull'ed the repository before add the patch, I'll review my
> origin's URL, sorry about that
> 
> On Tue, Mar 12, 2013 at 11:09:49PM -0500, Eric Sandeen wrote:
> > On 3/12/13 11:34 AM, Rich Johnston wrote:
> > > On 01/31/2013 02:13 PM, Carlos Maiolino wrote:
> > >> Set parentpid variable to the correct Parent's ID using getppid() instead of
> > >> getpid()
> > >>
> > >> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > >> ---
> > >>   common/main.c | 2 +-
> > >>   1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/common/main.c b/common/main.c
> > >> index 980d2d4..848a887 100644
> > >> --- a/common/main.c
> > >> +++ b/common/main.c
> > >> @@ -198,7 +198,7 @@ main( int argc, char *argv[] )
> > >>       /* Get the parent's pid. will be used in signal handling
> > >>        * to differentiate parent from children.
> > >>        */
> > >> -    parentpid = getpid( );
> > >> +    parentpid = getppid( );
> > >>       rval = atexit(mlog_exit_flush);
> > >>       assert(rval == 0);
> > >>
> > >>
> > > Sorry for the late review, this does not apply to current xfsdump tree.
> > 
> > Hm, and hasn't since 2011.  ;)
> > 
> > 2da84e5d changed this:
> > 
> >          * to differentiate parent from children.
> >          */
> > -       parentpid = getpid( );
> > +       parenttid = pthread_self( );
> > 
> > Carlos, was this maybe against an older tree or released version?
> > 
> > -Eric
> > 
> > > Regards
> > > --Rich
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> -- 
> Carlos
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
