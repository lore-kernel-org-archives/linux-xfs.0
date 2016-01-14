Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F23267F50
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 04:20:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85D6EAC002
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 02:20:12 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HtVF5v0tPt32MnvH (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 02:20:10 -0800 (PST)
Date: Thu, 14 Jan 2016 02:20:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
Message-ID: <20160114102009.GD27644@infradead.org>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195945.GC568@nyan> <20160113075501.GC21939@infradead.org>
	<20160113174241.GC10942@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160113174241.GC10942@nyan>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jan 13, 2016 at 06:42:41PM +0100, Felix Janda wrote:
> Is this really performance relevant?

I'm not entirely sure.  There are systems with giant amounts of mounted
file systems, in which case iterating each of them and requiring
multiple syscalls each might not be a good idea.

> Hmm, so we couldn't we use for linux just something like
> 
> int
> platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
> {
> 	int fd = open(block, O_EXCL);
> 	int e = errno;
> 	
> 	if (fd != -1) close(fd);
> 	if (e == EBUSY) {
> 		if (verbose)
> 			fprintf(stderr, _("%s: %s contains a mounted filesystem\n"), progname, name);
> 		return 1;
> 	}
> 
> 	return 0;

Please give me a couple of days to come up with an idea to use O_EXCL
on Linux and work around it on other platforms in a more integrated way.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
