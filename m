Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6AKGX7D119702 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 15:16:33 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F5CE3588B0
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 13:17:09 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id DTUFDvbjmLcwNiE0 for
	<xfs@oss.sgi.com>; Fri, 10 Jul 2009 13:17:09 -0700 (PDT)
Message-ID: <4A57A1C4.40004@sandeen.net>
Date: Fri, 10 Jul 2009 15:17:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair stops on "traversing filesystem..."
References: <4A55FAF7.5040908@gmail.com> <4A56D176.9010702@sandeen.net>
	<4A56ED5F.10400@gmail.com>
In-Reply-To: <4A56ED5F.10400@gmail.com>
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
To: Tomek Kruszona <bloodyscarion@gmail.com>
Cc: xfs@oss.sgi.com

Tomek Kruszona wrote:
> Eric Sandeen wrote:
>> No fix for you yet, but it's in cache_node_get(), in the for(;;) loop,
>> and it looks like cache_node_allocate() fails to get a new node and we
>> keep spinning.  I need to look some more at what's going on....
> 
> Hello!
> 
> Is this specific behavior for this particular broken filesystem or is it
> a bug in functions you mentioned? I'm just curious :)

This looks like some of the caching that xfs_repair does is mis-sized,
and it gets stuck when it's unable to find a slot for a new node to
cache.  IMHO that's still a bug that I'd like to work out.  If it gets
stuck this way, it'd probably be better to exit, and suggest a larger
hash size.

But anyway, I forced a bigger hash size:

xfs_repair -P -o bhash=1024 <blah>

and it did complete.  1024 is probably over the top, but it worked for
me on a 4G machine w/ some swap.

I'd strongly suggest doing a non-obfuscated xfs_metadump, do
xfs_mdrestore of that to some temp.img, run xfs_repair <blah> on that
temp.img, mount it, and see what you're left with; that way you'll know
what you're getting into w/ repair.

I ended up w/ about 5000 files in lost+found just FWIW...

Out of curiosity, do you know how the fs was damaged?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
