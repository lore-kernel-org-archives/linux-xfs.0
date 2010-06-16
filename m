Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5G2jTjk110065 for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 21:45:29 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E63063CDBD5
	for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 19:48:04 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 4admDWIAPUiQZSxQ for
	<xfs@oss.sgi.com>; Tue, 15 Jun 2010 19:48:04 -0700 (PDT)
Message-ID: <4C183B63.5090306@sandeen.net>
Date: Tue, 15 Jun 2010 21:48:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: Fix gcc 4.6 set but not read and unused statement
	warnings v2
References: <20100614081356.GA27499@basil.fritz.box>	<20100614083021.GA29354@lst.de>
	<4C15EF75.5080909@linux.intel.com>	<20100614124804.GA8547@lst.de>	<20100614133958.GH17092@basil.fritz.box>
	<20100614163122.GB369@basil.fritz.box>
In-Reply-To: <20100614163122.GB369@basil.fritz.box>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@lst.de>, dgc@fromorbit.com, xfs@oss.sgi.com

Andi Kleen wrote:
> On Mon, Jun 14, 2010 at 03:39:58PM +0200, Andi Kleen wrote:
>> On Mon, Jun 14, 2010 at 02:48:04PM +0200, Christoph Hellwig wrote:
>>> On Mon, Jun 14, 2010 at 10:59:33AM +0200, Andi Kleen wrote:
>>>>> How can this work?  bp->data is a void pointer.
>>>> It compiled with CONFIG_XFS_DEBUG enabled. Do I need to set some other
>>>> option to test this?
>>> It fails for me in a normal CONFIG_XFS_DEBUG build:
>>>
>>> fs/xfs/xfs_da_btree.c: In function 'xfs_da_root_join':
>>> fs/xfs/xfs_da_btree.c:737: warning: dereferencing 'void *' pointer
>>> fs/xfs/xfs_da_btree.c:737: error: request for member 'magic' in
>>> something not a structure or union
>>> fs/xfs/xfs_da_btree.c:737: warning: dereferencing 'void *' pointer
>>
>> Hmm, it really compiled here (scratching head)
> 
> Never mind, it seems SUBDIRS doesn't set the DEBUG flag correctly. 

really?

$ make SUBDIRS=fs/xfs
  CC [M]  fs/xfs/linux-2.6/xfs_super.o
fs/xfs/linux-2.6/xfs_super.c:73:2: error: #error DEBUG
make[1]: *** [fs/xfs/linux-2.6/xfs_super.o] Error 1

$ grep -A3 XFS_DEBUG fs/xfs/linux-2.6/xfs_super.c 
#ifdef CONFIG_XFS_DEBUG
#error DEBUG
#endif

(above just for testing)

Offtopic I guess, but it sure seems to set it for me.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
