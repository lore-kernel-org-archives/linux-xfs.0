Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Feb 2007 11:13:08 -0800 (PST)
Received: from talk.nabble.com (www.nabble.com [72.21.53.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1NJD3m7028568
	for <linux-xfs@oss.sgi.com>; Fri, 23 Feb 2007 11:13:04 -0800
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1HKfqp-0003BW-CY
	for linux-xfs@oss.sgi.com; Fri, 23 Feb 2007 11:13:03 -0800
Message-ID: <9124908.post@talk.nabble.com>
Date: Fri, 23 Feb 2007 11:13:03 -0800 (PST)
From: pgf111000 <junkmail@petergfrazier.com>
Subject: I/O error, SCSI error, reservation conflict.... xfs suggestions?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hello all-

I am in an fc6 x86_64 environment on an lvm2 ext3 fs (mkfs'd to a segate
750)... this is the host os.  The target os is a CLFS environment, which is
built on a areca 1280 hw raid6 (arcmsr driver compiled from source) 4
seagates (750s) array; all of the above on an AMD Opteron based tyan
board.....

the target os has three primary partitions:

boot- xfs
swap- swap
lvm2

The lvm partition has one pv (being the areca array); the lvm has multiple
lv's.... a few lv's are straight xfs, other lv's are 
LUKS w/ the mapped drive being xfs.

I'v read the doc at: http://web.bii.a-star.edu.sg/~james/100TB/14TB/#f  
...it's useful, but...

In the middle of read/write operations on the xfs formatted areca array I
experience the following repetative message (from /var/log/messages):

sd 3:0:1:0: reservation conflict
sd 3:0:1:0: SCSI error: return code = 0x00070018
end_request: I/O error, dev sdx, sector 681896097

The "SCSI error: return code" consistently returns "0x00070018".  The
"end_request: I/O error, dev sdx, sector" returns various sector values. 
The opteron produces significant io wait during these errors; the read/write
performance is marginal (in general).

I have run xfs_check on all the  parititions (LUKS/xfs and xfs)... no
errors.  I have scanned the array volume (on the hardware level)... no
errors.   I have run badblocks -nsv  ...on most of the parititions (LUKS/xfs
and xfs)... no error.  

Any and all thoughts/suggestions will be warmly received....
-- 
View this message in context: http://www.nabble.com/I-O-error%2C-SCSI-error%2C-reservation-conflict....-xfs-suggestions--tf3280660.html#a9124908
Sent from the linux-xfs mailing list archive at Nabble.com.
