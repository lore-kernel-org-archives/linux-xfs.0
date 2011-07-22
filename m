Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MEPNrw088562 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 09:25:23 -0500
Received: from xmail.sgi.com (pv-excas3-dc21.corp.sgi.com [137.38.102.206])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B17BBAC005
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 07:25:19 -0700 (PDT)
Subject: Re: [PATCH] xfs: set cursor in xfs_ail_splice() even when AIL was
	empty
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <201107212205.p6LM5dxF016460@stout.americas.sgi.com>
References: <201107212205.p6LM5dxF016460@stout.americas.sgi.com>
Date: Fri, 22 Jul 2011 09:24:28 -0500
Message-ID: <1311344668.2771.13.camel@doink>
MIME-Version: 1.0
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

On Thu, 2011-07-21 at 17:05 -0500, Alex Elder wrote:
> In xfs_ail_splice(), if a cursor is provided it is updated
> to point to the last item on the list to be spliced into
> the AIL.  But if the AIL was found to be empty, the cursor
> (if provided) is just initialized instead.
> 
> There is no reason the null AIL case needs to be any different.
> And treating it the same way allows this code to be rearranged
> a bit, with a somewhat tidier result.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

I discovered a problem as I was thinking about this
last night.  I'll send an update shortly.

The problem is that my proposed xfs_ail_splice()
shouldn't update the cursor if an empty list is
passed, because the result won't produce a valid
item pointer.  An earlier edition of this patch
asserted no empty list would get passed, but that
fired fairly quickly.  Looking carefully at the
code as it stands now, an empty list will actually
do no harm, but that's just lucky, more or less.

And because the list_splice() after that ends up
being a no-op, there is really no point in
scanning the AIL to re-validate lip.  Therefore
we should just avoid calling xfs_ail_splice()
at all with an empty item list.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
