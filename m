Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5CFckOj212312 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 10:38:46 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 036A51D3FA1B
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 08:39:07 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id cXd2V7Xql1SGVTCi for
	<xfs@oss.sgi.com>; Fri, 12 Jun 2009 08:39:07 -0700 (PDT)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by Ishtar.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5CFct2P007730 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 08:38:58 -0700
Message-ID: <4A32768D.7020606@tlinx.org>
Date: Fri, 12 Jun 2009 08:38:53 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfsdump -J: affecting 'normal dumps?'
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
To: xfs-oss <xfs@oss.sgi.com>

I wanted to copy a file system to another partition.  To get
everything, I used xfsdump/restore with the "-J" option, which is
stated to not update the online dump inventory.

My dumps, since the 1st of the month have been working 
fine up to this morning -- They were levels
0,2,5,4,7,6,9,8,9,9 and this mornings was a '1'.  It failed
saying that the last level 0 dump upon which it was based had
failed -- but AFAIK, that's not possible if the intermediate
(2,5,4,7,6,9,8,9,9) dumps all worked.  The only thing that couldl
have thrown it off would have been my xfsdump/restore (a data copy)
where both the dump and restore used the '-J' option (I encoded it 
in a script as:

xfsdump -b 64k -l 0 -J -p 300 - "$1" | xfsrestore -b 64k -B -F -J  - "$2"

Do I misunderstand the function of the "-J" switch?  Shouldn't
my level '1' dump have ignored the "datacopy" dump I performed with
the -J?  

Or was(is) there another option I should have(be) using?

Is there any easy way to get my dumps back-on-track?  I.e. to kick off a normal level-1 dump and have it be based on my June-1 lvl 0 dump?

Thanks!
Linda

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
