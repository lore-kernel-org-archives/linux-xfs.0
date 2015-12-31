Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB4EC7F37
	for <xfs@oss.sgi.com>; Thu, 31 Dec 2015 16:08:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 58D6CAC004
	for <xfs@oss.sgi.com>; Thu, 31 Dec 2015 14:08:45 -0800 (PST)
Received: from mail-yk0-f180.google.com (mail-yk0-f180.google.com
	[209.85.160.180]) by cuda.sgi.com with ESMTP id
	2MyxPzCKLETJJ0qK (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Dec 2015 14:08:37 -0800 (PST)
Received: by mail-yk0-f180.google.com with SMTP id v14so95332344ykd.3
	for <xfs@oss.sgi.com>; Thu, 31 Dec 2015 14:08:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5684A0CD.9040005@oracle.com>
References: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450899560-26708-3-git-send-email-ross.zwisler@linux.intel.com>
	<56838FA3.5030909@oracle.com>
	<CAPcyv4jAO-jJ3VCOJRCc7zrQULED362SdZ88dDgN+zfQQEsfsA@mail.gmail.com>
	<5684A0CD.9040005@oracle.com>
Date: Thu, 31 Dec 2015 14:08:36 -0800
Message-ID: <CAPcyv4hUfQVff60JiN7=gQTEFeRf7FRnobwbT84dTLvW2jdfvg@mail.gmail.com>
Subject: Re: [PATCH v6 2/7] dax: support dirty DAX entries in radix tree
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
To: Bob Liu <bob.liu@oracle.com>
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Wed, Dec 30, 2015 at 7:28 PM, Bob Liu <bob.liu@oracle.com> wrote:
>
> On 12/31/2015 04:39 AM, Dan Williams wrote:
>> On Wed, Dec 30, 2015 at 12:02 AM, Bob Liu <bob.liu@oracle.com> wrote:
>>> Hi Ross,
>>>
>>> On 12/24/2015 03:39 AM, Ross Zwisler wrote:
>>>> Add support for tracking dirty DAX entries in the struct address_space
>>>> radix tree.  This tree is already used for dirty page writeback, and it
>>>> already supports the use of exceptional (non struct page*) entries.
>>>>
>>>> In order to properly track dirty DAX pages we will insert new exceptional
>>>> entries into the radix tree that represent dirty DAX PTE or PMD pages.
>>>
>>> I may get it wrong, but there is "struct page" for persistent memory after
>>> "[PATCH v4 00/18]get_user_pages() for dax pte and pmd mappings".
>>> So why not just add "struct page" to radix tree directly just like normal page cache?
>>>
>>> Then we don't need to deal with any exceptional entries and special writeback.
>>
>> That "struct page" is optional and fsync/msync needs to operate in its absence.
>>
>
> Any special reason or scenario that "struct page" should not be enabled?
> I didn't see any disadvantages if always enable "struct page" by force when using DAX model for pmem.
> The benefits would be things can be more simple and less potential bugs because of smaller patches.
>

We can't enable struct page coverage by default.

The persistent memory capacity may be too large to allocate the memmap
array from DRAM.  Allocating it from pmem reduces the size of the
device and we can't have a block device change sizes just by booting a
different kernel (any kernel less than 4.5).  So, enabling struct page
must be an explicit action.

> Happy New Year!

Happy New Year!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
