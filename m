Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 021107F8C
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 15:31:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9F288F8040
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 13:31:00 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lmbxCRxXiUGqEJAt for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 13:30:59 -0800 (PST)
Date: Mon, 3 Feb 2014 08:30:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: relationship of nested stripe sizes, was: Question regarding XFS
	on LVM over hardware RAID.
Message-ID: <20140202213030.GQ2212@dastard>
References: <7A732267-B34F-4286-9B49-3AF8767C0B89@colorremedies.com>
	<52ED4143.6090303@hardwarefreak.com>
	<EDBD7355-F1EC-4773-9138-CA864CB2E84B@colorremedies.com>
	<52ED6AAF.6030703@hardwarefreak.com>
	<98961D3F-769D-44A9-98A8-FC7867893138@colorremedies.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <98961D3F-769D-44A9-98A8-FC7867893138@colorremedies.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>, xfs <xfs@oss.sgi.com>

On Sun, Feb 02, 2014 at 11:09:11AM -0700, Chris Murphy wrote:
> On Feb 1, 2014, at 2:44 PM, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> > On 2/1/2014 2:55 PM, Chris Murphy wrote:
> >> On Feb 1, 2014, at 11:47 AM, Stan Hoeppner
> >> <stan@hardwarefreak.com> wrote:
> > When nesting stripes, the chunk size of the outer stripe is
> > -always- equal to the stripe width of each inner striped array,
> > as I clearly demonstrated earlier:
> 
> Except when it's hardware raid6, and software raid0, and the user
> doesn't know they need to specify the chunk size in this manner.
> And instead they use the mdadm default. What you're saying makes
> complete sense, but I don't think this is widespread knowledge or
> well documented anywhere that regular end users would know this by
> and large.

And that is why this is a perfect example of what I'd like to see
people writing documentation for.

http://oss.sgi.com/archives/xfs/2013-12/msg00588.html

This is not the first time we've had this nested RAID discussion,
nor will it be the last. However, being able to point ot a web page
or or documentation makes it a whole lot easier.....

Stan - any chance you might be able to spare an hour a week to write
something about optimal RAID storage configuration for XFS?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
