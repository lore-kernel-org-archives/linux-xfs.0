Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0J1naDU016695 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 19:49:36 -0600
Message-ID: <4973DCD8.2070705@sgi.com>
Date: Mon, 19 Jan 2009 12:52:24 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/7] Remaining 2.6.29 queue
References: <20090109221104.237540000@bombadil.infradead.org>	<20090118170241.GA21181@infradead.org>
	<9305FAB6-0189-4F82-9E12-22656A7ABF9F@sgi.com>
In-Reply-To: <9305FAB6-0189-4F82-9E12-22656A7ABF9F@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Felix Blyakher wrote:
> Hi Christoph,
> 
> On Jan 18, 2009, at 11:02 AM, Christoph Hellwig wrote:
> 
>> On Fri, Jan 09, 2009 at 05:11:04PM -0500, Christoph Hellwig wrote:
>>> These are my current outstanding patches for 2.6.29, consisting of
>>> small enough fixes and lockdep annotations, and an early warning
>>> for a attr corruption frequently seen on kerneloops.org.
>> Can we please get these pushed out to Linus?  Thanks.
> 
> IIRC, Lachlan had problem applying your patches.
> I'll check it myself and let you know where we're
> here.

They applied okay but the first patch caused this build failure.

    CC      init/version.o
    LD      init/built-in.o
    LD      .tmp_vmlinux1
fs/built-in.o: In function `xfs_handle_to_dentry':
/home/lachlan/git/xfs-update/fs/xfs/linux-2.6/xfs_ioctl.c:211: undefined reference to `exportfs_decode_fh'
make: *** [.tmp_vmlinux1] Error 1

> 
> Felix
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
