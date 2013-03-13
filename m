Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DE94B7F37
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 07:47:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6122DAC001
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 05:46:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3AO3gemGLjz2ZgT9 for
	<xfs@oss.sgi.com>; Wed, 13 Mar 2013 05:46:58 -0700 (PDT)
Date: Wed, 13 Mar 2013 09:46:52 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfsdump: properly set Parent's PID
Message-ID: <20130313124651.GA2816@andromeda.usersys.redhat.com>
References: <1359663197-30473-1-git-send-email-cmaiolino@redhat.com>
	<513F58FE.1010200@sgi.com> <513FFC0D.3030705@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513FFC0D.3030705@sandeen.net>
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

Weird, I git pull'ed the repository before add the patch, I'll review my
origin's URL, sorry about that

On Tue, Mar 12, 2013 at 11:09:49PM -0500, Eric Sandeen wrote:
> On 3/12/13 11:34 AM, Rich Johnston wrote:
> > On 01/31/2013 02:13 PM, Carlos Maiolino wrote:
> >> Set parentpid variable to the correct Parent's ID using getppid() instead of
> >> getpid()
> >>
> >> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> >> ---
> >>   common/main.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/common/main.c b/common/main.c
> >> index 980d2d4..848a887 100644
> >> --- a/common/main.c
> >> +++ b/common/main.c
> >> @@ -198,7 +198,7 @@ main( int argc, char *argv[] )
> >>       /* Get the parent's pid. will be used in signal handling
> >>        * to differentiate parent from children.
> >>        */
> >> -    parentpid = getpid( );
> >> +    parentpid = getppid( );
> >>       rval = atexit(mlog_exit_flush);
> >>       assert(rval == 0);
> >>
> >>
> > Sorry for the late review, this does not apply to current xfsdump tree.
> 
> Hm, and hasn't since 2011.  ;)
> 
> 2da84e5d changed this:
> 
>          * to differentiate parent from children.
>          */
> -       parentpid = getpid( );
> +       parenttid = pthread_self( );
> 
> Carlos, was this maybe against an older tree or released version?
> 
> -Eric
> 
> > Regards
> > --Rich
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
