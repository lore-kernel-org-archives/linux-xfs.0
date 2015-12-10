Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C52237F37
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 14:24:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B36E88F8040
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 12:24:56 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id JafhtYyXFGgBDlQK for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2015 12:24:55 -0800 (PST)
Date: Thu, 10 Dec 2015 13:24:38 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 3/7] mm: add find_get_entries_tag()
Message-ID: <20151210202438.GA6590@linux.intel.com>
References: <1449602325-20572-1-git-send-email-ross.zwisler@linux.intel.com>
	<1449602325-20572-4-git-send-email-ross.zwisler@linux.intel.com>
	<CAA9_cmeVYinm4mMiDU4oz8fW4HQ3n1RqEbPHBW7A3OGmi9eXtw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA9_cmeVYinm4mMiDU4oz8fW4HQ3n1RqEbPHBW7A3OGmi9eXtw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@gmail.com>
Cc: the arch/x86 maintainers <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Ross Zwisler <ross.zwisler@linux.intel.com>, ext4 hackers <linux-ext4@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Wed, Dec 09, 2015 at 11:44:16AM -0800, Dan Williams wrote:
> On Tue, Dec 8, 2015 at 11:18 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > Add find_get_entries_tag() to the family of functions that include
> > find_get_entries(), find_get_pages() and find_get_pages_tag().  This is
> > needed for DAX dirty page handling because we need a list of both page
> > offsets and radix tree entries ('indices' and 'entries' in this function)
> > that are marked with the PAGECACHE_TAG_TOWRITE tag.
> >
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
<> 
> Why does this mostly duplicate find_get_entries()?
> 
> Surely find_get_entries() can be implemented as a special case of
> find_get_entries_tag().

I'm adding find_get_entries_tag() to the family of functions that already
exist and include find_get_entries(), find_get_pages(),
find_get_pages_contig() and find_get_pages_tag().

These functions all contain very similar code with small changes to the
internal looping based on whether you're looking through all radix slots or
only the ones that match a certain tag (radix_tree_for_each_slot() vs
radix_tree_for_each_tagged()).

We already have find_get_page() to get all pages in a range and
find_get_pages_tag() to get all pages in the range with a certain tag.  We
have find_get_entries() to get all pages and indices for a given range, but we
are currently missing find_get_entries_tag() to do that same search based on a
tag, which is what I'm adding.

I agree that we could probably figure out a way to combine the code for
find_get_entries() with find_get_entries_tag(), as we could do for the
existing functions find_get_pages() and find_get_pages_tag().  I think we
should probably add find_get_entries_tag() per this patch, though, and then
decide whether to do any combining later as a separate step.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
