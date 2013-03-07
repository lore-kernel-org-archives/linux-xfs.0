Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CBF67FA1
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 12:45:05 -0600 (CST)
Date: Thu, 7 Mar 2013 12:45:04 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: increase prealloc size to double that of the
	previous extent
Message-ID: <20130307184504.GP22182@sgi.com>
References: <1361287481-9649-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361287481-9649-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 19, 2013 at 10:24:41AM -0500, Brian Foster wrote:
> The updated speculative preallocation algorithm for handling sparse
> files can becomes less effective in situations with a high number of
> concurrent, sequential writers. The number of writers and amount of
> available RAM affect the writeback bandwidth slicing algorithm,
> which in turn affects the block allocation pattern of XFS. For
> example, running 32 sequential writers on a system with 32GB RAM,
> preallocs become fixed at a value of around 128MB (instead of
> steadily increasing to the 8GB maximum as sequential writes
> proceed).
> 
> Update the speculative prealloc heuristic to base the size of the
> next prealloc on double the size of the preceding extent. This
> preserves the original aggressive speculative preallocation
> behavior and continues to accomodate sparse files at a slight cost
> of increasing the size of preallocated data regions following holes
> of sparse files.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Excuse me.  This is the version I applied.  Not v1.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
