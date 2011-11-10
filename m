Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAA8VGX2060461 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 02:31:16 -0600
Date: Thu, 10 Nov 2011 03:31:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: handle Ctrl-D during prompts
Message-ID: <20111110083113.GA10573@infradead.org>
References: <1320876946-27643-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320876946-27643-1-git-send-email-wkendall@sgi.com>
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

On Wed, Nov 09, 2011 at 04:15:46PM -0600, Bill Kendall wrote:
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
> This patch changes xfsdump to treat Ctrl-D as if the user hit
> enter. User input (if any) will be passed back to the caller,
> and a new line will be echoed to the terminal.

Shouldn't Ctrl+D cause us to ignore the input that was added
before?  That's what I would expect from command line applications.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
