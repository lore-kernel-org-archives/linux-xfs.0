Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A9587F6F
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 10:39:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7E36C304062
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 08:39:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id SHk9izTcbQo98KdL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 08:39:23 -0700 (PDT)
Date: Tue, 15 Jul 2014 08:39:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] logprint: Fix printing of AGF buffers
Message-ID: <20140715153922.GB5369@infradead.org>
References: <1405349100-19734-1-git-send-email-jack@suse.cz>
	<20140715101931.GC30363@infradead.org>
	<20140715140938.GA1733@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140715140938.GA1733@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 15, 2014 at 04:09:38PM +0200, Jan Kara wrote:
>   I had a look before I submitted this patch and I didn't find anything.
> Now that I'm looking again, AGI buffers probably need a similar treatment.
> Superblock buffers are already checked against fixed number so those don't
> have a problem. Dquot buffers should be fine as well because those don't
> have a checksum and other unlogged stuff. And I didn't find any other
> structures in the log that would have the problem (please point me if I
> missed something).
> 
> Regarding how to fix this cleanly - offsetof() seems like a reasonably
> clean way to me. If you prefer to define number of bytes each buffer type
> has to have in the log, I can do that as well. Or I could define
> alternative structures only containing fields we need in the log so that we
> can print info but this all seems like an additional complexity with
> disputable gain...

I've taken a bit of a closer log (OMG, what a mess logprint is..), and
it seems at least in this are the AGF and AGI are affected of the struct
growth in v4.

It seems like in this specific case using your offsetoff trick is
fine, it just needs a good comment explaining it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
