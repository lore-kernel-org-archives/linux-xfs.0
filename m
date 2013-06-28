Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2AED37F6D
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 14:31:05 -0500 (CDT)
Date: Fri, 28 Jun 2013 14:31:04 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] xfs: don't shutdown log recovery on validation errors
Message-ID: <20130628193104.GM32736@sgi.com>
References: <20130614160940.GA32736@sgi.com> <51BB41AD.4050303@sandeen.net>
	<20130614190850.GB20932@sgi.com> <51BB6C7C.6050300@sandeen.net>
	<20130614194453.GC20932@sgi.com> <51BB74F0.7040406@sandeen.net>
	<20130614202223.GD20932@sgi.com>
	<20130628185406.GB27157@redhat.com>
	<20130628192420.GB20932@sgi.com> <20130628192828.GA1315@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130628192828.GA1315@redhat.com>
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
To: Dave Jones <davej@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com

On Fri, Jun 28, 2013 at 03:28:28PM -0400, Dave Jones wrote:
> On Fri, Jun 28, 2013 at 02:24:20PM -0500, Ben Myers wrote:
>  > Hi Dave,
>  > 
>  > On Fri, Jun 28, 2013 at 02:54:06PM -0400, Dave Jones wrote:
>  > > On Fri, Jun 14, 2013 at 03:22:23PM -0500, Ben Myers wrote:
>  > > 
>  > >  > > > Are you guys arguing that the log replay bug should not be fixed?
>  > >  > > 
>  > >  > > Speaking for myself, I'm not arguing that, not at all.
>  > >  > > (not that I know how to fix it, either)
>  > >  > 
>  > >  > ...until log replay is fixed.  Hell.  I'll just pull it in as-is.
>  > >  > 
>  > >  > Reviewed-by: Ben Myers <bpm@sgi.com>
>  > > 
>  > > Is this on its way to Linus ? Given it's a regression over 3.9, it probably should be.
>  > 
>  > This one was in my pull request for -rc6.  Looks like Linus merged it here:
>  > 
>  > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d58c6ff0b779c5adae2a8596fde69cb45f2a5d68
>  > 
>  > We still need to propose this one for -stable, IIRC.
> 
> Bah, no Reported-by:

Sorry Dave.  I'll do better next time.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
