Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5AJMhnu007402 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 14:22:43 -0500
Received: from e39.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9710F1666979
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 12:22:37 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id YFfauOc52X5QZBDy for
	<xfs@oss.sgi.com>; Fri, 10 Jun 2011 12:22:37 -0700 (PDT)
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5AJ8PeD020385
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 13:08:25 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5AJLw4Y281332 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 13:22:08 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5AJLw1r018934
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 13:21:58 -0600
Subject: Re: [PATCH]: [xfstests] Make ext2 requirement explicit for test 049
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <4DF26838.4030101@redhat.com>
References: <1307731533.7661.436.camel@chandra-lucid.beaverton.ibm.com>
	<4DF26838.4030101@redhat.com>
Date: Fri, 10 Jun 2011 12:21:57 -0700
Message-ID: <1307733717.7661.437.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: XFS <xfs@oss.sgi.com>

Good catch.

I will reroll the patch, test it and send it again.

Thanks.

chandra
On Fri, 2011-06-10 at 13:53 -0500, Eric Sandeen wrote:
> On 06/10/2011 01:45 PM, Chandra Seetharaman wrote:
> > Test 049 depends on ext2 module being supported by the kernel.
> > 
> > This patch makes it a explicit, instead of failing the test with
> > obscure message.
> > 
> > Signed-Off-By: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> > 
> > diff --git a/049 b/049
> > index 3d3f030..c6c4faa 100755
> > --- a/049
> > +++ b/049
> > @@ -64,6 +64,7 @@ _require_nobigloopfs
> >  _require_nonexternal
> >  _require_scratch
> >  _require_loop
> > +_require_ext2
> >  
> >  rm -f $seq.full
> >  
> > diff --git a/common.rc b/common.rc
> > index c510c66..531a43e 100644
> > --- a/common.rc
> > +++ b/common.rc
> > @@ -769,6 +769,23 @@ _require_loop()
> >      fi
> >  }
> >  
> > +# this test requires ext2 filesystem support
> > +#
> > +_require_ext2()
> > +{
> > +    if [ "$HOSTOS" != "Linux" ]
> > +    then
> > +	_notrun "This test requires linux for ext2 filesystem support"
> > +    fi
> > +
> > +    if modprobe ext2 >/dev/null 2>&1
> 
> Does this do the right thing if ext2 is built in?
> 
> If not, would :
> 
> modprobe ext2 >/dev/null 2>&1
> grep ext2 /proc/filesystems ...
> 
> work better?
> 
> -Eric
> 
> > +    then
> > +	:
> > +    else
> > +	_notrun "This test requires ext2 filesystem support"
> > +    fi
> > +}
> > +
> >  # this test requires that (large) loopback device files are not in use
> >  #
> >  _require_nobigloopfs()
> > 
> > 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
