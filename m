Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p71K4qvH024300 for <xfs@oss.sgi.com>; Mon, 1 Aug 2011 15:04:52 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 789CE1EF3916
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2011 13:04:51 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id 47ah6HnMmBOkPvhL for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2011 13:04:51 -0700 (PDT)
Message-ID: <4E3706D0.1000304@oracle.com>
Date: Mon, 01 Aug 2011 15:04:32 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] jfs: flush journal completely before releasing metadata
	inodes
References: <20110729155039.GA28306@infradead.org>
	<4E32D9EB.9020406@oracle.com> <4E36F086.4070900@oracle.com>
	<20110801183255.GA30985@infradead.org>
In-Reply-To: <20110801183255.GA30985@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: jfs-discussion@lists.sourceforge.net, xfs@oss.sgi.com



On 08/01/2011 01:32 PM, Christoph Hellwig wrote:
> On Mon, Aug 01, 2011 at 01:29:26PM -0500, Dave Kleikamp wrote:
>> On 07/29/2011 11:03 AM, Dave Kleikamp wrote:

>> This fixes a race during unmount. We need to not only make sure that
>> the journal is completely written, but that the metadata changes make
>> it to disk before releasing ipimap and ipbmap.
> 
> Looks sensible.  How far does a ./check -g auto get now?  Any other
> failures?

It runs through them all. A lot of tests get skipped claiming not to be
supported on jfs. A failure because jfs doesn't support fallocate and
hole-punch, but no crashes.

Shaggy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
