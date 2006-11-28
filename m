Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Nov 2006 07:33:10 -0800 (PST)
Received: from EX01.ad.tulane.edu (ex01.ad.tulane.edu [129.81.114.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kASFX2aG002527
	for <xfs@oss.sgi.com>; Tue, 28 Nov 2006 07:33:02 -0800
Date: Tue, 28 Nov 2006 09:20:03 -0600
Subject: get xfs_quota info as regular user 
From: Rene Salmon <rsalmon@tulane.edu>
Message-ID: <C191AFC3.1D43%rsalmon@tulane.edu>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Rene Salmon <rsalmon@tulane.edu>

Hi,


Did some searches on the list archives but could not find any useful info on
this.

Is there a way for a regular user to get info about his or her quota usage?

I tried both of these as a regular user and get nothing:

120> xfs_quota -c "quota userid"
121> xfs_quota -x -c "quota userid"

But if I log in as root I can manage to get the info I need:

# xfs_quota -c "quota userid"
Disk quotas for User userid (17080)
Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted
on
/dev/vg_u00/lv_u00     1691516   10240000   10291200   00 [--------] /u00
/dev/vg_u01/lv_u01     4272876   10240000   10291200   00 [--------] /u01
Disk quotas for User userid (17080)
Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted
on
/dev/vg_u00/lv_u00     1691516   10240000   10291200   00 [--------] /u00
/dev/vg_u01/lv_u01     4272876   10240000   10291200   00 [--------] /u01


Is there any way to allow users to check their quotas with out being root?

Thanks
Rene




-- 
        Rene Salmon
        Tulane University
        Center for Computational Science
        http://www.ccs.tulane.edu
        rsalmon@tulane.edu
        Tel 504-862-8393
        Fax 504-862-8392
