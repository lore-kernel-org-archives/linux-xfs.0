Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 05:02:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AC2q4p007341
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 05:02:53 -0700
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l8ABolHU015454
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 07:50:47 -0400
Received: from pobox.stuttgart.redhat.com (pobox.stuttgart.redhat.com [172.16.2.10])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l8ABok0k012917
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 07:50:46 -0400
Received: from dhcp-lab-203.englab.brq.redhat.com (dhcp-lab-203.englab.brq.redhat.com [10.34.33.203])
	by pobox.stuttgart.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id l8ABojZB026014
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 13:50:46 +0200
Message-ID: <46E52F95.3070307@redhat.com>
Date: Mon, 10 Sep 2007 13:50:45 +0200
From: Zdenek Prikryl <zprikryl@redhat.com>
MIME-Version: 1.0
Subject: getfattr and symlinks
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello,
I have one question, what is right behavior of getfattr in a recursive 
mode? Should getfattr follow symlinks in this mode (without [PLh] 
parameters)?

Example:

$HOME/file.txt
$HOME/symlink -> /
...

getfattr -Rd $HOME

So what is the right result? Follow "$HOME/symlink" or not?

Thank you

Zdenek Prikryl
