Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C87F7F6F
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 15:50:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 315348F8033
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 13:50:38 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7CBdvZrBwWfF88Pr for <xfs@oss.sgi.com>;
	Sun, 06 Mar 2016 13:50:05 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1acgYt-0000Y4-KQ
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 08:50:03 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1acgYh-0004nw-Sj
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 08:49:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfs: accumulated fixes for 4.6
Date: Mon,  7 Mar 2016 08:49:44 +1100
Message-Id: <1457300990-18300-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

This series is mostly fixes pulled from Darrick's rmap tree and one
for a growfs log recovery fix from me. I'm posting them mainly for a
final check before I merge them, and so everyone knows what is going
to be merged from Darrick's trees before the merge actually occurs.

Realistically, I'm not going to wait for days for people to
check/review these patch series before I merge them. If i don't hear
any objections within a couple of days, I'll simply push them out
into the for-next tree. Yes, I know this is a bit different to the
normal process, but I'm not posting these patches from Darrick's
tree until I've already reviewed (and therefore tested) them.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
