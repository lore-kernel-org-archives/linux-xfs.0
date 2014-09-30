Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 621BD7FD1
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 21:39:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F0E04AC008
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 19:39:32 -0700 (PDT)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
	cuda.sgi.com with ESMTP id OAfEgEuaqhFaOMeW for
	<xfs@oss.sgi.com>; Mon, 29 Sep 2014 19:39:31 -0700 (PDT)
From: "Ma, Jianpeng" <jianpeng.ma@intel.com>
Subject: Question: How to use systemtap count the total inode read from disk
Date: Tue, 30 Sep 2014 02:39:28 +0000
Message-ID: <6AA21C22F0A5DA478922644AD2EC308C8C986B@SHSMSX101.ccr.corp.intel.com>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi all,
  I want to count the total read inode from disk. 
  I count the call number of xfs_dinoe_from_disk.
 But at the same time, I use blktrace to trace all read-meta operation. And using xfs_db to analysis the read-operation. I found more meta-read are read inode.
But the count of systemtap is zero.

The script of systemtap

#! /usr/bin/env stap
global count
function report()
{
  printf("total count %u\n", count)
}
probe module("xfs").function("xfs_dinode_from_disk")
{
  count++
}
probe end
{
  report()
}
probe begin
{
  printf("starting probe\n")
  count = 0
}


Who know why? And How to do which can achieve my aim.


Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
