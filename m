Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0M6ZxfZ052596 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 00:36:00 -0600
In-Reply-To: <20090122062703.GA6873@infradead.org>
References: <1232578645-20213-1-git-send-email-felixb@sgi.com>
	<0AC805F5-C30E-4439-A32B-2625D7FBEDFD@sgi.com>
	<20090122062703.GA6873@infradead.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <B129F6F7-6A15-4CE3-AA84-7BC6637C4A25@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH] [XFS] Warn on transaction in flight on read-only remount
Date: Thu, 22 Jan 2009 00:34:46 -0600
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
Cc: xfs@oss.sgi.com


On Jan 22, 2009, at 12:27 AM, Christoph Hellwig wrote:

> On Thu, Jan 22, 2009 at 12:10:15AM -0600, Felix Blyakher wrote:
>> [resending after fixing xfs mailing list on oss]
>>
>> Just wanted to point out to discussion on this topic:
>>
>> http://oss.sgi.com/archives/xfs/2008-12/msg00019.html
>>
>> I merely took a suggestion from it, and put it in a patch.
>
> Did you actually test it?  WARN_ON has an inverted sense over
> ASSERT/ASSERT_ALWAYS, so this would trigger all the time.

Oops. Sure. Thanks for noticing it.

>
>>> +	/* Just warn here till VFS can correctly support
>>> +	 * read-only remount without racing.
>>> +	 */
>
> Also this should be:
>
> 	/*
> 	 * ...

Noted.

>
> I also have a VFS -level patch somewhere to prevent further writers to
> occur during a remount in a rather hacky way, but I'd rather have a
> testcase to reproduce this reliably before sending it to Al.

Sorry, I don't have a reproducible test case.
Just thought to prevent panic for now.

I'll repost the patch tomorrow.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
