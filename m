Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A6C87F66
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 19:44:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 811278F8065
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 17:44:10 -0700 (PDT)
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.10]) by
	cuda.sgi.com with ESMTP id QFMZ9u1JJ9DEZNeo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 17:44:09 -0700 (PDT)
Message-ID: <5389252A.5050503@zytor.com>
Date: Fri, 30 May 2014 17:41:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401480116-1973111-12-git-send-email-arnd@arndb.de>
	<20140531003712.GH14410@dastard>
In-Reply-To: <20140531003712.GH14410@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com

On 05/30/2014 05:37 PM, Dave Chinner wrote:
> 
> IOWs, the filesystem has to be able to reject any attempt to set a
> timestamp that is can't represent on disk otherwise Bad Stuff will
> happen,

Actually it is questionable if it is worse to reject a timestamp or just
let it wrap.  Rejecting a valid timestamp is a bit like "You don't
exist, go away."

> and filesystems have to be able to specify in their on
> disk format what timestamp encoding is being used. The solution will
> be different for every filesystem that needs to support time beyond
> 2038.

Actually the cutoff can be really different for each filesystem, not
necessarily 2038.  However, I maintain the above still holds.

Consider a filesystem that kept timestamps in YYMMDDHHMMSS format.  What
would you have expected such a filesystem to do on Jan 1, 2000?

	-hpa


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
