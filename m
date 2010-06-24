Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5O8xRWk094463 for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 03:59:27 -0500
Received: from stud.pam.szczecin.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0812D1E14690
	for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 02:02:08 -0700 (PDT)
Received: from stud.pam.szczecin.pl (stud.pam.szczecin.pl [212.14.5.154]) by
	cuda.sgi.com with ESMTP id b5Eb4AllLTGuELbb for
	<xfs@oss.sgi.com>; Thu, 24 Jun 2010 02:02:08 -0700 (PDT)
Received: from sws (helo=localhost)
	by stud.pam.szczecin.pl with local-esmtp (Exim 4.63)
	(envelope-from <sws@stud.pam.szczecin.pl>) id 1ORiJu-0003IC-KE
	for xfs@oss.sgi.com; Thu, 24 Jun 2010 11:02:02 +0200
Date: Thu, 24 Jun 2010 11:02:02 +0200 (CEST)
From: Stanczak Slawomir <sws@stud.pam.szczecin.pl>
Subject: xfs_quota report problem
Message-ID: <Pine.LNX.4.58.1006241045580.12138@stud.pam.szczecin.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I use xfs on my Debian Linux system. I have one question.
How can I display users with exceeded soft blocks limit only?

I can do:

xfs_quota -x -c report /home | grep day

xfs_quota -x -c report /home | grep day | awk '{print $1}'

but the solution isn't a good idea.

Have you any other idea?

Thanks for your help
Best regards
Slawomir Stanczak

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
