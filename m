Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2847C7CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 16:55:10 -0500 (CDT)
Subject: Re: [PATCH 4/5] xfs: xfs_inode_free() isn't RCU safe
References: <0A92B65A3BF94F60BB36EA3FA716DF1F@alyakaslap>
	<570CDC0B.3070802@sgi.com> <20160412211148.GJ567@dastard>
From: Brent Bice <bbice@sgi.com>
Message-ID: <570D6EBB.1010805@sgi.com>
Date: Tue, 12 Apr 2016 15:55:07 -0600
MIME-Version: 1.0
In-Reply-To: <20160412211148.GJ567@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Shyam Kaushik <shyam@zadarastorage.com>, Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On 04/12/2016 03:11 PM, Dave Chinner wrote:
> It seems that sgi.com is rejecting quite a bit of legitimate mail
> lately. I've seen a couple of people in the past couple of weeks
> send stuff that has reached my private in boxes but not the list.
> Now this one, too.

    Yeah, this one wasn't the anti-spam filters that I manage (the 
barracudas, our private RBL, etc) but spamassassin on oss.sgi.com. 
So...  Dunno.  I took a crack at whitelisting Alex's from address in 
spamassassin (though I haven't looked at it's configs or man pages in 
about 10 years).

> If someone is having to micro-manage the list to prevent rejections
> of valid email then that is bad...

So true.  I only happened to notice because I had someone (I forget who 
it was several years ago) tweak SA on oss so that rejections get 
forwarded to me.  The idea was I'd look at those (stuff that the cudas 
missed but spamassassin caught) and use that info to update our filters 
(the filters that benefit everyone at SGI, not just oss).

    Anyway, I don't always have the bandwidth to look at every email SA 
on oss rejects and update spam filters (if possible) and just happened 
to notice this one and that it wasn't spam.

    I am a lot more aggressive with the filters for oss because it's 
such a sore-thumb-target for spammers. For instance, there are large 
swaths of yahoo IP space being blocked now (for oss only) because over 
the years I only found one legit sender to oss from a yahoo IP - the 
rest was all spam/phish.  But I've only dropped in yahoo IP ranges that 
I was seeing spam from.  I've gotten aggressive with some Chinese IP 
space too for similar reasons. If any of the senders you know of having 
trouble might be in yahoo or chinese IP space let me know and I can look 
in the logs, but I'd bet a doughnut that if they didn't get a bounce 
then they're running afoul of spamassassin 'n not the filters I manage. :-(

    There was talk a while back of taking oss out of SGI and hosting it 
somewhere in "Da cloud!" (tm) and having someone else in the xfs 
community own it, wasn't there?  Anyone still looking into that?

Brent


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
