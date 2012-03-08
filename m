Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q288obZ0002345 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 02:50:37 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id 5uv3zbj9NYhBKlCo for
	<xfs@oss.sgi.com>; Thu, 08 Mar 2012 00:50:35 -0800 (PST)
Date: Thu, 8 Mar 2012 08:50:35 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: df bigger than ls?
Message-ID: <20120308085035.GA23992@nsrc.org>
References: <20120307155439.GA23360@nsrc.org>
	<20120307171619.GA23557@nsrc.org> <4F57A32A.5010704@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F57A32A.5010704@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Wed, Mar 07, 2012 at 12:04:26PM -0600, Eric Sandeen wrote:
> XFS speculatively preallocates space off the end of a file.  The amount of
> space allocated depends on the present size of the file, and the amount of
> available free space.  This can be overridden
> with mount -o allocsize=64k (or other size for example)

Aha.  This may well be what is screwing up gluster's disk usage on a striped
volume - I believe XFS is preallocating space which is actually going to end
up being a hole!

Here are the extent maps for two of the twelve files in my stripe:

root@storage1:~# xfs_bmap /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff 
/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff:
	0: [0..255]: 2933325744..2933325999
	1: [256..3071]: hole
	2: [3072..3327]: 2933326000..2933326255
	3: [3328..6143]: hole
	4: [6144..8191]: 2933326472..2933328519
	5: [8192..9215]: hole
	6: [9216..13311]: 2933369480..2933373575
	7: [13312..15359]: hole
	8: [15360..23551]: 2933375624..2933383815
	9: [23552..24575]: hole
	10: [24576..40959]: 2933587168..2933603551
	11: [40960..43007]: hole
	12: [43008..75775]: 2933623008..2933655775
	13: [75776..76799]: hole
	14: [76800..142335]: 2933656800..2933722335
	15: [142336..144383]: hole
	16: [144384..275455]: 2933724384..2933855455
	17: [275456..276479]: hole
	18: [276480..538623]: 2935019808..2935281951
	19: [538624..540671]: hole
	20: [540672..1064959]: 2935284000..2935808287
	21: [1064960..1065983]: hole
	22: [1065984..2114559]: 2935809312..2936857887
	23: [2114560..2116607]: hole
	24: [2116608..2119935]: 2943037984..2943041311
root@storage1:~# xfs_bmap /disk2/scratch2/work/PRSRA1/PRSRA1.1.0.bff 
/disk2/scratch2/work/PRSRA1/PRSRA1.1.0.bff:
	0: [0..255]: hole
	1: [256..511]: 2933194944..2933195199
	2: [512..3327]: hole
	3: [3328..3839]: 2933195200..2933195711
	4: [3840..6399]: hole
	5: [6400..8447]: 2933204416..2933206463
	6: [8448..9471]: hole
	7: [9472..13567]: 2933328792..2933332887
	8: [13568..15615]: hole
	9: [15616..23807]: 2933334936..2933343127
	10: [23808..24831]: hole
	11: [24832..41215]: 2933344152..2933360535
	12: [41216..43263]: hole
	13: [43264..76031]: 2934672032..2934704799
	14: [76032..77055]: hole
	15: [77056..142591]: 2934705824..2934771359
	16: [142592..144639]: hole
	17: [144640..275711]: 2934773408..2934904479
	18: [275712..276735]: hole
	19: [276736..538879]: 2934343328..2934605471
	20: [538880..540927]: hole
	21: [540928..1065215]: 2935498152..2936022439
	22: [1065216..1066239]: hole
	23: [1066240..2114815]: 2936023464..2937072039
	24: [2114816..2116863]: hole
	25: [2116864..2120191]: 2937074088..2937077415

You can see that at the start it works fine. There is a stripe size of
256 blocks, so:

* disk 1:    data for 1 x 256 blocks     <-- stripe 0, chunk 0
             hole for 11 x 256 blocks
             data for 1 x 256 block      <-- stripe 0, chunk 1
             ...

* disk 2:    hole for 1 x 256 blocks
             data for 1 x 256 blocks     <-- stripe 1, chunk 0
             hole for 11 x 256 blocks
             data for 1 x 256 blocks     <-- stripe 1, chunk 1
             ...

But after four chunks it gets screwed up. By the end the files are mostly
extent and hardly any hole.  The extent sizes increase in roughly powers of
two which seems to match the speculative preallocation algorithm.

I think this ought to be fixable. For example, if you seek *into* the
preallocated area and start writing, could you change the preallocation to
start at this location with a hole before?

(But would that mess up some 'seeky' workloads like databases? But they
would have ended up creating holes in filesystems which don't have
preallocation, so I doubt they do this)

Or for a more sledgehammer approach: if a file already contains any holes
then you could just disable preallocation completely.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
