Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25456 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbdHMVoN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Aug 2017 17:44:13 -0400
From: ToddAndMargo <ToddAndMargo@zoho.com>
Subject: RFE: xfsdump: better error message for existing dump file management
Message-ID: <5c07cc97-c518-7052-d3c3-507d495373ea@zoho.com>
Date: Sun, 13 Aug 2017 14:44:10 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi All,

When running this command twice in a row

# /usr/sbin/xfsdump -v verbose -M 1 -L 1 -l 0 -f 
/lin-bak/2017-08-1121-39-07md126p2.XfsDump /

It throws the following error message the second time the
command is thrown.

/usr/sbin/xfsdump:   stream 0 /lin-bak/2017-08-1121-39-07md126p2.XfsDump 
ERROR (operator error or resource exhaustion)


This error is caused by the second instance finding the backup
file already existing.  (I presume "resource exhaustion" comes
from the old tape back up days when you ran out of tapes.)

And it takes a ton of time to figure out when it happens.
Tears.


Request for Enhancement (RFE):  Would you guys please consider
a better error message that reflects what is actually happening.

Perhaps:
    "Destination file exists.  Overwrite (y/n)",   or
    "Destination file exists.  Overwriting",       or
    "Destination file exists.  Cowardly exiting.  Bummer dude!"

Many thanks,
-T



