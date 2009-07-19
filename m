Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6J0rpMD183696
	for <linux-xfs@oss.sgi.com>; Sat, 18 Jul 2009 19:53:51 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64DA513AF8F7
	for <linux-xfs@oss.sgi.com>; Sat, 18 Jul 2009 17:54:31 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id Ky9zKDOpTrvFo0SA for
	<linux-xfs@oss.sgi.com>; Sat, 18 Jul 2009 17:54:31 -0700 (PDT)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by Ishtar.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6J0sTV5012906
	for <linux-xfs@oss.sgi.com>; Sat, 18 Jul 2009 17:54:31 -0700
Message-ID: <4A626EC5.3090100@tlinx.org>
Date: Sat, 18 Jul 2009 17:54:29 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: data switchs su,sw and sunit,swidth
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux-Xfs <linux-xfs@oss.sgi.com>

Resending this as I never saw it show up on the list  (sent out
yesterday) (while other the messages came back in under 15 minutes 
or so)...

Have started to use RAID on a few of my disks and forgot about the
xfs 'su*sw' and 'sunit*swidth' options.

>From what I get in reading the manpage, 'su' is used with 'sw' and 
'sunit' is used with 'swidth'?

The RAID controller in one of my machines uses a "strip element" size, 
expressed in bytes, allowed values seem to be limited to powers 
of 512*2^*[1..11] (512B up to 1MB) (though as previously noticed, although
xfs's manpages claims to allow one expresses sizes with the unit 'm', it
only permits .25m (256k),  I guess I never tried seeing if the command line 
would take floating point ;^) ).

I believe 'su' would be set to the 'strip element size' (in k or m).

Then, for RAID 1 (mirror) would 'sw'==1?  Would setting the  su/sw  value
for a RAID 1 actually matter in any way?  Ie, technically -- it would 
fill in numbers for OS book-keeping, but wouldn't change anything in 
terms of performance or layout, vs. 'physically' -- where it could change
disk layout or performance?

At RAID 0, I'd guess  sw==2?

In RAID 5, would it be   sw  == #Disks-1?  So even w/6 disks, it still only
uses 1 disk for parity and  sw == 5?  

I wonder what becomes a max-safe RAID 5 size? (or is the number of parity
disks a settable option with RAID 5?)

Thanks!...
Linda



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
