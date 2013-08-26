Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4791E7F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 15:41:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 384238F8035
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 13:41:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id PjHQPMAL3BDTc5HB for <xfs@oss.sgi.com>;
	Mon, 26 Aug 2013 13:41:48 -0700 (PDT)
Message-ID: <521BBD8A.50104@sandeen.net>
Date: Mon, 26 Aug 2013 15:41:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaulting in phase 3
References: <trinity-9e6d7620-812f-48a7-9a7e-3098368ff59a-1376307533158@3capp-gmx-bs36>
In-Reply-To: <trinity-9e6d7620-812f-48a7-9a7e-3098368ff59a-1376307533158@3capp-gmx-bs36>
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
To: Jan Yves Brueckner <jyb@gmx.com>
Cc: xfs@oss.sgi.com

On 8/12/13 6:38 AM, Jan Yves Brueckner wrote:
> Hi there,
> 
> as in previous posts we've got a problem in repair/dir2.c after a
> xfs_repair -L -m 60000 segfaulting reproducibly at the very same
> point of recovery;
> 
> I did the initial repair with debianish 2.9.8 (some patches applied);
> then upgrading to latest stable 3.1.11 where the problem persists.
> 
> 3.1.11 when compiled w/o optimization and run with gdb however
> segfaulted in libpthread so I repeated with an -O0 of 2.9.8 to get
> the debugging information:

...

Ok finally looking at the metadump you provided, thanks.

But out of curiosity, what happened to this filesystem?  Seems
like a real mess.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
