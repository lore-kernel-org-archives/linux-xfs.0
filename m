Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B4DB07FA1
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 12:43:54 -0600 (CST)
Date: Thu, 7 Mar 2013 12:43:54 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: increase prealloc size to double that of the
	previous extent
Message-ID: <20130307184354.GO22182@sgi.com>
References: <1361231827-58766-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361231827-58766-1-git-send-email-bfoster@redhat.com>
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

On Mon, Feb 18, 2013 at 06:57:07PM -0500, Brian Foster wrote:
> The updated speculative preallocation algorithm becomes less
> effective in situations with a high number of concurrent,
> sequential writers. In running 32 sequential writers on a system
> with 32GB RAM, preallocs become fixed at a value of around 128MB.
> Update the heuristic to base the size of the prealloc on double
> the size of the preceding extent. This preserves the original
> aggressive speculative preallocation behavior at a slight cost of
> increasing the size of preallocated data regions following holes of
> sparse files.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Applied.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
