Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C33A97F3F
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 01:33:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 40CF5AC003
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 23:33:28 -0700 (PDT)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id ETvDaMZoC11H4rSz (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 23:33:23 -0700 (PDT)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N8F000YPM7LQ8B0@mailout4.samsung.com> for
	xfs@oss.sgi.com; Wed, 09 Jul 2014 15:33:21 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
	<20140708121500.GA518@infradead.org>
In-reply-to: <20140708121500.GA518@infradead.org>
Subject: RE: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Date: Wed, 09 Jul 2014 15:33:21 +0900
Message-id: <001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, 'Brian Foster' <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'Luk?? Czerner' <lczerner@redhat.com>, 'linux-ext4' <linux-ext4@vger.kernel.org>

> 
> On Tue, Jul 08, 2014 at 08:59:49PM +0900, Namjae Jeon wrote:
> > This patch implements fs ioctl's IOC_MOV_DATA for XFS.
> 
> Shouldn't this share code with the XFS_IOC_SWAPEXT implementation?
Lukas has raised the same question for ext4.
Both xfs(XFS_IOC_SWAPEXT) and ext4(EXT4_IOC_MOVE_EXT) has ioctls which uses
almost similar kind of structure as struct mov_data.
As such, there seems to be possiblity for sharing basic code (I will try)
used for sanity checking in IOC_MOV_DATA to be shared with these ioctls
but the core functionality code will remain different.

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
