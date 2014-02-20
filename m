Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 723E47F3F
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 13:12:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 56F9630408C
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 11:12:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id iEkAkiUvCReA1U2K for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 11:12:47 -0800 (PST)
Message-ID: <530653AE.9070705@sandeen.net>
Date: Thu, 20 Feb 2014 13:12:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: fix sibling pointer tests in
	verify_dir2_path()
References: <53051DB5.4080403@redhat.com>
	<20140220154122.GC26146@infradead.org>
In-Reply-To: <20140220154122.GC26146@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 2/20/14, 9:41 AM, Christoph Hellwig wrote:
> On Wed, Feb 19, 2014 at 03:10:13PM -0600, Eric Sandeen wrote:
>> RH QE reported that if we create a 1G filesystem with default
>> options, mount it, and create inodes until full, then run
>> repair, repair reports corruption in verify_dir2_path() with:
>>
>>> bad back pointer in block 8390324 for directory inode 131
> 
> Can you please wire this up for xfstests?

was working on it, but am hitting something weird, we never
hit ENOSPC when we hit maxicount; we keep creating inodes
but stop incrementing sb counters.  Urk.   (something in lazy
sb code...)

-Eric

>>
>> The commit 88b32f0 xfs: add CRCs to dir2/da node blocks
>> had a small error which regressed this; although we switch
>> to the "newnode," to check sibling pointers, we re-populate
>> the node hdr with the old "node" data.  This causes the
>> backpointer test to be testing the wrong node's values.
>>
>> Fixing this bug fixes the testcase.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
