Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9573D7F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 12:58:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 162EAAC00B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 10:58:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id O6AWZYiUP5kv2TpE for
	<xfs@oss.sgi.com>; Wed, 11 Dec 2013 10:57:59 -0800 (PST)
Date: Wed, 11 Dec 2013 13:57:46 -0500
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS: Internal error XFS_WANT_CORRUPTED_RETURN
Message-ID: <20131211185746.GA11861@redhat.com>
References: <20131211172725.GA4606@redhat.com>
	<68DD7157-6ACE-4548-A466-C1EBD31B6DEB@colorremedies.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <68DD7157-6ACE-4548-A466-C1EBD31B6DEB@colorremedies.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 11, 2013 at 11:52:51AM -0700, Chris Murphy wrote:
 > 
 > On Dec 11, 2013, at 10:27 AM, Dave Jones <davej@redhat.com> wrote:
 > > 
 > > Thoughts ? Could sda be dying ? (It is a fairly old crappy ssd)
 > 
 > It may reveal nothing useful, but please report the results from 'smartctl -x /dev/sda' and if not found install smartmontools package.


I meant it when I said 'old' and 'crappy'.
It doesn't even support the interesting SMART commands.

	Dave


smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.11.10-300.fc20.x86_64] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     G.SKILL 64GB SSD
Serial Number:    MK08085207D640017
Firmware Version: 02.10104
User Capacity:    64,105,742,336 bytes [64.1 GB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS, ATA/ATAPI-7 T13/1532D revision 4a
Local Time is:    Wed Dec 11 13:56:50 2013 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Disabled
Write cache is:   Disabled
ATA Security is:  Unavailable
Wt Cache Reorder: Unavailable

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Total time to complete Offline 
data collection: 		(    0) seconds.
Offline data collection
capabilities: 			 (0x00) 	Offline data collection not supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x00)	Error logging NOT supported.
					No General Purpose Logging support.

SMART Attributes Data Structure revision number: 1280
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
 12 Power_Cycle_Count       -O--CK   100   100   000    -    5447
  9 Power_On_Hours          -O--CK   100   100   000    -    0
194 Temperature_Celsius     POS---   032   100   000    -    0
229 Unknown_Attribute       -O----   100   000   000    -    260003199309804
232 Available_Reservd_Space -O----   100   048   000    -    9028846498104
233 Media_Wearout_Indicator -O----   100   000   000    -    1122231520092
234 Unknown_Attribute       -O----   100   000   000    -    782120273690
235 Unknown_Attribute       -O----   100   000   000    -    1006826557
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

Read SMART Log Directory failed: scsi error aborted command

ATA_READ_LOG_EXT (addr=0x00:0x00, page=0, n=1) failed: scsi error aborted command
Read GP Log Directory failed

SMART Extended Comprehensive Error Log (GP Log 0x03) not supported

SMART Error Log not supported

SMART Extended Self-test Log (GP Log 0x07) not supported

SMART Self-test Log not supported

Selective Self-tests/Logging not supported

SCT Commands not supported

Device Statistics (GP Log 0x04) not supported

ATA_READ_LOG_EXT (addr=0x11:0x00, page=0, n=1) failed: scsi error aborted command
Read SATA Phy Event Counters failed



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
