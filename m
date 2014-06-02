Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EE94529DF8
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 16:59:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E38A18F807A
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 14:59:08 -0700 (PDT)
Received: from mail.zytor.com ([198.137.202.10]) by cuda.sgi.com with ESMTP id
	u5DcBoUCTB7efSHf (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 14:59:07 -0700 (PDT)
Message-ID: <538CF346.2070504@zytor.com>
Date: Mon, 02 Jun 2014 14:57:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<4233989.Saca0ocOUr@wuerfel> <538CCFDE.2010107@zytor.com>
	<7175692.dpgYFMbTaP@wuerfel>
In-Reply-To: <7175692.dpgYFMbTaP@wuerfel>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, logfs@logfs.org, linux-afs@lists.infradead.org, "Joseph S. Myers" <joseph@codesourcery.com>, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, lftan@altera.com, linux-btrfs@vger.kernel.org

On 06/02/2014 12:55 PM, Arnd Bergmann wrote:
>>
>> The bit that is really going to hurt is every single ioctl that uses a
>> timespec.
>>
>> Honestly, though, I really don't understand the point with "struct
>> inode_time".  It seems like the zeroeth-order thing is to change the
>> kernel internal version of struct timespec to have a 64-bit time... it
>> isn't just about inodes.  We then should be explicit about the external
>> uses of time, and use accessors.
> 
> I picked these because they are fairly isolated from all other uses,
> in particular since inode times are the only things where we really
> care about times in the distant past or future (decades away as opposed
> to things that happened between boot and shutdown).
> 

If nothing else, I would expect to be able to set the system time to
weird values for testing.  So I'm not so sure I agree with that...

> For other kernel-internal uses, we may be better off migrating to
> a completely different representation, such as nanoseconds since
> boot or the architecture specific ktime_t, but this is really something
> to decide for each subsystem.

Having a bunch of different time representations in the kernel seems
like a real headache...

	-hpa


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
