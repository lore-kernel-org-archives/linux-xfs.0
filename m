Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F1B227F4E
	for <xfs@oss.sgi.com>; Sun, 10 Aug 2014 23:32:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E07D38F8037
	for <xfs@oss.sgi.com>; Sun, 10 Aug 2014 21:32:28 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	g6J0dYevm6dUIfFt for <xfs@oss.sgi.com>;
	Sun, 10 Aug 2014 21:32:23 -0700 (PDT)
Date: Mon, 11 Aug 2014 14:32:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Verifier fixes backported to stable kernels?
Message-ID: <20140811043219.GJ26465@dastard>
References: <CA+o=1OVY0pV18XMKz98dT5LGwE500DQQb5B1wh=HaGTAGuP+oQ@mail.gmail.com>
	<20140809005404.GG26465@dastard>
	<CA+o=1OX+Qq4Scq=su1MDDknRXJGL8F=7WV8P0PCeDjYep7rLnA@mail.gmail.com>
	<CA+o=1OXmM+WsFh-ipS4d8hn6RKvOuv3Zga+66PF4DBehuH-5-A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+o=1OXmM+WsFh-ipS4d8hn6RKvOuv3Zga+66PF4DBehuH-5-A@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Aug 09, 2014 at 05:55:19PM +0200, Fanael Linithien wrote:
> 2014-08-09 2:54 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> > What fixes are you talking about? List of commits, please, noting
> > whether the commit already has a "cc: <stable@vger.kernel.org>" in
> > it or not.
> 
> These are the commits:
> 
> 400b9d88757c0bfbdfa97014e090ec40a31c1282
> 67dc288c21064b31a98a53dc64f6b9714b819fd6 (this is the only one with the cc)
> 5fd364fee81a7888af806e42ed8a91c845894f2d
> ad3714b82c631a34724da09a7daa53afcab952fa

Ok, but please use the "one-line format" when quoting commits.

I.e. this:

$ git log --oneline -n 4 ad3714b
ad3714b xfs: dquot recovery needs verifiers
5fd364f xfs: quotacheck leaves dquot buffers without verifiers
67dc288 xfs: ensure verifiers are attached to recovered buffers
400b9d8 xfs: catch buffers written without verifiers attached

is much more informative to the reader without a git tree to look up
commits.

As it is, those commits have not yet been sent to Linus, hence they
won't yet be accepted by the stable kernel folk. And because they
haven't been sent to Linus yet, I can redo the commits in that topic
branch with the needed stable tags. I've got to add a couple more
fixes that need to go to stable, too, so a pull req won't happen for
a couple of days yet....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
