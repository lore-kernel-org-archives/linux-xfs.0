Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DMHoB1156732 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 17:17:50 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 873741DED
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 15:19:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8rqA2i2KqLitkQGX for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 15:19:20 -0700 (PDT)
Message-ID: <4AD4FCDD.1060602@sandeen.net>
Date: Tue, 13 Oct 2009 17:19:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 03/14] repair: kill B_IS_META flag
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090902175840.224768080@bombadil.infradead.org>
	<4AD38744.3010702@sandeen.net>
	<20091013221646.GA31385@infradead.org>
In-Reply-To: <20091013221646.GA31385@infradead.org>
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

Christoph Hellwig wrote:
> On Mon, Oct 12, 2009 at 02:45:08PM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>
>>> B_IS_META is the inverse flag of B_IS_INODE which is not really obvious
>>> from it's use.  So just use !B_IS_INODE to make it more clear.
>>>
>> Logic-wise it's fine, but is this change really helpful?   The comment says:
>>
>> /*
>> * Test if bit 0 or 2 is set in the "priority tag" of the buffer to see if
>> * the buffer is for an inode or other metadata.
>> */
>>
>> so basically it distinguishes inodes from other metadata right.
> 
> Yes, with the key on other.  In my books inodes are meta-data.
> 
>> B_IS_INODE is clear; B_IS_META is pretty clear, "!B_IS_INODE" seems muddy; so
>> very many things are "not inodes" :)
> 
> In a buffercache (and in fact a whole application) that only deals with
> metadata at all !B_IS_INODE meaning other metadata seems a lot more
> clear to me than B_IS_META.
> 

Ok, I'm fine with that I suppose.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
