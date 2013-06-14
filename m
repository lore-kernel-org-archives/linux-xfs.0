Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 867D67F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 09:08:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 719348F8054
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 07:08:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uNtg9yUrtTfSh1H4 for
	<xfs@oss.sgi.com>; Fri, 14 Jun 2013 07:08:47 -0700 (PDT)
Date: Fri, 14 Jun 2013 16:08:41 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfstests: print missing utility name
In-Reply-To: <20130613025350.GJ29338@dastard>
Message-ID: <alpine.LFD.2.00.1306141608200.2327@localhost.localdomain>
References: <alpine.LFD.2.00.1306121558030.14273@localhost.localdomain>
	<20130613025350.GJ29338@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2006138564-1371218924=:2327"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2006138564-1371218924=:2327
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 13 Jun 2013, Dave Chinner wrote:

> Date: Thu, 13 Jun 2013 12:53:50 +1000
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: xfs-oss <xfs@oss.sgi.com>
> Subject: Re: [PATCH] xfstests: print missing utility name
> 
> On Wed, Jun 12, 2013 at 04:02:19PM +0200, Lukáš Czerner wrote:
> > Currently when the utility such as fio or dmsetup is missing user does
> > not get the information about the utility name which is actually
> > missing. Fix it by providing second argument to the _require_command().
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  common/rc | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/common/rc b/common/rc
> > index fe6bbfc..984cef1 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -1054,6 +1054,7 @@ _require_realtime()
> >  _require_command()
> >  {
> >      [ -n "$1" ] && _cmd="$1" || _cmd="$2"
> > +    [ -z $_cmd ] && _cmd="<fill utility name>"
> 
> 
> The problem here is that the command will be empty if it doesn't
> exist, so it's difficult to tell if one or two parameters is valid.
> 
> So, I'd suggest that _require_command should be changed to:
> 
> _require_command()
> {
> 	_name=$1
> 	_cmd=$2
> 
> 	[ $# -ge 1 ] || _fatal "Brainfart! What command is required?"
> 	[ -n $_cmd -a -x $_cmd ] || _notrun "$_name not found, skipping test."
> }
> 
> And all the callers have their parameters swapped to avoid this
> confusion about what exists and what doesn't....
> 
> Cheers,
> 
> Dave.

Fair enough.

-Lukas
> 
> 
--8323328-2006138564-1371218924=:2327
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-2006138564-1371218924=:2327--
