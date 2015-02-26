Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 02BDB7F47
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2015 02:50:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B7B1AC009
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2015 00:50:13 -0800 (PST)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	RMBYRNLCjt59e2ar (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Feb 2015 00:49:42 -0800 (PST)
Received: by mail-wi0-f174.google.com with SMTP id em10so39197657wid.1
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2015 00:49:41 -0800 (PST)
Message-ID: <54EEDE23.6080009@gmail.com>
Date: Thu, 26 Feb 2015 09:49:39 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
MIME-Version: 1.0
Subject: Re: Documenting MS_LAZYTIME
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
	<54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org>
In-Reply-To: <20150221025636.GB7922@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-man@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, mtk.manpages@gmail.com, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

Ted,

On 02/21/2015 03:56 AM, Theodore Ts'o wrote:
> On Fri, Feb 20, 2015 at 09:49:34AM -0600, Eric Sandeen wrote:
>>
>>>               This mount option significantly reduces  writes  to  the
>>>               inode  table  for workloads that perform frequent random
>>>               writes to preallocated files.
>>
>> This seems like an overly specific description of a single workload out
>> of many which may benefit, but what do others think?  "inode table" is also
>> fairly extN-specific.
> 
> How about somethign like "This mount significantly reduces writes
> needed to update the inode's timestamps, especially mtime and actime.

What is "actime" in the preceding line? Should it be "ctime"?

> Examples of workloads where this could be a large win include frequent
> random writes to preallocated files, as well as cases where the
> MS_STRICTATIME mount option is enabled."?

I think some version of the following text could also usefully go 
into the page, but...

> (The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat system
> calls will return the correctly updated atime, but those atime updates
> won't get flushed to disk unless the inode needs to be updated for
> file system / data consistency reasons, or when the inode is pushed
> out of memory, or when the file system is unmounted.)

I find the wording of there a little confusing. Is the following 
a correct rewrite:

    The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat(2)
    will return the correctly updated atime, but the atime updates
    will be flushed to disk only when (1) the inode needs to be 
    updated for filesystem / data consistency reasons or (2) the 
    inode is pushed out of memory, or (3) the filesystem is 
    unmounted.)

?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
