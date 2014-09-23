Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 42F987F4E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 22:44:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 308AD304039
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 20:44:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id T2VjMj7o92zG286F (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 20:44:19 -0700 (PDT)
Date: Tue, 23 Sep 2014 00:43:52 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: beginners project: RENAME_EXCHANGE
Message-ID: <20140923034351.GB25353@localhost.localdomain>
References: <20140922173545.GA20308@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140922173545.GA20308@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi, for some time I don't work on anything upstream due being very busy with
another stuff, I'm interested in take this project if nobody has objections

On Mon, Sep 22, 2014 at 10:35:45AM -0700, Christoph Hellwig wrote:
> As people are looking for beginners projects one in a while there's
> an easy one at the moment:  implement support for the RENAME_EXCHANGE
> flag to the renameat2 system call, which swaps the names for two
> existing files.  Documentation here:
> 
> http://man7.org/linux/man-pages/man2/rename.2.html
> 
> This should mostly be doable by refactoring (or more likely copy &
> pasting) the existing rename implementation.  xfstests already has test
> case for it, although making sure they covering everything would be a
> nice extrea.
> 
> (if no one replies to the list I will add it to the wiki after a while)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
