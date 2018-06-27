Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39434 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752210AbeF0Xhd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Jun 2018 19:37:33 -0400
Subject: Re: Mounting xfs filesystem takes long time
References: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
 <20180619161819.GD21698@magnolia>
 <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
 <20180621191535.GI7508@wotan.suse.de>
 <89d39e37-3944-f58d-018c-d36bdc9f870c@sandeen.net>
 <CAJCQCtSHT7fcHHxBaTESq5cdQQnYH95maNHby4MULCkar6mfeg@mail.gmail.com>
 <20180621221911.GT19934@dastard>
 <CAJCQCtSzsYSyCD2eEvdgpKJ8ZFShsJrV2FxKZ4bv=-S6gpx2fw@mail.gmail.com>
 <20180622040221.GY19934@dastard> <20180627232333.GB21242@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <98c71f4a-94e5-00e8-46af-a4c3ca4e520b@sandeen.net>
Date: Wed, 27 Jun 2018 18:37:31 -0500
MIME-Version: 1.0
In-Reply-To: <20180627232333.GB21242@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "swadmin - levigo.de" <swadmin@levigo.de>, xfs list <linux-xfs@vger.kernel.org>



On 6/27/18 6:23 PM, Luis R. Rodriguez wrote:
> On Fri, Jun 22, 2018 at 02:02:21PM +1000, Dave Chinner wrote:
>> On Thu, Jun 21, 2018 at 09:19:54PM -0600, Chris Murphy wrote:
>>> On Thu, Jun 21, 2018 at 4:19 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>
>>>> The mkfs ratios are about as optimal as we can get for the
>>>> information we have about the storage - growing by
>>>> 10x (i.e.  increaseing the number of AGs by 10x) puts us at the
>>>> outside edge of the acceptible filesystem performance and longevity
>>>> charcteristics. Growing by 100x puts us way outside the window,
>>>> and examples like this where we are taking about growing by 10000x
>>>> is just way beyond anything the static AG layout architecture was
>>>> ever intended to support....
> 
> I don't  have time to test this but I can probably do so after my vacation
> (now). Would it be best to just codify this eventually instead of having
> this as tribal knowledge?

Honestly, if we wanted something like this I think it'd be based on terminal
AG count, not growfs multiplier for a specific instance.

Otherwise 100 consecutive 4x growfs's would yield the same problems without
tripping any of these tests.

-Eric

> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 8ec445afb74b..14f4b6dce08f 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -75,6 +75,9 @@ main(int argc, char **argv)
>  	fs_path_t		*fs;	/* mount point information */
>  	libxfs_init_t		xi;	/* libxfs structure */
>  	char			rpath[PATH_MAX];
> +	int			fflag;	/* -f flag */
> +	long long		dsize_max_suggested; /* max suggested size */
> +	long long		dsize_max_arch; /* max design over flow */
>  
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
> @@ -93,6 +96,8 @@ main(int argc, char **argv)
>  		case 'd':
>  			dflag = 1;
>  			break;
> +		case 'f':
> +			fflag = 1;
>  		case 'e':
>  			esize = atol(optarg);
>  			rflag = 1;
> @@ -249,6 +254,24 @@ main(int argc, char **argv)
>  	if (dflag | mflag | aflag) {
>  		xfs_growfs_data_t	in;
>  
> +		/*
> +		 * Growing the filesyste by 10x increases the AG size by 10 as
> +		 * well, and this puts us outside edge of the acceptible
> +		 * filesystem performance and longevity charcteristics.
> +		 *
> +		 * Growing by 100x puts us way outside the window...
> +		 *
> +		 * Growing by 10000x is just way beyond anything the static AG
> +		 * layout architecture was ever intended to support, so unless
> +		 * you use -f, we won't allow in between 10x-1000x.
> +		 */
> +		dsize_max_suggested = ddsize * 10 / (geo.blocksize / BBSIZE);
> +		if (dsize_max_suggested < ddsize)
> +			dsize_max_suggested = ULLONG_MAX;
> +		dsize_max_arch = ddsize * 1000 / (geo.blocksize / BBSIZE);
> +		if (dsize_max_arch < ddsize)
> +			dsize_max_arch = ULLONG_MAX;
> +
>  		if (!mflag)
>  			maxpct = geo.imaxpct;
>  		if (!dflag && !aflag)	/* Only mflag, no data size change */
> @@ -261,6 +284,26 @@ main(int argc, char **argv)
>  				(long long)dsize,
>  				(long long)(ddsize/(geo.blocksize/BBSIZE)));
>  			error = 1;
> +		} else if (!fflag &&
> +			   dsize > dsize_max_arch) {
> +			fprintf(stderr, _(
> +				"data size %lld beyond what XFS recomends for "
> +				"this fs, max should be %lld but if used you "
> +				"will suffer. Max suggested is %lld or use "
> +				"-f to override.\n"),
> +				(long long)dsize,
> +				dsize_max_arch,
> +				dsize_max_suggested);
> +			error = 1;
> +		} else if (!fflag &&
> +			   dsize > dsize_max_suggested) {
> +			fprintf(stderr, _(
> +				"data size %lld beyond what XFS recomends for "
> +				"this fs, max suggested is %lld or use "
> +				"-f to override.\n"),
> +				(long long)dsize,
> +				dsize_max_suggested);
> +			error = 1;
>  		}
>  
>  		if (!error && dsize < geo.datablocks) {
> 
