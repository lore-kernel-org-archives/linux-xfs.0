Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3N9JxGp036367
	for <linux-xfs@oss.sgi.com>; Fri, 23 Apr 2010 04:20:00 -0500
Received: from mail-gw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 234232E9759
	for <linux-xfs@oss.sgi.com>; Fri, 23 Apr 2010 02:22:00 -0700 (PDT)
Received: from mail-gw0-f53.google.com (mail-gw0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id VJeMYa643FtoVHNu
	for <linux-xfs@oss.sgi.com>; Fri, 23 Apr 2010 02:22:00 -0700 (PDT)
Received: by gwj21 with SMTP id 21so2973953gwj.26
	for <linux-xfs@oss.sgi.com>; Fri, 23 Apr 2010 02:22:00 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 23 Apr 2010 17:21:54 +0800
Message-ID: <y2u389deec71004230221zb7fe7249g91f09cf4845ae4a6@mail.gmail.com>
Subject: How do I use "realtime subvolume" for storing video data?
From: hank peng <pengxihan@gmail.com>
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
To: linux-xfs@oss.sgi.com

Hi, folks:
I am using XFS in storing video suvillence data, and today I found
"realtime subvolume" feature on SGI website. I used to make xfs with
default parameters, but I think this feature is maybe very useful to
me.
SGI website said: XFS supports the notion of a "realtime subvolume" -
a separate area of disk space where only file data is stored.  This is
really what I need, since disk space become biger and biger nowerdays,
if some sectors are corrupted, video data is lost which is acceptable
but the whole XFS filesystem down is not acceptable.

I googled some information, but it seems that few people made use of
this feature. I wonder if it is usable in my case and how do I use it?

-- 
The simplest is not all best but the best is surely the simplest!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
