Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D0A5B7F37
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2016 13:49:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DB05AC001
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2016 11:49:02 -0800 (PST)
Date: Mon, 18 Jan 2016 06:48:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs deadlocks since upgrading to 4.1.15
Message-ID: <20160117194852.GR6033@dastard>
References: <5698B6EE.4000502@profihost.ag> <20160115225508.GQ6033@dastard>
	<569A972C.5060802@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <569A972C.5060802@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Jan 16, 2016 at 08:17:00PM +0100, Stefan Priebe wrote:
> Hi Dave,
> 
> Am 15.01.2016 um 23:55 schrieb Dave Chinner:
> >On Fri, Jan 15, 2016 at 10:07:58AM +0100, Stefan Priebe wrote:
> >>Hello,
> >>
> >>since we upgraded from 3.18 to 4.1.15 i've seen many deadlocks. Alle
> >>call traces show xfs.
> >>
> >>Attention all those are down top instead of top down (sorry for the
> >>wrong order).
> >
> >Can you repost them with line wrapping turned off, so they are
> >readable without causing beeding eye syndrome?
> i'm sorry. i was a bit optimistic that someone can read that.
> 
> Here are the traces in correct order, without timestamps but at
> pastebin which seems to be easier at least with thunderbird as it
> has no easy to use option to disable wrapping.
> 
> Nr 1:
> http://pastebin.com/raw/Fuxd86TP
> 
> Nr 2:
> http://pastebin.com/raw/Dp7mEcKi
> 
> Nr 3:
> http://pastebin.com/raw/BY3gUwzx

Commit 7a29ac4 ("xfs: give all workqueues rescuer threads") should
fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
