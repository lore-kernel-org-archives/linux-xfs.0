Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 395AF29E00
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 18:57:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3F08AC002
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 16:57:25 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id d6OoAixwP95vdnyN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 30 Mar 2014 16:57:22 -0700 (PDT)
Date: Mon, 31 Mar 2014 00:57:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs i_lock vs mmap_sem lockdep trace.
Message-ID: <20140330235717.GO18016@ZenIV.linux.org.uk>
References: <20140329223109.GA24098@redhat.com>
	<20140330234335.GB16336@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140330234335.GB16336@dastard>
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
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Mar 31, 2014 at 10:43:35AM +1100, Dave Chinner wrote:
> filldir on a directory inode vs page fault on regular file. Known
> issue, definitely a false positive. We have to change locking
> algorithms to avoid such deficiencies of lockdep (a case of "lockdep
> considered harmful", perhaps?) so it's not something I'm about to
> rush...

Give i_lock on directories a separate class, as it's been done for i_mutex...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
