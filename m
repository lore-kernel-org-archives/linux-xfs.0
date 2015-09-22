Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4320F7F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 20:42:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 322DF304032
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 18:42:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vlJvxPztECJA4oue for <xfs@oss.sgi.com>;
	Mon, 21 Sep 2015 18:42:31 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D5CEF6214D14
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 20:42:30 -0500 (CDT)
Subject: Re: [PATCH] mkfs.xfs: add [-U uuid] option
References: <1442855060-38259-1-git-send-email-mel@ohmu.fi>
	<20150921221839.GC19114@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5600B206.20806@sandeen.net>
Date: Mon, 21 Sep 2015 20:42:30 -0500
MIME-Version: 1.0
In-Reply-To: <20150921221839.GC19114@dastard>
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
To: xfs@oss.sgi.com

On 9/21/15 5:18 PM, Dave Chinner wrote:
> On Mon, Sep 21, 2015 at 08:04:20PM +0300, Mika Eloranta wrote:
>> The UUID can now be optionally specified during filesystem
>> creation.
> 
> Which UUID are you wanting to set - the metadata uuid or the user
> visible UUID label? Or both?

At mkfs time it should be the same / both.  (the only reason they need
to diverge is a post-mkfs user-visible change on a V5 fs).

 Can you explain the use case for this?
> i.e. I'm trying to work out why Why doesn't mkfs.xfs +
> xfs_admin -U <uuid> doesn't work for you?
> 
> We need some explaination in the commit message so that when we look
> at this in a couple of years time we know why we added this to
> mkfs...

I'm a little curious to know why it's desired, but it's also so trivial
it seems worth accepting if it's useful to someone.

mke2fs (mkfs.ext[234]) and mkfs.btrfs can do this today as well, so
something seems to be driving the desire for the feature.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
