Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AJCopo201302 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 14:12:50 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id EtZC2t6gEA4SdAOK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 12:12:49 -0700 (PDT)
Received: from telerig.nabble.com ([192.168.236.162])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1SHgUi-0004Sf-CX
	for xfs@oss.sgi.com; Tue, 10 Apr 2012 12:12:48 -0700
Message-ID: <33663734.post@talk.nabble.com>
Date: Tue, 10 Apr 2012 12:12:48 -0700 (PDT)
From: troby <Thorn.Roby@harlandfs.com>
Subject: Re: How to pre-allocate files for sequential access?
In-Reply-To: <33564834.post@talk.nabble.com>
MIME-Version: 1.0
References: <33564834.post@talk.nabble.com>
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
To: xfs@oss.sgi.com


Thanks all for your help. Due to unrelated collateral damage within the
database software, I had the "opportunity" to rebuild the filesystems using
some of your suggestions. I set up external log devices for the two busiest
filesystems (RAID5 for the row data, a RAID10 on 4 drives for indexes) and
configured the stripe widths correctly this time. The inode64 mount option
did result in sequential allocation, with a single 2GB segment per file, for
all files which were pre-allocated by the MongoDB software. A small number
of similar files I created manually using dd from /dev/zero with a single
2GB block showed 3 or 4 segments coming from different AG's, with
corresponding disparate block ranges, but there aren't enough of those to
cause problems. 
One thing that puzzles me is that despite my configuration of the underlying
RAID stripe geometry both at filesystem creation and mount time, all the
filesystems show average request sizes (mostly writes at this time) of
around 240 sectors. This is correct for some of them, but the RAID1 stripe
is twice that wide and the RAID5 almost 4 times as wide. The files being
written are all memory-mapped, so I'm wondering if that means the kernel
uses some other settings besides the fstab mount options to determine the
request size. The flush activity only happens a few times a minute and only
lasts a second or two, so I don't think there's really a significant
performance impact under the current load. And since the writes are actually
going to a 1GB controller cache, I suspect there is enough time for the
controller to assemble a full RAID5 stripe before writing to disk.
-- 
View this message in context: http://old.nabble.com/How-to-pre-allocate-files-for-sequential-access--tp33564834p33663734.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
