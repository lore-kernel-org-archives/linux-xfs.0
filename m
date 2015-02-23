Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F10F67F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 06:20:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8AEADAC002
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 04:20:47 -0800 (PST)
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com
	[209.85.213.173]) by cuda.sgi.com with ESMTP id
	H0lSuitOXHh7OOEu (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 04:20:45 -0800 (PST)
Received: by mail-ig0-f173.google.com with SMTP id a13so17607529igq.0
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 04:20:44 -0800 (PST)
Message-ID: <54EB1B19.8050808@gmail.com>
Date: Mon, 23 Feb 2015 07:20:41 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-man@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

On 2015-02-20 21:56, Theodore Ts'o wrote:
> On Fri, Feb 20, 2015 at 09:49:34AM -0600, Eric Sandeen wrote:
>>
>>>                This mount option significantly reduces  writes  to  the
>>>                inode  table  for workloads that perform frequent random
>>>                writes to preallocated files.
>>
>> This seems like an overly specific description of a single workload out
>> of many which may benefit, but what do others think?  "inode table" is also
>> fairly extN-specific.
>
> How about somethign like "This mount significantly reduces writes
> needed to update the inode's timestamps, especially mtime and actime.
> Examples of workloads where this could be a large win include frequent
> random writes to preallocated files, as well as cases where the
> MS_STRICTATIME mount option is enabled."?
>
> (The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat system
> calls will return the correctly updated atime, but those atime updates
> won't get flushed to disk unless the inode needs to be updated for
> file system / data consistency reasons, or when the inode is pushed
> out of memory, or when the file system is unmounted.)
>
If you want to list some specific software, it should help with anything 
that uses sqlite (which notably includes firefox and chrome), as well as 
most RDMS software and systemd-journald.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
