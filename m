Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0EMlhnO006776 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 16:47:43 -0600
Message-ID: <496E6C2A.5020007@sgi.com>
Date: Thu, 15 Jan 2009 09:50:18 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/7] xfs: fix dentry aliasing issues in open_by_handle
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221259.292773000@bombadil.infradead.org>
	<20090111233306.GH8071@disturbed>
	<20090112153934.GA28382@infradead.org>
	<496D8E10.4000501@sgi.com> <20090114223737.GZ8071@disturbed>
In-Reply-To: <20090114223737.GZ8071@disturbed>
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Wed, Jan 14, 2009 at 06:02:40PM +1100, Lachlan McIlroy wrote:
>> Christoph,
>>
>> When I build with this patch it fails with:
>>
>>    CC      init/version.o
>>    LD      init/built-in.o
>>    LD      .tmp_vmlinux1
>> fs/built-in.o: In function `xfs_handle_to_dentry':
>> /home/lachlan/git/xfs-update/fs/xfs/linux-2.6/xfs_ioctl.c:211: undefined reference to `exportfs_decode_fh'
>> make: *** [.tmp_vmlinux1] Error 1
> 
> Given:
> 
> EXPORT_SYMBOL_GPL(exportfs_decode_fh);
> 
> Did you build with EXPORTFS support in your kernel?
Not explicitly.  I can't find a reference to it anywhere in my .config.

> 
> If not, then I think that fs/xfs/Kconfig needs to select EXPORTFS
> when XFS is configured in (i.e. it's a new dependency).
> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
