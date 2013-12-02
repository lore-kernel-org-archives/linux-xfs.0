Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6506029DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 11:04:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5389930407E
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 09:04:26 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id vVojLfZrYpTL6xDh (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 09:04:21 -0800 (PST)
Date: Mon, 2 Dec 2013 09:04:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/15] mkfs: validate all input values
Message-ID: <20131202170420.GA14935@infradead.org>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
In-Reply-To: <1385689430-10103-5-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4936769943326555936=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4936769943326555936==
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Nov 29, 2013 at 12:43:39PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Right now, mkfs does a poor job of input validation of values. Many
> parameters do not check for trailing garbage and so will pass
> obviously invalid values as OK. Some don't even detect completely
> invalid values, leaving it for other checks later on to fail due to
> a bad value conversion - these tend to rely on atoi() implicitly
> returning a sane value when it is passed garbage, and atoi gives no
> guarantee of the return value when passed garbage.

Would be useful to have a test case for some of these garbage values..

> Finally, the block size of the filesystem is not known until all
> the options have been parsed and we can determine if the default is
> to be used. This means any parameter that relies on using conversion
> from filesystem block size (the "NNNb" format) requires the block
> size to first be specified on the command line so it is known.
> 
> Similarly, we make the same rule for specifying counts in sectors.
> This is a change from the existing behaviour that assumes sectors
> are 512 bytes unless otherwise changed on the command line. This,
> unfortunately, leads to complete silliness where you can specify the
> sector size as a count of sectors. It also means that you can do
> some conversions with 512 byte sector sizes, and others with
> whatever was specified on the command line, meaning the mkfs
> behaviour changes depending in where in the command line the sector
> size is changed....

I wonder if this might break some existing uses.  The whole notion of
512byte sectors is so ingrained in most people that this doesn't sound
as stupid as it is.

Maybe just warn about that particular case for now instead of outright
rejecting it?

> +	creds.cr_uid = getnum(getstr(pp), 0, 0, false);
> +	creds.cr_gid = getnum(getstr(pp), 0, 0, false);

Not that I really care deeply, but requiring uids to be numeric seems a
little silly.  Maybe we should put accepting user and groups names on a
beginners todo list somewhere.

> +long long
> +getnum(
> +	const char	*str,
> +	unsigned int	blocksize,
> +	unsigned int	sectorsize,
> +	bool		convert)
> +{
> +	long long	i;
> +	char		*sp;
> +
> +	if (convert)
> +		return cvtnum(blocksize, sectorsize, str);
> +
> +	i = strtoll(str, &sp, 0);
> +	if (i == 0 && sp == str)
> +		return -1LL;
> +	if (*sp != '\0')
> +		return -1LL; /* trailing garbage */
> +	return i;
> +}

So this function does two totally different things based on the last
parameter?  Unless the answers is one of the next patches will fix it
¿ thyink it should be split.


--===============4936769943326555936==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4936769943326555936==--
