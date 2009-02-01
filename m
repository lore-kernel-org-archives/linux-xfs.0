Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n119n7Uo169793 for <xfs@oss.sgi.com>; Sun, 1 Feb 2009 03:49:08 -0600
Message-ID: <49856FE6.8020601@panasas.com>
Date: Sun, 01 Feb 2009 11:48:22 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for compatibility
	with legacy xfs ioctls
References: <4980C71F.1010804@ankitjain.org> <200901310138.34164.arnd@arndb.de>
	<20090130171423.f99c88d0.akpm@linux-foundation.org>
	<200901310248.42820.arnd@arndb.de>
In-Reply-To: <200901310248.42820.arnd@arndb.de>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, hch@infradead.org, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Arnd Bergmann wrote:
> On Saturday 31 January 2009, Andrew Morton wrote:
>> Is this written in a standard somewhere?  Is it guaranteed?
> 
> Alignment is defined in the architecture psABI documents. 
> Unfortunately, many of them were written before the 'long long'
> type became part of the C standard, so it's not strictly guaranteed.
> AFAICT, the alignment of __u64 on x86 is the same as the alignment
> of 'double' by convention.
> 
> However, the problem is well-understood: x86 is the only one
> that has a problem in 32/64 bit compat mode. m68k has similar
> issues with 16/32 bit integers, but those don't apply here.
> 
>> If some (perhaps non-gcc) compiler were to lay this out differently
>> (perhaps with suitable command-line options) then that's liveable
>> with - as long as the kernel never changes the layout.  Of course
>> it would be better to avoid this if poss.
> 
> If a compiler was using irregular structure alignment, all sorts of
> library interfaces would break. The kernel ABI is only a small part
> of the problem then.
> 
>> The other potential issue with a structure like this is that there's a
>> risk that it will lead us to copy four bytes of uninitialised kernel
>> memory out to userspace.
>>
>> IOW, it seems a generally bad idea to rely upon compiler-added padding
>> for this sort of thing.
> 
> Agreed in general, but the whole point of this particular patch was to
> provide compatibility with an interface that has been part of XFS for
> many years.
> Linux already has a better interface for new users (sys_fallocate), so
> changing the patch would not be helpful and not provide any advantage.
> 
> There is also no leak of uninitialized data here, because this structure
> is only read, never written.
> 
> 	Arnd <><
Arnd Bergmann wrote:
> +struct space_resv {
> +	__s16		l_type;
> +	__s16		l_whence;
> +	__s64		l_start;
> +	__s64		l_len;		/* len == 0 means until end of file */
> +	__s32		l_sysid;
> +	__u32		l_pid;
> +	__s32		l_pad[4];	/* reserve area			    */
> +};

What about telling the compiler exactly what you said above, just
to be sure we all mean the same thing. (And as documentation for new
comers):

+struct space_resv_64 {
+	__s16		l_type;
+	__s16		l_whence;
+	__u32		reserved;
+	__s64		l_start;
+	__s64		l_len;		/* len == 0 means until end of file */
+	__s32		l_sysid;
+	__u32		l_pid;
+	__s32		l_pad[4];	/* reserve area			    */
+} __packed;

And define another one for x86_32

Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
