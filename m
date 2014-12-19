Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 99EED7F3F
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 14:27:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 793E08F8039
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 12:27:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WTACUqbBiZVrSj6p (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Dec 2014 12:27:02 -0800 (PST)
Date: Fri, 19 Dec 2014 15:26:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_repair: fix max block offset test
Message-ID: <20141219202656.GA19036@laptop.bfoster>
References: <5489DA3B.5050908@redhat.com>
	<20141218151835.GC13471@laptop.bfoster>
	<5494745E.60500@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5494745E.60500@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Dec 19, 2014 at 12:54:22PM -0600, Eric Sandeen wrote:
> On 12/18/14 9:18 AM, Brian Foster wrote:
> 
> hought this looked familiar:
> > 
> > http://oss.sgi.com/archives/xfs/2014-09/msg00524.html
> > 
> > Either one is fine with me. If we use the fix below, I think we should
> > update the error message since it technically refers to the extent
> > offset and we slightly tweak the meaning of the failure.
> > 
> > Brian
> 
> Ok, so here's what I wonder about with your patch.
> 
> +               if (irec.br_startoff > fs_max_file_offset)  {
> 
> What if the extent starting logical offset is *at* fs_max_file_offset
> (which is sadly in blocks, not bytes, for extra confusion points),
> but the extent is 1GB in length?
> 
> Isn't this a problem because we've now got files in the block which
> are beyond fs_max_file_offset, and probably also beyond sb_maxbytes?
> 

Yeah... at the time I simply viewed this as outside the scope of this
particular check due to the logic and wording. It makes sense to widen
the logic to catch anything that starts before yet extends past max
offset, assuming we aren't actually checking that anywhere else.

> I'm not sure I follow why you feel the message needs to change with
> my version:
> 
> +		/* Ensure this extent does not extend beyond the max offset */
> +		if (irec.br_startoff + irec.br_blockcount - 1 >
> +							fs_max_file_offset) {
>                         do_warn(
> _("inode %" PRIu64 " - extent offset too large - start %" PRIu64 ", "
>   "count %" PRIu64 ", offset %" PRIu64 "\n"),
>                                 ino, irec.br_startblock, irec.br_blockcount,
>                                 irec.br_startoff);
> 
> If any (block) offset in the file is beyond the max, then we say the offset is
> too large, and give it's physical block, its length, and its starting offset
> (granted, the message is a bit *weird* - br_startblock really doesn't matter
> here, but I don't think I've fundamentally changed the meaning of the test).

As discussed on irc, I read "extent offset" as the offset of the extent
in the file, so it seemed a bit confusing if br_startoff isn't
necessarily the problem.

Brian

> 
> However, I've come to learn that you are almost always right about subtleties
> like this, so perhaps you can explain again to me, using smaller words.  :)
> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
