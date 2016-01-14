Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A0AC67F47
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 13:10:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 932628F8065
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 11:10:14 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id jsTS6kKmGdxuwtDY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 11:10:13 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 68DD320B9B
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 20:10:12 +0100 (CET)
Date: Thu, 14 Jan 2016 20:07:35 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
Message-ID: <20160114190735.GB627@nyan>
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

Christoph Hellwig wrote:
> On Wed, Jan 13, 2016 at 06:42:41PM +0100, Felix Janda wrote:
> > Is this really performance relevant?
> 
> I'm not entirely sure.  There are systems with giant amounts of mounted
> file systems, in which case iterating each of them and requiring
> multiple syscalls each might not be a good idea.

Of course, it is not very elegant...

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

No problem. Thank you!

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
