Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2BMQow9185678 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 16:26:56 -0600
Received: from iport-c2-out.ucsd.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FEC610D1D23
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 14:29:31 -0800 (PST)
Received: from iport-c2-out.ucsd.edu (iport-c2-out.ucsd.edu [132.239.0.119])
	by cuda.sgi.com with ESMTP id 70BKvSDBYiDgZkmt for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2011 14:29:31 -0800 (PST)
Subject: Re: Does XFS ever relocate extents after they are on disk?
Mime-Version: 1.0 (Apple Message framework v1082)
From: Steven Swanson <swanson@cs.ucsd.edu>
In-Reply-To: <20110311100936.GA11879@infradead.org>
Date: Fri, 11 Mar 2011 14:29:30 -0800
Message-Id: <D03B8F30-7E6D-4C85-8160-9FB505E09B9F@cs.ucsd.edu>
References: <903E14DC-D9EA-4BDC-8D43-FBB9AB4127BC@cs.ucsd.edu>
	<20110311100936.GA11879@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph,

Thanks for the quick reply.  

Here's another question:  If I write data to an extent that already exists, am I also guaranteed that the new data will overwrite the same location?  For instance, will XFS ever relocate an extent on a write in order to expand the extent?

-steve


On Mar 11, 2011, at 2:09 AM, Christoph Hellwig wrote:

> On Thu, Mar 10, 2011 at 11:55:21PM -0800, Steven Swanson wrote:
>> I have simple question that I'm having trouble finding a concrete answer for:
>> 
>> Does XFS ever relocate a file or one of its extents once it's been written to disk?  For instance, does the file system ever decide to reorganize extents to reduce fragmentation.
>> 
>> I've read through all the documentation I can find, and everything points to using an external de-fragmentation tool, which suggests that XFS won't do it autonomously, but for the project we are working on it would be useful to know for certain when and under what conditions XFS might decide to move an extent that's already been written.
> 
> XFS kernel code will never move the written extents by itself.  The xfs_fsr
> tool can instruct the kernel to move extents by the swapext ioctl, and
> it can be run through a cron job, although that is usually not required.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
