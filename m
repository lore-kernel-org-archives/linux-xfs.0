Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67ABF7F53
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 18:32:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAA90AC004
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 16:32:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UTsKdQxTgXnHqbXz for <xfs@oss.sgi.com>;
	Mon, 22 Jul 2013 16:32:45 -0700 (PDT)
Date: Tue, 23 Jul 2013 09:32:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/49] xfsprogs: patches for crc-dev branch
Message-ID: <20130722233240.GC19986@dastard>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<51EB80DB.80602@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51EB80DB.80602@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Jul 21, 2013 at 02:34:03AM -0400, Michael L. Semon wrote:
> On 07/19/2013 02:44 AM, Dave Chinner wrote:
> 
> > Comments, thoughts, flames?
> 
> I was hoping that I could use this 3.12 patchset with a 3.11.0-rc 
> kernel, but the xfstests look like a disaster by going that way.  

We'll, if you don't have all the filtering patches that I posted a
while back it'll make quite a mess with all the experimental
warnings mkfs and repair emit, and the xfs_db tests that modify
filesystem structures will all also fail...

I'll repost them later today...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
