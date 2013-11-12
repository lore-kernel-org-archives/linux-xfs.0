Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 44DEF29E04
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 12:32:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 313D430405F
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 10:32:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SRHrOxmGlldH30E2 for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 10:32:34 -0800 (PST)
Message-ID: <52827440.9060603@sandeen.net>
Date: Tue, 12 Nov 2013 12:32:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfststs: add a helper to get the minimum dio size
References: <20131106105932.GA7807@infradead.org>
	<52826FBC.4000003@sandeen.net>
	<20131112183031.GA8106@infradead.org>
In-Reply-To: <20131112183031.GA8106@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 11/12/13, 12:30 PM, Christoph Hellwig wrote:
> On Tue, Nov 12, 2013 at 12:13:16PM -0600, Eric Sandeen wrote:
>> On 11/6/13, 4:59 AM, Christoph Hellwig wrote:
>>> Various tests opencode checks to find out the minimum support direct I/O
>>> size.  Replace those with a generic helper that handles network filesystems as
>>> well.  Also remove the Linux 2.4 workaround we had in once place.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> No callers of min_dio_alignment w/o a blockdev right?  But I guess
>> that fallback is harmless.
> 
> All network filesystems will not have a device here.  Not sure how the
> btrfs pool names work, but that would be another suspect.
> 

Ah, sure.  So when running on NFS the blkdev is unset.  Wasn't thinking
about it that way, thanks.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
