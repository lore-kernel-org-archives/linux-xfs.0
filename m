Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 642387F84
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:20:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5268F8F8040
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:20:32 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Qpd46NHIKTH3paRN for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:20:23 -0800 (PST)
Date: Mon, 9 Dec 2013 09:20:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Sudden File System Corruption
Message-ID: <20131208222014.GA31386@dastard>
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
	<20131205174058.GF1935@sgi.com> <20131205175053.GG1935@sgi.com>
	<CAPd9ww9YFbMEe-dM96zHsbRJgQuBHfF=ipromch1Yw6SzPUftg@mail.gmail.com>
	<20131206002308.GS10553@sgi.com>
	<CAPd9ww8XDzGbSZsEEoCmSuJ+KBYUWqHeRON1sFr6bG1fZ6af7w@mail.gmail.com>
	<20131206225612.GU10553@sgi.com>
	<CAPd9ww_Df6FwDc_Kv82LKAZR5ML8DLUHwLruBY+innemOtggtw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPd9ww_Df6FwDc_Kv82LKAZR5ML8DLUHwLruBY+innemOtggtw@mail.gmail.com>
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
To: Mike Dacre <mike.dacre@gmail.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com


[ For future reference - can people keep triage on the public list
so everyone can see that the problem is being worked on? ]

On Fri, Dec 06, 2013 at 03:15:33PM -0800, Mike Dacre wrote:
> On Fri, Dec 6, 2013 at 2:56 PM, Ben Myers <bpm@sgi.com> wrote:
> > It's great that you have this.  And an interesting repair log.
> > The good news is that it doesn't look like the corruption that
> > xfs_repair doesn't fix, the bad news is that I don't recognise
> > it.
> 
> Here is the repair log from right after the corruption happened.
> The repair was successful.

If xfs_repair didn't report any freespace corruption, then it's
because it didn't see any. And that's not actually surprising for
this sort of shutdown followed by log recovery failures.

What it means the corruption was detected pretty much
immediately after it occurred and the shutdown confined it to the
log before it could be propagated to the in place metadata. Which
generally means the shutdown occurred within 30s of it occurring.

In my experience, this sort of "corruption confined to the log"
shutdown is usually a result of some kind of memory corruption that
is captured accidentally in the log due to object relogging (i.e. in
a dirty region from a previous change that is not yet committed to
the log) prior to it being detected in a transaction.

Without being able to see the before/after log recovery filesystem
images, there's nothing we can do to track this down further.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
