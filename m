Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C7etEM154868 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 01:40:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F2F7257567
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 23:43:07 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	SWvA7hvCpeoEAVaO for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 23:43:07 -0800 (PST)
Date: Wed, 12 Jan 2011 18:43:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/12] xfs: rework error logging infrastructure
Message-ID: <20110112074304.GN28803@dastard>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294805789.3115.131.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294805789.3115.131.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 11, 2011 at 10:16:29PM -0600, Alex Elder wrote:
> On Wed, 2011-01-12 at 11:35 +1100, Dave Chinner wrote:
> > This series completely reworks the cmn_err logging infrastructure
> > by replacing it with a simple, consistent API that can be used everwhere.
> > IOWs, this series replaces the various cmn_err APIs:
> 
> . . .
> 
> I reviewed the whole series, and offered a correction
> on just one thing.  I might quibble with the indentation
> of some of the format strings here or there, but I
> didn't bother, there sometimes is no nice way to
> do those.

Yeah, I tried to make them a bit more consistent - one line if
possible, even if the indenting was not "pretty". In some places it
made a major improvement, in other places I wasn't quite so happy
with the result.

> I personally like the result a lot, it's a lot cleaner
> and easier on the eyes.
>
> In any case, you say it's an RFC but I'm OK with it.

It was an RFC because I wasn't sure whether people would like the
interface I proposed and converted to. I know I mentioned it
previously, but no-one commented in reply with a yay or nay, so
I just went an did it and this is the result.

> I'm just starting to test with it but you can consider
> the whole series reviewed by me.

Great, thanks. I'll push it out into a topic branch tomorrow...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
