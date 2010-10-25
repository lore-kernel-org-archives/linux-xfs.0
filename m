Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PG9c8h245593 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 11:09:39 -0500
Date: Mon, 25 Oct 2010 11:10:52 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: XFS journaling position
Message-ID: <20101025161052.GC19425@sgi.com>
References: <31c7e56286d37870011c17ee8e002760.squirrel@webmail.ics.forth.gr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <31c7e56286d37870011c17ee8e002760.squirrel@webmail.ics.forth.gr>
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
To: klonatos@ics.forth.gr
Cc: xfs@oss.sgi.com

On Mon, Oct 25, 2010 at 08:26:04AM +0300, klonatos@ics.forth.gr wrote:
|      I have recently discovered that the default journalling position of
| XFS is in the "middle" AG, if the log is internal (e.g. for 32 AGs
| the journal will be placed at the AG = 16). Although I am aware that
| there is possible to explicitly specify a journal location using the
| -l agnum=X mkfs option, I am really curious about the resoning behind
| the default choice.

I haven't found any documentation to support this, but I have been told
that the middle was selected for the single disk case to minimize seek
times.  The distance the head must travel to or from other locations on
the disk is optimized by placing the log in the middle of the disk.


-- 
Geoffrey Wehrman
SGI Building 10                             Office: (651)683-5496
2750 Blue Water Road                           Fax: (651)683-5098
Eagan, MN 55121                             E-mail: gwehrman@sgi.com
	  http://www.sgi.com/products/storage/software/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
