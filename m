Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LIeU1A169725 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 13:40:30 -0500
Received: from idcmail-mo1so.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA7844011E8
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:43:58 -0700 (PDT)
Received: from idcmail-mo1so.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by
	cuda.sgi.com with ESMTP id k4btV31KaW5k28Fb for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:43:58 -0700 (PDT)
Subject: Re: buffered writeback torture program
Mime-Version: 1.0 (Apple Message framework v1082)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1303410534-sup-6933@think>
Date: Thu, 21 Apr 2011 12:43:47 -0600
Message-Id: <004198D6-9941-4322-BDB1-8176B80262C7@dilger.ca>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
	<1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org>
	<93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
	<20110421180213.GA19255@infradead.org> <1303408883-sup-1495@think>
	<20110421180805.GA2627@infradead.org> <1303410534-sup-6933@think>
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
To: Chris Mason <chris.mason@oracle.com>
Cc: axboe <axboe@kernel.dk>, jack <jack@suse.cz>, xfs <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, dchinner <dchinner@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On 2011-04-21, at 12:29 PM, Chris Mason wrote:
> Excerpts from Christoph Hellwig's message of 2011-04-21 14:08:05 -0400:
>> On Thu, Apr 21, 2011 at 02:02:43PM -0400, Chris Mason wrote:
>>> For this program, they are almost all dirty pages.
>>> 
>>> I tried patching it to give up if we seek but it is still pretty slow.
>>> There's something else going on in addition to the xfs clustering being
>>> too aggressive.
>> 
>> I'm not sure where you this beeing to agressive from - it's doing
>> exactly the same amount of I/O as a filesystem writing out a single
>> page from ->writepage or using write_cache_pages (either directly
>> or as a copy) as ->writepages.  The only thing special compared to
>> the no ->writepages case is that it's submitting a large I/O
>> from the first ->writepage call.
> 
> Ok, I see what you mean.  The clustering code stops once it hits
> nr_to_write, I missed that.  So we shouldn't be doing more than a single
> writepages call.

I wonder if it makes sense to disentangle the two processes state in the kernel, by forking the fsync thread before any writes are done.  That would avoid penalizing the random writer in the VM/VFS, but means there needs to be some coordination between the threads (e.g. polling for a sentinel file written when the sequential phase is complete).

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
