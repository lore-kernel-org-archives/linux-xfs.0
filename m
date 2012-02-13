Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DHFxjq026850 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 11:15:59 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dRcMGvgmBgQhIEQK (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 09:15:58 -0800 (PST)
Date: Mon, 13 Feb 2012 12:15:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
Message-ID: <20120213171556.GA13449@infradead.org>
References: <4F394116.8080200@cape-horn-eng.com>
	<20120213170825.GA7197@infradead.org>
	<4F394442.9020307@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F394442.9020307@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Feb 13, 2012 at 06:11:30PM +0100, Richard Ems wrote:
> On 02/13/2012 06:08 PM, Christoph Hellwig wrote:
> > On Mon, Feb 13, 2012 at 05:57:58PM +0100, Richard Ems wrote:
> >> This is a backup system running dirvish, so most files in the dirs I am
> >> removing are hard links. Almost all of the files do have ACLs set.
> > 
> > How many ACLs do you usually have set?  If they aren't stored inline
> > but need to go out of the inode unlinks will be extremly slow for
> > kernels before v3.2.
> > 
> 
> Almost all dirs and files there do have ACLs set.
> Each of them do have about 10 user ACLs and 10 default ACls.
> Is that too many?
> Is this then the reason for being that slow?

That doesn't sound like a lot to me, but instead of guessing around,
let's just check the actual facts.

Does "xfs_bmap -a" for the kind of files you are deleting show any
extents? If it doesn't the output will look like:

# xfs_bmap -a internal
internal: no extents

if it has any it will look like:

# xfs_bmap -a external
external:
	0: [0..7]: 8557712..8557719

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
