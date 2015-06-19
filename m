Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 636D87F67
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 04:21:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3667A8F8050
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 02:21:49 -0700 (PDT)
Received: from smtp-out6.electric.net ([192.162.217.190]) by cuda.sgi.com with
	ESMTP id YBoQk7n0t8Oa6S3o (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 02:21:46 -0700 (PDT)
Received: from 1Z5sUb-0005mE-UF by out6d.electric.net with emc1-ok (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5sUb-0005n5-Um
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 02:21:45 -0700
Received: from [192.171.162.48] (helo=lismore.npm.ac.uk)
	by out6d.electric.net with esmtp (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5sUb-0005mE-UF
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 02:21:45 -0700
Received: from lismore.npm.ac.uk (localhost.localdomain [127.0.0.1])
	by localhost (Email Security Appliance) with SMTP id
	2EFCE8D6D12_583DF29B
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 09:21:45 +0000 (GMT)
Received: from Harris.npm.ac.uk (harris.npm.ac.uk [192.171.162.107])
	by lismore.npm.ac.uk (Sophos Email Appliance) with ESMTP id
	F29768D6CCD_583DF28F
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 09:21:44 +0000 (GMT)
From: Mike Grant <mggr@pml.ac.uk>
Subject: [PATCH 0/2] xfs_repair: clear new memory after realloc
Date: Fri, 19 Jun 2015 10:21:34 +0100
Message-ID: <1434705696-21705-1-git-send-email-mggr@pml.ac.uk>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Mike Grant <mggr@pml.ac.uk>

This patchset fixes the seg-fault bug that was crashing an xfs_repair attempt
on a 150TB filesystem.  The problem, including traces and metadump link, is
in the mail thread "xfs_repair segfault + debug info" 29/May/2015.  After the
patch was applied, the xfs_repair ran through to completion.

There's also a cosmetic reformatting of nearby lines included, but this can be
dropped if preferred.

Mike Grant (2):
  xfs_repair: reformat lines to fit within 80 characters
  xfs_repair: clear new memory after realloc

 repair/phase6.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

-- 
2.1.0

(apologies for the following junk forcibly appended by my company)


Please visit our new website at www.pml.ac.uk and follow us on Twitter  @PlymouthMarine

Winner of the Environment & Conservation category, the Charity Awards 2014.

Plymouth Marine Laboratory (PML) is a company limited by guarantee registered in England & Wales, company number 4178503. Registered Charity No. 1091222. Registered Office: Prospect Place, The Hoe, Plymouth  PL1 3DH, UK. 

This message is private and confidential. If you have received this message in error, please notify the sender and remove it from your system. You are reminded that e-mail communications are not secure and may contain viruses; PML accepts no liability for any loss or damage which may be caused by viruses.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
