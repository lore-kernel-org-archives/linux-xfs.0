Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 36B247CA4
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 16:54:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E04698F8037
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 14:54:06 -0700 (PDT)
Received: from mx5-phx2.redhat.com (mx5-phx2.redhat.com [209.132.183.37]) by
	cuda.sgi.com with ESMTP id S2QENK5FmuYrkSVV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 14:54:04 -0700 (PDT)
Date: Tue, 6 Sep 2016 17:53:59 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <58974432.234567.1473198839605.JavaMail.zimbra@redhat.com>
In-Reply-To: <20160903003919.GI30056@dastard>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
	<1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
	<20160903003919.GI30056@dastard>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
	detected
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com



----- Original Message -----
> Fundamentally a splice infrastructure problem. If we let splice race
> with hole punch and other fallocate() based extent manipulations to
> avoid this lockdep warning, we allow potential for read or write to
> regions of the file that have been freed. We can live with having
> lockdep complain about this potential deadlock as it is unlikely to
> ever occur in practice. The other option is simply not an acceptible
> solution....
The problem with living with having this lockdep complain that
it seems once this lockdep happens, it will prevent other complains from
showing up. For example, I have to apply the commit dc3a04d to fix an early
rcu lockdep first during the bisecting.
   CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
