Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8FEm1j7215040 for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 09:48:02 -0500
Received: from na3sys009aog125.obsmtp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F9B81679F1
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 07:48:00 -0700 (PDT)
Received: from na3sys009aog125.obsmtp.com (na3sys009aog125.obsmtp.com
	[74.125.149.153]) by cuda.sgi.com with ESMTP id
	4ZLbEiUsV16mo0Kx for <xfs@oss.sgi.com>;
	Thu, 15 Sep 2011 07:48:00 -0700 (PDT)
Received: by yib25 with SMTP id 25so1144577yib.37
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 07:47:59 -0700 (PDT)
Date: Thu, 15 Sep 2011 09:47:55 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

I've got a workload that is latency sensitive that writes data to a
memory mapped file on XFS.  With the 3.0 kernel I'm seeing stalls of
up to 100ms that occur during writeback that we did not see with older
kernels.  I've traced the stalls and it looks like they are blocking
on wait_on_page_writeback() introduced in
d76ee18a8551e33ad7dbd55cac38bc7b094f3abb "fs: block_page_mkwrite
should wait for writeback to finish"

Reading the commit description doesn't really explain to me why this
change was needed.  Can someone explain what "This is needed to
stabilize pages during writeback for those two filesystems." means in
the context of that commit?  Is this a problem for older kernels as
well?  Should this have been backported to the stable kernels? What
are the downsides of reverting this commit?

Assuming this change is required are there any alternatives solutions
to avoid these stalls with mmaped I/O on XFS?

Thanks,
Shawn


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
