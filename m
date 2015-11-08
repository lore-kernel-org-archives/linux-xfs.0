Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B7BE7F54
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 16:19:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F2DA8F8035
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 14:19:39 -0800 (PST)
Received: from mail-lb0-f178.google.com (mail-lb0-f178.google.com
	[209.85.217.178]) by cuda.sgi.com with ESMTP id
	JaK6UYmdkZ9g6Vls (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Nov 2015 14:19:36 -0800 (PST)
Received: by lbces9 with SMTP id es9so17520912lbc.2
	for <xfs@oss.sgi.com>; Sun, 08 Nov 2015 14:19:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHQdGtQitLZq9fKHhzZbqS5ESRYNgNpw=M+y715mWMjFi-cgNQ@mail.gmail.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-46-git-send-email-agruenba@redhat.com>
	<CAHQdGtScoRb-722ES168O8tkp-Rbvwe6bZ=70WwgiXpCC3vsHw@mail.gmail.com>
	<CAHc6FU5xkjWJeGFR5mO8+OAEMwwU6yWK7H8CV1fn5dk-LS23-g@mail.gmail.com>
	<CAHQdGtQitLZq9fKHhzZbqS5ESRYNgNpw=M+y715mWMjFi-cgNQ@mail.gmail.com>
Date: Sun, 8 Nov 2015 23:19:35 +0100
Message-ID: <CAHc6FU6mmJj0N6Jq1_fp59kv5h3XeuLUamfNg3iNo64=+rTYCA@mail.gmail.com>
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

On Thu, Nov 5, 2015 at 4:57 PM, Trond Myklebust
<trond.myklebust@primarydata.com> wrote:
> On Thu, Nov 5, 2015 at 6:07 AM, Andreas Gruenbacher <agruenba@redhat.com> wrote:
>> Trond,
>>
>> On Tue, Nov 3, 2015 at 5:25 PM, Trond Myklebust
>> <trond.myklebust@primarydata.com> wrote:
>>> On Tue, Nov 3, 2015 at 10:17 AM, Andreas Gruenbacher
>>> <agruenba@redhat.com> wrote:
>>>> When encoding large, variable-length objects such as acls into xdr_bufs,
>>>> it is easier to allocate buffer pages on demand rather than precomputing
>>>> the required buffer size.
>>>
>>> NACK. We're not doing allocations from inside the XDR encoders. This
>>> can and should be done before calling into the SUNRPC layer.
>>
>> an XDR-encoded ACL can be up to 64k (16 pages) in size. In practice,
>> large ACLs like that will almost never occur and almost all ACLs will
>> fit into a single page though.
>>
>> The XDR-encoded ACL contains strings for the user and group names
>> which need to be looked up when the idmapper is used. Those lookups
>> are somewhat expensive; in addition, the lookup results can change
>> over time. When precomputing the size, allocating space, and then
>> encoding the ACL, we could run out of space when encoding.
>>
>> So we could always allocate the maximum 16 pages, encode the acl, and
>> free the unused pages. This would be rather wasteful though.
>>
>> Given how simple it is to allocate pages as we go, this seems the
>> better choice here. This doesn't break any existing code either; NULL
>> page pointers would have oopsed in xdr_get_next_encode_buffer before.
>>
>> From the memory management point of view, there is no difference in
>> preallocating GFP_NOFS pages and allocating them on demand; the pages
>> are allocated in the same task and locking context in both cases.
>>
>> So could you please explain why you object to this change?
>
> Allocating memory deep in the bowels of the RPC code with the
> expectation that it will be freed by the caller of the RPC request is
> a layering violation of the ugliest sort.

Ah, there we have it, Godwin's Law for software discussions.

What happens here is the following: the caller sets up an xdr_stream
that contains an array of NULL page pointers (__nfs4_proc_set_acl ->
nfs4_encode_acl -> xdr_init_encode_pages). It does so on purpose to
tell the XDR layer to allocate pages for it as needed, and it knows it
is responsible for later freeing those pages.

Without this patch, the XDR layer would immediately Oops when hitting
a NULL page pointer. This tells us that the XDR layer is so far not
prepared to handle NULL page pointers, and that we can assign a
meaning to NULL page pointers without affecting existing callers.

Using the existing XDR layer for XDR-encoding ACLs makes sense because
the XDR layer already knows how to align things, encode into multiple
pages, handle strings that wrap across pages, etc. I really don't want
to duplicate all that for ACLs.

> How is anyone who is
> unfamiliar with the code going to be able to understand what is going
> on without tracing through 1000 lines of code to spot where the
> allocation is happening?

Somebody unfamiliar with the existing code will not understand it
without putting some effort in, either. What do you expect? Besides,
the caller doesn't care where the allocation is happening, it just
cares that it is happening when it should.

> Aside from that, we do not want any non-critical blocking while
> holding the RPC socket lock. Your allocation request will block all
> further traffic to the server until it is satisfied. That includes
> blocking page writeback, which might actually free up memory to
> satisfy the allocation.
>
> As I said above, there is no reason whatsoever to have to do all this
> inside encode_setacl(). The entire ACL encoding into pages can be done
> before even calling into the RPC layer, just like we do today.

You have pointed that out before, and as a consequence, it was fixed
in the July 22 snapshot (https://lwn.net/Articles/652058/):

    * Changes to the nfs patches: acls are now encoded above the sunrpc
      layer. This means we can no longer encode small acls directly into the
      scratch area of an xdr_buf, we always have to allocate extra memory.
      But we also don't need to touch the nfs sunrpc code, which Trond objected
      to.

Since then, the ACL encoding happens in __nfs4_proc_set_acl, before
calling into the RPC layer.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
