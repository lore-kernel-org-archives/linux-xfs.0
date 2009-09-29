Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8TAEWeh199014 for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 05:14:34 -0500
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A06D911903EA
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 03:15:50 -0700 (PDT)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id SefZPeO9b4OnOwIc for
	<xfs@oss.sgi.com>; Tue, 29 Sep 2009 03:15:50 -0700 (PDT)
Message-ID: <4AC1DE4E.6060102@news-service.com>
Date: Tue, 29 Sep 2009 12:15:42 +0200
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
References: <89c4f90c0909160327l1a1fdaa2g131cd7fa249ad529@mail.gmail.com>
	<20090917185953.GA24590@infradead.org>
In-Reply-To: <20090917185953.GA24590@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Sep 16, 2009 at 12:27:21PM +0200, Tommy van Leeuwen wrote:
>> Hello All,
>>
>> We had this error reported on the list about 1 or 2 months ago. During
>> that time a lot of fixes were applied. However, we still experience
>> this problem with the recent 2.6.31 tree. We've also applied an extra
>> log entry to aid in debugging.
>>
>> printk("XFS: inode_init_always failed to re-initialize inode\n");
>>
>> However, we didn't see this logging!
> 
> Can you try the patch below, its does two things
> 
>  - remove all that reclaimable flagging if we reclaim the inode
>    directly.  This removes any possibility of racing with the reclaiming
>    thread.
>  - adds asserts if one of the reclaim-related flags is already set.

Update: We've applied this patch on 2 servers. They didn't crash until 
now. Today we've applied the patch on 6 other servers.

We'll keep you posted.

-Patrick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
