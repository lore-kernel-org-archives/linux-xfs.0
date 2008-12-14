Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBEHncDP008657
	for <linux-xfs@oss.sgi.com>; Sun, 14 Dec 2008 11:49:38 -0600
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sun, 14 Dec 2008 18:49:32 +0100
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<4943F37B.8080405@sandeen.net>
	<1229225480.16555.152.camel@localhost>
	(sfid-20081214_183451_158861_5E7EF8DA)
In-Reply-To: <1229225480.16555.152.camel@localhost>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812141849.33534.Martin@lichtvoll.de>
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
To: linux-xfs@oss.sgi.com
Cc: linux-raid@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Alan Piszcz <ap@solarrain.com>, Redeeman <redeeman@metanurb.dk>

Am Sonntag 14 Dezember 2008 schrieb Redeeman:
> On Sat, 2008-12-13 at 11:40 -0600, Eric Sandeen wrote:
> > Martin Steigerwald wrote:
> > > At the moment it appears to me that disabling write cache may often
> > > give more performance than using barriers. And this doesn't match
> > > my expectation of write barriers as a feature that enhances
> > > performance.
> >
> > Why do you have that expectation?  I've never seen barriers
> > advertised as enhancing performance.  :)
>
> My initial thoughts were that write barriers would enhance performance,
> in that, you could have write cache on. So its really more of an
> expectation that wc+barriers on, performs better than wc+barriers off
> :)

Exactly that. My expectation from my technical understanding of the write 
barrier feature is from most performant to least performant:

1) Write cache + no barrier, but NVRAM ;)
2) Write cache + barrier
3) No write cache, where is shouldn't matter whether barrier was enabled 
or not

With 1 write requests are unordered, thus meta data changes could be 
applied in place before landing into the journal for example, thus NVRAM 
is a must. With 2 write requests are unordered except for certain 
markers, the barriers that say: Anything before the barrier goes before 
and anything after the barrier goes after it. This leaves room for 
optimizing the write requests before and after - either in-kernel by an 
IO scheduler or in firmware by NCQ, TCQ, FUA. And with 3 write requests 
would always be ordered... and if the filesystems places a marker - a 
sync in this case - any write requests that are in flight till then have 
to land on disk before the filesystem can proceed.

>From that understanding, which I explained in detail in my Linux-Magazin 
article[1] I always thought that write cache + barrier has to be faster 
than no write cache.

Well I am ready to learn more. But for me until now that was the whole 
point of the effort with write barriers. Seems I completely misunderstood 
their purpose if thats not what they where meant for.

[1] Only in german, it had een translated to english but never published: 
http://www.linux-magazin.de/online_artikel/beschraenktes_schreiben

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
