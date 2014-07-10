Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 107677F3F
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 08:48:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CAF64304067
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 06:48:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id hUSvFpe2DVdqCtHk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Jul 2014 06:48:53 -0700 (PDT)
Date: Thu, 10 Jul 2014 06:48:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: symlink loop for /lib64/libhandle.so
Message-ID: <20140710134851.GA26652@infradead.org>
References: <1404898212.7231.12.camel@jtulak>
	<20140709132836.GA65226@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140709132836.GA65226@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Jan ??ul??k <jan@tulak.me>, XFS mail list <xfs@oss.sgi.com>

On Wed, Jul 09, 2014 at 09:28:36AM -0400, Brian Foster wrote:
> > If it not an intended behavior, I can try to find the source of the bug
> > and make a patch (I'm new here :-).
> > 
> 
> I can reproduce this on fedora rawhide via 'make install-qa.' This is
> not intended behavior. I couldn't tell you what the problem is, but
> patches are certainly welcome. :)

This sounds like an fallout from the /lib -> /usr/lib symlink mess in
Fedora.  Might be worth taking a look at the specfile how Eric worked
around that for the RPM..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
