Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3CB127CA0
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 09:55:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F241C304032
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 07:55:06 -0700 (PDT)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id HUs9Eu0ujscLkLHm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 18 Jun 2016 07:55:04 -0700 (PDT)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 87CE520A88
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 16:55:03 +0200 (CEST)
Date: Sat, 18 Jun 2016 16:53:49 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
Message-ID: <20160618145349.GA17760@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195945.GC568@nyan> <20160113075501.GC21939@infradead.org>
	<20160113174241.GC10942@nyan>
	<20160114102009.GD27644@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160114102009.GD27644@infradead.org>
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

On Thu, 14 Jan 2016 at 02:20:09 -0800, Christoph Hellwig wrote:
> On Wed, Jan 13, 2016 at 06:42:41PM +0100, Felix Janda wrote:
> > Is this really performance relevant?
> 
> I'm not entirely sure.  There are systems with giant amounts of mounted
> file systems, in which case iterating each of them and requiring
> multiple syscalls each might not be a good idea.
> 
> > Hmm, so we couldn't we use for linux just something like
> > 
> > int
> > platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
> > {
> > 	int fd = open(block, O_EXCL);
> > 	int e = errno;
> > 	
> > 	if (fd != -1) close(fd);
> > 	if (e == EBUSY) {
> > 		if (verbose)
> > 			fprintf(stderr, _("%s: %s contains a mounted filesystem\n"), progname, name);
> > 		return 1;
> > 	}
> > 
> > 	return 0;
> 
> Please give me a couple of days to come up with an idea to use O_EXCL
> on Linux and work around it on other platforms in a more integrated way.

Ping?

Thanks,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
