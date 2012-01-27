Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0R7odXd136121 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 01:50:39 -0600
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	OiZapeCmBUOLzX1C (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jan 2012 23:50:38 -0800 (PST)
Received: by iakl21 with SMTP id l21so2099295iak.26
	for <xfs@oss.sgi.com>; Thu, 26 Jan 2012 23:50:38 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 27 Jan 2012 08:50:38 +0100
Message-ID: <CAEBWcAT2zfDskgDjFr0KcnfsT2A65r04AM1cv2-TfnNJTB1__Q@mail.gmail.com>
Subject: Insane file system overhead on large volume
From: Manny <dermaniac@gmail.com>
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

Hi there,

I'm not sure if this is intended behavior, but I was a bit stumped
when I formatted a 30TB volume (12x3TB minus 2x3TB for parity in RAID
6) with XFS and noticed that there were only 22 TB left. I just called
mkfs.xfs with default parameters - except for swith and sunit which
match the RAID setup.

Is it normal that I lost 8TB just for the file system? That's almost
30% of the volume. Should I set the block size higher? Or should I
increase the number of allocation groups? Would that make a
difference? Whats the preferred method for handling such large
volumes?

Thanks a lot,
Manny

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
