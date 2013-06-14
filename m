Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B83FE7F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 11:31:24 -0500 (CDT)
Date: Fri, 14 Jun 2013 11:31:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] xfs: don't shutdown log recovery on validation errors
Message-ID: <20130614163119.GB32736@sgi.com>
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
	<1371003548-4026-2-git-send-email-david@fromorbit.com>
	<20130613010441.GX20932@sgi.com> <20130613020827.GG29338@dastard>
	<20130613220903.GA20932@sgi.com> <20130614001306.GM29338@dastard>
	<20130614160940.GA32736@sgi.com>
	<20130614161724.GA11235@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130614161724.GA11235@redhat.com>
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
Cc: xfs@oss.sgi.com

Hi Dave,

On Fri, Jun 14, 2013 at 12:17:24PM -0400, Dave Jones wrote:
> On Fri, Jun 14, 2013 at 11:09:40AM -0500, Ben Myers wrote:
> 
>  > > > I think your suggestion that non-debug systems could warn instead of
>  > > > fail is a good one, but removing the verifier altogether is
>  > > > inappropriate.
>  > > 
>  > > Changing every single verifier in a non-trivial way is not something
>  > > I'm about to do for a -rc6 kernel. Removing the verifiers from log
>  > > recovery just reverts to the pre-3.8 situation, so is perfectly
>  > > acceptable short term solution while we do the more invasive verify
>  > > changes.
>  > > 
>  > > > Can you make the metadump available?  I need to understand this better
>  > > > before I can sign off.  Also:  Any idea how far back this one goes?
>  > > 
>  > > No, I can't make the metadump available to you - it was provided
>  > > privately and not obfuscated and so you'd have to ask Dave for it.
>  > 
>  > Dave (Jones), could you make the metadump available to me?  I'd like to
>  > understand this a little bit better.  I'm a bit uncomfortable with the
>  > proposition that we should corrupt silently in this case...
> 
> Sorry, I don't have it any more.   I'll see if I can recreate the problem
> next week and prepare another dump.

Much appreciated.  Thanks!

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
