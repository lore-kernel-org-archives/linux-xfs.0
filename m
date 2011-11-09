Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA98cFNb213084 for <xfs@oss.sgi.com>; Wed, 9 Nov 2011 02:38:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B3F810377EF
	for <xfs@oss.sgi.com>; Wed,  9 Nov 2011 00:38:14 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Lk2kxJbtr8SdnF18 for <xfs@oss.sgi.com>;
	Wed, 09 Nov 2011 00:38:14 -0800 (PST)
Date: Wed, 9 Nov 2011 03:38:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/3] xfstests: Add a group of reservation space test
Message-ID: <20111109083811.GA23248@infradead.org>
References: <4EB8A441.7090506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EB8A441.7090506@cn.fujitsu.com>
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
To: WuBo <wu.bo@cn.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Nov 08, 2011 at 11:38:41AM +0800, WuBo wrote:
> Changes v1->v2:
> - Make test-set support generic
> 
> This patch set add a group of reservation space test. Especailly for btrfs.
> It includes three parts: copy workload, prealloc and write posix.
> 
> For test 273, I hope it's usefull for Josef's reserve improve work.
> For test 274 and 275, the current btrfs is not pass yet.
> 
> Wu Bo (3):
>   xfstests 273: add a copy and reserve test
>   xfstests 274: add a prealloc and reserve test
>   xfstests 275: add a write and reserve test

The patches look good to me.  Unless someone else complains until
tomorrow I'll put them in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
