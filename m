Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R8Obhd031111 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 02:24:37 -0600
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0C04BC8B1
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 00:23:54 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by cuda.sgi.com with ESMTP id eJmUjE00gwkLoUkN for
	<xfs@oss.sgi.com>; Tue, 27 Jan 2009 00:23:54 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id 13so37517fge.8
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 00:23:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497E0163.8010207@sandeen.net>
References: <6efe08af0901252337m22844fc2yee3cef2a8ed8ac6@mail.gmail.com>
	<497E0163.8010207@sandeen.net>
Date: Tue, 27 Jan 2009 10:23:53 +0200
Message-ID: <6efe08af0901270023k1f8dbcd6te5592cbf3eff7129@mail.gmail.com>
Subject: Re: xfs_repair refuse to repair my corrupted xfs partition
From: "Vitaly V. Ch" <vitaly.v.ch@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

I use xfs_repair version 2.9.7 from slackware 12.1

\\wbr Vitaly Chernookiy

On Mon, Jan 26, 2009 at 8:30 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Vitaly V. Ch wrote:
>> Hi All!
>
> ...
>
>> #xfs_repai /dev/loop0
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - zero log...
>>         - scan filesystem freespace and inode maps...
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan and clear agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>> entry "" in shortform directory 128 references invalid inode 0
>> zero length entry in shortform dir 128, junking 3 entries
>> corrected entry count in directory 128, was 3, now 0
>> corrected directory 128 size, was 69, now 6
>> bogus .. inode number (0) in directory inode 128, clearing inode number
>> xfs_repair: dir2.c:2133: process_dir2: Assertion `(ino !=
>> mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino
>> && (ino == *parent || need_root_dotdot == 1))' failed.
>>
>>
>> What I can do for repair my data? There was no hardware failure
>
> you haven't said what version of xfs_repair you're using; if you are not
> using the latest (2.10.2) please try that first.
>
> -Eric
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
