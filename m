Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3F9iGru255734 for <xfs@oss.sgi.com>; Wed, 15 Apr 2009 04:44:27 -0500
Received: from mail.isg.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68A42216DFF
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2009 02:43:59 -0700 (PDT)
Received: from mail.isg.de (rzfoobar.is-asp.com [217.11.194.155]) by
	cuda.sgi.com with ESMTP id AsEIGazili25m9HP for
	<xfs@oss.sgi.com>; Wed, 15 Apr 2009 02:43:59 -0700 (PDT)
Message-ID: <49E5AC5E.90103@isg.de>
Date: Wed, 15 Apr 2009 11:43:58 +0200
From: Peter Niemayer <niemayer@isg.de>
MIME-Version: 1.0
Subject: Re: XFS support for TRIM / blkdev_issue_discard?
References: <20090331053013.7642414167108@attica.americas.sgi.com>
	<49E4A131.5040309@isg.de>
	<BB5058FD-E69F-4254-9548-82CD634C7FD6@sgi.com>
In-Reply-To: <BB5058FD-E69F-4254-9548-82CD634C7FD6@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

Felix Blyakher wrote:
>> do you know whether there are plans to support the ATA TRIM command /
>> blkdev_issue_discard() call in XFS for Linux anytime soon?
> 
> This topic was indeed brought up in xfs discussions.
> Though, we don't have any definite plans on supporting it yet.
> That doesn't mean that we oppose to it, just the lack of
> resources at the moment.
> Your mail will bring it up for discussion again.

Thanks a lot for your information!

Of course, I volunteer to help with testing & qualified feed-back.
I might even help with the implementation if you can tell me
where to look for the (hopefully well defined ;-) place in the
filesystem code where sectors become known not to contain relevant
data anymore.
But since I'm unfamiliar with kernel-filesystem programming, it
might take longer answering my questions then somebody involved
with XFS already would need to insert the blkdev_issue_discard()
calls.

Regards,

Peter Niemayer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
