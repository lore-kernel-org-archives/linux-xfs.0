Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9E0RkWH162764 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 19:27:46 -0500
Received: from realbig.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81D132029
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 17:29:15 -0700 (PDT)
Received: from realbig.com (realbig.com [207.36.196.230]) by cuda.sgi.com with
	ESMTP id vDeHtUupGGUyyuxL for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2009 17:29:15 -0700 (PDT)
Date: Tue, 13 Oct 2009 19:29:00 -0500 (CDT)
From: Andy Poling <andy@realbig.com>
Subject: Re: Wrapped journal record corruption on read at recovery - patch
	attached (was Re: XFS corruption with failover)
In-Reply-To: <20091013233324.GA28942@infradead.org>
Message-ID: <alpine.DEB.2.00.0910131853200.11546@andydesk>
References: <mailman.0.1255458988.141519.xfs@oss.sgi.com>
	<alpine.DEB.2.00.0910131342440.11546@andydesk>
	<20091013233324.GA28942@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: John Quigley <jquigley@cleversafe.com>, xfs@oss.sgi.com

On Tue, 13 Oct 2009, Christoph Hellwig wrote:
> However the way this is written is a bit confusing.  Probably less
> confusing than some of the surrounding code,  but it adds up.
>
> We calculate the offset for one case above, and then after we're done
> with the reading that never touches offset we calculate it if we don't
> have it.
>
> So this at very least needs a big comment describing it, or even better
> moving up the xlog_align call so that we can simply always use
> offset directly, which could also get rid of the now superflous bufaddr
> variable by always using offset.
>
> Exactly the same also applies for the second use.
>
> Anyway, thanks a lot again and if you can fix this up I'd welcome it,
> otherwise I'll do it once I get some time.

Agreed.  I aimed for the smallest possible patch, thinking it might increase
the likelihood of acceptance.  :-)

I think the complexity here stems from an uncertainty (as we prepare for the
"second" read) whether there was a first read or not.  As the code reads
today, if there is data before the end, the first read is done and offset has
been set.  If not, offset is NULL.

It seems like the more elegant approach would be to set offset before the
first read, and then update it if the first read takes place (in case it was
unaligned).  That also gets rid of bufaddr, and seems like it might read
better.

I'll try that and see how it goes.


> I suspect we might even be able to come up with a small enough testcase
> for this for xfsqa, we just need to make sure logs are aligned and then
> find a good enough heuristic to reproduce log wrapping.

I don't know if it would be appropriate in that context, but maybe a tool to
process an unwrapped log and wrap it would be easier?

-Andy

It ain't what you don't know that gets you into trouble.
It's what you know for sure that just ain't so. - Mark Twain

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
