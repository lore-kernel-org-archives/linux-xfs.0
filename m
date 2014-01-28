Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 51E5C7F9A
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 14:06:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 349798F8037
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 12:06:08 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	d0j10rHhPsxy8VAH for <xfs@oss.sgi.com>;
	Tue, 28 Jan 2014 12:05:56 -0800 (PST)
Date: Wed, 29 Jan 2014 07:05:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: server lock ups maybe XFS related - BUG: bad unlock balance
	detected!
Message-ID: <20140128200549.GK2212@dastard>
References: <CAGoO68jx6XgyEX3=GXy2icm0Ze65i_T4nVSv0ito8Kz6hP_jWg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGoO68jx6XgyEX3=GXy2icm0Ze65i_T4nVSv0ito8Kz6hP_jWg@mail.gmail.com>
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
To: Max Veprinsky <max.veprinsky@livetext.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 28, 2014 at 12:32:28PM -0600, Max Veprinsky wrote:
> Hello everybody!
> 
> First time called, first time listener looking for help.
> In the past couple of months a Dell R900 has been locking up what
> seems to be at random intervals. This time the messages log has
> captured something that maybe of use to help sort out the issue, of
> course it could be not related at all.

Lockdep output is unrelated to the hang. The XFS code in that kernel
is missing an annotation in the code to silence the lockdep warning.

>  The server did not lockup until Jan 28 11:20

What does sysrq-w tell you when it locks up?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
