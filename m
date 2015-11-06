Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 588FA7F86
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 20:06:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4DE9AC004
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 18:06:47 -0800 (PST)
Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	by cuda.sgi.com with ESMTP id SzAZy3uQsjZxaK70 (version=TLSv1
	cipher=IDEA-CBC-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Nov 2015 18:06:44 -0800 (PST)
From: "Al Lau (alau2)" <alau2@cisco.com>
Subject: RE: mkfs.xfs -n size=65536
Date: Fri, 6 Nov 2015 02:06:42 +0000
Message-ID: <0da393a1fb794f73ba7ad4a74e0b6fc9@XCH-ALN-020.cisco.com>
References: <0F279340237AA148AD7E3C6A70561A5E01266BE7@xmb-rcd-x14.cisco.com>
	<20151013002308.GI27164@dastard>
	<8a1b26a3b869448e805485c529c447a4@XCH-ALN-020.cisco.com>
	<20151013033304.GL27164@dastard>
	<c88efb6bc4ad49779e965a7a67b2df57@XCH-ALN-020.cisco.com>
	<20151013043016.GE31326@dastard>
	<b391cb17b6714a479150f9681380e102@XCH-ALN-020.cisco.com>
	<20151013082548.GH31326@dastard>
In-Reply-To: <20151013082548.GH31326@dastard>
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

We run the systemtap script in the background.  The kmem_alloc message appeared in the /var/log/messages.  The call stack is captured by the systemtap is follow.

 0xffffffffa02a0030 : xfs_err+0x0/0x90 [xfs]
 0xffffffffa02a853d : kmem_alloc+0xbd/0xf0 [xfs]
 0xffffffffa02eeb6e : xfs_log_commit_cil+0x39e/0x4c0 [xfs]
 0xffffffffa02a7d3c : xfs_trans_commit+0x11c/0x240 [xfs]
 0xffffffffa02dd353 : xfs_remove+0x343/0x380 [xfs]
 0xffffffffa029d93a : xfs_vn_unlink+0x5a/0xc0 [xfs]
 0xffffffff811bde51
 0xffffffff811be056 (inexact)
 0xffffffff811b166e (inexact)
 0xffffffff810823cc (inexact)
 0xffffffff811c11b6 (inexact)
 0xffffffff815f3219 (inexact)

Nov  5 18:13:21 csx-ceph1-003 kernel: XFS: possible memory allocation deadlock in kmem_alloc (mode:0x8250)

#! /usr/bin/env stap

probe module("xfs").function("xfs_err").call
{
  print_backtrace();
}

# nohup stap -o /var/systemtap/kmem_alloc_bt.out backtrace.stp &

Redhat support case is https://access.redhat.com/support/cases/#/case/01500239

Thanks,
-Al
-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Tuesday, October 13, 2015 1:26 AM
To: Al Lau (alau2)
Cc: xfs@oss.sgi.com
Subject: Re: mkfs.xfs -n size=65536

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
> -rw-r--r--. 1 root root 3360239878657 Oct 13 07:25 fragmented # 
> filefrag fragmented
> fragmented: 385533 extents found

That's a lot of extents, but for a 3TB sparse file that is being written in random 4k blocks, that's expected and there's little you can do about it. Preallocation of the file or use of extent size hints will reduce physical fragmentation, but you only want to use those if the file will eventually become non-sparse and sequential read IO performance is required...

i.e. the definition of "fragmented" really depends on the application, IO patterns and whether the current physical layout is acheiving the desired performance attributes of the file in question....

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
