Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7EB0D7F93
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 02:44:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 52B25304053
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 00:44:57 -0800 (PST)
Received: from shards.monkeyblade.net (shards.monkeyblade.net [149.20.54.216])
	by cuda.sgi.com with ESMTP id aq2d12nH1V1Kv8JK for
	<xfs@oss.sgi.com>; Sat, 18 Jan 2014 00:44:56 -0800 (PST)
Date: Sat, 18 Jan 2014 00:44:53 -0800 (PST)
Message-Id: <20140118.004453.1800341321580114709.davem@davemloft.net>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140118082730.GH10323@ZenIV.linux.org.uk>
References: <CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<20140118082730.GH10323@ZenIV.linux.org.uk>
Mime-Version: 1.0
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
To: viro@ZenIV.linux.org.uk
Cc: axboe@kernel.dk, sfrench@samba.org, sage@inktank.com, mfasheh@suse.com, xfs@oss.sgi.com, hch@infradead.org, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sat, 18 Jan 2014 08:27:30 +0000

> BTW, would sockets benefit from having ->sendpages() that would take an
> array of (page, offset, len) triples?  It would be trivial to do and
> some of the helpers that are falling out of writing that writev-based
> default_file_splice_write() look like they could be reused for
> calling that one...  Dave?

That's originally how the sendpage method was implemented, but back then
Linus asked us to only pass one page at a time.

I don't remember the details beyond that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
