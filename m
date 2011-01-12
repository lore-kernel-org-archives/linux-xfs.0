Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C4FH9H137393 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 22:15:17 -0600
Subject: Re: [RFC, PATCH 0/12] xfs: rework error logging infrastructure
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294792553-8378-1-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
Date: Tue, 11 Jan 2011 22:16:29 -0600
Message-ID: <1294805789.3115.131.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2011-01-12 at 11:35 +1100, Dave Chinner wrote:
> This series completely reworks the cmn_err logging infrastructure
> by replacing it with a simple, consistent API that can be used everwhere.
> IOWs, this series replaces the various cmn_err APIs:

. . .

I reviewed the whole series, and offered a correction
on just one thing.  I might quibble with the indentation
of some of the format strings here or there, but I
didn't bother, there sometimes is no nice way to
do those.

I personally like the result a lot, it's a lot cleaner
and easier on the eyes.

In any case, you say it's an RFC but I'm OK with it.

I'm just starting to test with it but you can consider
the whole series reviewed by me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
