Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6DE7F7CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 06:40:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34D1130404E
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 04:40:09 -0700 (PDT)
Received: from mail-qg0-f45.google.com (mail-qg0-f45.google.com
	[209.85.192.45]) by cuda.sgi.com with ESMTP id 7emio6p382t7r6Go
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 04:40:06 -0700 (PDT)
Received: by mail-qg0-f45.google.com with SMTP id j35so62291231qge.0
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 04:40:06 -0700 (PDT)
Subject: Re: fallocate mode flag for "unshare blocks"?
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331003242.GA5813@localhost.localdomain>
	<56FD079F.3060606@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56FD0C49.7040308@gmail.com>
Date: Thu, 31 Mar 2016 07:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <56FD079F.3060606@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: bo.li.liu@oracle.com
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On 2016-03-31 07:18, Austin S. Hemmelgarn wrote:
> On 2016-03-30 20:32, Liu Bo wrote:
>> On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
>>> Hi all,
>>>
>>> Christoph and I have been working on adding reflink and CoW support to
>>> XFS recently.  Since the purpose of (mode 0) fallocate is to make sure
>>> that future file writes cannot ENOSPC, I extended the XFS fallocate
>>> handler to unshare any shared blocks via the copy on write mechanism I
>>> built for it.  However, Christoph shared the following concerns with
>>> me about that interpretation:
>>>
>>>> I know that I suggested unsharing blocks on fallocate, but it turns out
>>>> this is causing problems.  Applications expect falloc to be a fast
>>>> metadata operation, and copying a potentially large number of blocks
>>>> is against that expextation.  This is especially bad for the NFS
>>>> server, which should not be blocked for a long time in a synchronous
>>>> operation.
>>>>
>>>> I think we'll have to remove the unshare and just fail the fallocate
>>>> for a reflinked region for now.  I still think it makes sense to expose
>>>> an unshare operation, and we probably should make that another
>>>> fallocate mode.
>>
>> I'm expecting fallocate to be fast, too.
>>
>> Well, btrfs fallocate doesn't allocate space if it's a shared one
>> because it thinks the space is already allocated.  So a later overwrite
>> over this shared extent may hit enospc errors.
> And this _really_ should get fixed, otherwise glibc will add a check for
> running posix_fallocate against BTRFS and force emulation, and people
> _will_ complain about performance.
>
Thinking a bit further about this, how hard would it be to add the 
ability to have unwritten extents point somewhere else for reads?  Then 
when we get an fallocate call, we create the unwritten extents, and add 
the metadata to make them read from the shared region.  Then, when a 
write gets issued to that extent, the parts that aren't being written in 
that block get copied, the write happens, and then the link for that 
block gets removed.  This way, fallocate would still provide the correct 
semantics, it would be relatively fast (still not quite as fast as it is 
now, but it wouldn't be anywhere near as slow as copying the data), and 
the cost of copying gets amortized across writes (we may not need to 
copy everything, but we'll still copy less than we would for just 
un-sharing the extent).  This would of course need to be an incompat 
feature, but I would personally say that's not as much of an issue, as 
things are subtly broken in the common use-case right now (at this point 
I'm just thinking BTRFS, as what Darrick suggested for XFS seems to be a 
better solution there at least short term).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
