Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o65NW2X0146797 for <xfs@oss.sgi.com>; Mon, 5 Jul 2010 18:32:03 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4DEE1B241A0
	for <xfs@oss.sgi.com>; Mon,  5 Jul 2010 16:34:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	RAo1YjWc0MVsY2wp for <xfs@oss.sgi.com>;
	Mon, 05 Jul 2010 16:34:51 -0700 (PDT)
Date: Tue, 6 Jul 2010 09:34:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Slow delete
Message-ID: <20100705233448.GB24712@dastard>
References: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
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
To: Andrei Deftu <andreideftu@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 05, 2010 at 05:27:44PM +0300, Andrei Deftu wrote:
> Hi,
> 
> As many people have pointed out, xfs is very slow when deleting a
> large number of files. Does anyone has a technical answer to this
> problem? Also, I am interested to know if there is a way to
> temporarily speed up the delete process, regardless of all the other
> parameters.

The technical reason is to do with the architecture of the
transaction and logging subsystem of XFS. The key concept: relogging
of dirty objects. The reason it affects unlinks: removing files
from the same directory modifies the same objects repeatedly (e.g.
the directory btree blocks).

For a detailed explanation of the concept and how delayed logging
takes advantage of it to speed up stuff like deleting a large number
of files, see:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/filesystems/xfs-delayed-logging-design.txt

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
