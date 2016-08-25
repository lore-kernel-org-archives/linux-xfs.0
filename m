Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5ABE87CA0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 03:04:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1FAF030404E
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 01:04:07 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZLX0VyP4pIl8ZwHw (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 01:04:05 -0700 (PDT)
Date: Thu, 25 Aug 2016 01:04:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 xfsprogs 00/14] Convert from off64_t to off_t
Message-ID: <20160825080402.GA28747@infradead.org>
References: <cover.1471107858.git.felix.janda@posteo.de>
	<20160824011911.GA19025@dastard> <20160824204746.GA25162@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160824204746.GA25162@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Wed, Aug 24, 2016 at 10:47:46PM +0200, Felix Janda wrote:
> > screws up xfstests because it changes all the error messages
> > that are output to stderr and captured by the test harness.
> > There are quite a few tests that this causes failures for,
> > and because it's stderr, it's not as simple as just adding a new
> > filter to do 'sed -e "s/^\(.*\)64\(: .*$\)/\1\2/"' on stderr.
> 
> Thanks for testing!
> 
> I can rework the patches to leave stderr unchanged. I guess that this
> is preferable as opposed to updating the output expected by xfstests
> since xfstests should be usable with both old and new xfsprogs.

I would prefer to change the output if we can find a good way to
filter it.  I suspect the issues are things like perror lines
which would look odd if we leave the 64 back in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
