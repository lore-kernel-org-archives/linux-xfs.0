Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4RG74Ex226806 for <xfs@oss.sgi.com>; Sun, 27 May 2012 11:07:05 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id CAe5HSrU28LcQdx3 for <xfs@oss.sgi.com>;
	Sun, 27 May 2012 09:07:03 -0700 (PDT)
Message-ID: <4FC25126.7070002@sandeen.net>
Date: Sun, 27 May 2012 11:07:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: very slow file deletion on an SSD
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard>
	<4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard>
	<4FC18845.6030301@gmail.com> <4FC19408.5020502@sandeen.net>
	<CAAxjCEzX4dmm6YuR__1_a6mw+D=vizV0VrCLqCC-d5GSgkbE6g@mail.gmail.com>
	<1338124504.28212.255.camel@oxygen.netxsys.com>
	<5856C5F0-C13E-415D-907B-491C1BBCC0C2@gmail.com>
In-Reply-To: <5856C5F0-C13E-415D-907B-491C1BBCC0C2@gmail.com>
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
To: joe.landman@gmail.com
Cc: Stefan Ring <stefanrin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Krzysztof Adamski <k@adamski.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 5/27/12 9:59 AM, joe.landman@gmail.com wrote:
> This is going to be a very fragmented file.  I am guessing that this
> is the reason for the long duration delete.   I'll do some more
> measurements before going to 3.4.x as per Eric's note.

filefrag -v should also tell you how many fragments, and because it
uses fiemap it probably won't run into the same problems.

But it sounds like we can just assume very high fragmentation.

It's not addressing the exact issue, but why are the files so fragmented?
Are they very hole-y or is it just an issue with how they are written?
Perhaps preallocation would help you here?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
