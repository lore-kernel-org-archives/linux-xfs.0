Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D0BA37F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:34:55 -0500 (CDT)
Date: Thu, 25 Jul 2013 15:34:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 17/48] xfs: add CRC protection to remote attributes
Message-ID: <20130725203454.GE3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-18-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-18-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:40AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are two ways of doing this - the first is to add a CRC to the
> remote attribute entry in the attribute block. The second is to
> treat them similar to the remote symlink, where each fragment has
> it's own header and identifies fragment location in the attribute.
> 
> The problem with the CRC in the remote attr entry is that we cannot
> identify the owner of the metadata from the metadata blocks
> themselves, or where the blocks fit into the remote attribute. The
> down side to this approach is that we never know when the attribute
> has been read from disk or not and so we have to verify it every
> time it is read, and we must calculate it during the create
> transaction and log it. We do not log CRCs for any other metadata,
> and so this creates a unique set of coherency problems that, in
> general, are best avoided.
> 
> Adding an identifying header to each allocated block allows us to
> identify each fragment and where in the attribute it is located. It
> enables us to rebuild the remote attribute from just the raw blocks
> containing the attribute. It also provides us to do per-block CRCs
> verification at IO time rather than during the transaction context
> that creates it or every time it is read into a user buffer. Hence
> it avoids all the problems that an external, logged CRC has, and
> provides all the benefits of self identifying metadata.
> 
> The only complexity is that we have to add a header per fragment,
> and we don't know how many fragments will be needed prior to
> allocations. If we take the symlink example, the header is 56 bytes
> and hence for a 4k block size filesystem, in the worst case 16
> headers requires 1 extra block for the 64k attribute data. For 512
> byte filesystems the worst case is an extra block for every 9
> fragments (i.e. 16 extra blocks in the worse case). This will be
> very rare and so it's not really a major concern.
> 
> Because allocation is done in two steps - the first finds a hole
> large enough in the attribute file, the second does the allocation -
> we only need to find a hole big enough for a worst case allocation.
> We only need to allocate enough extra blocks for number of headers
> required by the fragments, and we can calculate that as we go....
> 
> Hence it really only makes sense to use the same model as for
> symlinks - it doesn't add that much complexity, does not require an
> attribute tree format change, and does not require logging
> calculated CRC values.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Corresponds to commit d2e448d5fde

I see the rework of the remote attribute code later in the series...

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
