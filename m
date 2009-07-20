Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KJJ9f5103811
	for <linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 14:19:10 -0500
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C01210A8B8E
	for <linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 12:27:53 -0700 (PDT)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id Hh6hfv0K9VOScNZ0 for
	<linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 12:27:53 -0700 (PDT)
Message-ID: <4A64C34F.80807@news-service.com>
Date: Mon, 20 Jul 2009 21:19:43 +0200
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
References: <4A408316.2070903@news-service.com>	<1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>	<20090623171305.GB23971@infradead.org>	<4A4A7205.6010101@news-service.com>
	<20090630204256.GA1891@infradead.org>
In-Reply-To: <20090630204256.GA1891@infradead.org>
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
Cc: linux-xfs@oss.sgi.com, Tommy van Leeuwen <tommy@news-service.com>, Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

Hi Christoph,

I saw some patches from your hand on this list ("fixes for memory 
allocator recursions into the filesystem"). Are these patches related to 
this issue?

Thanks,

-Patrick

Christoph Hellwig wrote:
> On Tue, Jun 30, 2009 at 10:13:57PM +0200, Patrick Schreurs wrote:
>> Hi (again),
>>
>> Anyone has any advice to prevent this from happening? We've seen 10  
>> crashes in the last 14 days. Would it be helpful to enable  
>> CONFIG_XFS_DEBUG? Does this result in a big performance hit on busy xfs  
>> filesystems? If we can help troubleshoot this problem, please advice.
>>
>> If i understand correctly this issue also exists in 2.6.29? Should i  
>> downgrade to the latest 2.6.28 kernel to regain stability?
> 
> For now please downgrade to the latest 2.6.28, yes.  I hope I will have
> time and machine ressources to dig deeper into the problem this week.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
