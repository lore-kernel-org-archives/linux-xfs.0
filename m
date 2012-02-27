Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1RIWwQC111737 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 12:32:58 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id EqVIzls0MeXnoZc5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Feb 2012 10:32:56 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1S25NX-0005My-Do
	for xfs@oss.sgi.com; Mon, 27 Feb 2012 10:32:55 -0800
Message-ID: <33401743.post@talk.nabble.com>
Date: Mon, 27 Feb 2012 10:32:55 -0800 (PST)
From: MikeJeezy <forums@mgaccess.net>
Subject: Re: mount: Structure needs cleaning
In-Reply-To: <4F4B2281.1070200@hardwarefreak.com>
MIME-Version: 1.0
References: <33393100.post@talk.nabble.com>
	<4F49B693.4080309@hardwarefreak.com>
	<33393429.post@talk.nabble.com> <20120227004902.GQ3592@dastard>
	<33397518.post@talk.nabble.com>
	<4F4B2281.1070200@hardwarefreak.com>
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


> You want the individual drive write caches disabled.  Leaving their read
caches enabled is fine.
>
>The reason is that a power drop, kernel panic, or hardware lockup
>(thermal etc) clears the drive write caches before the blocks are
>written to the platters.  It is suspected that many/most of these free
>space btree corruptions, such as yours here, are caused by data in
>caches not being flushed to the platters.  SAN/RAID controllers with
>BBWC usually guarantee data in the write cache gets properly flushed to
>the platters when the system comes back up. 

Makes total sense. Thanks so much.
-- 
View this message in context: http://old.nabble.com/mount%3A-Structure-needs-cleaning-tp33393100p33401743.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
