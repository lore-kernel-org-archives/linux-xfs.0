Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3BF427F3F
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 11:58:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1ACB18F8033
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 09:58:22 -0800 (PST)
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com
	[209.85.217.174]) by cuda.sgi.com with ESMTP id
	0cYAavlD9o7kZJcz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Nov 2015 09:58:21 -0800 (PST)
Received: by lbbcs9 with SMTP id cs9so2808182lbb.1
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 09:58:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151110170703.GB17530@fieldses.org>
References: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
	<20151110112943.GA17038@infradead.org>
	<CAHc6FU5g7=wd1Wt4+GCaLJjNu7giruZyAON3VcYn-A=ffYMsmw@mail.gmail.com>
	<CAH2r5ms1ckC59o9sbBEBAWQA0Q3tGOs=YJpk01xg19zThJDt-w@mail.gmail.com>
	<20151110170703.GB17530@fieldses.org>
Date: Tue, 10 Nov 2015 18:58:19 +0100
Message-ID: <CAHc6FU6aWsWO1SOSyNVnbObE0GoE4dr5a3WVTgvX4xn0wum1Fg@mail.gmail.com>
Subject: Re: [PATCH v15 00/22] Richacls (Core and Ext4)
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Steve French <smfrench@gmail.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Nov 10, 2015 at 6:07 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Tue, Nov 10, 2015 at 10:43:46AM -0600, Steve French wrote:
>> On Tue, Nov 10, 2015 at 6:39 AM, Andreas Gruenbacher
>> <agruenba@redhat.com> wrote:
>> > On Tue, Nov 10, 2015 at 12:29 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> >> On Mon, Nov 09, 2015 at 12:08:41PM +0100, Andreas Gruenbacher wrote:
>> >>> Here is another update to the richacl patch queue.  This posting contains
>> >>> the patches ready to be merged; the patches later in the queue still need
>> >>> some more review.
>> <snip>
>> >> and still abuses xattrs instead of a proper syscall interface.
>> >> That's far from being ready to merge.
>> >
>> > The xattr syscall interface is what's used for very similar kinds of
>> > things today; using it for richacls as well sure does not count as
>> > abuse. Things could be improved in the xattr interface and in its
>> > implementation, but we need more substantial reasons than that for
>> > reimplementing the wheel once again.
>>
>> I don't have strong disagreement with using pseudo-xattrs to
>> store/retrieve ACLs (we already do this) but retrieving/setting an ACL
>> all at once can be awkward  when ACLs are quite large e.g. when it
>> encodes to over 1MB
>
> At least in the NFS case, that's also a limitation of the protocol.

I couldn't find a limit in the NFSv4 specification, but the client and
server implementations both define arbitrary ACL size limits. In
addition, the xattr syscalls allow attributes to be up to 64k long.

> If
> we really wanted to support massive ACLs then we'd need both syscall and
> NFS interfaces to allow incrementally reading and writing ACLs, and I
> don't even know what those would look like.
>
> So this is a fine limitation as far as I'm concerned.

The bigger problem would be incrementally setting ACLs. To prevent
processes from racing with each other, we would need a locking
mechanism. In addition, the memory overhead would be prohibitive and
access decisions would become extremely slow; we would have to come up
with mechanisms to avoid those problems.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
