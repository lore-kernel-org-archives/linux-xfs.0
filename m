Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 721D67F37
	for <xfs@oss.sgi.com>; Wed, 30 Dec 2015 21:29:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 612B38F8033
	for <xfs@oss.sgi.com>; Wed, 30 Dec 2015 19:29:08 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id lEp6mUWYpvtnFvkv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Dec 2015 19:29:06 -0800 (PST)
Message-ID: <5684A0CD.9040005@oracle.com>
Date: Thu, 31 Dec 2015 11:28:13 +0800
From: Bob Liu <bob.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/7] dax: support dirty DAX entries in radix tree
References: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450899560-26708-3-git-send-email-ross.zwisler@linux.intel.com>
	<56838FA3.5030909@oracle.com>
	<CAPcyv4jAO-jJ3VCOJRCc7zrQULED362SdZ88dDgN+zfQQEsfsA@mail.gmail.com>
In-Reply-To: <CAPcyv4jAO-jJ3VCOJRCc7zrQULED362SdZ88dDgN+zfQQEsfsA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>


On 12/31/2015 04:39 AM, Dan Williams wrote:
> On Wed, Dec 30, 2015 at 12:02 AM, Bob Liu <bob.liu@oracle.com> wrote:
>> Hi Ross,
>>
>> On 12/24/2015 03:39 AM, Ross Zwisler wrote:
>>> Add support for tracking dirty DAX entries in the struct address_space
>>> radix tree.  This tree is already used for dirty page writeback, and it
>>> already supports the use of exceptional (non struct page*) entries.
>>>
>>> In order to properly track dirty DAX pages we will insert new exceptional
>>> entries into the radix tree that represent dirty DAX PTE or PMD pages.
>>
>> I may get it wrong, but there is "struct page" for persistent memory after
>> "[PATCH v4 00/18]get_user_pages() for dax pte and pmd mappings".
>> So why not just add "struct page" to radix tree directly just like normal page cache?
>>
>> Then we don't need to deal with any exceptional entries and special writeback.
> 
> That "struct page" is optional and fsync/msync needs to operate in its absence.
> 

Any special reason or scenario that "struct page" should not be enabled?
I didn't see any disadvantages if always enable "struct page" by force when using DAX model for pmem.
The benefits would be things can be more simple and less potential bugs because of smaller patches.

Happy New Year!
Bob

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
