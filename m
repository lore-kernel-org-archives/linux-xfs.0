Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 428D57F37
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 12:05:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 319188F8065
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 10:05:32 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5kP6j34rMWJ8jtH7 for <xfs@oss.sgi.com>;
	Wed, 28 Jan 2015 10:05:28 -0800 (PST)
Message-ID: <54C924E7.5020404@sandeen.net>
Date: Wed, 28 Jan 2015 12:05:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: maxpct option for small xfs filesystems
References: <54C667F3.8040303@oracle.com>
	<20150126223715.GA7621@dastard>	<54C7BB78.4060203@oracle.com>
	<54C7BD60.5000104@sandeen.net> <54C8BCEC.5050101@oracle.com>
In-Reply-To: <54C8BCEC.5050101@oracle.com>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 1/28/15 4:41 AM, Alexander Tsvetkov wrote:
> What is expected behaviour in this case when it's required for fs to allocate new inodes starting to exceed defined maxpct
> percentage? Which error is expected to be returned to user, enospc or probably just some warning?

Sorry, I didn't answer this.  ENOSPC is expected.

There's not a lot of value in enforcing this strictly to the last inode,
because a % is fairly coarse anyway, but we should not blow right past
it as we do today.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
