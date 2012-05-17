Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4HJ9Mq7228881 for <xfs@oss.sgi.com>; Thu, 17 May 2012 14:09:22 -0500
Received: from pmpc1228.npm.ac.uk (pmpc1228.nerc-pml.ac.uk [192.171.161.128])
	by cuda.sgi.com with ESMTP id F6ywOQudEJIwCCFK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 May 2012 12:09:20 -0700 (PDT)
Received: from pmpc1228.npm.ac.uk (localhost.localdomain [127.0.0.1])
	by pmpc1228.npm.ac.uk (8.14.4/8.14.4) with ESMTP id q4HJ9IxJ006132
	for <xfs@oss.sgi.com>; Thu, 17 May 2012 20:09:18 +0100
Message-ID: <4FB54CDE.9010100@pml.ac.uk>
Date: Thu, 17 May 2012 20:09:18 +0100
From: Mike Grant <mggr@pml.ac.uk>
MIME-Version: 1.0
Subject: XFS stack overflows
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

I was googling around for stack overflow problems with large XFS
filesystems and came across http://lwn.net/Articles/476562/ where Dave
asked people to email in occurrences of this problem (good article
btw!).  I can confirm that we've had regular crashes on our RHEL6 box
(2.6.32-131.6.1.el6.x86_64) with a 60TB XFS filesystem*.  We've
confirmed the crashes are stack overflows in XFS allocation from looking
at crash dumps.  This is medium-reproducible by writing to the
filesystem over NFS.  RH have had a case open (#00414047) open on this
issue since Feb 2011, though I don't know if it's been filtered upstream.

The last email I see on the subject on this list was
http://oss.sgi.com/archives/xfs/2011-12/msg00264.html where Dave
mentioned a patch, but recommended rebuilding the kernel with 16k
stacks.  Is this patch likely to be applied or has it been already?  If
not, presumably the 16k stack rebuild is the best way to go for a
working system?

Cheers,

Mike.

* Subsequently we've been limiting all XFS filesystems to a maximum of
30TB and haven't seen problems with those (other than data management
issues because our datasets are much bigger than 30TB).  While this is
still somewhat of a niche issue, cheap 48TB NAS servers are increasingly
common (~$10k).  As XFS is the only mainstream Linux filesystem capable
of handling these volumes, I imagine more people are likely to run into
this issue over time.
-- 
PGP: 0xD4925D35 (5A17 756C 3F78 27DB C641 F50C 05EC 4F23 D492 5D35)
*******************************************************************
Plymouth Marine Laboratory, Prospect Place, Plymouth, UK. PL4 9PN.
PML is a company limited by guarantee and a registered charity.
Registered England & Wales company no:4178503; charity no:1091222
                     http://www.pml.ac.uk/
This email is confidential and for the intended recipient(s) only.
Terms and legal disclaimers apply: http://rsg.pml.ac.uk/email.html
*******************************************************************

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
