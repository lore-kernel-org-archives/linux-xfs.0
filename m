Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5FBDB7CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 11:47:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8C74AC001
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 09:47:54 -0700 (PDT)
Received: from mail-lb0-f196.google.com (mail-lb0-f196.google.com
	[209.85.217.196]) by cuda.sgi.com with ESMTP id
	VL9HQ0IcHZ3IojKG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 09:47:52 -0700 (PDT)
Received: by mail-lb0-f196.google.com with SMTP id q4so7407719lbq.3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 09:47:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3E147309-67EA-4B29-B4E0-883BA03B7BFC@dilger.ca>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331003242.GA5813@localhost.localdomain>
	<20160331075529.GB4209@infradead.org>
	<3E147309-67EA-4B29-B4E0-883BA03B7BFC@dilger.ca>
Date: Thu, 31 Mar 2016 18:47:50 +0200
Message-ID: <CAPmG0jZEM0a7J1=LZMQ-Y6oM0BgB04uDKdb7MZgNso4QAt=mPA@mail.gmail.com>
Subject: Re: fallocate mode flag for "unshare blocks"?
From: Henk Slager <eye1tm@gmail.com>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Liu Bo <bo.li.liu@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Thu, Mar 31, 2016 at 5:31 PM, Andreas Dilger <adilger@dilger.ca> wrote:
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

There are also use-cases on BTRFS with CoW disabled, like operations
on virtual machine images that aren't snapshotted.
Those files tend to be big and having fallocate() implemented and
working like for e.g. XFS, in order to achieve space and speed
efficiency, makes sense IMHO.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
