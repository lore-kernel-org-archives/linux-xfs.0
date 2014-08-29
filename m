Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D099B7F95
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 05:08:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BECD8304039
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 03:08:12 -0700 (PDT)
Received: from smtp.inserm.fr (smtp.inserm.fr [195.98.252.37]) by cuda.sgi.com
	with ESMTP id tu4YElnHXL2FSJ71 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 03:08:11 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp.inserm.fr (SrvInserm) with ESMTP id 5B61216846A
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 12:08:09 +0200 (CEST)
Received: from smtp.inserm.fr ([195.98.252.37])
	by localhost (potentille.inserm.fr [127.0.0.1]) (amavisd-new,
	port 10026) with ESMTP id btTV-QTKML_1 for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 12:08:09 +0200 (CEST)
Received: from cognac-lmde.crcm.mrs (236-ne1068.marseille.inserm.fr
	[195.220.68.236])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by smtp.inserm.fr (SrvInserm) with ESMTP id 428651683DD
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 12:08:08 +0200 (CEST)
Message-ID: <54005108.1020203@inserm.fr>
Date: Fri, 29 Aug 2014 12:08:08 +0200
From: Samuel Granjeaud <samuel.granjeaud@inserm.fr>
MIME-Version: 1.0
Subject: Run out of inodes?
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
To: xfs@oss.sgi.com

Hi,

Sorry if the answer is obvious, but I didn't find any clear answer after 
googling.

I have a XFS system of 18T over LVM. Recently, I could not create new 
files or directories.

# mkdir tempo
mkdir: cannot create directory `tempo': No space left on device

After deleting a few files, this command runs successfully.

So I think that the system runs out of something, inodes I guess.

But the df diagnosis does not enlight it: only 1% used.

# df -ht xfs
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/vg1_backup-backup
                        18T   12T  6.6T  63% /mnt/vg1_backup/backup
# df -it xfs
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/vg1_backup-backup
                      18874040320  530042 18873510278    1% 
/mnt/vg1_backup/backup

So what is wrong? How should I solve the problem?

I read about xfs_grow -m, but I am not sure if it could help.
Of course, I rebooted the system before my trials.

Best regards,
Samuel


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
