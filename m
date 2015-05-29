Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DA967F3F
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 09:04:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C06B0AC002
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 07:04:02 -0700 (PDT)
Received: from smtp-out6.electric.net ([192.162.217.191]) by cuda.sgi.com with
	ESMTP id U5mxMh5CYuqBEgV7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 May 2015 07:04:00 -0700 (PDT)
Received: from 1YyKtC-0000bj-UW by out6c.electric.net with emc1-ok (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1YyKtC-0000cf-V9
	for xfs@oss.sgi.com; Fri, 29 May 2015 07:03:58 -0700
Received: from [192.171.162.48] (helo=lismore.npm.ac.uk)
	by out6c.electric.net with esmtp (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1YyKtC-0000bj-UW
	for xfs@oss.sgi.com; Fri, 29 May 2015 07:03:58 -0700
Received: from lismore.npm.ac.uk (localhost.localdomain [127.0.0.1])
	by localhost (Email Security Appliance) with SMTP id
	4B6868D7775_56871CEB
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 14:03:58 +0000 (GMT)
Received: from Harris.npm.ac.uk (harris.npm.ac.uk [192.171.162.107])
	by lismore.npm.ac.uk (Sophos Email Appliance) with ESMTP id
	1105D8D776C_56871CEF
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 14:03:58 +0000 (GMT)
Message-ID: <556871CD.6090507@pml.ac.uk>
Date: Fri, 29 May 2015 15:03:57 +0100
From: Mike Grant <mggr@pml.ac.uk>
MIME-Version: 1.0
Subject: xfs_repair segfault + debug info
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

We recently had a 180TB XFS filesystem go down after following some
ill-considered advice from a Dell tech (re-onlining a maybe-failed disk,
which one might think was ok..).  It's not irreplaceable data, but
xfs_repair segfaults when trying to fix up and I thought that might be
of interest here to help fix the segfault.  We're not expecting to
recover the data, though it would be nice.

Partial logs & backtraces of xfs_repair runs using the latest Centos-7
xfsprogs package and also run with the xfs_repair built from the git
master, copies of core dumps and a metadump are at:
 https://rsg.pml.ac.uk/shared_files/mggr/xfs_segfault

Maximum memory use was only about 1GB by the time of the crash, and
there was 120GB+ of swap available, so I don't think that was an issue.
 The command was "xfs_repair -v /dev/md0 -t 60 -P".

Run time is about 2 hours to a crash and we'll probably want to wipe and
rebuild the server next week sometime.  Happy to run tests or gather
more info in the meantime though!

Please let me know if there's anything else that would be useful.

Cheers,

Mike.


Please visit our new website at www.pml.ac.uk and follow us on Twitter  @PlymouthMarine

Winner of the Environment & Conservation category, the Charity Awards 2014.

Plymouth Marine Laboratory (PML) is a company limited by guarantee registered in England & Wales, company number 4178503. Registered Charity No. 1091222. Registered Office: Prospect Place, The Hoe, Plymouth  PL1 3DH, UK. 

This message is private and confidential. If you have received this message in error, please notify the sender and remove it from your system. You are reminded that e-mail communications are not secure and may contain viruses; PML accepts no liability for any loss or damage which may be caused by viruses.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
