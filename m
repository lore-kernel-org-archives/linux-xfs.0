Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM4WFQ6117339 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 22:32:15 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E12E49019BB
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 20:32:13 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id B54VzGcuajt7dBvb for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 20:32:13 -0800 (PST)
Message-ID: <4ECB25C7.8070801@sandeen.net>
Date: Mon, 21 Nov 2011 22:32:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair is recommended over xfs_check.
References: <4ECAC84C.1070000@sauce.co.nz> <20111122002306.GI2386@dastard>
In-Reply-To: <20111122002306.GI2386@dastard>
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
Cc: Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

On 11/21/11 6:23 PM, Dave Chinner wrote:
> On Tue, Nov 22, 2011 at 10:53:16AM +1300, Richard Scobie wrote:
>> Is there currently now any situation where xfs_check would be used
>> in preference to xfs_repair?
>>
>> If not, perhaps xfs_check could be deprecated.
> 
> xfs_check is one of the ways we test that xfs_repair is doing the
> right thing. Having two implementation that you can use to compare
> results is a good thing.....

What about for end users though?  I'm not sure there's much need
for end users to be comparing xfs_check against xfs_repair in general,
anyway ...

Often enough I see users using xfs_check just because it's there,
and running into trouble... it seems reasonable to warn the
casual user against it, or at least recommend xfs_repair -n
instead.  What do you think?

-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
