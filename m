Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 282137F3F
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 14:33:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 181CD304039
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 12:32:58 -0800 (PST)
Received: from mail-vk0-f44.google.com (mail-vk0-f44.google.com
	[209.85.213.44]) by cuda.sgi.com with ESMTP id 2GshVwmJcopFoB4u
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2015 12:32:55 -0800 (PST)
Received: by vkgj66 with SMTP id j66so4175404vkg.1
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 12:32:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151210202438.GA6590@linux.intel.com>
References: <1449602325-20572-1-git-send-email-ross.zwisler@linux.intel.com>
	<1449602325-20572-4-git-send-email-ross.zwisler@linux.intel.com>
	<CAA9_cmeVYinm4mMiDU4oz8fW4HQ3n1RqEbPHBW7A3OGmi9eXtw@mail.gmail.com>
	<20151210202438.GA6590@linux.intel.com>
Date: Thu, 10 Dec 2015 12:31:53 -0800
Message-ID: <CAPcyv4g6ieXDUSGUCpevmQfvGWZUqfW-2NTNC9TsVUxF0aoTNQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] mm: add find_get_entries_tag()
From: Dan Williams <dan.j.williams@intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, ext4 hackers <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Thu, Dec 10, 2015 at 12:24 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Wed, Dec 09, 2015 at 11:44:16AM -0800, Dan Williams wrote:
>> On Tue, Dec 8, 2015 at 11:18 AM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> > Add find_get_entries_tag() to the family of functions that include
>> > find_get_entries(), find_get_pages() and find_get_pages_tag().  This is
>> > needed for DAX dirty page handling because we need a list of both page
>> > offsets and radix tree entries ('indices' and 'entries' in this function)
>> > that are marked with the PAGECACHE_TAG_TOWRITE tag.
>> >
>> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> <>
>> Why does this mostly duplicate find_get_entries()?
>>
>> Surely find_get_entries() can be implemented as a special case of
>> find_get_entries_tag().
>
> I'm adding find_get_entries_tag() to the family of functions that already
> exist and include find_get_entries(), find_get_pages(),
> find_get_pages_contig() and find_get_pages_tag().
>
> These functions all contain very similar code with small changes to the
> internal looping based on whether you're looking through all radix slots or
> only the ones that match a certain tag (radix_tree_for_each_slot() vs
> radix_tree_for_each_tagged()).
>
> We already have find_get_page() to get all pages in a range and
> find_get_pages_tag() to get all pages in the range with a certain tag.  We
> have find_get_entries() to get all pages and indices for a given range, but we
> are currently missing find_get_entries_tag() to do that same search based on a
> tag, which is what I'm adding.
>
> I agree that we could probably figure out a way to combine the code for
> find_get_entries() with find_get_entries_tag(), as we could do for the
> existing functions find_get_pages() and find_get_pages_tag().  I think we
> should probably add find_get_entries_tag() per this patch, though, and then
> decide whether to do any combining later as a separate step.

Ok, sounds good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
