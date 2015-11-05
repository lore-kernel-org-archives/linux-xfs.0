Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E44947F76
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 09:57:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C39D4304059
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 07:57:09 -0800 (PST)
Received: from mail-ob0-f170.google.com (mail-ob0-f170.google.com
	[209.85.214.170]) by cuda.sgi.com with ESMTP id
	gvGktpjbaQAsttgY (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Nov 2015 07:57:04 -0800 (PST)
Received: by obbza9 with SMTP id za9so69598082obb.1
	for <xfs@oss.sgi.com>; Thu, 05 Nov 2015 07:57:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHc6FU5xkjWJeGFR5mO8+OAEMwwU6yWK7H8CV1fn5dk-LS23-g@mail.gmail.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-46-git-send-email-agruenba@redhat.com>
	<CAHQdGtScoRb-722ES168O8tkp-Rbvwe6bZ=70WwgiXpCC3vsHw@mail.gmail.com>
	<CAHc6FU5xkjWJeGFR5mO8+OAEMwwU6yWK7H8CV1fn5dk-LS23-g@mail.gmail.com>
Date: Thu, 5 Nov 2015 10:57:04 -0500
Message-ID: <CAHQdGtQitLZq9fKHhzZbqS5ESRYNgNpw=M+y715mWMjFi-cgNQ@mail.gmail.com>
Subject: Re: [PATCH v13 45/51] sunrpc: Allow to demand-allocate pages to
	encode into
From: Trond Myklebust <trond.myklebust@primarydata.com>
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
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API Mailing List <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Thu, Nov 5, 2015 at 6:07 AM, Andreas Gruenbacher <agruenba@redhat.com> wrote:
> Trond,
>
> On Tue, Nov 3, 2015 at 5:25 PM, Trond Myklebust
> <trond.myklebust@primarydata.com> wrote:
>> On Tue, Nov 3, 2015 at 10:17 AM, Andreas Gruenbacher
>> <agruenba@redhat.com> wrote:
>>> When encoding large, variable-length objects such as acls into xdr_bufs,
>>> it is easier to allocate buffer pages on demand rather than precomputing
>>> the required buffer size.
>>
>> NACK. We're not doing allocations from inside the XDR encoders. This
>> can and should be done before calling into the SUNRPC layer.
>
> an XDR-encoded ACL can be up to 64k (16 pages) in size. In practice,
> large ACLs like that will almost never occur and almost all ACLs will
> fit into a single page though.
>
> The XDR-encoded ACL contains strings for the user and group names
> which need to be looked up when the idmapper is used. Those lookups
> are somewhat expensive; in addition, the lookup results can change
> over time. When precomputing the size, allocating space, and then
> encoding the ACL, we could run out of space when encoding.
>
> So we could always allocate the maximum 16 pages, encode the acl, and
> free the unused pages. This would be rather wasteful though.
>
> Given how simple it is to allocate pages as we go, this seems the
> better choice here. This doesn't break any existing code either; NULL
> page pointers would have oopsed in xdr_get_next_encode_buffer before.
>
> From the memory management point of view, there is no difference in
> preallocating GFP_NOFS pages and allocating them on demand; the pages
> are allocated in the same task and locking context in both cases.
>
> So could you please explain why you object to this change?
>

Allocating memory deep in the bowels of the RPC code with the
expectation that it will be freed by the caller of the RPC request is
a layering violation of the ugliest sort. How is anyone who is
unfamiliar with the code going to be able to understand what is going
on without tracing through 1000 lines of code to spot where the
allocation is happening?

Aside from that, we do not want any non-critical blocking while
holding the RPC socket lock. Your allocation request will block all
further traffic to the server until it is satisfied. That includes
blocking page writeback, which might actually free up memory to
satisfy the allocation.

As I said above, there is no reason whatsoever to have to do all this
inside encode_setacl(). The entire ACL encoding into pages can be done
before even calling into the RPC layer, just like we do today.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
