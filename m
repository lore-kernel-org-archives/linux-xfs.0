Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D8587CA1
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 15:28:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17B33AC003
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 13:28:18 -0700 (PDT)
Received: from mail-vk0-f48.google.com (mail-vk0-f48.google.com
	[209.85.213.48]) by cuda.sgi.com with ESMTP id eCjJuSEXZxFUMCyB
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Jul 2016 13:28:16 -0700 (PDT)
Received: by mail-vk0-f48.google.com with SMTP id v6so38445804vkb.2
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 13:28:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160712191142.GE449@fieldses.org>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	<1467294433-3222-18-git-send-email-agruenba@redhat.com>
	<1468324560.7798.14.camel@redhat.com>
	<20160712191142.GE449@fieldses.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 12 Jul 2016 22:28:15 +0200
Message-ID: <CAHc6FU6k+eZ1Ozc8wofDBNOAHZzvXXWMAs1NJNTbd9Ntbqqsqw@mail.gmail.com>
Subject: Re: [PATCH v23 17/22] richacl: Automatic Inheritance
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
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@redhat.com>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Jul 12, 2016 at 9:11 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Tue, Jul 12, 2016 at 07:56:00AM -0400, Jeff Layton wrote:
>> Barf. AI seems like a trainwreck waiting to happen. What are the
>> chances that userland is going to get this right?
>
> This is just taken from Windows, so presumably Samba should do the right
> thing (with one workaround required--see the discussion of PROTECTED in
> the changelog).
>
>> Still, I do applaud the fact that you're just doing the bare minimum in
>> kernel to support userland apps that want this. Thanks for not trying
>> to push the propagation of the changed ACEs into the kernel.
>
> Agreed.  But, again, this is just what Windows does.  (I wonder whether
> there's an OS that's actually tried do any sort of atomic propagation.)

NetWare's NSS filesystem did have automatic propagation, but I think
that was implemented by composing the permissions along the path to a
file at access time.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
