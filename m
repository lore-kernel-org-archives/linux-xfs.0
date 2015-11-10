Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B7147F37
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 06:40:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BC8EBAC006
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 04:39:57 -0800 (PST)
Received: from mail-lb0-f171.google.com (mail-lb0-f171.google.com
	[209.85.217.171]) by cuda.sgi.com with ESMTP id
	YIE75fD44v0P69LQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Nov 2015 04:39:54 -0800 (PST)
Received: by lbbkw15 with SMTP id kw15so113136693lbb.0
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 04:39:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151110112943.GA17038@infradead.org>
References: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
	<20151110112943.GA17038@infradead.org>
Date: Tue, 10 Nov 2015 13:39:52 +0100
Message-ID: <CAHc6FU5g7=wd1Wt4+GCaLJjNu7giruZyAON3VcYn-A=ffYMsmw@mail.gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Nov 10, 2015 at 12:29 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Nov 09, 2015 at 12:08:41PM +0100, Andreas Gruenbacher wrote:
>> Here is another update to the richacl patch queue.  This posting contains
>> the patches ready to be merged; the patches later in the queue still need
>> some more review.
>
> It still has the same crappy fs interfaces with lots of boilerplate
> code

Could you please be more specific so that I can trace this complaint
to some actual code?

> and still abuses xattrs instead of a proper syscall interface.
> That's far from being ready to merge.

The xattr syscall interface is what's used for very similar kinds of
things today; using it for richacls as well sure does not count as
abuse. Things could be improved in the xattr interface and in its
implementation, but we need more substantial reasons than that for
reimplementing the wheel once again.

[The recently discussed xattr fixes
(http://permalink.gmane.org/gmane.linux.file-systems/101502) and two
small POSIX ACL fixes
(http://permalink.gmane.org/gmane.linux.file-systems/101499) are
currently stuck waiting for Al, by the way.]

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
