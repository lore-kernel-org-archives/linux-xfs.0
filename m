Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 422D17FC1
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 05:07:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D9DBAC002
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 03:07:10 -0800 (PST)
Received: from mail-lb0-f182.google.com (mail-lb0-f182.google.com
	[209.85.217.182]) by cuda.sgi.com with ESMTP id
	qxZUHTWLEP6QuVCy (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Nov 2015 03:07:07 -0800 (PST)
Received: by lbbes7 with SMTP id es7so32680421lbb.2
	for <xfs@oss.sgi.com>; Thu, 05 Nov 2015 03:07:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHQdGtScoRb-722ES168O8tkp-Rbvwe6bZ=70WwgiXpCC3vsHw@mail.gmail.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-46-git-send-email-agruenba@redhat.com>
	<CAHQdGtScoRb-722ES168O8tkp-Rbvwe6bZ=70WwgiXpCC3vsHw@mail.gmail.com>
Date: Thu, 5 Nov 2015 12:07:05 +0100
Message-ID: <CAHc6FU5xkjWJeGFR5mO8+OAEMwwU6yWK7H8CV1fn5dk-LS23-g@mail.gmail.com>
Subject: Re: [PATCH v13 45/51] sunrpc: Allow to demand-allocate pages to
	encode into
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
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API Mailing List <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

Trond,

On Tue, Nov 3, 2015 at 5:25 PM, Trond Myklebust
<trond.myklebust@primarydata.com> wrote:
> On Tue, Nov 3, 2015 at 10:17 AM, Andreas Gruenbacher
> <agruenba@redhat.com> wrote:
>> When encoding large, variable-length objects such as acls into xdr_bufs,
>> it is easier to allocate buffer pages on demand rather than precomputing
>> the required buffer size.
>
> NACK. We're not doing allocations from inside the XDR encoders. This
> can and should be done before calling into the SUNRPC layer.

an XDR-encoded ACL can be up to 64k (16 pages) in size. In practice,
large ACLs like that will almost never occur and almost all ACLs will
fit into a single page though.

The XDR-encoded ACL contains strings for the user and group names
which need to be looked up when the idmapper is used. Those lookups
are somewhat expensive; in addition, the lookup results can change
over time. When precomputing the size, allocating space, and then
encoding the ACL, we could run out of space when encoding.

So we could always allocate the maximum 16 pages, encode the acl, and
free the unused pages. This would be rather wasteful though.

Given how simple it is to allocate pages as we go, this seems the
better choice here. This doesn't break any existing code either; NULL
page pointers would have oopsed in xdr_get_next_encode_buffer before.

>From the memory management point of view, there is no difference in
preallocating GFP_NOFS pages and allocating them on demand; the pages
are allocated in the same task and locking context in both cases.

So could you please explain why you object to this change?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
