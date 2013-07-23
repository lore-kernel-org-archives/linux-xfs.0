Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6EBA77F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:10:47 -0500 (CDT)
Date: Tue, 23 Jul 2013 14:10:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 05/48] xfsprogs: Support new AGFL format
Message-ID: <20130723191043.GK3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-6-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:28AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the addition of CRCs to the filesystem format, the AGFL has a
> new format structure definition. Existing code that pulls freelist
> blocks out via dereferencing agfl->agfl_bno no longer works as the
> location of the free list is now variable depending on the disk
> format in use.
> 
> Hence all the users of agfl_bno need ot be converted to extract the
> location of the first free list entry from the AGFL and grab entries
> relative to that first entry. It's a simple change, but needs to be
> made in several places as there is very little code reuse within and
> between the different utilities in xfsprogs.

Looks fine.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
