Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 75F1D7F47
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 02:29:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65AD0304059
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 00:29:04 -0700 (PDT)
Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	by cuda.sgi.com with ESMTP id ysgrhnfw8x838f31 (version=TLSv1
	cipher=IDEA-CBC-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2015 00:29:02 -0700 (PDT)
From: "Al Lau (alau2)" <alau2@cisco.com>
Subject: RE: mkfs.xfs -n size=65536
Date: Tue, 13 Oct 2015 07:28:48 +0000
Message-ID: <b391cb17b6714a479150f9681380e102@XCH-ALN-020.cisco.com>
References: <0F279340237AA148AD7E3C6A70561A5E01266BE7@xmb-rcd-x14.cisco.com>
	<20151013002308.GI27164@dastard>
	<8a1b26a3b869448e805485c529c447a4@XCH-ALN-020.cisco.com>
	<20151013033304.GL27164@dastard>
	<c88efb6bc4ad49779e965a7a67b2df57@XCH-ALN-020.cisco.com>
	<20151013043016.GE31326@dastard>
In-Reply-To: <20151013043016.GE31326@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Are the xfs_db and filefrag the utilities to use to determine file fragmentation?

# df -k /var/kmem_alloc
Filesystem      1K-blocks       Used Available Use% Mounted on
/dev/sdf1      3905109820 3359385616 545724204  87% /var/kmem_alloc
# xfs_db -r -c frag /dev/sdf1 
actual 438970, ideal 388168, fragmentation factor 11.57%

# ls -l fragmented
-rw-r--r--. 1 root root 3360239878657 Oct 13 07:25 fragmented
# filefrag fragmented 
fragmented: 385533 extents found

Thanks,
-Al
-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Monday, October 12, 2015 9:30 PM
To: Al Lau (alau2)
Cc: xfs@oss.sgi.com
Subject: Re: mkfs.xfs -n size=65536

On Tue, Oct 13, 2015 at 03:55:26AM +0000, Al Lau (alau2) wrote:
> To remedy the fragmented files in our production systems, can I run 
> the xfs_fsr utility to de-fragment the files?

Well, first you need to determine that the files are fragmented and that it is affecting performance....

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
