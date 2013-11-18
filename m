Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D2FA29E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 09:27:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BAE77AC005
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 07:27:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id CHPHzlSop4DSdc4j (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 07:27:27 -0800 (PST)
Date: Mon, 18 Nov 2013 07:27:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: setfacl fix
Message-ID: <20131118152723.GA19649@infradead.org>
References: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw@mail.gmail.com>
	<20131116145507.GA22395@infradead.org>
	<CAH2r5mtXjnAOpKzZzta_yWDGyEPzR7h1wb0UW2pnoicm9Qsgxg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAH2r5mtXjnAOpKzZzta_yWDGyEPzR7h1wb0UW2pnoicm9Qsgxg@mail.gmail.com>
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
To: Steve French <smfrench@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>, xfs@oss.sgi.com

On Sat, Nov 16, 2013 at 03:38:09PM -0600, Steve French wrote:
> Makes sense to add a setfacl/getfacl test to xfstest and was trying to
> build updated xfstests and look at what has changed but ran into a
> strange error building xfstests and didn't see an obvious answer when
> googling for it.  Any idea how to workaround the build failure?
> 
> Building src
>     [DEP]
>     [CC]    dirstress
> gcc: error: /lib64/libhandle.so: Too many levels of symbolic links
> 
> 
> These are the steps I went through from a fairly clean Fedora 19 64
> system before the make failure:

No idea.  Maybe some of the RedHat people on the xfs list have more
experience with Fedora than I have.

> 
> git clone git://oss.sgi.com/xfs/cmds/xfstests
> git clone git://oss.sgi.com/xfs/cmds/xfsprogs
> sudo yum install uuid-devel e2fsprogs-devel libuuid-devel
> libattr-devel libacl-devel
> cd xfsprogs
> make
> sudo make install-qa
> cd ../xfstests
> ./configure
> make (which failed with the symlink error above)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
