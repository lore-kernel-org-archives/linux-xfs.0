Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E1E27F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 11:45:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D50A8F8040
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 09:45:24 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id 0MedDD743JM9PWsZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2016 09:45:18 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id A6FAF20AD9
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 18:45:16 +0100 (CET)
Date: Wed, 13 Jan 2016 18:42:41 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
Message-ID: <20160113174241.GC10942@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195945.GC568@nyan> <20160113075501.GC21939@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160113075501.GC21939@infradead.org>
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
> On Tue, Jan 12, 2016 at 08:59:45PM +0100, Felix Janda wrote:
> > ustat has been used to check whether a device file is mounted.
> > The function is deprecated and not supported by uclibc and musl.
> > Now do the check using the *mntent functions.
> > 
> > Based on patch by Natanael Copa <ncopa@alpinelinux.org>.
> > 
> > Signed-off-by: Felix Janda <felix.janda@posteo.de>
> 
> ustat is a lot more efficient in checking for the mountedness
> than this loop, so I'd really prefer not to do this unconditionally.

Is this really performance relevant?

Notice that linux's platform_check_iswritable does something very
similar. I've tried to make it consistent with the version from
freebsd.c.

> As far as Linux is concerned the best thing we could do is to use
> O_EXCL for any open of a device file, as Linux overloadds O_EXCL
> behavior for block devices so that any other O_EXCL open will
> be rejected if one has the file open.
> 
> But that might be a major pain to find into the cross platform
> framework..

Hmm, so we couldn't we use for linux just something like

int
platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
{
	int fd = open(block, O_EXCL);
	int e = errno;
	
	if (fd != -1) close(fd);
	if (e == EBUSY) {
		if (verbose)
			fprintf(stderr, _("%s: %s contains a mounted filesystem\n"), progname, name);
		return 1;
	}

	return 0;
}


Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
