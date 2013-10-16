Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E6FB67F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 13:12:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D99478F8081
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 11:12:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 0MBpvzhe4aYBvl9d (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 11:12:38 -0700 (PDT)
Date: Wed, 16 Oct 2013 11:12:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fs/attr.c:notify_change locking warning.
Message-ID: <20131016181234.GA26646@infradead.org>
References: <20131005005210.GA25773@redhat.com> <20131005031918.GL4446@dastard>
	<20131015201905.GA7509@infradead.org>
	<20131015213618.GU4446@dastard>
	<20131016070528.GB18721@infradead.org>
	<20131016102651.GF4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131016102651.GF4446@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Wed, Oct 16, 2013 at 09:26:51PM +1100, Dave Chinner wrote:
> The killpriv calls? I couldn't find anything that implemented those
> security hooks nor any documentation about it, so I'm pretty much
> clueless about it. FWIW, ocfs2 doesn't implement them, either....

The killpriv code ends up doing xattr calls for per-file capabilities
(grep security/commoncap.c for killpriv).  Seems like ocfs2 is buggy in
that regard.

I suspect the easiest way to solve it properly in XFS is to simply
retake the iolock exclusive and get the i_mutex as part of it.  This
means direct I/O writes to files with the suid bit won't scale, but I
think we can live with that given that it avoids introducing special
cases that impact more code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
