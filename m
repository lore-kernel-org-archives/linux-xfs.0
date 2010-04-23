Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3NEmXEQ060581 for <xfs@oss.sgi.com>; Fri, 23 Apr 2010 09:48:33 -0500
Received: from b.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 82401154959F
	for <xfs@oss.sgi.com>; Fri, 23 Apr 2010 07:50:31 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (bongo.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id YuHDMbrVOJEWi7Vz for
	<xfs@oss.sgi.com>; Fri, 23 Apr 2010 07:50:31 -0700 (PDT)
Message-Id: <1A865685-5F74-4629-9905-110D6AACD4BB@filmlight.ltd.uk>
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20100423130051.GA7163@infradead.org>
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: inode parent pointer attributes
Date: Fri, 23 Apr 2010 15:50:29 +0100
References: <8A91C8CC-6DC4-4334-A2B9-ED814DAF0352@filmlight.ltd.uk>
	<20100423130051.GA7163@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 23 Apr 2010, at 14:00, Christoph Hellwig wrote:

> On Fri, Apr 23, 2010 at 12:07:08PM +0100, Roger Willcocks wrote:
>> Hi folks,
>>
>> Commit 6d73cf133c5477f7038577bfeda603ce9946f8cb reintroduced the
>> XFS_SB_VERSION2_PARENTBIT in the kernel headers, which is described
>> in the xfs filesystem structure document as 'All inodes must have an
>> extended attribute that points back to its parent inode'.
>>
>> There's currently (afaict) no Linux kernel implementation of this.  
>> But
>> it's something I would find very useful for a filesystem extension  
>> I'm
>> working on.
>
> Work on the Linux port of this feature stopped when SGI closed the
> Melbourne engineering office where people were working on it.
> Fortunately SGI did publish the latest development state of it for
> others to continue.  I've attached my local copy in case you're
> interested on finishing this.
>

Thanks Christoph, I'll take a look.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
