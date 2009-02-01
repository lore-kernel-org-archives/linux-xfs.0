Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n11Gb9PJ194949 for <xfs@oss.sgi.com>; Sun, 1 Feb 2009 10:37:10 -0600
Message-ID: <4985CF66.6090409@sandeen.net>
Date: Sun, 01 Feb 2009 10:35:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs
	for compatibility with legacy xfs ioctls
References: <4980C71F.1010804@ankitjain.org>
	<200901310138.34164.arnd@arndb.de>	<20090130171423.f99c88d0.akpm@linux-foundation.org>	<200901310248.42820.arnd@arndb.de>
	<49856FE6.8020601@panasas.com>	<Pine.LNX.4.64.0902011104320.20875@anakin>	<49857BEB.30404@panasas.com>	<Pine.LNX.4.64.0902011151180.20875@anakin>
	<4985966D.8040402@panasas.com> <4985C1B0.8060905@sandeen.net>
	<4985CCFA.4070008@panasas.com>
In-Reply-To: <4985CCFA.4070008@panasas.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Arnd Bergmann <arnd@arndb.de>, mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, hch@infradead.org, xfs-masters@oss.sgi.com, Geert Uytterhoeven <geert@linux-m68k.org>, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Boaz Harrosh wrote:
> Eric Sandeen wrote:
>> Boaz Harrosh wrote:
>>
>> ...
>>
>>> I don't understand
>>>
>>> if you have a structure like
>>> struct foo {
>>> 	u32 one;
>>> 	u32 two;
>>> };
>>> vs
>>> struct foo_packed {
>>> 	u32 one;
>>> 	u32 two;
>>> } __packed;
>>>
>>> Just adding an __attribute__((packed)) to it clearly does not change
>>> the layout of the structure. Are you saying the __attribute__((packed))
>>> is an hint to the compiler that foo_packed might be used unaligned. This
>>> is just brain-dead, because I can use an unaligned pointer to foo just as
>>> I can to foo_packed. Otherwise there is no difference what-so-ever between
>>> the two. I have to see it to believe. It is totally the wrong hint in the
>>> wrong place taking away valuable meaning of saying "please don't use padding
>>> holes in this structure"
>>>
>>> Sorry for been so slow, I just don't get it.
>>> Boaz
>> While I'm no gcc guru, I can confirm that gratuitous use of the packed
>> attribute is suboptimal; adding "packed" to every ondisk structure made
>> obdump -d xfs.ko | wc -l explode by about 15,000 lines on ia64.
> 
> Yes! but are the structures the same? that is sizeof(foo_packed) == sizeof(foo) ?
> If not then clearly above is expected.

Yes, they are the same.  They're disk structure definitions after all;
ia64 doesn't *need* the packing, but adding the packed attribute changes
the code that gcc generates.

See also, perhaps,
http://digitalvampire.org/blog/index.php/2006/07/31/why-you-shouldnt-use-__attribute__packed/

For an interface like this maybe it's fine, but sprnkling it around like
pixie dust may not be a good plan.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
