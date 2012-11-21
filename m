Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAL9sSoW029140 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 03:54:28 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1uc1sb0EQZ4Ebied (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 01:56:38 -0800 (PST)
Date: Wed, 21 Nov 2012 04:56:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] mkfs.xfs: go into multidisk mode when geometry is
	on cmdline
Message-ID: <20121121095636.GC23339@infradead.org>
References: <50ABB115.9070905@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50ABB115.9070905@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ben England <bengland@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Nov 20, 2012 at 10:34:29AM -0600, Eric Sandeen wrote:
> So now for a ~5T fs, for example, we'd make several more
> AGs:
> 
> # truncate --size=5t fsfile
> # mkfs.xfs -N -d su=128k,sw=8 fsfile | grep agcount
> meta-data=fsfile                 isize=256    agcount=5, agsize=268435424 blks
> # mkfs/mkfs.xfs -N -d su=128k,sw=8 fsfile | grep agcount
> meta-data=fsfile                 isize=256    agcount=32, agsize=41943008 blks

Can you add this to xfstests, please?

> TBH, though, is there ever any value in treating a very large
> fs as "!multidisk?"  When would we ever want to pretend that
> a 16T filesystem doesn't have a lot of spindles behind it?

Not now, but I'm pretty sure we'll get there not too soon in the
future.

> +	} else if (daflag)	/* User-specified AG count */
> +		agsize = dblocks / agcount + (dblocks % agcount != 0);
> +	else
> +		calc_default_ag_geometry(blocklog, dblocks,
> +				dsunit | dswidth, &agsize, &agcount);
> +

I know the code was just moved, but can you add braces to the else if
constructs so that the whole if else if else has consistent bracing?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
