Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF7A67CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 06:20:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 854238F804C
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 04:20:03 -0700 (PDT)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com
	[209.85.192.43]) by cuda.sgi.com with ESMTP id MCKYHMrbA73tFPiD
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 04:20:02 -0700 (PDT)
Received: by mail-qg0-f43.google.com with SMTP id w104so56297990qge.3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 04:20:02 -0700 (PDT)
Subject: Re: fallocate mode flag for "unshare blocks"?
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331003242.GA5813@localhost.localdomain>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56FD079F.3060606@gmail.com>
Date: Thu, 31 Mar 2016 07:18:55 -0400
MIME-Version: 1.0
In-Reply-To: <20160331003242.GA5813@localhost.localdomain>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: bo.li.liu@oracle.com, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On 2016-03-30 20:32, Liu Bo wrote:
> On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
>> Hi all,
>>
>> Christoph and I have been working on adding reflink and CoW support to
>> XFS recently.  Since the purpose of (mode 0) fallocate is to make sure
>> that future file writes cannot ENOSPC, I extended the XFS fallocate
>> handler to unshare any shared blocks via the copy on write mechanism I
>> built for it.  However, Christoph shared the following concerns with
>> me about that interpretation:
>>
>>> I know that I suggested unsharing blocks on fallocate, but it turns out
>>> this is causing problems.  Applications expect falloc to be a fast
>>> metadata operation, and copying a potentially large number of blocks
>>> is against that expextation.  This is especially bad for the NFS
>>> server, which should not be blocked for a long time in a synchronous
>>> operation.
>>>
>>> I think we'll have to remove the unshare and just fail the fallocate
>>> for a reflinked region for now.  I still think it makes sense to expose
>>> an unshare operation, and we probably should make that another
>>> fallocate mode.
>
> I'm expecting fallocate to be fast, too.
>
> Well, btrfs fallocate doesn't allocate space if it's a shared one
> because it thinks the space is already allocated.  So a later overwrite
> over this shared extent may hit enospc errors.
And this _really_ should get fixed, otherwise glibc will add a check for 
running posix_fallocate against BTRFS and force emulation, and people 
_will_ complain about performance.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
