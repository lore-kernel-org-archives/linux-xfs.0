Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38160 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755360AbdLOMeX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 07:34:23 -0500
Date: Fri, 15 Dec 2017 04:34:17 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Naming of tag operations in the XArray
Message-ID: <20171215123417.GA10348@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-9-willy@infradead.org>
 <66ad068b-1973-ca41-7bbf-8a0634cc488d@infradead.org>
 <20171215042214.GA17444@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171215042214.GA17444@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 14, 2017 at 08:22:14PM -0800, Matthew Wilcox wrote:
> On Mon, Dec 11, 2017 at 03:10:22PM -0800, Randy Dunlap wrote:
> > > +A freshly-initialised XArray contains a ``NULL`` pointer at every index.
> > > +Each non-``NULL`` entry in the array has three bits associated with
> > > +it called tags.  Each tag may be flipped on or off independently of
> > > +the others.  You can search for entries with a given tag set.
> > 
> > Only tags that are set, or search for entries with some tag(s) cleared?
> > Or is that like a mathematical set?
> 
> hmm ...
> 
> "Each tag may be set or cleared independently of the others.  You can
> search for entries which have a particular tag set."
> 
> Doesn't completely remove the ambiguity, but I can't think of how to phrase
> that better ...

Thinking about this some more ...

At the moment, the pieces of the API which deal with tags look like this:

bool xa_tagged(const struct xarray *, xa_tag_t)
bool xa_get_tag(struct xarray *, unsigned long index, xa_tag_t);
void xa_set_tag(struct xarray *, unsigned long index, xa_tag_t);
void xa_clear_tag(struct xarray *, unsigned long index, xa_tag_t);
int xa_get_tagged(struct xarray *, void **dst, unsigned long start,
                        unsigned long max, unsigned int n, xa_tag_t);

bool xas_get_tag(const struct xa_state *, xa_tag_t);
void xas_set_tag(const struct xa_state *, xa_tag_t);
void xas_clear_tag(const struct xa_state *, xa_tag_t);
void *xas_find_tag(struct xa_state *, unsigned long max, xa_tag_t);
xas_for_each_tag(xas, entry, max, tag) { }

(at some point there will be an xa_for_each_tag too, there just hasn't
been a user yet).

I'm always ambivalent about using the word 'get' in an API because it has
two common meanings; (increment a refcount) and (return the state).  How
would people feel about these names instead:

bool xa_any_tagged(xa, tag);
bool xa_is_tagged(xa, index, tag);
void xa_tag(xa, index, tag);
void xa_untag(xa, index, tag);
int xa_select(xa, dst, start, max, n, tag);

bool xas_is_tagged(xas, tag);
void xas_tag(xas, tag);
void xas_untag(xas, tag);
void *xas_find_tag(xas, max, tag);
xas_for_each_tag(xas, entry, max, tag) { }

(the last two are unchanged)

