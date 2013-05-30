Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 305C77F58
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 12:49:48 -0500 (CDT)
Date: Thu, 30 May 2013 12:49:47 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 5/9] xfs: fix split buffer vector log recovery support
Message-ID: <20130530174947.GD20932@sgi.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-6-git-send-email-david@fromorbit.com>
	<51A65550.50508@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A65550.50508@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, May 29, 2013 at 02:21:52PM -0500, Mark Tinguely wrote:
> On 05/27/13 01:38, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >A long time ago in a galaxy far away....
> >
> >.. the was a commit made to fix some ilinux specific "fragmented
> >buffer" log recovery problem:
> >
> >http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=b29c0bece51da72fb3ff3b61391a391ea54e1603
> >
> >That problem occurred when a contiguous dirty region of a buffer was
> >split across across two pages of an unmapped buffer. It's been a
> >long time since that has been done in XFS, and the changes to log
> >the entire inode buffers for CRC enabled filesystems has
> >re-introduced that corner case.
> >
> >And, of course, it turns out that the above commit didn't actually
> >fix anything - it just ensured that log recovery is guaranteed to
> >fail when this situation occurs. And now for the gory details.
> >
> ...
> 
> Thanks for the great walk through of the problem.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
