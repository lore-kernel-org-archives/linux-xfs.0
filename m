Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JFpYbQ258284 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 10:51:34 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E664C1432290
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 08:53:58 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id n2UXMgDt6DmqtewH for
	<xfs@oss.sgi.com>; Sun, 19 Apr 2009 08:53:58 -0700 (PDT)
Message-ID: <49EB487C.1020205@sandeen.net>
Date: Sun, 19 Apr 2009 10:51:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS support for TRIM / blkdev_issue_discard?
References: <20090331053013.7642414167108@attica.americas.sgi.com>	<49E4A131.5040309@isg.de>	<BB5058FD-E69F-4254-9548-82CD634C7FD6@sgi.com>
	<20090419081927.GE16929@discord.disaster>
In-Reply-To: <20090419081927.GE16929@discord.disaster>
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
Cc: Peter Niemayer <niemayer@isg.de>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Tue, Apr 14, 2009 at 01:32:35PM -0500, Felix Blyakher wrote:
>> On Apr 14, 2009, at 9:44 AM, Peter Niemayer wrote:
>>
>>> Dear Felix Blyakher,
>> Hi Peter,
>>
>>> do you know whether there are plans to support the ATA TRIM command /
>>> blkdev_issue_discard() call in XFS for Linux anytime soon?
>> This topic was indeed brought up in xfs discussions.
>> Though, we don't have any definite plans on supporting it yet.
> 
> I did some initial work on tracking extents being freed, but then
> the TRIM request morphed into a "tell the largest free space around
> the area just freed" and that is much harder to do than simply to
> issue a "we just freed this bit" command.

FWIW, ext[34] is still doing it block by block.  At least for SSDs, I
think that's fine, isn't it?  For think provisioning it might be
different.  I  think (?) the simply block-by-block free is still
relevant, no?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
