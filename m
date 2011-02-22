Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1MLcr6E261266 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 15:38:53 -0600
Subject: Re: [PATCH] xfs_repair: validate inode di_flaaags field
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1298407556.1960.54.camel@doink>
References: <1298407419.1960.48.camel@doink> <1298407556.1960.54.camel@doink>
Date: Tue, 22 Feb 2011 15:39:05 -0600
Message-ID: <1298410745.1960.73.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com
Cc: Dave Chinner <dchinner@redhat.com>

On Tue, 2011-02-22 at 14:45 -0600, Alex Elder wrote:
> On Tue, 2011-02-22 at 14:43 -0600, Alex Elder wrote:
> > (I may have missed it, but I don't believe Dave posted
> > this patch so I'm doing it for him to get it on the
> > list.  -Alex)
> > 
> > xfs-reapir is not validating the di_flags field in the inode for
> > sanity. Block fuzzing indicates that we are not picking situations
> > like the RT bit being set on filesystems without realtime devices.
> >     
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>

Turns out this was on the list, it just was sent as a
"will you please try this patch" message on the subject
of "XFS internal error xfs_iformat(realtime) even after
xfs_repair."


Anyway, now I've reviewed it, and it looks good.  The
typo's in the subject line and in the description ought
to be fixed before it's committed.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
