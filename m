Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 031377CBF
	for <linux-xfs@oss.sgi.com>; Mon,  3 Jun 2013 11:40:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E54B130408B
	for <linux-xfs@oss.sgi.com>; Mon,  3 Jun 2013 09:40:03 -0700 (PDT)
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id 392kUcwNfrktI298 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Mon, 03 Jun 2013 09:40:02 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	r53Ge0Q3018742
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Mon, 3 Jun 2013 18:40:00 +0200
Message-ID: <51ACC6DF.4050507@itwm.fraunhofer.de>
Date: Mon, 03 Jun 2013 18:39:59 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: 3.9.0: general protection fault
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard> <5187A663.707@itwm.fraunhofer.de>
	<20130507011254.GP19978@dastard>
	<5188E2F5.1090304@itwm.fraunhofer.de>
	<20130507220742.GC24635@dastard>
	<518A8FD4.40700@itwm.fraunhofer.de>
	<20130509004115.GM24635@dastard>
	<518CC9A9.9060500@itwm.fraunhofer.de>
	<20130511001213.GA32675@dastard>
In-Reply-To: <20130511001213.GA32675@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com

Just an update here, the issue only came up once again on another system 
and I didn't have time for a couple of days to even save the collectl 
log file. I then increased the max number of rotated log files, but it 
didn't happen again ever since. So I don't have any logs about the state 
of the system at crash time so far.
However, I just got a captured file corruption:

> (squeeze)fslab3:~/fstests# cat /mnt/fhgfs//fslab4/ql-fstest/fstest13579.err
> File corruption in /mnt/fhgfs//fslab4/ql-fstest/fstest.13635/d040/d030/7ae214d1 (create time: Mon Jun  3 17:36:11 2013) around 246415360 [pattern = 7ae214d1]
> After n-checks: 3
> Expected: d1, got: 83 (pos = 247324600)
> Expected: 14, got: ec (pos = 247324601)
> Expected: e2, got: 30 (pos = 247324602)
> Expected: 7a, got: 48 (pos = 247324603)
> Expected: d1, got: 89 (pos = 247324604)
> Expected: 14, got: 5d (pos = 247324605)
> Expected: e2, got: e8 (pos = 247324606)
...
> Expected: 14, got: 84 (pos = 247324661)
> Expected: e2, got: b9 (pos = 247324662)
> Expected: 7a, got: 0 (pos = 247324663)

Hmm, exactly 64 bytes of corrupted data, the file itself has a size of 
512MiB.

I'm going to export single disks from the controller to use it with 
md-raid6 as this allows to do parity checks and to identify bad disks.


Cheers,
Bernd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
