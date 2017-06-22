Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25309 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdFVEXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2017 00:23:11 -0400
From: Todd Chester <ToddAndMargo@zoho.com>
Subject: RFE: man page changes
Message-ID: <4dc77769-499b-4933-2075-97982e1fdf76@zoho.com>
Date: Wed, 21 Jun 2017 21:22:58 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Dear XFS Developers,

The staff on Red Hat's bugzilla asked me if I would post
this kind of stuff "upstream".  I hope I have the right place.

Sunday night I almost had heart failure when trying to
restore a file with xfsrestore.  The file was a proposal
whose loss could have had the potential of costing me two
months income.

The panic turned out to be improper wording in the man
page which made me think my backups were all corrupted
(I have several).  I got my files back because I would
not give up.   (I mainly troubleshoot for a living with
the occasional code thrown in.)

Would you please consider the following additions to
the "man page" to save anyone else from the panic
I went through?

http://rpm.pbone.net/index.php3/stat/4/idpl/28948473/dir/scientific_linux_7/com/xfsdump-3.1.4-1.el7.x86_64.rpm.html




To "-i" section, please consider appending the following:

-i  ... Please note that the -R (resume previously interrupted
     restore) option and -Q (Force completion of an interrupted
     restore session) option are not compatible with this option
     and the program will terminate with an error


To the "-R" section, please consider appending the following:

-R  ... Please note that -i (interactive) option is not compatible
     with this option and the program will terminate with an error


To the "-Q" section, please consider appending the following:

-Q  ... Please note that -i (interactive) option is not
     compatible with this option and the program will
     terminate with an error



The reason for these additions is to remove the utter confusion caused 
by the following errors, especially trying to figure out why a restore 
program is required when you are running a restore program:

root@rn4 lin-bak]# xfsrestore -R -i -f 2017-06-17_14-47-46_homeXfsDump /home
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.4 (dump format 3.0) - type ^C for status and control
xfsrestore: ERROR: -i valid only when initiating restore
xfsrestore: Restore Status: ERROR

[root@rn4 lin-bak]# xfsrestore -Q -i -f 2017-06-17_14-47-46_homeXfsDump 
/home
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.4 (dump format 3.0) - type ^C for status and control
xfsrestore: ERROR: -i valid only when initiating restore
xfsrestore: Restore Status: ERROR


Your consideration is sincerely appreciated.

Many thanks,
-T

