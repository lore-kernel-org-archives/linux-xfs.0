Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D5CB7CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 10:43:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D173EAC001
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 08:43:30 -0700 (PDT)
Received: from mail-qg0-f51.google.com (mail-qg0-f51.google.com
	[209.85.192.51]) by cuda.sgi.com with ESMTP id 9bMMTWvUMjf8kgPT
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 08:43:28 -0700 (PDT)
Received: by mail-qg0-f51.google.com with SMTP id j35so68022418qge.0
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 08:43:28 -0700 (PDT)
Subject: Re: fallocate mode flag for "unshare blocks"?
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331003242.GA5813@localhost.localdomain>
	<20160331075529.GB4209@infradead.org>
	<3E147309-67EA-4B29-B4E0-883BA03B7BFC@dilger.ca>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56FD458D.3020007@gmail.com>
Date: Thu, 31 Mar 2016 11:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <3E147309-67EA-4B29-B4E0-883BA03B7BFC@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Liu Bo <bo.li.liu@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On 2016-03-31 11:31, Andreas Dilger wrote:
> On Mar 31, 2016, at 1:55 AM, Christoph Hellwig <hch@infradead.org> wrote:
>>
>> On Wed, Mar 30, 2016 at 05:32:42PM -0700, Liu Bo wrote:
>>> Well, btrfs fallocate doesn't allocate space if it's a shared one
>>> because it thinks the space is already allocated.  So a later overwrite
>>> over this shared extent may hit enospc errors.
>>
>> And this makes it an incorrect implementation of posix_fallocate,
>> which glibcs implements using fallocate if available.
>
> It isn't really useful for a COW filesystem to implement fallocate()
> to reserve blocks.  Even if it did allocate all of the blocks on the
> initial fallocate() call, when it comes time to overwrite these blocks
> new blocks need to be allocated as the old ones will not be overwritten.
>
> Because of snapshots that could hold references to the old blocks,
> there isn't even the guarantee that the previous fallocated blocks will
> be released in a reasonable time to free up an equal amount of space.

That really depends on how it's done.  AFAIK, unwritten extents on BTRFS 
are block reservations which make sure that you can write there (IOW, 
the unwritten extent gets converted to a regular extent in-place, not 
via COW).  This means that it is possible to guarantee that the first 
write to that area will work, which is technically all that POSIX 
requires.  This in turn means that stuff like SystemD and RDBMS software 
don't exactly see things working as they expect them too, but that's 
because they make assumptions based on existing technology.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
