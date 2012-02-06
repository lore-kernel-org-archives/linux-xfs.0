Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16HeDd8152855 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 11:40:13 -0600
Message-ID: <4F301079.9010505@sgi.com>
Date: Mon, 06 Feb 2012 11:40:09 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: use the full 32-bit generation number
References: <1325880565-20934-1-git-send-email-wkendall@sgi.com>
	<20120205133648.GA27225@infradead.org>
In-Reply-To: <20120205133648.GA27225@infradead.org>
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

Christoph Hellwig wrote:
> On Fri, Jan 06, 2012 at 02:09:25PM -0600, Bill Kendall wrote:
>> dump format version has been bumped to 3. xfsdump also required changes to
>> its inode-to-generation cache. This map is not persistent though, so no
>> compatibility or version changes were required there.
> 
> Shouldn't the be an option to still generate the old format for
> compatibility reasons?

The new format contains more information than the old. The new
xfsrestore can drop back to using 12-bit generation numbers even
if the dump used 32 bits. It will do this automatically when
applying a series of restores if the oldest dump used only 12 bits.

It's possible that a site would revert to an old xfsdump in the
middle of a series of incremental backups, allowing for the oldest
backup to use 32-bit generation numbers and a newer backup to use
only 12 bits. xfsrestore won't get this right, so a case could be
made for having a "force 12-bit generation numbers" option on
xfsrestore.

You were referring to an xfsdump option. What use case did you
have in mind? Compatibility with an old restore?

Thanks,
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
