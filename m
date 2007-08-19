Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 12:10:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7JJAbbm007860
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 12:10:39 -0700
Message-ID: <46C895BB.2000004@sandeen.net>
Date: Sun, 19 Aug 2007 14:10:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] optimize XFS_IS_REALTIME_INODE w/o realtime config
References: <46C7627A.60503@sandeen.net> <20070819190847.GB2929@infradead.org>
In-Reply-To: <20070819190847.GB2929@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Sat, Aug 18, 2007 at 04:19:54PM -0500, Eric Sandeen wrote:
>> Use XFS_IS_REALTIME_INODE in more places, and #define it to
>> 0 if CONFIG_XFS_RT is off.  This should be safe because mount
>> checks in xfs_rtmount_init:
>>
>> # define xfs_rtmount_init(m)    (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
>>
>> so if we get mounted w/o CONFIG_XFS_RT, no realtime inodes should
>> be encountered after that.
>>
>> Defining XFS_IS_REALTIME_INODE to 0 saves a bit of stack space,
>> presumeably gcc can optimize around the various "if (0)" type
>> checks:
> 
> Looks good to me.
> 
> Not sure if anyone disables the rt volume, but as long as it's a config
> option we should try to avoid as much as possible away if it's not enabled.
> 

Fedora does :)

-Eric
