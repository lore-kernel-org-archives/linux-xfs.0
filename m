Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GL88GH062484
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jun 2011 16:08:09 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 538071D756E1
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jun 2011 14:08:07 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 6vyoYhZ8P7esWmOd for <linux-xfs@oss.sgi.com>;
	Thu, 16 Jun 2011 14:08:07 -0700 (PDT)
Message-ID: <4DFA70B7.5080206@sandeen.net>
Date: Thu, 16 Jun 2011 16:08:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: sparse file handling bug in XFS
References: <081DDE43F61F3D43929A181B477DCA95639B561F@MSXAOA6.twosigma.com>	<4DFA2A76.6000104@sandeen.net>
	<4DFA3E7D.4030408@sandeen.net>
	<20110616175743.GA20570@infradead.org>
In-Reply-To: <20110616175743.GA20570@infradead.org>
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
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Sean Noonan <Sean.Noonan@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, Ian Baum <Ian.Baum@twosigma.com>, Stephen Degler <Stephen.Degler@twosigma.com>, "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 6/16/11 12:57 PM, Christoph Hellwig wrote:
> On Thu, Jun 16, 2011 at 12:33:49PM -0500, Eric Sandeen wrote:
>> Actually this looks like it's a result of
>>
>> 6e857567dbbfe14dd6cc3f7414671b047b1ff5c7 xfs: don't truncate prealloc from frequently accessed inodes
>>
>> I thought Dave's patch from the "Re: drastic changes to allocsize semantics in or around 2.6.38?"
>> thread would fix it, but it doesn't seem to.  Here it is anyway ;)
> 
> It should fix the thing about the preallocation staying when removing
> and recreating the file.  Keeping pre-allocate blocks around otherwise
> is a considered a feature.

It strikes me as odd that truncating & rewriting would lead to
different preallocation though .. I'll let Dave chime in.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
