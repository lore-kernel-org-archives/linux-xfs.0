Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o464FAJ2070817 for <xfs@oss.sgi.com>; Wed, 5 May 2010 23:15:10 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6324128138D
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 21:17:19 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id netBeEfaPKTvED5B for
	<xfs@oss.sgi.com>; Wed, 05 May 2010 21:17:19 -0700 (PDT)
Date: Thu, 6 May 2010 14:17:04 +1000 (EST)
From: nathans@aconex.com
Message-ID: <827899224.88951273119424327.JavaMail.root@mail-au>
In-Reply-To: <921460991.88921273119221574.JavaMail.root@mail-au>
Subject: Re: [PATCH 07/11] xfs: Delayed logging design documentation
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Yo,

Looking good Dave!  Thanks for writing this up, it made for some
interesting lunch time reading.  ;)

Here's a few typos I noticed, marked 'em up as I read along...


> +required for objects that are frequently logged. Parts inodes are

"Some parts of ..."?

> +The limitation on asynchrnous transaction throughput is the number

"asynchronous"

> +Effectively, this gives us the maximum bound out outstanding metadata

"out" -> "of"

> +formating the changes in a transaction to the log buffer. Hence we

"formatting"

> +One of the key changes that delayed logging makes to the operation of
> the
> +journalling subsystem is that is dissociates the amount of

"is" -> "it", and "disassociates" (or maybe "dissociates" is what you
meant, you chem freak you. ;)

> +recovered filesysetm is concerned, there may be many thousands of

filesystem.

> +This introduces lots of scope of deadlocks with transactions that are

"scope for deadlocks"?

> +The solution is relatively simple - it just a long time to recognise

"took a long time"

> +rewrite the vector addresses to point at the memory buffer we end up

"and rewriting the"

> with a
> +self-describing object that it can be passed to the log buffer write

"that can be"

> is entire
> +arbitrary and done to make it easy for debugging - the last items in

"is entirely"

> +crash during the write of a such a transaction could partially
> overwrites the

"partially overwrite"

> +format structure. That is, two vectors totalling roughly 150 bytes.

"totaling"

> +the write reservation (the actual space availble to the transaction)

"available"

> +checkpoint commit to complete. This background push checked and
> executed by transaction commit code.

"is checked"

> +log item completion. THe result of this is that pinning and unpinning

"The"

> +are entered and completed is the object considered clean.`

Spurious "`" there?

> +		=> gain confidence and fix problems reported by early
> +		   adopters (a.k.a. guinea pigs)

:-)


cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
