Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 72C357F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 03:26:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 600D2304098
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 01:26:10 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xCND4zXgEHSE9JBx for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2015 01:26:01 -0700 (PDT)
Date: Tue, 13 Oct 2015 19:25:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs -n size=65536
Message-ID: <20151013082548.GH31326@dastard>
References: <0F279340237AA148AD7E3C6A70561A5E01266BE7@xmb-rcd-x14.cisco.com>
	<20151013002308.GI27164@dastard>
	<8a1b26a3b869448e805485c529c447a4@XCH-ALN-020.cisco.com>
	<20151013033304.GL27164@dastard>
	<c88efb6bc4ad49779e965a7a67b2df57@XCH-ALN-020.cisco.com>
	<20151013043016.GE31326@dastard>
	<b391cb17b6714a479150f9681380e102@XCH-ALN-020.cisco.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b391cb17b6714a479150f9681380e102@XCH-ALN-020.cisco.com>
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
To: "Al Lau (alau2)" <alau2@cisco.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Oct 13, 2015 at 07:28:48AM +0000, Al Lau (alau2) wrote:
> Are the xfs_db and filefrag the utilities to use to determine file fragmentation?
> 
> # df -k /var/kmem_alloc
> Filesystem      1K-blocks       Used Available Use% Mounted on
> /dev/sdf1      3905109820 3359385616 545724204  87% /var/kmem_alloc
> # xfs_db -r -c frag /dev/sdf1 
> actual 438970, ideal 388168, fragmentation factor 11.57%

http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F

> # ls -l fragmented
> -rw-r--r--. 1 root root 3360239878657 Oct 13 07:25 fragmented
> # filefrag fragmented 
> fragmented: 385533 extents found

That's a lot of extents, but for a 3TB sparse file that is being
written in random 4k blocks, that's expected and there's little you
can do about it. Preallocation of the file or use of extent size
hints will reduce physical fragmentation, but you only want to use
those if the file will eventually become non-sparse and sequential
read IO performance is required...

i.e. the definition of "fragmented" really depends on the
application, IO patterns and whether the current physical layout is
acheiving the desired performance attributes of the file in
question....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
