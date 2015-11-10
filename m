Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AC4D47F3F
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 13:17:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D8F0304032
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 11:17:49 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id SlYCD3la5JJL1XH6 for <xfs@oss.sgi.com>;
	Tue, 10 Nov 2015 11:17:46 -0800 (PST)
Date: Tue, 10 Nov 2015 14:17:45 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v15 00/22] Richacls (Core and Ext4)
Message-ID: <20151110191745.GA19379@fieldses.org>
References: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
	<20151110112943.GA17038@infradead.org>
	<CAHc6FU5g7=wd1Wt4+GCaLJjNu7giruZyAON3VcYn-A=ffYMsmw@mail.gmail.com>
	<CAH2r5ms1ckC59o9sbBEBAWQA0Q3tGOs=YJpk01xg19zThJDt-w@mail.gmail.com>
	<20151110170703.GB17530@fieldses.org>
	<CAHc6FU6aWsWO1SOSyNVnbObE0GoE4dr5a3WVTgvX4xn0wum1Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU6aWsWO1SOSyNVnbObE0GoE4dr5a3WVTgvX4xn0wum1Fg@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Steve French <smfrench@gmail.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Nov 10, 2015 at 06:58:19PM +0100, Andreas Gruenbacher wrote:
> On Tue, Nov 10, 2015 at 6:07 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > On Tue, Nov 10, 2015 at 10:43:46AM -0600, Steve French wrote:
> >> I don't have strong disagreement with using pseudo-xattrs to
> >> store/retrieve ACLs (we already do this) but retrieving/setting an ACL
> >> all at once can be awkward  when ACLs are quite large e.g. when it
> >> encodes to over 1MB
> >
> > At least in the NFS case, that's also a limitation of the protocol.
> 
> I couldn't find a limit in the NFSv4 specification, but the client and
> server implementations both define arbitrary ACL size limits. In
> addition, the xattr syscalls allow attributes to be up to 64k long.

I don't recall 4.0 specifying any limit, 4.1 does include negotiation of
maximum rpc calls and replies, and that effectively limits ACL sizes
since they have to fit in a single rpc.

> The bigger problem would be incrementally setting ACLs. To prevent
> processes from racing with each other, we would need a locking
> mechanism. In addition, the memory overhead would be prohibitive and
> access decisions would become extremely slow; we would have to come up
> with mechanisms to avoid those problems.

Right.  Anyway, not worth the trouble, I think.

(Though what might be worth thinking about at some point is just making
sure we fail in helpful ways.)

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
