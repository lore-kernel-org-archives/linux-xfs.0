Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52DOaYG100807 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 08:24:36 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12D3C30408F
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2009 06:24:51 -0700 (PDT)
Message-Id: <8637EA4C-FD28-4733-9532-062DFBA746DA@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A24FEF9.6050309@dermichi.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: regarding the inode64 mount option
Date: Tue, 2 Jun 2009 08:24:47 -0500
References: <4A1E81D8.7010706@dermichi.com>	<20090528145612.GA14684@infradead.org>
	<4A1EAB31.7090604@sandeen.net> <4A24FEF9.6050309@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


On Jun 2, 2009, at 5:29 AM, Michael Weissenbacher wrote:

> Hi Eric + Christoph!
>> http://sandeen.net/wordpress/?p=9
> This is a scary list indeed! Does this apply only to Fedora on i686  
> or also to x86_64?
>
> In general, does the inode64 option make sense at all on a partition  
> that is <1TB in size?

inode64 doesn't do anything on a partition smaller than 1TB.

>> Actually they should still be accessible, we just won't create new
>> inodes not addressable by 32bit inode numbers.
> Well, in my tests it didn't work.

Indeed. (I thought I already replied stating this, but found my
mail in Drafts folder).

What you're seeing is expected result, which was observed in our
environment as well.

[snip]

> The filesystem is consistent - xfs_check (3.0.1) doesn't report any  
> problems.

Right, filesystem is still consistent.
And xfs_check/xfs_repair has no idea that filesystem may be mounted
without the inode64.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
