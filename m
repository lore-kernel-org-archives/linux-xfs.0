Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0M6Rm92052006 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 00:27:48 -0600
Date: Thu, 22 Jan 2009 01:27:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [XFS] Warn on transaction in flight on read-only remount
Message-ID: <20090122062703.GA6873@infradead.org>
References: <1232578645-20213-1-git-send-email-felixb@sgi.com>
	<0AC805F5-C30E-4439-A32B-2625D7FBEDFD@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0AC805F5-C30E-4439-A32B-2625D7FBEDFD@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 22, 2009 at 12:10:15AM -0600, Felix Blyakher wrote:
> [resending after fixing xfs mailing list on oss]
>
> Just wanted to point out to discussion on this topic:
>
> http://oss.sgi.com/archives/xfs/2008-12/msg00019.html
>
> I merely took a suggestion from it, and put it in a patch.

Did you actually test it?  WARN_ON has an inverted sense over
ASSERT/ASSERT_ALWAYS, so this would trigger all the time.

>> +	/* Just warn here till VFS can correctly support
>> +	 * read-only remount without racing.
>> +	 */

Also this should be:

	/*
	 * ...

I also have a VFS -level patch somewhere to prevent further writers to
occur during a remount in a rather hacky way, but I'd rather have a
testcase to reproduce this reliably before sending it to Al.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
