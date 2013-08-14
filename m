Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A91E7F51
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 11:51:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9402AAC001
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 09:51:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qHonI76BG3OvFwsl for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 09:51:10 -0700 (PDT)
Message-ID: <520BB57C.5020506@sandeen.net>
Date: Wed, 14 Aug 2013 11:51:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<52090C6C.6060604@allmail.net> <20130813000453.GQ12779@dastard>
	<520A5132.6090608@allmail.net> <20130814062041.GB12779@dastard>
In-Reply-To: <20130814062041.GB12779@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Maier <m1278468@allmail.net>, xfs@oss.sgi.com

On 8/14/13 1:20 AM, Dave Chinner wrote:

> Hence looks like we'll need some new xfs_repair functionality to fix
> this. It might take me a little while to get you a fix - perhaps
> someone else with a little bit of spare time could get it done
> sooner than I can. Anyone?

Pff, not like I have the time, but it also looks pretty trivial.

secondary_sb_wack() only conditionally checks & zeroes unused space;
making it unconditional is probably all it takes.

I think it also needs to _not_ zero sb_bad_features2 as it does
today, because that is supposed to be kept in sync w/ sb_features2.

I have a patch I'll test; it'd be great to get a metadump from Michael
to test it on his original failure case.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
