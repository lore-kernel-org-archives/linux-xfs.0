Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25479 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdFVEcK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2017 00:32:10 -0400
From: Todd Chester <ToddAndMargo@zoho.com>
Subject: Please consider a better error message for this error
Message-ID: <324e8bdc-b8d0-29d1-3cd2-f2441e4507ff@zoho.com>
Date: Wed, 21 Jun 2017 21:32:06 -0700
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

Would one of our intrepid heroes please modifying the
following incomprehensible error message?

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


So basically you have to use a restore program when you are already 
using a restore program.  Huh ????  `jmp 0` ???

Would you please consider altering the error message to:

    xfsrestore: ERROR: -i (interactive) option not valid when
                invoked with -R or -Q options

or something similar?

There are man page addition that should go along with this.  I
sent them in another post.

If I am reading the source code correctly, the fix can be made at

from the following SRPM's tar ball, content.c
http://rpm.pbone.net/index.php3/stat/26/dist/95/size/857409/name/xfsdump-3.1.4-1.el7.src.rpm



Old:

1513		if ( tranp->t_reqdumplabvalpr ) {
1514			mlog( MLOG_NORMAL | MLOG_ERROR, _(
1515			      "-%c valid only when initiating restore\n"),
1516			      GETOPT_DUMPLABEL );
1617			return BOOL_FALSE;
1518		}


Revised:

1513		if ( tranp->t_reqdumplabvalpr ) {
1514			mlog( MLOG_NORMAL | MLOG_ERROR, _(
1515			      "-%c (interactive) option not valid when invoked with -R or 
-Q options\n"),
1516			      GETOPT_DUMPLABEL );
1617			return BOOL_FALSE;
1518		}



I sincerely appreciate your consideration in the matter.

Many thanks,
-T





