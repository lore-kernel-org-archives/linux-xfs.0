Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 69CFC29E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 16:44:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4A66D8F8040
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 14:44:53 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2SyEZF2LdXd6llDJ for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 14:44:51 -0800 (PST)
Date: Tue, 19 Nov 2013 09:44:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: setfacl fix
Message-ID: <20131118224426.GW6188@dastard>
References: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw@mail.gmail.com>
	<20131116145507.GA22395@infradead.org>
	<CAH2r5mtXjnAOpKzZzta_yWDGyEPzR7h1wb0UW2pnoicm9Qsgxg@mail.gmail.com>
	<20131118152723.GA19649@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131118152723.GA19649@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Steve French <smfrench@gmail.com>, xfs@oss.sgi.com, samba-technical <samba-technical@lists.samba.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>

On Mon, Nov 18, 2013 at 07:27:23AM -0800, Christoph Hellwig wrote:
> On Sat, Nov 16, 2013 at 03:38:09PM -0600, Steve French wrote:
> > Makes sense to add a setfacl/getfacl test to xfstest and was trying to
> > build updated xfstests and look at what has changed but ran into a
> > strange error building xfstests and didn't see an obvious answer when
> > googling for it.  Any idea how to workaround the build failure?
> > 
> > Building src
> >     [DEP]
> >     [CC]    dirstress
> > gcc: error: /lib64/libhandle.so: Too many levels of symbolic links

What's the circular link chain?

> > These are the steps I went through from a fairly clean Fedora 19 64
> > system before the make failure:
> 
> No idea.  Maybe some of the RedHat people on the xfs list have more
> experience with Fedora than I have.

Don't look at me - I use Debian for all my upstream stuff.... ;)

> > git clone git://oss.sgi.com/xfs/cmds/xfstests
> > git clone git://oss.sgi.com/xfs/cmds/xfsprogs
> > sudo yum install uuid-devel e2fsprogs-devel libuuid-devel
> > libattr-devel libacl-devel
> > cd xfsprogs
> > make
> > sudo make install-qa
> > cd ../xfstests
> > ./configure
> > make (which failed with the symlink error above)

Having the output of all the steps, especially the xfsprogs
install-qa step is probably going to be necessary to debug this. You
probably want to run "make Q= install-qa" so that it runs verbosely.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
