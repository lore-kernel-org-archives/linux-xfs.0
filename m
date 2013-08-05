Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A85C87CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 17:25:36 -0500 (CDT)
Date: Mon, 5 Aug 2013 17:25:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 11/12] xfs: rework remote attr CRCs
Message-ID: <20130805222532.GH3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370607901-11538-12-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:00PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Note: this changes the on-disk remote attribute format. I assert
> that this is OK to do as CRCs are marked experimental and the first
> kernel it is included in has not yet reached release yet. Further,
> the userspace utilities are still evolving and so anyone using this
> stuff right now is a developer or tester using volatile filesystems
> for testing this feature. Hence changing the format right now to
> save longer term pain is the right thing to do.
> 
> The fundamental change is to move from a header per extent in the
> attribute to a header per filesytem block in the attribute. This
> means there are more header blocks and the parsing of the attribute
> data is slightly more complex, but it has the advantage that we
> always know the size of the attribute on disk based on the length of
> the data it contains.
> 
> This is where the header-per-extent method has problems. We don't
> know the size of the attribute on disk without first knowing how
> many extents are used to hold it. And we can't tell from a
> mapping lookup, either, because remote attributes can be allocated
> contiguously with other attribute blocks and so there is no obvious
> way of determining the actual size of the atribute on disk short of
> walking and mapping buffers.
> 
> The problem with this approach is that if we map a buffer
> incorrectly (e.g. we make the last buffer for the attribute data too
> long), we then get buffer cache lookup failure when we map it
> correctly. i.e. we get a size mismatch on lookup. This is not
> necessarily fatal, but it's a cache coherency problem that can lead
> to returning the wrong data to userspace or writing the wrong data
> to disk. And debug kernels will assert fail if this occurs.
> 
> I found lots of niggly little problems trying to fix this issue on a
> 4k block size filesystem, finally getting it to pass with lots of
> fixes. The thing is, 1024 byte filesystems still failed, and it was
> getting really complex handling all the corner cases that were
> showing up. And there were clearly more that I hadn't found yet.
> 
> It is complex, fragile code, and if we don't fix it now, it will be
> complex, fragile code forever more.
> 
> Hence the simple fix is to add a header to each filesystem block.
> This gives us the same relationship between the attribute data
> length and the number of blocks on disk as we have without CRCs -
> it's a linear mapping and doesn't require us to guess anything. It
> is simple to implement, too - the remote block count calculated at
> lookup time can be used by the remote attribute set/get/remove code
> without modification for both CRC and non-CRC filesystems. The world
> becomes sane again.
> 
> Because the copy-in and copy-out now need to iterate over each
> filesystem block, I moved them into helper functions so we separate
> the block mapping and buffer manupulations from the attribute data
> and CRC header manipulations. The code becomes much clearer as a
> result, and it is a lot easier to understand and debug. It also
> appears to be much more robust - once it worked on 4k block size
> filesystems, it has worked without failure on 1k block size
> filesystems, too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Goes with commit ad1858d77771172e08016890f0eb2faedec3ecee

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
