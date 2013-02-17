Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 859417FBB
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 09:50:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7168A8F8035
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 07:50:48 -0800 (PST)
Received: from mail-wg0-f66.google.com (mail-wg0-f66.google.com
	[74.125.82.66]) by cuda.sgi.com with ESMTP id FzJd4ysUzFtm9RND
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 17 Feb 2013 07:50:47 -0800 (PST)
Received: by mail-wg0-f66.google.com with SMTP id 16so1047887wgi.1
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 07:50:46 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 17 Feb 2013 21:20:46 +0530
Message-ID: <CAEUQcehy1fy5-W-TA--2emBgL3y9JskqRPCZf1ED5JDbPHqKTQ@mail.gmail.com>
Subject: High %user CPU in XFS
From: Subranshu Patel <spatel.ml@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

 I created 2 filesystem on my system (RHEL 6.3, kernel 2.6.32) - XFS
and EXT4 and mounted them.

On both the filesystem I executed a program which performed the following:
- Create large number of directories
- Removing all the directories

During the execution of the program, I monitored the %user and %system
CPU usage (using sar command)

For EXT4 the %user was 1% and %system was 21%
For XFS the %user was 20% and %system was 52%

But I am not able to understand %user consumption, since %user reports
the CPU usage of the user level (application), shouldn't it be the
same for both EXT4 and XFS?

What are the factors that decide the %user component keeping in mind
that only the filesystem is different?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
