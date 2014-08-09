Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 303617F9D
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 22:19:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0ADCA304032
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 20:19:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UANNhpXGkf9lVYt8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 20:19:14 -0700 (PDT)
Message-ID: <53E5932E.6@redhat.com>
Date: Fri, 08 Aug 2014 22:19:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't zero partial page cache pages during O_DIRECT
References: <53E4E03A.7050101@fb.com> <20140809003628.GE26465@dastard>
	<53E5885A.9090302@fb.com>
In-Reply-To: <53E5885A.9090302@fb.com>
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
To: Chris Mason <clm@fb.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 8/8/14, 9:32 PM, Chris Mason wrote:

>> Go on, call me a deranged monkey on some serious mind-controlling
>> substances. I don't care. :)

Insider / obscure quote achievement unlocked!
 
> The deranged part is invalidating pos -> -1 on a huge file because of a
> single 512b direct read.  But, if you mix O_DIRECT and buffered you get
> what the monkeys give you and like it.

Agreed, I really scratch my head at that one...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
