Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D20247F59
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 13:22:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF8118F8049
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 11:22:50 -0700 (PDT)
Received: from mail-ig0-f181.google.com (mail-ig0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	b7GMOo99xb12BZOW (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 11:22:46 -0700 (PDT)
Received: by iggf3 with SMTP id f3so61236785igg.1
	for <xfs@oss.sgi.com>; Mon, 03 Aug 2015 11:22:46 -0700 (PDT)
Received: from [192.168.1.171] (50-197-102-113-static.hfc.comcastbusiness.net.
	[50.197.102.113]) by smtp.googlemail.com with ESMTPSA id
	rs4sm6262231igb.13.2015.08.03.11.22.44 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 03 Aug 2015 11:22:44 -0700 (PDT)
From: Joe Landman <joe.landman@gmail.com>
Subject: Nevermind (RTFMP): swalloc/allocsize question
Message-ID: <55BFB173.1010302@gmail.com>
Date: Mon, 3 Aug 2015 14:22:43 -0400
MIME-Version: 1.0
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
To: xfs <xfs@oss.sgi.com>

Yeah ... so its a decaffeinated day /sigh

from mount man page

        allocsize=size
               Sets the buffered I/O end-of-file preallocation size when 
doing delayed allocation writeout  (default  size
               is  64KiB).   Valid  values  for  this option are page 
size (typically 4KiB) through to 1GiB, inclusive, in
               power-of-2 increments

Its doing the right thing.  I wasn't.

RTFMP == Read The Fine Man Page


Joe

joe.landman@gmail.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
