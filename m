Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9F7947CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 18:27:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25D15AC001
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 16:27:47 -0700 (PDT)
Received: from exprod7og119.obsmtp.com (exprod7og119.obsmtp.com [64.18.2.16])
	by cuda.sgi.com with SMTP id 4sIqNJ6oOXPdpUCw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 16:27:45 -0700 (PDT)
Message-ID: <519176E7.8070204@genband.com>
Date: Mon, 13 May 2013 17:27:35 -0600
From: Chris Friesen <chris.friesen@genband.com>
MIME-Version: 1.0
Subject: 2.6.27-based kernel failing xfstests xfs/182
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
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com


Hi,

I'm working on an embedded system running a 2.6.27-based kernel.

I'm digging into some intermittent xfs corruption issues.  Yes, I 
realize the right answer is probably to upgrade, but for the usual 
embedded reasons that's tricky.

I'm seeing test xfs/182 fail with 40 or so files showing messages like:

file /opt/xfstest2/960 has incorrect size - sync failed

In our case the xfs filesystems used for testing are on top of lvm, 
which is in turn on top of two SAS drives in RAID1.

Any suggestions on where I should start looking?  I'm looking at the 
"do_sync() and XFSQA test 182 failures...." thread on the mailing list 
from 2008, can someone point me to the commit that eventually resulted 
from that?

Thanks,
Chris


-- 

Chris Friesen
Software Designer
www.genband.com
office:+1.343.883.2717

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
