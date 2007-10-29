Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 08:51:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9TFp01S011849
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 08:51:04 -0700
Message-ID: <47260168.3000003@sandeen.net>
Date: Mon, 29 Oct 2007 10:51:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Default mount options (that suck less).
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725FBB4.1010400@sandeen.net> <20071029154456.GA25142@puku.stupidest.org>
In-Reply-To: <20071029154456.GA25142@puku.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

Chris Wedgwood wrote:
> On Mon, Oct 29, 2007 at 10:26:44AM -0500, Eric Sandeen wrote:
> 
>> What would you think of a mkfs conf file like e2fsprogs has, which
>> defines filesystem classes, and defaults for each?  (small, news,
>> largefile, etc...)
> 
> That makes more sense for ext2/3 where some meta-data isn't
> dynamically allocated as needed, for example, historically nntp
> servers used one file per article and would often run out of inodes.

well, anything that is fixed at mkfs time could use this... inode size,
ag count, etc.  If there are common use cases which would want different
mkfs-fixed defaults, it might make sense.

-Eric
