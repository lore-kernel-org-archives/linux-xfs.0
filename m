Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A23029DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:12:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E71E5AC004
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 15:12:45 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3WepkqEEOZP3To79 for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 15:12:44 -0800 (PST)
Date: Tue, 3 Dec 2013 10:12:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/15] mkfs: validate all input values
Message-ID: <20131202231202.GA10988@dastard>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-5-git-send-email-david@fromorbit.com>
	<20131202170420.GA14935@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20131202170420.GA14935@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5343116672677361142=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--===============5343116672677361142==
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Dec 02, 2013 at 09:04:20AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 29, 2013 at 12:43:39PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Right now, mkfs does a poor job of input validation of values. Many
> > parameters do not check for trailing garbage and so will pass
> > obviously invalid values as OK. Some don't even detect completely
> > invalid values, leaving it for other checks later on to fail due to
> > a bad value conversion - these tend to rely on atoi() implicitly
> > returning a sane value when it is passed garbage, and atoi gives no
> > guarantee of the return value when passed garbage.
> 
> Would be useful to have a test case for some of these garbage values..

Yes, I need to write a script that tests a large number of
valid/invalid command line options to make sure I haven't broken
random stuff. The conflicts part is the fun bit...

But, in general, stuff like this is what I'm trying to prevent:

# mkfs.xfs -d agcount=32fdsglkjg /dev/vda

will take that as a valid parameter with a value of 32....

> > Finally, the block size of the filesystem is not known until all
> > the options have been parsed and we can determine if the default is
> > to be used. This means any parameter that relies on using conversion
> > from filesystem block size (the "NNNb" format) requires the block
> > size to first be specified on the command line so it is known.
> > 
> > Similarly, we make the same rule for specifying counts in sectors.
> > This is a change from the existing behaviour that assumes sectors
> > are 512 bytes unless otherwise changed on the command line. This,
> > unfortunately, leads to complete silliness where you can specify the
> > sector size as a count of sectors. It also means that you can do
> > some conversions with 512 byte sector sizes, and others with
> > whatever was specified on the command line, meaning the mkfs
> > behaviour changes depending in where in the command line the sector
> > size is changed....
> 
> I wonder if this might break some existing uses.  The whole notion of
> 512byte sectors is so ingrained in most people that this doesn't sound
> as stupid as it is.
> 
> Maybe just warn about that particular case for now instead of outright
> rejecting it?

How does this make sense, though?

# mkfs.xfs -s size=4s /dev/vda

Specifying the sector size in *sectors* is currently considered a
valid thing to do. That's insane and fundamentally broken, because
this

# mkfs.xfs -b size=4s -s size=2s /dev/vda

results in the block size conversion using a 512 byte sector size,
and everything else using a 1024 byte sector size for conversions.
e.g:

# mkfs.xfs -b size=4s -s size=2s -n size=2s /dev/vda

results in a block size of 2k (4*512) and a directory block size of
2k (2*1024). i.e. the result of unit conversion is dependent on
where the sector size is specified on the command line!

> > +	creds.cr_uid = getnum(getstr(pp), 0, 0, false);
> > +	creds.cr_gid = getnum(getstr(pp), 0, 0, false);
> 
> Not that I really care deeply, but requiring uids to be numeric seems a
> little silly.  Maybe we should put accepting user and groups names on a
> beginners todo list somewhere.

Yup, seems like a goo idea to support that...

> 
> > +long long
> > +getnum(
> > +	const char	*str,
> > +	unsigned int	blocksize,
> > +	unsigned int	sectorsize,
> > +	bool		convert)
> > +{
> > +	long long	i;
> > +	char		*sp;
> > +
> > +	if (convert)
> > +		return cvtnum(blocksize, sectorsize, str);
> > +
> > +	i = strtoll(str, &sp, 0);
> > +	if (i == 0 && sp == str)
> > +		return -1LL;
> > +	if (*sp != '\0')
> > +		return -1LL; /* trailing garbage */
> > +	return i;
> > +}
> 
> So this function does two totally different things based on the last
> parameter?  Unless the answers is one of the next patches will fix it
> ¿ thyink it should be split.

That function grows a lot more checking of the values - min/max
checking, conflict/respec checking, etc as everything gets converted
to struct based checking.

What I intended to do was remove cvtnum() altogether as it is now a
direct copy of the cvtnum function in libxcmd/input.c::cvtnum() and
just link against libxcmd. I haven't got that far yet - I might just
move cvtnum into getnum() and be done with it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


--===============5343116672677361142==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5343116672677361142==--
