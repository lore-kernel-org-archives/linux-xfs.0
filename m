Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B052D7F3F
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 16:52:04 -0600 (CST)
Date: Thu, 5 Dec 2013 16:52:04 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/2] xfs free the list of recovery items on error.
Message-ID: <20131205225204.GQ1935@sgi.com>
References: <20131002125110.745269864@sgi.com>
	<20131002125409.930462395@sgi.com> <20131204205105.GV1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131204205105.GV1935@sgi.com>
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

On Wed, Dec 04, 2013 at 02:51:05PM -0600, Ben Myers wrote:
> On Wed, Oct 02, 2013 at 07:51:12AM -0500, Mark Tinguely wrote:
> > Recovery builds a list of items on the transaction's
> > r_itemq head. Normally these items are committed and freed.
> > But in the event of a recovery error, these allocations
> > are leaked.
> > 
> > If the error occurs during item reordering, then reconstruct
> > the r_itemq list before deleting the list to avoid leaking
> > the entries that were on one of the temporary lists.
> > 
> > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> 
> Looks good to me.
> Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
