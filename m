Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6IJwuKq125006 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 14:58:57 -0500
Received: from johnbokma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42D6F7C318
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 12:58:55 -0700 (PDT)
Received: from johnbokma.com (johnbokma.com [174.143.254.155]) by cuda.sgi.com
	with ESMTP id TWBSBQlYEYi6JNlE for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 12:58:55 -0700 (PDT)
Received: from [192.168.1.100] (unknown [200.92.64.33])
	by johnbokma.com (Postfix) with ESMTPSA id 87BB4120051
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 19:58:55 +0000 (UTC)
Message-ID: <4E24907F.6020903@johnbokma.com>
Date: Mon, 18 Jul 2011 14:58:55 -0500
From: John Bokma <contact@johnbokma.com>
MIME-Version: 1.0
Subject: 30 TB RAID6 + XFS slow write performance
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dear list members,

A customer of mine is currently struggling with the performance of a 30 =

TB RAID6 which uses XFS as the filing system. I am somewhat sure it's =

not XFS that's causing the performance issue but my expertise is not XFS =

nor RAID; I just wrote the software that after moving to the larger RAID =

(from a much smaller one, ~ 3TB, using ext3) suddenly seems to have a =

huge drop in write performance.

The software I wrote writes many small (50-150K) files in parallel (100+ =

processes), thousands of times per hour. Writing a file of 50-150K now =

and then seems to take between 30 and 90 seconds, and more rarely can =

take over 200 seconds (several times an hour).

When all processes are stopped and restarted again the 30-90 seconds =

delay start happening when about 16-20+ processes are running.

To me this sounds like something has been configured wrong. I already =

recommended my customer to find someone who is capable of configuring =

the RAID correctly; to me it sounds like a hardware/configuration issue.

Any insights are very welcome.

Hardware:
card: MegaRAID SAS 9260-16i
disks: 14x Barracuda=AE XT ST33000651AS 3TB (2 hot spares).
RAID6
~ 30TB

Thanks for reading,
John

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
