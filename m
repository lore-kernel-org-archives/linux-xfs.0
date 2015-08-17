Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D55727F37
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 14:36:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD5878F8052
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 12:36:25 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id sGrKjU54CmKUxcIL (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 12:36:24 -0700 (PDT)
Date: Mon, 17 Aug 2015 12:36:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/11] xfsprogs: replace obsolete memalign with
	posix_memalign
Message-ID: <20150817193624.GA8444@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-9-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439828606-7886-9-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 06:23:23PM +0200, Jan Tulak wrote:
> Memalign from <malloc.h> was marked obsolete in favor of a posix
> variant from <stdlib.h>. So replace all calls and remove <malloc.h>
> includes. This also enhances support on other posix platforms,
> which doesn't have <malloc.h>.
> 
> Because posix_memalign returns any error as a return code, not in
> errno, change relevant checks in code (and add a missing one).

I have to say I hate the posix_memalign calling convention.  Any chance
you could just provide a memalign impementation using posix_memalign for
MacOS?

Something like:

static inline void *memalign(size_t alignment, size_t size)
{
	int error;
	void *buf;

	error = posix_memalign(&buf, alignment, size);
	if (error)
		errno = error;
		buf = NULL;
	}

	return buf;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
