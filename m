Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17KqhFJ002040 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 14:52:43 -0600
Message-ID: <4F318F17.4010504@sgi.com>
Date: Tue, 07 Feb 2012 14:52:39 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: use the full 32-bit generation number
References: <1325880565-20934-1-git-send-email-wkendall@sgi.com>
	<20120205133648.GA27225@infradead.org> <4F301079.9010505@sgi.com>
	<20120206174140.GA10315@infradead.org>
In-Reply-To: <20120206174140.GA10315@infradead.org>
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
> On Mon, Feb 06, 2012 at 11:40:09AM -0600, Bill Kendall wrote:
>> You were referring to an xfsdump option. What use case did you
>> have in mind? Compatibility with an old restore?
>
> Yes.

Ok, I can see the value in that if a filesystem is being moved
to another system which has an older xfsrestore.

I'll repost with that change as well as with an option for
xfsrestore to truncate all generation numbers down to 12-bits
as mentioned in my last mail.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
