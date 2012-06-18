Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5IKaTtN236119 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 15:36:29 -0500
Received: from smtp-out-04.shaw.ca (smtp-out-04.shaw.ca [64.59.134.12]) by
	cuda.sgi.com with ESMTP id masObQRJjZokoQwh for
	<xfs@oss.sgi.com>; Mon, 18 Jun 2012 13:36:28 -0700 (PDT)
Subject: Re: XFS status update for May 2012
Mime-Version: 1.0 (Apple Message framework v1084)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20120618184344.GV4721@sgi.com>
Date: Mon, 18 Jun 2012 14:36:27 -0600
Message-Id: <1005E3D5-D9F4-42F9-8BAE-9FB40A8AFA57@dilger.ca>
References: <20120618120853.GA15480@infradead.org>
	<AD997E9D-2C1E-4EE4-80D7-2A5C998B6E9E@dilger.ca>
	<20120618184344.GV4721@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>, LKML List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 2012-06-18, at 12:43 PM, Ben Myers wrote:
> On Mon, Jun 18, 2012 at 12:25:37PM -0600, Andreas Dilger wrote:
>> On 2012-06-18, at 6:08 AM, Christoph Hellwig wrote:
>>> May saw the release of Linux 3.4, including a decent sized XFS update.
>>> Remarkable XFS features in Linux 3.4 include moving over all metadata
>>> updates to use transactions, the addition of a work queue for the
>>> low-level allocator code to avoid stack overflows due to extreme stack
>>> use in the Linux VM/VFS call chain,
>> 
>> This is essentially a workaround for too-small stacks in the kernel,
>> which we've had to do at times as well, by doing work in a separate
>> thread (with a new stack) and waiting for the results?  This is a
>> generic problem that any reasonably-complex filesystem will have when
>> running under memory pressure on a complex storage stack (e.g. LVM +
>> iSCSI), but causes unnecessary context switching.
>> 
>> Any thoughts on a better way to handle this, or will there continue
>> to be a 4kB stack limit and hack around this with repeated kmalloc
>> on callpaths for any struct over a few tens of bytes, implementing
>> memory pools all over the place, and "forking" over to other threads
>> to continue the stack consumption for another 4kB to work around
>> the small stack limit?
> 
> FWIW, I think your characterization of the problem as a 'workaround for
> too-small stacks in the kernel' is about right.  I don't think any of
> the XFS folk were very happy about having to do this, but in the near
> term it doesn't seem that we have a good alternative.  I'm glad to see
> that there are others with the same pain, so maybe we can build some
> support for upping the stack limit.

Is this problem mostly hit in XFS with dedicated service threads like
kNFSd and similar, or is it a problem with any user thread perhaps
entering the filesystem for memory reclaim inside an already-deep
stack?

For dedicated service threads I was wondering about allocating larger
stacks for just those processes (16kB would be safe), and then doing
something special at thread startup to use this larger stack.  If
the problem is for any potential thread, then the solution would be
much more complex in all likelihood.

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
