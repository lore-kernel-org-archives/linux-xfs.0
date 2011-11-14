Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEAU0SL204971 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 04:30:00 -0600
Date: Mon, 14 Nov 2011 05:29:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfsdump: handle Ctrl-D during prompts
Message-ID: <20111114102958.GC31043@infradead.org>
References: <1320951342-15477-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320951342-15477-1-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 10, 2011 at 12:55:42PM -0600, Bill Kendall wrote:
> xfsdump does not currently handle Ctrl-D well during a dialog
> prompt. If some text is entered followed by Ctrl-D, an assert
> will trip because xfsdump expects a new-line character at the
> end of the user's input (or if asserts are disabled, the last
> character the user entered will be dropped).
> 
> If Ctrl-D is entered without entering any response, some dialog
> callers (e.g., tree_subtree_inter()) will abort because they
> receive an unexpected response code.
> 
> This patch changes xfsdump to behave like other interactive
> commands (xfs_db, bash, parted, ...) with respect to Ctrl-D.
> If Ctrl-D precedes any input, an empty string is returned.
> If Ctrl-D follows some input, it is ignored and xfsdump will
> continue to wait for more input.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good, I'll put this in during the next round of userspace updates.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
