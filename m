Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6H9Rg4U078271 for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 04:27:43 -0500
Received: from padma.gslab.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 47486A85400
	for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 02:36:06 -0700 (PDT)
Received: from padma.gslab.com (padma.gslab.com [59.163.66.102]) by
	cuda.sgi.com with SMTP id gpNVDIUTU41t8U7a for
	<xfs@oss.sgi.com>; Fri, 17 Jul 2009 02:36:06 -0700 (PDT)
Message-ID: <4A60442E.7010206@gslab.com>
Date: Fri, 17 Jul 2009 02:28:14 -0700
From: Milind Dumbare <milind@gslab.com>
MIME-Version: 1.0
Subject: Multi threaded random IO
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org

Any standard comparison between multi threaded random Write vs multi 
threaded random Read on XFS or any other filesystem?

I see multi threaded random Write faster than multi threaded random 
Read. Which is contradictory to standard "Reads faster that Writes" law.

My test setup is.
10MB record size, 2TB filesize, 8 threads.iozone

Any comments?

Thanks,
Milind

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
