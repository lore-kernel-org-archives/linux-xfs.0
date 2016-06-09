Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F6567CA2
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:43:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 734658F8035
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 09:43:15 -0700 (PDT)
Received: from mx2.math.uh.edu (mx2.math.uh.edu [129.7.128.33]) by
	cuda.sgi.com with ESMTP id mrhk8SBcR83Q8FQF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2016 09:43:12 -0700 (PDT)
Received: from epithumia.math.uh.edu ([129.7.128.2])
	by mx2.math.uh.edu with esmtp (Exim 4.86_2)
	(envelope-from <tibbs@math.uh.edu>) id 1bB331-0005fW-JB
	for xfs@oss.sgi.com; Thu, 09 Jun 2016 11:43:12 -0500
From: Jason L Tibbitts III <tibbs@math.uh.edu>
Subject: xfsaild 20 wakeups per second
Date: Thu, 09 Jun 2016 11:43:11 -0500
Message-ID: <ufaeg86e2jk.fsf@epithumia.math.uh.edu>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I was tuning the power consumption of my new laptop and noticed that
each xfsaild process is still waking up 20 times per second.  I found
http://oss.sgi.com/archives/xfs/2012-03/msg00237.html which I think
indicates that this was a workaround for some other issue and wouldn't
be permanent.  Unfortunately that was 4+ years ago.  I wasn't able to
locate any other discussion about the topic.

Was it determined that the wakeups were going to have to stay
permanently?  Or was the issue just not revisited?  And if the former,
is there a way to tune the wakeup frequency in any way?

 - J<

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
