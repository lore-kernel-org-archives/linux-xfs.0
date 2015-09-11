Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE59D7F37
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 01:19:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BEDFE8F8049
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 23:19:54 -0700 (PDT)
Received: from posti6.jyu.fi (posti6.jyu.fi [130.234.4.43]) by cuda.sgi.com
	with ESMTP id 8Z5KN3k2j2rYFrDE (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2015 23:19:52 -0700 (PDT)
Date: Fri, 11 Sep 2015 09:19:47 +0300
From: Tapani Tarvainen <tapani.j.tarvainen@jyu.fi>
Subject: Re: "This is a bug."
Message-ID: <20150911061947.GA3398@tehanu.it.jyu.fi>
References: <20150910123030.GG26847@tehanu.it.jyu.fi>
	<20150910123603.GA27863@bfoster.bfoster>
	<20150910125441.GA28374@tehanu.it.jyu.fi>
	<20150910130106.GB27863@bfoster.bfoster>
	<20150910130530.GB28374@tehanu.it.jyu.fi>
	<20150910145154.GC27863@bfoster.bfoster>
	<20150910173138.GB18940@tarvainen.info>
	<20150910175557.GE27863@bfoster.bfoster>
	<20150910180339.GB18739@tarvainen.info>
	<20150910183358.GF27863@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910183358.GF27863@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 10 Sep 14:33, Brian Foster (bfoster@redhat.com) wrote:

> > >... was the filesystem created small and then grown to a much
> > > larger size via xfs_growfs?
> > 
> > Almost certainly yes, although how small it initially was I'm not
> > sure.

It actually been grown several times over the years - the system is
rather old. Indeed, all its disks have been replaced with bigger ones
without reinstallation, so the filesystem could not have been
initially created as big as it is now.

> That probably explains that then. While growfs is obviously supported,
> it's not usually a great idea to grow from something really small to
> really large like this

That's good to know - but sometimes you just can't plan
ahead far enough.

> I'd expect such a large filesystem with such small allocation groups to
> probably introduce overhead in terms of metadata usage (24k agi's,
> agf's, 2x free space btrees and 1x inode btree per AG), spending more
> time in AG selection algorithms for allocations and whatnot, increased
> fragmentation due to capping the maximum contiguous extent size,
> creating more work for userspace tools such as repair, etc., and
> probably to have other weird or non-obvious side effects that I'm not
> familiar with.

So it's likely to also make it more fragile and harder to repair in
case of a disaster like this.

So, my take from this is that

(1) The bug was real but it was just in the old version of xfs_repair
in Debian Wheezy, and even when the machine is updated to Jessie
(due soon) it's better to install latest (4.20) xfsprogs from sources
rather Jessie's packaged 3.20; and

(2) When a filesystem grows a lot it is better to recreate it
(at least every now and then if the growth is incremental)
rather than keep growing it forever.

If there's anything you'd like to add, and especially if there
is something you'd still like to debug where I could help,
please let me know.

Thank you for your help,

-- 
Tapani Tarvainen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
