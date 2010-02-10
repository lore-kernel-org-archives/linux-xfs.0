Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1AFfWpw058443 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 09:41:32 -0600
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB5EE139564B
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 07:42:44 -0800 (PST)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id ayDGLgEU0o2fzkq7 for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2010 07:42:44 -0800 (PST)
Message-ID: <4B72D3F3.2040308@news-service.com>
Date: Wed, 10 Feb 2010 16:42:43 +0100
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Inode reclaim fixes (was Re: 2.6.31	xfs_fs_destroy_inode:
	cannot reclaim)
References: <4B3F9F88.9030307@news-service.com>
	<20100107110446.GA13802@discord.disaster>
	<4B45CFAC.4000607@news-service.com>
	<20100108113114.GA8654@discord.disaster>
	<4B504B03.7050604@news-service.com>
	<4B6706CE.1020207@news-service.com>
	<20100208194226.GD9527@infradead.org>
	<4B712166.9010701@news-service.com>
	<20100209103157.GA5197@infradead.org>
	<4B72A9D1.8030101@news-service.com>
	<20100210145508.GA29047@infradead.org>
In-Reply-To: <20100210145508.GA29047@infradead.org>
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

On 10-2-2010 15:55, Christoph Hellwig wrote:
> On Wed, Feb 10, 2010 at 01:42:57PM +0100, Patrick Schreurs wrote:
>> Thanks for the patch. After having this patch applied we saw *a lot*
>> warnings. They all look like this:
>
> Ok, looks like that is not an issue, so you can discard that patch.
>
> I went down to the radix tree code to look for races in it's tag
> handling, but then noticed that we might have an issue with our
> usage of the radix-tree API.  Can you try the patch below ontop
> of Dave's rollup, and instead of my previous one?

Okay. This patch is currently active. Thanks. I don't have a way to 
trigger it, so we'll have to wait and see what happens.

Obviously we'll keep you posted.

Have any of these patches been sent to the stable team? And have these 
patches been submitted to the upcoming 2.6.33 kernel?

-Patrick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
