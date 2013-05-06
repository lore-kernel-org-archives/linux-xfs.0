Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6264429DF8
	for <linux-xfs@oss.sgi.com>; Mon,  6 May 2013 07:28:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4B9FAC004
	for <linux-xfs@oss.sgi.com>; Mon,  6 May 2013 05:28:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	IUbs7Zp1lCxl4BKU for <linux-xfs@oss.sgi.com>;
	Mon, 06 May 2013 05:28:47 -0700 (PDT)
Date: Mon, 6 May 2013 22:28:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.0: general protection fault
Message-ID: <20130506122844.GL19978@dastard>
References: <kltu6o$33j$1@ger.gmane.org>
 <km7oop$28c$1@ger.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <km7oop$28c$1@ger.gmane.org>
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-xfs@oss.sgi.com

On Mon, May 06, 2013 at 10:14:22AM +0200, Bernd Schubert wrote:
> And anpther protection fault, this time with 3.9.0. Always happens
> on one of the servers. Its ECC memory, so I don't suspect a faulty
> memory bank. Going to fsck now-

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> 
> >[303340.514052] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> >[303340.517913] Modules linked in: fhgfs(O) fhgfs_client_opentk(O)

Kernel tainted with out of tree modules. Can you reproduce the
problem with them?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
