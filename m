Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B07277CA7
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 19:57:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7537E304032
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 17:57:08 -0700 (PDT)
Received: from mail-oi0-f44.google.com (mail-oi0-f44.google.com
	[209.85.218.44]) by cuda.sgi.com with ESMTP id eVJOLb5yK9WK8bEM
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Sep 2016 17:57:06 -0700 (PDT)
Received: by mail-oi0-f44.google.com with SMTP id p186so148916923oia.2
	for <xfs@oss.sgi.com>; Fri, 02 Sep 2016 17:57:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160903003919.GI30056@dastard>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
	<1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
	<20160903003919.GI30056@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Sep 2016 17:57:04 -0700
Message-ID: <CA+55aFy17iuUYRSLO=e1e+W5oW8GRYy93myk816UjRgEFxQDOw@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
	detected
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, CAI Qian <caiqian@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>

On Fri, Sep 2, 2016 at 5:39 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Fundamentally a splice infrastructure problem.

Yeah, I don't really like how we handle the pipe lock.

It *might* be possible to instead just increment the reference
counters as we build a kvec[] array of them, and simply do teh write
without holding the pipe lock at all.

That has other problems, ie concurrect spices from the same pipe would
possibly write the same data multiple times, though.

But yes, the fundamental problem is how splice wants to take the pipe
lock both early and late. Very annoying.

              Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
