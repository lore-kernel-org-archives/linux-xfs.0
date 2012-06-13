Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D6OLCs094610 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 01:24:21 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id uSwJSyNQtTgyDFIA
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jun 2012 23:24:20 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so2255991pbb.26
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 23:24:20 -0700 (PDT)
Message-ID: <4FD8320C.1060308@redhat.com>
Date: Wed, 13 Jun 2012 08:24:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: add FALLOC_FL_ZERO_RANGE to fallocate
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
	<1339515364-17374-3-git-send-email-pbonzini@redhat.com>
	<20120613021610.GQ22848@dastard>
In-Reply-To: <20120613021610.GQ22848@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

Il 13/06/2012 04:16, Dave Chinner ha scritto:
>> > +	BUG_ON((mode & FALLOC_FL_PUNCH_HOLE) && (mode & FALLOC_FL_ZERO_RANGE));
> Never put BUG_ON() or BUG() in XFS code that can return an error.
> Return EINVAL if we chose not to support it, and if it's really
> something we consider bad, emit a warning to syslog (i.e.
> xfs_warn()) and potentially add a ASSERT() case so that debug
> kernels will trip over it. Nobody should be panicing a production
> system just because a user supplied a set of incorrect syscall
> paramters....

I know, the BUG_ON() is because it is ruled out in VFS code.  Of course
if I remove that code, this will not be a BUG_ON() anymore.

Paolo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
