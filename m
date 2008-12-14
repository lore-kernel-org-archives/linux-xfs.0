Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBE3VPbT021466 for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 21:31:25 -0600
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
From: Redeeman <redeeman@metanurb.dk>
In-Reply-To: <4943F37B.8080405@sandeen.net>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<493A9BE7.3090001@sandeen.net>
	<alpine.DEB.1.10.0812130724340.18746@p34.internal.lan>
	(sfid-20081213_171213_704814_AA9856DD)
	<200812131826.25280.Martin@lichtvoll.de>
	<4943F37B.8080405@sandeen.net>
Date: Sun, 14 Dec 2008 04:31:20 +0100
Message-Id: <1229225480.16555.152.camel@localhost>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: linux-xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>, linux-raid@vger.kernel.orgxfs@oss.sgi.com

On Sat, 2008-12-13 at 11:40 -0600, Eric Sandeen wrote:
> Martin Steigerwald wrote:
> 
> > At the moment it appears to me that disabling write cache may often give 
> > more performance than using barriers. And this doesn't match my 
> > expectation of write barriers as a feature that enhances performance. 
> 
> Why do you have that expectation?  I've never seen barriers advertised
> as enhancing performance.  :)

My initial thoughts were that write barriers would enhance performance,
in that, you could have write cache on. So its really more of an
expectation that wc+barriers on, performs better than wc+barriers off :)

> 
> I do wonder why barriers on, write cache off is so slow; I'd have
> thought the barriers were a no-op.  Maybe I'm missing something.
> 
> > Right now a "nowcache" option and having this as default appears to make 
> > more sense than defaulting to barriers. 
> 
> I don't think that turning off write cache is something the filesystem
> can do; you have to take that as an administrative step on your block
> devices.
> 
> > But I think this needs more 
> > testing than just those simple high meta data load tests. Anyway I am 
> > happy cause I have a way to speed up XFS ;-).
> 
> My only hand-wavy concern is whether this has any adverse physical
> effect on the drive (no cache == lots more head movement etc?) but then
> barriers are constantly flushing/invalidating that cache, so it's
> probably a wash.  And really, I have no idea.  :)
> 
> -Eric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
