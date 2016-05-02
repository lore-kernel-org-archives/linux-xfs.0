Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04A8D7CD1
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 11:23:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE7418F8035
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 09:23:00 -0700 (PDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id j7zvpBTq5Yz8R9Qh
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 09:22:54 -0700 (PDT)
Received: by mail-wm0-f51.google.com with SMTP id e201so113572899wme.0
	for <xfs@oss.sgi.com>; Mon, 02 May 2016 09:22:54 -0700 (PDT)
Message-ID: <57277EDA.9000803@plexistor.com>
Date: Mon, 02 May 2016 19:22:50 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>	<5727753F.6090104@plexistor.com>
	<CAPcyv4jWPTDbbw6uMFEEt2Kazgw+wb5Pfwroej--uQPE+AtUbA@mail.gmail.com>
In-Reply-To: <CAPcyv4jWPTDbbw6uMFEEt2Kazgw+wb5Pfwroej--uQPE+AtUbA@mail.gmail.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, Vishal Verma <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On 05/02/2016 07:01 PM, Dan Williams wrote:
> On Mon, May 2, 2016 at 8:41 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>> On 04/29/2016 12:16 AM, Vishal Verma wrote:
>>> All IO in a dax filesystem used to go through dax_do_io, which cannot
>>> handle media errors, and thus cannot provide a recovery path that can
>>> send a write through the driver to clear errors.
>>>
>>> Add a new iocb flag for DAX, and set it only for DAX mounts. In the IO
>>> path for DAX filesystems, use the same direct_IO path for both DAX and
>>> direct_io iocbs, but use the flags to identify when we are in O_DIRECT
>>> mode vs non O_DIRECT with DAX, and for O_DIRECT, use the conventional
>>> direct_IO path instead of DAX.
>>>
>>
>> Really? What are your thinking here?
>>
>> What about all the current users of O_DIRECT, you have just made them
>> 4 times slower and "less concurrent*" then "buffred io" users. Since
>> direct_IO path will queue an IO request and all.
>> (And if it is not so slow then why do we need dax_do_io at all? [Rhetorical])
>>
>> I hate it that you overload the semantics of a known and expected
>> O_DIRECT flag, for special pmem quirks. This is an incompatible
>> and unrelated overload of the semantics of O_DIRECT.
> 
> I think it is the opposite situation, it us undoing the premature
> overloading of O_DIRECT that went in without performance numbers.

We have tons of measurements. Is not hard to imagine the results though.
Specially the 1000 threads case

> This implementation clarifies that dax_do_io() handles the lack of a
> page cache for buffered I/O and O_DIRECT behaves as it nominally would
> by sending an I/O to the driver.  

> It has the benefit of matching the
> error semantics of a typical block device where a buffered write could
> hit an error filling the page cache, but an O_DIRECT write potentially
> triggers the drive to remap the block.
> 

I fail to see how in writes the device error semantics regarding remapping of
blocks is any different between buffered and direct IO. As far as the block
device it is the same exact code path. All The big difference is higher in the
VFS.

And ... So you are willing to sacrifice the 99% hotpath for the sake of the
1% error path? and piggybacking on poor O_DIRECT.

Again there are tons of O_DIRECT apps out there, why are you forcing them to
change if they want true pmem performance?

I still believe dax_do_io() can be made more resilient to errors, and clear
errors on writes. Me going digging in old patches ...

Cheers
Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
