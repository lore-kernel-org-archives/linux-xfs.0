Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C57F87FA1
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 22:13:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2472304043
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 20:13:49 -0800 (PST)
Received: from mail-qa0-f51.google.com (mail-qa0-f51.google.com
	[209.85.216.51]) by cuda.sgi.com with ESMTP id lCdW0QY9vGAoYaZw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Feb 2013 20:13:48 -0800 (PST)
Received: by mail-qa0-f51.google.com with SMTP id cr7so1921308qab.3
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 20:13:48 -0800 (PST)
Date: Thu, 28 Feb 2013 23:13:44 -0500
From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] xfstests: don't remove trailing zeros from integers
Message-ID: <20130301041344.GA3206@rocky>
References: <20130301002637.GB5016@wallace>
 <51301A92.2080104@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51301A92.2080104@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com, Eric Whitney <enwlinux@gmail.com>

* Eric Sandeen <sandeen@redhat.com>:
> On 2/28/13 6:26 PM, Eric Whitney wrote:
> > _within_tolerance strips trailing zeros from the min and max range
> > values it outputs.  This leads to damage if the min or max value is
> > an integer containing trailing zeros rather than a real number with
> > a fractional part containing trailing zeros. Xfstest 289 can exhibit
> > this problem when its input is out of range.  Modify the code so it
> > will only remove trailing zeros found after a decimal point.
> 
> whoops, that's not too good.
> 
> It's only for the output message in a failure case though, correct?
> But it makes the error output unhelpful.

Right on both counts.  We'd noticed the error output was confusing a few
months ago when you fixed an ext4 free space reporting problem (this is an
IOU) - 1280000 reported as 128 in that case.

> 
> Seems a little weird that it still leaves the trailing decimal:
> 
> $ echo 20000.00 | sed -e '/\./s/0*$//'
> 20000.
> 
> but that's not a big deal. The patch makes it better and
> the output is understandable even if it has a trailing
> decimal (which it had before anyway) so:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I'd reached the same conclusion, but if preferred I'll take this farther
and eliminate the trailing decimal.

Thanks for the review!

Eric

> 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > ---
> >  common.filter |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/common.filter b/common.filter
> > index 9e4c90c..1df2f97 100644
> > --- a/common.filter
> > +++ b/common.filter
> > @@ -106,8 +106,10 @@ EOF
> >  
> >    # fix up min, max precision for output
> >    # can vary for 5.3, 6.2
> > -  _min=`echo $_min | sed -e 's/0*$//'` # get rid of trailling zeroes
> > -  _max=`echo $_max | sed -e 's/0*$//'` # get rid of trailling zeroes
> > +
> > +  # remove any trailing zeroes from min, max if they have fractional parts
> > +  _min=`echo $_min | sed -e '/\./s/0*$//'`
> > +  _max=`echo $_max | sed -e '/\./s/0*$//'`
> >  
> >    if [ $_in_range -eq 1 ] 
> >    then
> > 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
